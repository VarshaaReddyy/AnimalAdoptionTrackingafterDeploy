using { db } from './schema';



entity db.StatusTexts {
    key type : String(40);   // name of the code type, e.g. 'AnimalStatus'
    key code : String(40);   // stored code,           e.g. 'AVAILABLE'
        text : String(100);  // shown to the user,     e.g. 'Available'
}

annotate db.StatusTexts with {
    code @title : 'Code' @Common.Text : text @Common.TextArrangement : #TextOnly;
    text @title : 'Description';
    type @UI.Hidden;
};

extend db.Users with {
    roleText : Association to one db.StatusTexts on roleText.type = 'UserRole' and roleText.code = role;
    statusText : Association to one db.StatusTexts on statusText.type = 'UserStatus' and statusText.code = status;
}

extend db.Shelters with {
    shelterTypeText : Association to one db.StatusTexts on shelterTypeText.type = 'ShelterType' and shelterTypeText.code = shelterType;
}

extend db.Animals with {
    animalStatusText : Association to one db.StatusTexts on animalStatusText.type = 'AnimalStatus' and animalStatusText.code = animalStatus;
    vaccinationStatusText : Association to one db.StatusTexts on vaccinationStatusText.type = 'VaccinationStatus' and vaccinationStatusText.code = vaccinationStatus;
    spayedOrNeuteredText : Association to one db.StatusTexts on spayedOrNeuteredText.type = 'YesNo' and spayedOrNeuteredText.code = spayedOrNeutered;
}

extend db.AdoptionApplications with {
    statusText : Association to one db.StatusTexts on statusText.type = 'ApplicationStatus' and statusText.code = status;
}

extend db.Adoptions with {
    statusText : Association to one db.StatusTexts on statusText.type = 'AdoptionStatus' and statusText.code = status;
}

extend db.HealthRecords with {
    healthStatusText : Association to one db.StatusTexts on healthStatusText.type = 'HealthStatus' and healthStatusText.code = healthStatus;
}

extend db.Inspections with {
    inspectionTypeText : Association to one db.StatusTexts on inspectionTypeText.type = 'InspectionType' and inspectionTypeText.code = inspectionType;
    resultText : Association to one db.StatusTexts on resultText.type = 'InspectionResult' and resultText.code = result;
}

extend db.ApplicationStatusHistory with {
    oldStatusText : Association to one db.StatusTexts on oldStatusText.type = 'ApplicationStatus' and oldStatusText.code = oldStatus;
    newStatusText : Association to one db.StatusTexts on newStatusText.type = 'ApplicationStatus' and newStatusText.code = newStatus;
}

annotate db.Users with {
    role
        @Common.Text : roleText.text
        @Common.TextArrangement : #TextOnly
        @Common.ValueListWithFixedValues
        @Common.ValueList : {
            CollectionPath : 'StatusTexts',
            Parameters : [
                { $Type : 'Common.ValueListParameterInOut',    LocalDataProperty : role, ValueListProperty : 'code' },
                { $Type : 'Common.ValueListParameterConstant', ValueListProperty : 'type', Constant : 'UserRole' }
            ]
        }
        @assert.range;
    status
        @Common.Text : statusText.text
        @Common.TextArrangement : #TextOnly
        @Common.ValueListWithFixedValues
        @Common.ValueList : {
            CollectionPath : 'StatusTexts',
            Parameters : [
                { $Type : 'Common.ValueListParameterInOut',    LocalDataProperty : status, ValueListProperty : 'code' },
                { $Type : 'Common.ValueListParameterConstant', ValueListProperty : 'type', Constant : 'UserStatus' }
            ]
        }
        @assert.range;
};

annotate db.Shelters with {
    shelterType
        @Common.Text : shelterTypeText.text
        @Common.TextArrangement : #TextOnly
        @Common.ValueListWithFixedValues
        @Common.ValueList : {
            CollectionPath : 'StatusTexts',
            Parameters : [
                { $Type : 'Common.ValueListParameterInOut',    LocalDataProperty : shelterType, ValueListProperty : 'code' },
                { $Type : 'Common.ValueListParameterConstant', ValueListProperty : 'type', Constant : 'ShelterType' }
            ]
        }
        @assert.range;
};

annotate db.Animals with {
    animalStatus
        @Common.Text : animalStatusText.text
        @Common.TextArrangement : #TextOnly
        @Common.ValueListWithFixedValues
        @Common.ValueList : {
            CollectionPath : 'StatusTexts',
            Parameters : [
                { $Type : 'Common.ValueListParameterInOut',    LocalDataProperty : animalStatus, ValueListProperty : 'code' },
                { $Type : 'Common.ValueListParameterConstant', ValueListProperty : 'type', Constant : 'AnimalStatus' }
            ]
        }
        @assert.range;
    vaccinationStatus
        @Common.Text : vaccinationStatusText.text
        @Common.TextArrangement : #TextOnly
        @Common.ValueListWithFixedValues
        @Common.ValueList : {
            CollectionPath : 'StatusTexts',
            Parameters : [
                { $Type : 'Common.ValueListParameterInOut',    LocalDataProperty : vaccinationStatus, ValueListProperty : 'code' },
                { $Type : 'Common.ValueListParameterConstant', ValueListProperty : 'type', Constant : 'VaccinationStatus' }
            ]
        }
        @assert.range;
    spayedOrNeutered
        @Common.Text : spayedOrNeuteredText.text
        @Common.TextArrangement : #TextOnly
        @Common.ValueListWithFixedValues
        @Common.ValueList : {
            CollectionPath : 'StatusTexts',
            Parameters : [
                { $Type : 'Common.ValueListParameterInOut',    LocalDataProperty : spayedOrNeutered, ValueListProperty : 'code' },
                { $Type : 'Common.ValueListParameterConstant', ValueListProperty : 'type', Constant : 'YesNo' }
            ]
        }
        @assert.range;
};

annotate db.AdoptionApplications with {
    status
        @Common.Text : statusText.text
        @Common.TextArrangement : #TextOnly
        @Common.ValueListWithFixedValues
        @Common.ValueList : {
            CollectionPath : 'StatusTexts',
            Parameters : [
                { $Type : 'Common.ValueListParameterInOut',    LocalDataProperty : status, ValueListProperty : 'code' },
                { $Type : 'Common.ValueListParameterConstant', ValueListProperty : 'type', Constant : 'ApplicationStatus' }
            ]
        }
        @assert.range;
};

annotate db.Adoptions with {
    status
        @Common.Text : statusText.text
        @Common.TextArrangement : #TextOnly
        @Common.ValueListWithFixedValues
        @Common.ValueList : {
            CollectionPath : 'StatusTexts',
            Parameters : [
                { $Type : 'Common.ValueListParameterInOut',    LocalDataProperty : status, ValueListProperty : 'code' },
                { $Type : 'Common.ValueListParameterConstant', ValueListProperty : 'type', Constant : 'AdoptionStatus' }
            ]
        }
        @assert.range;
};

annotate db.HealthRecords with {
    healthStatus
        @Common.Text : healthStatusText.text
        @Common.TextArrangement : #TextOnly
        @Common.ValueListWithFixedValues
        @Common.ValueList : {
            CollectionPath : 'StatusTexts',
            Parameters : [
                { $Type : 'Common.ValueListParameterInOut',    LocalDataProperty : healthStatus, ValueListProperty : 'code' },
                { $Type : 'Common.ValueListParameterConstant', ValueListProperty : 'type', Constant : 'HealthStatus' }
            ]
        }
        @assert.range;
};

annotate db.Inspections with {
    inspectionType
        @Common.Text : inspectionTypeText.text
        @Common.TextArrangement : #TextOnly
        @Common.ValueListWithFixedValues
        @Common.ValueList : {
            CollectionPath : 'StatusTexts',
            Parameters : [
                { $Type : 'Common.ValueListParameterInOut',    LocalDataProperty : inspectionType, ValueListProperty : 'code' },
                { $Type : 'Common.ValueListParameterConstant', ValueListProperty : 'type', Constant : 'InspectionType' }
            ]
        }
        @assert.range;
    result
        @Common.Text : resultText.text
        @Common.TextArrangement : #TextOnly
        @Common.ValueListWithFixedValues
        @Common.ValueList : {
            CollectionPath : 'StatusTexts',
            Parameters : [
                { $Type : 'Common.ValueListParameterInOut',    LocalDataProperty : result, ValueListProperty : 'code' },
                { $Type : 'Common.ValueListParameterConstant', ValueListProperty : 'type', Constant : 'InspectionResult' }
            ]
        }
        @assert.range;
};

annotate db.ApplicationStatusHistory with {
    oldStatus
        @Common.Text : oldStatusText.text
        @Common.TextArrangement : #TextOnly;
    newStatus
        @Common.Text : newStatusText.text
        @Common.TextArrangement : #TextOnly;
};

