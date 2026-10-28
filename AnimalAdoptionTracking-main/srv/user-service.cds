using { db as my } from '../db/schema';
using from '../db/statustexts';

using {
    db.common.Description
} from '../db/common';

@requires: 'User'
service UserCatalogService {


    @readonly
    entity AnimalsSrv as projection on my.Animals
    actions {

        action applyForAdoption(
            reasonForAdoption : Description,
            housingDetails    : Description,
            petExperience     : Description
        ) returns AdoptionApplicationsSrv;

    };



    entity AdoptionApplicationsSrv
        as projection on my.AdoptionApplications
        actions {
            // Withdraw an own application before review (FR-USR-008)
            action withdrawApplication() returns String;
        };




    @readonly
    entity ApplicationStatusHistorySrv
        as projection on my.ApplicationStatusHistory;


    
    @readonly
    entity StatusTexts as projection on my.StatusTexts;

 

    @readonly
    entity InspectionsSrv as projection on my.Inspections;



    @readonly
    entity AdoptionsSrv as projection on my.Adoptions;




    @readonly
    entity HealthRecordsSrv as projection on my.HealthRecords;



    @readonly
    entity SheltersSrv as projection on my.Shelters;



    entity UsersSrv as projection on my.Users
    actions {
        action editProfile(
            firstName   : String,
            lastName    : String,
            email       : String,
            phoneNumber : String,
            address     : String,
            city        : String,
            state       : String,
            postalCode  : String
        ) returns UsersSrv;
    };


    @readonly
    entity UserDashboardStats {
        key ID                  : String;

        myApplications         : Integer;
        pendingApplications    : Integer;
        approvedApplications   : Integer;
        myAdoptions            : Integer;
    }

}




annotate UserCatalogService.UsersSrv with @odata.draft.enabled;

annotate UserCatalogService.UsersSrv with @(
    Capabilities.InsertRestrictions : { Insertable : false }
) {
    email  @readonly;
    role   @readonly;
    status @readonly;
};
