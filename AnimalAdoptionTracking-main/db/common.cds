namespace db.common;

/* Generic Types */

type GUID              : UUID;
type Name              : String(100);
type ShortCode         : String(20);
type Description       : String(500);
type LongText          : String(1000);
type Address           : String(255);
type Email             : String(255);
type PhoneNumber       : String(20);
type Website           : String(200);
type PostalCode        : String(20);
type City              : String(100);
type State             : String(100);

type Weight            : Decimal(10,2);
type Percentage        : Decimal(5,2);

type CreatedAt         : Timestamp;
type ModifiedAt        : Timestamp;

/* ENUMS */

type UserRole : String enum {
    ADOPTER;
    SHELTER_STAFF;
    ADMIN;
};

type UserStatus : String enum {
    ACTIVE;
    INACTIVE;
    SUSPENDED;
};

type AnimalStatus : String enum {
    AVAILABLE;
    RESERVED;
    ADOPTED;
    MEDICAL_HOLD;
    QUARANTINE;
};

type VaccinationStatus : String enum {
    PENDING;
    PARTIAL;
    COMPLETED;
};

type ApplicationStatus : String enum {
    SUBMITTED;
    UNDER_REVIEW;
    APPROVED;
    REJECTED;
    WITHDRAWN;
};

type AdoptionStatus : String enum {
    PENDING;
    COMPLETED;
    CANCELLED;
};

type InspectionType : String enum {
    HOME_VISIT;
    FOLLOW_UP;
    FINAL_REVIEW;
};

type InspectionResult : String enum {
    PASS;
    FAIL;
    PENDING;
};

type HealthStatus : String enum {
    HEALTHY;
    UNDER_TREATMENT;
    CRITICAL;
    RECOVERED;
};

type ShelterType : String enum {
    GOVERNMENT;
    PRIVATE;
    NGO;
    RESCUE_CENTER;
};

type YesNo : String enum {
    YES;
    NO;
};

aspect AuditFields {
    createdAt  : Timestamp   @cds.on.insert: $now;
    createdBy  : String(255) @cds.on.insert: $user;
    modifiedAt : Timestamp   @cds.on.insert: $now  @cds.on.update: $now;
    modifiedBy : String(255) @cds.on.insert: $user @cds.on.update: $user;
} 

