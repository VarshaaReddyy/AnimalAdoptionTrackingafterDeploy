const cds = require('@sap/cds');

module.exports = cds.service.impl(async function () {

    const {
        UsersSrv,
        SheltersSrv,
        AnimalsSrv,
        AdoptionApplicationsSrv,
        AdoptionsSrv,
        HealthRecordsSrv,
        InspectionsSrv,
        DashboardStats,

    } = this.entities;


    const onlyFilled = (data) => Object.fromEntries(
        Object.entries(data).filter(([, value]) => value !== undefined && value !== null && value !== "")
    );


this.on("editShelter", "SheltersSrv", async (req) => {

    const ID = req.params[0].ID;

    const {
        shelterName,
        shelterCode,
        addressLine1,
        addressLine2,
        city,
        state,
        postalCode,
        country,
        contactNumber,
        email,
        website,
        capacity,
        currentOccupancy,
        operatingTime,
        closingTime,
        shelterType,
        licenseNumber
    } = req.data;

    await UPDATE("db.Shelters")
        .set(onlyFilled({
            shelterName,
            shelterCode,
            addressLine1,
            addressLine2,
            city,
            state,
            postalCode,
            country,
            contactNumber,
            email,
            website,
            capacity,
            currentOccupancy,
            operatingTime,
            closingTime,
            shelterType,
            licenseNumber,
            modifiedAt: new Date()
        }))
        .where({ ID });

    return await SELECT.one
        .from("db.Shelters")
        .where({ ID });
});

this.on("editHealthRecord", "HealthRecordsSrv", async (req) => {

    const ID = req.params[0].ID;

    const {
        animalID,
        checkupDate,
        healthStatus,
        diagnosis,
        treatment,
        medication,
        veterinarianName,
        weight,
        nextCheckupDate,
        remarks,
        medicalDocument
    } = req.data;

    await UPDATE("db.HealthRecords")
        .set(onlyFilled({
            animal_ID: animalID,
            checkupDate,
            healthStatus,
            diagnosis,
            treatment,
            medication,
            veterinarianName,
            weight,
            nextCheckupDate,
            remarks,
            medicalDocument,
            modifiedAt: new Date()
        }))
        .where({ ID });

    return await SELECT.one
        .from("db.HealthRecords")
        .where({ ID });
});

this.on("editInspection", "InspectionsSrv", async (req) => {

    const ID = req.params[0].ID;

    const {
        adoptionID,
        inspectorID,
        inspectionDate,
        inspectionType,
        existingPetDetails,
        result,
        remarks,
        inspectionDocument
    } = req.data;

    await UPDATE("db.Inspections")
        .set(onlyFilled({
            adoption_ID: adoptionID,
            inspector_ID: inspectorID,
            inspectionDate,
            inspectionType,
            existingPetDetails,
            result,
            remarks,
            inspectionDocument,
            modifiedAt: new Date()
        }))
        .where({ ID });

    return await SELECT.one
        .from("db.Inspections")
        .where({ ID });
});
this.on("editAnimal", "AnimalsSrv", async (req) => {

    const animalID = req.params[0].ID;

    const {
        shelterID,
        name,
        species,
        breed,
        gender,
        age,
        arrivalDate,
        animalStatus,
        vaccinationStatus,
        spayedOrNeutered,
        photo,
        description
    } = req.data;

    await UPDATE(AnimalsSrv)
        .set(onlyFilled({
            shelter_ID: shelterID,
            name,
            species,
            breed,
            gender,
            age,
            arrivalDate,
            animalStatus,
            vaccinationStatus,
            spayedOrNeutered,
            photo,
            description,
            modifiedAt: new Date()
        }))
        .where({ ID: animalID });

    return await SELECT.one
        .from(AnimalsSrv)
        .where({ ID: animalID });
});

this.on("READ", "ApplicationStatusSummary", async () => {

    const submitted = await SELECT.one
        .from(AdoptionApplicationsSrv)
        .where({ status: "SUBMITTED" })
        .columns`count(*) as count`;

    const review = await SELECT.one
        .from(AdoptionApplicationsSrv)
        .where({ status: "UNDER_REVIEW" })
        .columns`count(*) as count`;

    const approved = await SELECT.one
        .from(AdoptionApplicationsSrv)
        .where({ status: "APPROVED" })
        .columns`count(*) as count`;

    const rejected = await SELECT.one
        .from(AdoptionApplicationsSrv)
        .where({ status: "REJECTED" })
        .columns`count(*) as count`;

    const withdrawn = await SELECT.one
        .from(AdoptionApplicationsSrv)
        .where({ status: "WITHDRAWN" })
        .columns`count(*) as count`;

    return [
        {
            status: "Submitted",
            count: Number(submitted.count)
        },
        {
            status: "Under Review",
            count: Number(review.count)
        },
        {
            status: "Approved",
            count: Number(approved.count)
        },
        {
            status: "Rejected",
            count: Number(rejected.count)
        },
        {
            status: "Withdrawn",
            count: Number(withdrawn.count)
        }
    ];
});


// ==========================================================
// ADOPTION TREND
// ==========================================================

this.on("READ", "AdoptionTrend", async () => {

    const adoptions =
        await SELECT.from(AdoptionsSrv).columns("adoptionDate");

    // Group by calendar month ("2026-04"), then sort oldest -> newest
    const monthMap = {};

    adoptions.forEach(record => {
        if (record.adoptionDate) {
            const key = String(record.adoptionDate).slice(0, 7);
            monthMap[key] = (monthMap[key] || 0) + 1;
        }
    });

    return Object.keys(monthMap).sort().map(key => ({
        month: new Date(key + "-01T00:00:00Z")
            .toLocaleString("en-US", { month: "short", year: "2-digit", timeZone: "UTC" }),
        count: monthMap[key]
    }));
});




this.on("READ", "ShelterOccupancy", async () => {

    const shelters =
        await SELECT.from(SheltersSrv);

    return shelters.map(shelter => {

        const percentage =
            shelter.capacity > 0
                ? (shelter.currentOccupancy /
                    shelter.capacity) * 100
                : 0;

        return {
            shelterName: shelter.shelterName,
            city: shelter.city,
            capacity: Number(shelter.capacity || 0),
            currentOccupancy:
                Number(shelter.currentOccupancy || 0),

            // IMPORTANT:
            // CDS + XML both expect occupancyPercentage
            occupancyPercentage:
                Number(percentage.toFixed(2))
        };
    });
});



this.on("READ", "AnimalCategorySummary", async () => {

    const result = await SELECT
        .from(AnimalsSrv)
        .columns(
            "species",
            {
                func: "count",
                args: [{ val: 1 }],
                as: "count"
            }
        )
        .groupBy("species");

    return result;
});



    this.on('READ', 'DashboardStats', async (request) => {

    const totalAnimals =
        await SELECT.one.from(AnimalsSrv).columns`count(*) as count`;

    const availableAnimals =
        await SELECT.one.from(AnimalsSrv)
            .where({ animalStatus: 'AVAILABLE' })
            .columns`count(*) as count`;

    const totalApplications =
        await SELECT.one.from(AdoptionApplicationsSrv)
            .columns`count(*) as count`;

    const approvedApplications =
        await SELECT.one.from(AdoptionApplicationsSrv)
            .where({ status: 'APPROVED' })
            .columns`count(*) as count`;

    const pendingApplications =
        await SELECT.one.from(AdoptionApplicationsSrv)
            .where({ status: { in: ['SUBMITTED', 'UNDER_REVIEW'] } })
            .columns`count(*) as count`;

    const totalShelters =
        await SELECT.one.from(SheltersSrv)
            .columns`count(*) as count`;

    return [{
        ID: 'DASHBOARD',
        totalAnimals: totalAnimals.count,
        availableAnimals: availableAnimals.count,
        totalApplications: totalApplications.count,
        approvedApplications: approvedApplications.count,
        pendingApplications: pendingApplications.count,
        totalShelters: totalShelters.count
    }];
});



    this.on('createUser', async (request, response) => {

        const userData = {...request.data,
                            createdAt: new Date(),
                            modifiedAt: new Date() 
                         };

        const objTransaction = cds.tx(request);

        let returnData = await objTransaction.run([
            INSERT.into(UsersSrv).entries(userData)
        ]).then((resolve, reject) => {

            if (typeof(resolve) !== 'undefined') {
                return userData;
            } else {
                request.error(500, 'Error in inserting data into database');
            }

        }).catch(err => {
            request.error(500, 'There is an error : ' + err.toString());
        });

        return userData;
    });


    this.on('createShelter', async (request, response) => {

        const shelterData = {...request.data,
                            createdAt: new Date(),
                            modifiedAt: new Date() 
                         };

        const objTransaction = cds.tx(request);

        let returnData = await objTransaction.run([
            INSERT.into(SheltersSrv).entries(shelterData)
        ]).then((resolve, reject) => {

            if (typeof(resolve) !== 'undefined') {
                return shelterData;
            } else {
                request.error(500, 'Error in inserting data into database');
            }

        }).catch(err => {
            request.error(500, 'There is an error : ' + err.toString());
        });

        return shelterData;
    });

    this.on('createAnimal', async (request, response) => {

    const animalData = {
        shelter_ID: request.data.shelterID,
        name: request.data.name,
        species: request.data.species,
        breed: request.data.breed,
        gender: request.data.gender,
        age: request.data.age,
        arrivalDate: request.data.arrivalDate,
        animalStatus: request.data.animalStatus,
        vaccinationStatus: request.data.vaccinationStatus,
        spayedOrNeutered: request.data.spayedOrNeutered,
        photo: request.data.photo,
        description: request.data.description,
        createdAt: new Date(),
        modifiedAt: new Date()
    };

    const objTransaction = cds.tx(request);

    try {
        await objTransaction.run(
            INSERT.into(AnimalsSrv).entries(animalData)
        );

        return animalData;

    } catch (err) {
        request.error(500, 'There is an error: ' + err.message);
    }
    });


    // this.on('createAnimal', async (request, response) => {

    //     const animalData = {...request.data,
    //                         createdAt: new Date(),
    //                         modifiedAt: new Date() 
    //                      };

    //     const objTransaction = cds.tx(request);

    //     let returnData = await objTransaction.run([
    //         INSERT.into(AnimalsSrv).entries(animalData)
    //     ]).then((resolve, reject) => {

    //         if (typeof(resolve) !== 'undefined') {
    //             return animalData;
    //         } else {
    //             request.error(500, 'Error in inserting data into database');
    //         }

    //     }).catch(err => {
    //         request.error(500, 'There is an error : ' + err.toString());
    //     });

    //     return animalData;
    // });


    // this.on('createApplication', async (request, response) => {

    //     const applicationData = {...request.data,
    //                         createdAt: new Date(),
    //                         modifiedAt: new Date() 
    //                      };

    //     const objTransaction = cds.tx(request);

    //     let returnData = await objTransaction.run([
    //         INSERT.into(AdoptionApplicationsSrv).entries(applicationData)
    //     ]).then((resolve, reject) => {

    //         if (typeof(resolve) !== 'undefined') {
    //             return applicationData;
    //         } else {
    //             request.error(500, 'Error in inserting data into database');
    //         }

    //     }).catch(err => {
    //         request.error(500, 'There is an error : ' + err.toString());
    //     });

    //     return applicationData;
    // });

   this.on("applyForAdoption", async (req) => {

    const animalID = req.params[0].ID;

    const {
        reasonForAdoption,
        housingDetails,
        petExperience
    } = req.data;

    // Sample logged-in user
    const applicantID =
        "21390C66-6925-49F2-BDD5-AF0838C335A5";

    try {

        // Check animal exists
        const animal = await SELECT.one
            .from(AnimalsSrv)
            .where({ ID: animalID });

        if (!animal) {
            req.error(404, "Animal not found");
        }

        // Check animal availability
        if (animal.animalStatus !== "AVAILABLE") {
            req.error(
                400,
                "This animal is not available for adoption"
            );
        }

        // Create application
        await INSERT.into(AdoptionApplicationsSrv).entries({

            animal_ID: animalID,
            applicant_ID: applicantID,

            applicationDate: new Date(),

            reasonForAdoption:
                reasonForAdoption,

            housingDetails:
                housingDetails,

            petExperience:
                petExperience,

            status: "PENDING",

            createdAt: new Date(),
            modifiedAt: new Date()

        });

        return "Application submitted successfully";

    } catch (error) {

        console.error(
            "Apply for Adoption Error:",
            error
        );

        req.error(500, error.message);
    }
});

    this.on('READ', 'UserDashboardStats', async (request) => {
    const USER_ID =
        '21390C66-6925-49F2-BDD5-AF0838C335A5';
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
                status: 'UNDER_REVIEW'
            })
            .columns`count(*) as count`;

    const approvedApplications =
        await SELECT.one
            .from(AdoptionApplicationsSrv)
            .where({
                applicant_ID: USER_ID,
                status: 'APPROVED'
            })
            .columns`count(*) as count`;

    

    return [{
        ID: 'USER_DASHBOARD',
        myApplications: myApplications.count,
        pendingApplications: pendingApplications.count,
        approvedApplications: approvedApplications.count,
        
    }];
});

    this.on('createApplication', async (request, response) => {

    const applicationData = {
        animal_ID: request.data.animalID,
        applicant_ID: request.data.applicantID,
        applicationDate: request.data.applicationDate,
        reasonForAdoption: request.data.reasonForAdoption,
        housingDetails: request.data.housingDetails,
        petExperience: request.data.petExperience,
        status: request.data.status,
        reviewedBy_ID: request.data.reviewedByID,
        staffRemarks: request.data.staffRemarks,
        createdAt: new Date(),
        modifiedAt: new Date()
    };

    const objTransaction = cds.tx(request);

    try {
        await objTransaction.run(
            INSERT.into(AdoptionApplicationsSrv).entries(applicationData)
        );

        return applicationData;

    } catch (err) {
        request.error(500, 'There is an error: ' + err.message);
    }
    });

    // this.on('createAdoption', async (request, response) => {

    //     const adoptionData = {...request.data,
    //                         createdAt: new Date(),
    //                         modifiedAt: new Date() 
    //                      };

    //     const objTransaction = cds.tx(request);

    //     let returnData = await objTransaction.run([
    //         INSERT.into(AdoptionsSrv).entries(adoptionData)
    //     ]).then((resolve, reject) => {

    //         if (typeof(resolve) !== 'undefined') {
    //             return adoptionData;
    //         } else {
    //             request.error(500, 'Error in inserting data into database');
    //         }

    //     }).catch(err => {
    //         request.error(500, 'There is an error : ' + err.toString());
    //     });

    //     return adoptionData;
    // });

    this.on('createHealthRecord', async (request, response) => {

    const healthRecordData = {
        animal_ID: request.data.animalID,
        checkupDate: request.data.checkupDate,
        healthStatus: request.data.healthStatus,
        diagnosis: request.data.diagnosis,
        treatment: request.data.treatment,
        medication: request.data.medication,
        veterinarianName: request.data.veterinarianName,
        weight: request.data.weight,
        nextCheckupDate: request.data.nextCheckupDate,
        remarks: request.data.remarks,
        medicalDocument: request.data.medicalDocument,
        createdAt: new Date(),
        modifiedAt: new Date()
    };

    const objTransaction = cds.tx(request);

    try {
        await objTransaction.run(
            INSERT.into(HealthRecordsSrv).entries(healthRecordData)
        );

        return healthRecordData;

    } catch (err) {
        request.error(500, 'There is an error: ' + err.message);
    }
    });

    // ==========================================================
    // HEALTH: eligibility, checkup status, change history
    // (FR-ADM-014 / 015 / 016)
    // ==========================================================

    const health = require("./lib/health");
    const { HealthRecords: HealthRecordsDB } = cds.entities("db");

    this.after("READ", "AnimalsSrv", health.addAdoptionEligibility);
    this.after("READ", "HealthRecordsSrv", health.addCheckupStatus);

    // Saving a health record (Save button) -> log each changed field
    this.before("UPDATE", "HealthRecordsSrv", async (req) => {
        const ID = req.data.ID ?? req.params[0]?.ID ?? req.params[0];
        req._healthBefore = await SELECT.one.from(HealthRecordsDB).where({ ID });
    });

    this.after("UPDATE", "HealthRecordsSrv", async (result, req) => {
        const ID = req.data.ID ?? req.params[0]?.ID ?? req.params[0];
        await health.logHealthRecordChanges(req, req._healthBefore, { ...req.data, ID });
    });

    this.after("CREATE", "HealthRecordsSrv", async (result, req) => {
        await health.logHealthRecordChanges(req, null, { ...req.data, ...(result || {}) });
    });


    // ==========================================================
    // APPLICATION REVIEW (FR-ADM-007 / 008 / 009)
    // Workflow: SUBMITTED -> UNDER_REVIEW -> APPROVED | REJECTED
    // Every status change writes one ApplicationStatusHistory row.
    // ==========================================================

    const { ApplicationStatusHistorySrv } = this.entities;

    const OPEN_STATUSES = ["SUBMITTED", "UNDER_REVIEW"];

    // Users row of the logged-in admin (matched by login email)
    const getReviewerID = async (req) => {
        const email = (req.user.attr?.email || req.user.id).toLowerCase();
        const reviewer = await SELECT.one.from(UsersSrv).columns("ID").where({ email });
        return reviewer ? reviewer.ID : null;
    };

    const writeHistory = async (req, applicationID, oldStatus, newStatus, remarks) => {
        await INSERT.into(ApplicationStatusHistorySrv).entries({
            ID: cds.utils.uuid(),
            application_ID: applicationID,
            oldStatus,
            newStatus,
            changedBy: req.user.id,
            changedAt: new Date(),
            remarks
        });
    };

    const getOpenApplication = async (req) => {
        const ID = req.params[0].ID ?? req.params[0];
        const application = await SELECT.one.from(AdoptionApplicationsSrv).where({ ID });
        if (!application) {
            req.reject(404, "Application not found");
        }
        if (!OPEN_STATUSES.includes(application.status)) {
            req.reject(400, `Application is already ${application.status} and cannot be changed.`);
        }
        return application;
    };


    this.on("markUnderReview", async (req) => {

        const application = await getOpenApplication(req);

        if (application.status !== "SUBMITTED") {
            req.reject(400, "Only submitted applications can be moved to Under Review.");
        }

        await UPDATE(AdoptionApplicationsSrv)
            .set({ status: "UNDER_REVIEW", reviewedBy_ID: await getReviewerID(req) })
            .where({ ID: application.ID });

        await writeHistory(req, application.ID, application.status, "UNDER_REVIEW", "Review started");

        return "Application moved to Under Review";
    });


    this.on("approveApplication", async (req) => {

        const application = await getOpenApplication(req);
        const reviewerID = await getReviewerID(req);

        // 1. Approve this application
        await UPDATE(AdoptionApplicationsSrv)
            .set({ status: "APPROVED", reviewedBy_ID: reviewerID })
            .where({ ID: application.ID });

        await writeHistory(req, application.ID, application.status, "APPROVED", "Application approved");

        // 2. The animal is now adopted
        await UPDATE(AnimalsSrv)
            .set({ animalStatus: "ADOPTED" })
            .where({ ID: application.animal_ID });

        // 3. Close the other open applications for the same animal
        const others = await SELECT.from(AdoptionApplicationsSrv)
            .columns("ID", "status")
            .where({
                animal_ID: application.animal_ID,
                ID: { "!=": application.ID },
                status: { in: OPEN_STATUSES }
            });

        for (const other of others) {
            const reason = "Animal has been adopted by another applicant.";
            await UPDATE(AdoptionApplicationsSrv)
                .set({ status: "REJECTED", staffRemarks: reason, reviewedBy_ID: reviewerID })
                .where({ ID: other.ID });
            await writeHistory(req, other.ID, other.status, "REJECTED", reason);
        }

        // 4. Create the adoption record automatically (FR-ADM-010)
        const existingAdoption = await SELECT.one.from(AdoptionsSrv)
            .where({ application_ID: application.ID });

        if (!existingAdoption) {
            await INSERT.into(AdoptionsSrv).entries({
                ID: cds.utils.uuid(),
                application_ID: application.ID,
                animal_ID: application.animal_ID,
                adoptionDate: new Date().toISOString().slice(0, 10),
                status: "PENDING",
                completedBy_ID: reviewerID,
                remarks: "Generated automatically after approval"
            });
        }

        return "Application Approved";
    });


    this.on("rejectApplication", async (req) => {

        const reason = (req.data.reason || "").trim();

        if (!reason) {
            req.reject(400, "Please enter a rejection reason.");
        }

        const application = await getOpenApplication(req);

        await UPDATE(AdoptionApplicationsSrv)
            .set({
                status: "REJECTED",
                staffRemarks: reason,          // shown to the applicant (FR-USR-010)
                reviewedBy_ID: await getReviewerID(req)
            })
            .where({ ID: application.ID });

        await writeHistory(req, application.ID, application.status, "REJECTED", reason);

        return "Application Rejected";
    });


    // this.on('createHealthRecord', async (request, response) => {

    //     const healthRecordData = {...request.data,
    //                         createdAt: new Date(),
    //                         modifiedAt: new Date() 
    //                      };

    //     const objTransaction = cds.tx(request);

    //     let returnData = await objTransaction.run([
    //         INSERT.into(HealthRecordsSrv).entries(healthRecordData)
    //     ]).then((resolve, reject) => {

    //         if (typeof(resolve) !== 'undefined') {
    //             return healthRecordData;
    //         } else {
    //             request.error(500, 'Error in inserting data into database');
    //         }

    //     }).catch(err => {
    //         request.error(500, 'There is an error : ' + err.toString());
    //     });

    //     return healthRecordData;
    // });


    // this.on('createInspection', async (request, response) => {

    //     const inspectionData = {...request.data,
    //                         createdAt: new Date(),
    //                         modifiedAt: new Date() 
    //                      };

    //     const objTransaction = cds.tx(request);

    //     let returnData = await objTransaction.run([
    //         INSERT.into(InspectionsSrv).entries(inspectionData)
    //     ]).then((resolve, reject) => {

    //         if (typeof(resolve) !== 'undefined') {
    //             return inspectionData;
    //         } else {
    //             request.error(500, 'Error in inserting data into database');
    //         }

    //     }).catch(err => {
    //         request.error(500, 'There is an error : ' + err.toString());
    //     });

    //     return inspectionData;
    // });

    this.on('createInspection', async (request, response) => {

    const inspectionData = {
        adoption_ID: request.data.adoptionID,
        inspector_ID: request.data.inspectorID,
        inspectionDate: request.data.inspectionDate,
        inspectionType: request.data.inspectionType,
        existingPetDetails: request.data.existingPetDetails,
        result: request.data.result,
        remarks: request.data.remarks,
        inspectionDocument: request.data.inspectionDocument,
        createdAt: new Date(),
        modifiedAt: new Date()
    };

    const objTransaction = cds.tx(request);

    try {
        await objTransaction.run(
            INSERT.into(InspectionsSrv).entries(inspectionData)
        );

        return inspectionData;

    } catch (err) {
        request.error(500, 'There is an error: ' + err.message);
    }
    });

    this.on('deleteUser', async (request ,response)=>{
        
        const{
            ID
        } = request.data;

        try{
            const objTransaction = cds.tx(request);

            await objTransaction.delete(UsersSrv).where({
                ID:ID
            })
            return "Successfully updated";
        }catch(error){
            request.error("Error : ",error)
        }
        
    });

    this.on('deleteShelter', async (request ,response)=>{
        
        const{
            ID
        } = request.data;

        try{
            const objTransaction = cds.tx(request);

            await objTransaction.delete(SheltersSrv).where({
                ID:ID
            })
            return "Successfully updated";
        }catch(error){
            request.error("Error : ",error)
        }
        
    });

    this.on('deleteAnimal', async (request ,response)=>{
        
        const{
            ID
        } = request.data;

        try{
            const objTransaction = cds.tx(request);

            await objTransaction.delete(AnimalsSrv).where({
                ID:ID
            })
            return "Successfully updated";
        }catch(error){
            request.error("Error : ",error)
        }
        
    });

    this.on('deleteApplication', async (request ,response)=>{
        
        const{
            ID
        } = request.data;

        try{
            const objTransaction = cds.tx(request);

            await objTransaction.delete(AdoptionApplicationsSrv).where({
                ID:ID
            })
            return "Successfully updated";
        }catch(error){
            request.error("Error : ",error)
        }
        
    });

    this.on('deleteHealthRecord', async (request ,response)=>{
        
        const{
            ID
        } = request.data;

        try{
            const objTransaction = cds.tx(request);

            await objTransaction.delete(HealthRecordsSrv).where({
                ID:ID
            })
            return "Successfully updated";
        }catch(error){
            request.error("Error : ",error)
        }
        
    });

    this.on('deleteInspection', async (request ,response)=>{
        
        const{
            ID
        } = request.data;

        try{
            const objTransaction = cds.tx(request);

            await objTransaction.delete(InspectionsSrv).where({
                ID:ID
            })
            return "Successfully updated";
        }catch(error){
            request.error("Error : ",error)
        }
        
    });

    

});