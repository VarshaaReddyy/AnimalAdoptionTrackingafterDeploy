using UserCatalogService as service from '../../srv/user-service';

// ==========================================================
// MY ADOPTIONS (FR-USR-012 .. 015, FR-USR-019)
// ==========================================================

annotate service.AdoptionsSrv with @(

    UI.HeaderInfo : {
        TypeName       : 'Adoption',
        TypeNamePlural : 'My Adoptions',
        Title          : { Value : animal.name },
        Description    : { Value : animal.breed }
    },

    UI.LineItem : [
        { $Type : 'UI.DataField', Value : animal.name,         Label : 'Animal',
            ![@HTML5.CssDefaults] : { width : '8rem' }
        },
        { $Type : 'UI.DataField', Value : animal.species,      Label : 'Species',
            ![@HTML5.CssDefaults] : { width : '7rem' }
        },
        { $Type : 'UI.DataField', Value : adoptionDate,        Label : 'Adoption Date',
            ![@HTML5.CssDefaults] : { width : '8rem' }
        },
        { $Type : 'UI.DataField', Value : animal.shelter.shelterName, Label : 'Adopted From',
            ![@HTML5.CssDefaults] : { width : '11rem' }
        },
        { $Type : 'UI.DataField', Value : status,              Label : 'Status',
            ![@HTML5.CssDefaults] : { width : '8rem' }
        }
    ],

    UI.FieldGroup #Adoption : {
        $Type : 'UI.FieldGroupType',
        Data : [
            { $Type : 'UI.DataField', Value : adoptionDate, Label : 'Adoption Date' },
            { $Type : 'UI.DataField', Value : status,       Label : 'Status' },
            { $Type : 'UI.DataField', Value : remarks,      Label : 'Remarks' }
        ]
    },

    UI.FieldGroup #Animal : {
        $Type : 'UI.FieldGroupType',
        Data : [
            { $Type : 'UI.DataField', Value : animal.name,              Label : 'Name' },
            { $Type : 'UI.DataField', Value : animal.species,           Label : 'Species' },
            { $Type : 'UI.DataField', Value : animal.breed,             Label : 'Breed' },
            { $Type : 'UI.DataField', Value : animal.gender,            Label : 'Gender' },
            { $Type : 'UI.DataField', Value : animal.age,               Label : 'Age (years)' },
            { $Type : 'UI.DataField', Value : animal.vaccinationStatus, Label : 'Vaccination Status' }
        ]
    },

    UI.FieldGroup #Shelter : {
        $Type : 'UI.FieldGroupType',
        Data : [
            { $Type : 'UI.DataField', Value : animal.shelter.shelterName,   Label : 'Shelter' },
            { $Type : 'UI.DataField', Value : animal.shelter.city,          Label : 'City' },
            { $Type : 'UI.DataField', Value : animal.shelter.contactNumber, Label : 'Contact Number' },
            { $Type : 'UI.DataField', Value : animal.shelter.email,         Label : 'Email' }
        ]
    },

    UI.Facets : [
        { $Type : 'UI.ReferenceFacet', ID : 'AdoptionFacet',    Label : 'Adoption',    Target : '@UI.FieldGroup#Adoption' },
        { $Type : 'UI.ReferenceFacet', ID : 'AnimalFacet',      Label : 'Animal',      Target : '@UI.FieldGroup#Animal' },
        { $Type : 'UI.ReferenceFacet', ID : 'ShelterFacet',     Label : 'Shelter',     Target : '@UI.FieldGroup#Shelter' },
        // FR-USR-019: post-adoption inspection status and result
        { $Type : 'UI.ReferenceFacet', ID : 'InspectionsFacet', Label : 'Post-Adoption Inspections', Target : 'inspections/@UI.LineItem' }
    ]
);

annotate service.InspectionsSrv with @(
    UI.LineItem : [
        { $Type : 'UI.DataField', Value : inspectionDate,     Label : 'Inspection Date',
            ![@HTML5.CssDefaults] : { width : '8rem' }
        },
        { $Type : 'UI.DataField', Value : inspectionType,     Label : 'Type',
            ![@HTML5.CssDefaults] : { width : '8rem' }
        },
        { $Type : 'UI.DataField', Value : result,             Label : 'Result',
            ![@HTML5.CssDefaults] : { width : '6rem' }
        },
        { $Type : 'UI.DataField', Value : remarks,            Label : 'Remarks',
            ![@HTML5.CssDefaults] : { width : '14rem' }
        },
        { $Type : 'UI.DataField', Value : inspectionDocument, Label : 'Inspection Document' }
    ]
);
