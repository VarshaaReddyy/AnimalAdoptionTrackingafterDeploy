using { db } from './schema';


annotate db.Users with {
    ID          @title : 'User ID';
    firstName   @title : 'First Name';
    lastName    @title : 'Last Name';
    email       @title : 'Email';
    phoneNumber @title : 'Phone';
    address     @title : 'Address';
    city        @title : 'City';
    state       @title : 'State';
    postalCode  @title : 'Postal Code';
    role        @title : 'Role';
    status      @title : 'Account Status';
};

annotate db.Shelters with {
    ID               @title : 'Shelter ID';
    shelterName      @title : 'Shelter Name';
    shelterCode      @title : 'Shelter Code';
    addressLine1     @title : 'Address Line 1';
    addressLine2     @title : 'Address Line 2';
    city             @title : 'City';
    state            @title : 'State';
    postalCode       @title : 'Postal Code';
    country          @title : 'Country';
    contactNumber    @title : 'Contact Number';
    email            @title : 'Email';
    website          @title : 'Website';
    capacity         @title : 'Capacity';
    currentOccupancy @title : 'Current Occupancy';
    operatingTime    @title : 'Opening Time';
    closingTime      @title : 'Closing Time';
    shelterType      @title : 'Shelter Type';
    licenseNumber    @title : 'License Number';
};

annotate db.Animals with {
    ID                @title : 'Animal ID';
    shelter           @title : 'Shelter';
    name              @title : 'Name';
    species           @title : 'Species';
    breed             @title : 'Breed';
    gender            @title : 'Gender';
    age               @title : 'Age (years)';
    arrivalDate       @title : 'Arrival Date';
    animalStatus      @title : 'Adoption Status';
    vaccinationStatus @title : 'Vaccination Status';
    spayedOrNeutered  @title : 'Spayed / Neutered';
    photo             @title : 'Photo';
    description       @title : 'Description';
};

annotate db.AdoptionApplications with {
    ID                @title : 'Application ID';
    animal            @title : 'Animal';
    applicant         @title : 'Applicant';
    applicationDate   @title : 'Application Date';
    reasonForAdoption @title : 'Reason for Adoption';
    housingDetails    @title : 'Housing Details';
    petExperience     @title : 'Pet Experience';
    status            @title : 'Status';
    reviewedBy        @title : 'Reviewed By';
    staffRemarks      @title : 'Reviewer Comments';
};

annotate db.Adoptions with {
    ID           @title : 'Adoption ID';
    application  @title : 'Application';
    animal       @title : 'Animal';
    adoptionDate @title : 'Adoption Date';
    status       @title : 'Status';
    completedBy  @title : 'Completed By';
    remarks      @title : 'Remarks';
};

annotate db.HealthRecords with {
    ID               @title : 'Health Record ID';
    animal           @title : 'Animal';
    checkupDate      @title : 'Checkup Date';
    healthStatus     @title : 'Health Status';
    diagnosis        @title : 'Diagnosis';
    treatment        @title : 'Treatment';
    medication       @title : 'Medication';
    veterinarianName @title : 'Veterinarian';
    weight           @title : 'Weight (kg)';
    nextCheckupDate  @title : 'Next Checkup';
    remarks          @title : 'Remarks';
    medicalDocument  @title : 'Medical Document';
};

annotate db.Inspections with {
    ID                 @title : 'Inspection ID';
    adoption           @title : 'Adoption';
    inspector          @title : 'Inspector';
    inspectionDate     @title : 'Inspection Date';
    inspectionType     @title : 'Inspection Type';
    existingPetDetails @title : 'Existing Pet Details';
    result             @title : 'Result';
    remarks            @title : 'Remarks';
    inspectionDocument @title : 'Inspection Document';
};

annotate db.ApplicationStatusHistory with {
    oldStatus @title : 'From Status';
    newStatus @title : 'To Status';
    changedBy @title : 'Changed By';
    changedAt @title : 'Changed At';
    remarks   @title : 'Remarks';
};



annotate db.Animals with {
    ID      @UI.Hidden;
    shelter @Common.Text : shelter.shelterName  @Common.TextArrangement : #TextOnly;
};

annotate db.Shelters with {
    ID @UI.Hidden;
};

annotate db.Users with {
    ID @UI.Hidden;
};

annotate db.HealthRecords with {
    ID     @UI.Hidden;
    animal @Common.Text : animal.name  @Common.TextArrangement : #TextOnly;
};

annotate db.Inspections with {
    ID        @UI.Hidden;
    adoption  @Common.Text : adoption.animal.name  @Common.TextArrangement : #TextOnly;
    inspector @Common.Text : inspector.firstName   @Common.TextArrangement : #TextOnly;
};

annotate db.AdoptionApplications with {
    animal     @Common.Text : animal.name           @Common.TextArrangement : #TextOnly;
    applicant  @Common.Text : applicant.firstName   @Common.TextArrangement : #TextOnly;
    reviewedBy @Common.Text : reviewedBy.firstName  @Common.TextArrangement : #TextOnly;
};

annotate db.Adoptions with {
    ID          @UI.Hidden;
    application @UI.Hidden;
    animal      @Common.Text : animal.name           @Common.TextArrangement : #TextOnly;
    completedBy @Common.Text : completedBy.firstName @Common.TextArrangement : #TextOnly;
};
