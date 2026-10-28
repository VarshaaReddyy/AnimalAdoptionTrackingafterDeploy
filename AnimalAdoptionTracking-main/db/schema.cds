namespace db;

using {
    db.common.AuditFields,
    db.common.GUID,
    db.common.Name,
    db.common.ShortCode,
    db.common.Description,
    db.common.Address,
    db.common.Email,
    db.common.PhoneNumber,
    db.common.Website,
    db.common.PostalCode,
    db.common.City,
    db.common.State,
    db.common.Weight,

    db.common.UserRole,
    db.common.UserStatus,
    db.common.AnimalStatus,
    db.common.VaccinationStatus,
    db.common.ApplicationStatus,
    db.common.AdoptionStatus,
    db.common.HealthStatus,
    db.common.InspectionType,
    db.common.InspectionResult,
    db.common.ShelterType,
    db.common.YesNo
} from './common';


entity Users : AuditFields{

    key ID              : GUID;

    firstName           : Name;
    lastName            : Name;
    email               : Email;
    phoneNumber         : PhoneNumber;

    address             : Address;
    city                : City;
    state               : State;
    postalCode          : PostalCode;

    role                : UserRole;
    status              : UserStatus;


    applications        : Association to many AdoptionApplications
                          on applications.applicant = $self;
}


entity Shelters : AuditFields{

    key ID              : GUID;

    shelterName         : Name;
    shelterCode         : ShortCode;

    addressLine1        : Address;
    addressLine2        : Address;

    city                : City;
    state               : State;
    postalCode          : PostalCode;

    country             : String(50);
    contactNumber       : PhoneNumber;
    email               : Email;
    website             : Website;

    capacity            : Integer;
    currentOccupancy    : Integer;

    operatingTime       : Time;
    closingTime         : Time;

    shelterType         : ShelterType;
    licenseNumber       : String(50);


    animals             : Association to many Animals
                          on animals.shelter = $self;
}


entity Animals : AuditFields{

    key ID              : GUID;

    shelter             : Association to Shelters;

    name                : Name;
    species             : String(100);
    breed               : String(100);
    gender              : String(20);

    age                 : Integer;
    arrivalDate         : Date;

    animalStatus        : AnimalStatus;
    vaccinationStatus   : VaccinationStatus;
    spayedOrNeutered    : YesNo;

    photo               : String(500);
    description         : Description;


    applications        : Association to many AdoptionApplications
                          on applications.animal = $self;

    healthRecords       : Association to many HealthRecords
                          on healthRecords.animal = $self;
}


entity AdoptionApplications : AuditFields {

    key ID              : GUID;

    animal              : Association to Animals;
    applicant           : Association to Users;

    applicationDate     : Date;

    reasonForAdoption   : Description;
    housingDetails      : Description;
    petExperience       : Description;

    status              : ApplicationStatus;

    reviewedBy          : Association to Users;
    staffRemarks        : Description;


    adoption            : Association to one Adoptions
                          on adoption.application = $self;


    history             : Association to many ApplicationStatusHistory
                          on history.application = $self;
}


entity Adoptions : AuditFields{

    key ID              : GUID;

    application         : Association to AdoptionApplications;
    animal              : Association to Animals;

    adoptionDate        : Date;

    status              : AdoptionStatus;
    completedBy         : Association to Users;

    remarks             : Description;


    inspections         : Association to many Inspections
                          on inspections.adoption = $self;
}


entity HealthRecords : AuditFields{

    key ID              : GUID;

    animal              : Association to Animals;

    checkupDate         : Date;

    healthStatus        : HealthStatus;

    diagnosis           : Description;
    treatment           : Description;
    medication          : Description;

    veterinarianName    : Name;

    weight                : Weight;
    nextCheckupDate     : Date;

    remarks             : Description;
    medicalDocument     : String(500);


    changes             : Association to many HealthRecordChanges
                          on changes.healthRecord = $self;


}


entity Inspections : AuditFields{

    key ID              : GUID;

    adoption            : Association to Adoptions;

    inspector           : Association to Users;

    inspectionDate      : Date;
    inspectionType      : InspectionType;

    existingPetDetails  : Description;

    result              : InspectionResult;
    remarks             : Description;

    inspectionDocument  : String(500);

}



entity ApplicationStatusHistory {

    key ID              : GUID;

    application         : Association to AdoptionApplications;

    oldStatus           : ApplicationStatus;
    newStatus           : ApplicationStatus;

    changedBy           : String(255);
    changedAt           : Timestamp;

    remarks             : Description;
}


entity HealthRecordChanges {

    key ID              : GUID;

    healthRecord        : Association to HealthRecords;

    field               : String(60);
    oldValue            : String(500);
    newValue            : String(500);

    changedBy           : String(255);
    changedAt           : Timestamp;
}


extend Animals with {
    virtual adoptionEligibility    : String(100);
    virtual eligibilityCriticality : Integer;
}

extend HealthRecords with {
    virtual checkupStatus          : String(30);
    virtual checkupCriticality     : Integer;
}
