using UserCatalogService as service from '../../srv/user-service';
annotate service.AnimalsSrv with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'Created At',
                Value : createdAt,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Last Changed At',
                Value : modifiedAt,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Name',
                Value : name,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Species',
                Value : species,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Breed',
                Value : breed,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Gender',
                Value : gender,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Age (years)',
                Value : age,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Arrival Date',
                Value : arrivalDate,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Adoption Status',
                Value : animalStatus,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Vaccination Status',
                Value : vaccinationStatus,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Spayed / Neutered',
                Value : spayedOrNeutered,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Photo',
                Value : photo,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Description',
                Value : description,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'HealthSummaryFacet',
            Label : 'Health & Eligibility',
            Target : '@UI.FieldGroup#HealthSummary',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'HealthRecordsFacet',
            Label : 'Health Records & Upcoming Checkups',
            Target : 'healthRecords/@UI.LineItem',
        }
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'Name',
            Value : name,
            ![@HTML5.CssDefaults] : { width : '8rem' }
        },
        {
            $Type : 'UI.DataField',
            Label : 'Species',
            Value : species,
            ![@HTML5.CssDefaults] : { width : '7rem' }
        },
        {
            $Type : 'UI.DataField',
            Label : 'Breed',
            Value : breed,
            ![@HTML5.CssDefaults] : { width : '10rem' }
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'UserCatalogService.applyForAdoption',
            Label : 'Apply for Adoption'
        },
        {
            $Type : 'UI.DataField',
            Label : 'Adoption Eligibility',
            Value : adoptionEligibility,
            Criticality : eligibilityCriticality,
            ![@HTML5.CssDefaults] : { width : '15rem' }
        }
    ],
);

annotate service.AnimalsSrv with {
    shelter @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'SheltersSrv',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : shelter_ID,
                ValueListProperty : 'ID',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'shelterName',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'shelterCode',
            },
            
        ],
    }
};



// FR-USR-004 / 016 / 017: read-only health information for adopters
annotate service.AnimalsSrv with @(
    UI.FieldGroup #HealthSummary : {
        $Type : 'UI.FieldGroupType',
        Data : [
            { $Type : 'UI.DataField', Value : adoptionEligibility, Label : 'Adoption Eligibility', Criticality : eligibilityCriticality },
            { $Type : 'UI.DataField', Value : animalStatus,        Label : 'Adoption Status' },
            { $Type : 'UI.DataField', Value : vaccinationStatus,   Label : 'Vaccination Status' },
            { $Type : 'UI.DataField', Value : spayedOrNeutered,    Label : 'Spayed / Neutered' },
            { $Type : 'UI.DataField', Value : shelter.shelterName, Label : 'Shelter' },
            { $Type : 'UI.DataField', Value : shelter.city,        Label : 'Shelter City' }
        ]
    }
);

annotate service.HealthRecordsSrv with @(
    UI.LineItem : [
        { $Type : 'UI.DataField', Value : checkupDate,     Label : 'Checkup Date' },
        { $Type : 'UI.DataField', Value : healthStatus,    Label : 'Health Status' },
        { $Type : 'UI.DataField', Value : diagnosis,       Label : 'Diagnosis' },
        { $Type : 'UI.DataField', Value : treatment,       Label : 'Treatment' },
        { $Type : 'UI.DataField', Value : nextCheckupDate, Label : 'Next Checkup' },
        { $Type : 'UI.DataField', Value : checkupStatus,   Label : 'Checkup Status', Criticality : checkupCriticality },
        { $Type : 'UI.DataField', Value : medicalDocument, Label : 'Health Certificate' }
    ],
    UI.PresentationVariant : {
        SortOrder : [ { Property : checkupDate, Descending : true } ],
        Visualizations : [ '@UI.LineItem' ]
    }
);
