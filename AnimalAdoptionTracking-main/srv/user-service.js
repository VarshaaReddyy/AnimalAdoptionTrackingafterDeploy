const cds = require("@sap/cds");

module.exports = cds.service.impl(async function () {

    const {
        AnimalsSrv,
        AdoptionApplicationsSrv,
        AdoptionsSrv,
        HealthRecordsSrv,
        SheltersSrv,
        UsersSrv,
        InspectionsSrv,
        ApplicationStatusHistorySrv
    } = this.entities;

        
    const getCurrentUserID = async (req) => {

        
        const email =
            (req.user.attr?.email || req.user.id).toLowerCase();

        const user = await SELECT.one
            .from(UsersSrv)
            .columns("ID")
            .where({ email });

        if (user) {
            return user.ID;
        }

       
        const ID = cds.utils.uuid();

        await INSERT.into(UsersSrv).entries({
            ID,
            firstName: req.user.attr?.givenName || "",
            lastName: req.user.attr?.familyName || "",
            email,
            role: "ADOPTER",
            status: "ACTIVE",
            createdAt: new Date(),
            modifiedAt: new Date()
        });

        return ID;
    };
   
    this.on("applyForAdoption", async (req) => {

        try {

            const animalID = req.params[0].ID;

            const {
                reasonForAdoption,
                housingDetails,
                petExperience
            } = req.data;


           
            const applicantID =
                await getCurrentUserID(req);


            
            const animal = await SELECT.one
                .from(AnimalsSrv)
                .where({
                    ID: animalID
                });


            if (!animal) {
                return req.error(
                    404,
                    "Animal not found"
                );
            }


            
            if (animal.animalStatus !== "AVAILABLE") {

                return req.error(
                    400,
                    "This animal is not available for adoption."
                );

            }


            
            const existingApplication =
                await SELECT.one
                    .from(AdoptionApplicationsSrv)
                    .where({
                        animal_ID: animalID,
                        applicant_ID: applicantID,
                        status: { in: ["SUBMITTED", "UNDER_REVIEW", "APPROVED"] }
                    });


            if (existingApplication) {

                return req.error(
                    400,
                    "You have already submitted an application for this animal."
                );

            }


            

            const applicationData = {

                animal_ID: animalID,

                applicant_ID: applicantID,

                applicationDate: new Date(),

                reasonForAdoption:
                    reasonForAdoption,

                housingDetails:
                    housingDetails,

                petExperience:
                    petExperience,

                ID: cds.utils.uuid(),

              
                status: "SUBMITTED"
            };


            await INSERT
                .into(AdoptionApplicationsSrv)
                .entries(applicationData);

            await INSERT.into(ApplicationStatusHistorySrv).entries({
                ID: cds.utils.uuid(),
                application_ID: applicationData.ID,
                oldStatus: null,
                newStatus: "SUBMITTED",
                changedBy: req.user.id,
                changedAt: new Date(),
                remarks: "Application submitted"
            });


            

            const createdApplication =
                await SELECT.one
                    .from(AdoptionApplicationsSrv)
                    .where({ ID: applicationData.ID });


            return createdApplication;


        } catch (error) {

            console.error(
                "Apply for Adoption Error:",
                error
            );

            return req.error(
                500,
                error.message
            );
        }

    });




    this.on(
        "READ",
        "UserDashboardStats",
        async (req) => {

            const USER_ID =
                await getCurrentUserID(req);


            const myApplications =
                await SELECT.one
                    .from(AdoptionApplicationsSrv)
                    .where({
                        applicant_ID: USER_ID
                    })
                    .columns`count(*) as count`;


            const pendingApplications =
                await SELECT.one
                    .from(AdoptionApplicationsSrv)
                    .where({
                        applicant_ID: USER_ID,
                        status: { in: ["SUBMITTED", "UNDER_REVIEW"] }
                    })
                    .columns`count(*) as count`;


            const approvedApplications =
                await SELECT.one
                    .from(AdoptionApplicationsSrv)
                    .where({
                        applicant_ID: USER_ID,
                        status: "APPROVED"
                    })
                    .columns`count(*) as count`;


            const myAdoptions =
                await SELECT.one
                    .from(AdoptionsSrv)
                    .where({ "application.applicant_ID": USER_ID })
                    .columns`count(*) as count`;


            return [{

                ID: "USER_DASHBOARD",

                myApplications:
                    Number(myApplications.count || 0),

                pendingApplications:
                    Number(pendingApplications.count || 0),

                approvedApplications:
                    Number(approvedApplications.count || 0),

                myAdoptions:
                    Number(myAdoptions.count || 0)

            }];

        }
    );


    const health = require("./lib/health");

    this.after("READ", "AnimalsSrv", health.addAdoptionEligibility);
    this.after("READ", "HealthRecordsSrv", health.addCheckupStatus);


    

    this.before("READ", "AdoptionApplicationsSrv", async (req) => {
        req.query.where({ applicant_ID: await getCurrentUserID(req) });
    });

    this.before("READ", "AdoptionsSrv", async (req) => {
        req.query.where({ "application.applicant_ID": await getCurrentUserID(req) });
    });

    this.before("READ", "InspectionsSrv", async (req) => {
        req.query.where({ "adoption.application.applicant_ID": await getCurrentUserID(req) });
    });

    this.before("READ", "ApplicationStatusHistorySrv", async (req) => {
        req.query.where({ "application.applicant_ID": await getCurrentUserID(req) });
    });

    this.before("READ", "UsersSrv", async (req) => {
        req.query.where({ ID: await getCurrentUserID(req) });
    });


  
    this.before(["UPDATE", "DELETE"], "UsersSrv", async (req) => {
        if (req.data.ID && req.data.ID !== await getCurrentUserID(req)) {
            req.reject(403, "You can only change your own profile.");
        }
    });


    this.before("CREATE", "AdoptionApplicationsSrv", async (req) => {
        req.data.applicant_ID = await getCurrentUserID(req);
        req.data.status = "SUBMITTED";
        req.data.applicationDate = req.data.applicationDate || new Date().toISOString().slice(0, 10);
    });

    this.before(["UPDATE", "DELETE"], "AdoptionApplicationsSrv", async (req) => {
        const ID = req.data.ID ?? req.params[0]?.ID ?? req.params[0];
        const application = await SELECT.one.from(AdoptionApplicationsSrv)
            .where({ ID, applicant_ID: await getCurrentUserID(req) });
        if (!application) {
            req.reject(404, "Application not found");
        }
        if (application.status !== "SUBMITTED") {
            req.reject(400, "Only applications that are still Submitted can be changed.");
        }
        delete req.data.status;
        delete req.data.applicant_ID;
        delete req.data.reviewedBy_ID;
        delete req.data.staffRemarks;
    });


   

    this.on("withdrawApplication", async (req) => {

        const ID = req.params[0].ID ?? req.params[0];

        const application = await SELECT.one.from(AdoptionApplicationsSrv)
            .where({ ID, applicant_ID: await getCurrentUserID(req) });

        if (!application) {
            req.reject(404, "Application not found");
        }

        if (application.status !== "SUBMITTED") {
            req.reject(400, "Only applications that are still Submitted can be withdrawn.");
        }

        await UPDATE(AdoptionApplicationsSrv)
            .set({ status: "WITHDRAWN", staffRemarks: "Withdrawn by applicant" })
            .where({ ID });

        await INSERT.into(ApplicationStatusHistorySrv).entries({
            ID: cds.utils.uuid(),
            application_ID: ID,
            oldStatus: "SUBMITTED",
            newStatus: "WITHDRAWN",
            changedBy: req.user.id,
            changedAt: new Date(),
            remarks: "Withdrawn by applicant"
        });

        return "Application withdrawn";
    });


    this.on("editProfile", async (req) => {

    const USER_ID =
        await getCurrentUserID(req);

    const {
        firstName,
        lastName,
        email,
        phoneNumber,
        address,
        city,
        state,
        postalCode
    } = req.data;

    await UPDATE(UsersSrv)
        .set(Object.fromEntries(Object.entries({
            firstName,
            lastName,
           
            phoneNumber,
            address,
            city,
            state,
            postalCode
        }).filter(([, value]) => value !== undefined && value !== null && value !== "")))
        .where({
            ID: USER_ID
        });

    return await SELECT.one
        .from(UsersSrv)
        .where({
            ID: USER_ID
        });
});

});