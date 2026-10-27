using CatalogService as service from '../../srv/cat-service';
annotate service.HealthRecordsSrv with @(
    UI.HeaderInfo : {
        TypeName : 'Health Record',
        TypeNamePlural : 'Health Records'
    },

    UI.LineItem : [
        { Value : animal_ID,        Label : 'Animal',
            ![@HTML5.CssDefaults] : { width : '7rem' }
        },
        { Value : checkupDate,      Label : 'Checkup Date',
            ![@HTML5.CssDefaults] : { width : '8rem' }
        },
        { Value : healthStatus,     Label : 'Health Status',
            ![@HTML5.CssDefaults] : { width : '9rem' }
        },
        { Value : veterinarianName, Label : 'Veterinarian',
            ![@HTML5.CssDefaults] : { width : '10rem' }
        },
        { Value : nextCheckupDate,  Label : 'Next Checkup',
            ![@HTML5.CssDefaults] : { width : '8rem' }
        },
        // FR-ADM-014: overdue / due soon / scheduled
        { Value : checkupStatus,    Label : 'Checkup Status', Criticality : checkupCriticality,
            ![@HTML5.CssDefaults] : { width : '8rem' }
        }
    ],
    UI.SelectionFields : [ animal_ID, healthStatus, nextCheckupDate ],
    UI.PresentationVariant : {
        SortOrder : [ { Property : nextCheckupDate, Descending : false } ],
        Visualizations : [ '@UI.LineItem' ]
    },
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
                Label : 'Checkup Date',
                Value : checkupDate,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Health Status',
                Value : healthStatus,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Diagnosis',
                Value : diagnosis,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Treatment',
                Value : treatment,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Medication',
                Value : medication,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Veterinarian Name',
                Value : veterinarianName,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Weight (kg)',
                Value : weight,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Next Checkup',
                Value : nextCheckupDate,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Remarks',
                Value : remarks,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Medical Document',
                Value : medicalDocument,
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
        // FR-ADM-015: change history of this health record
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'ChangesFacet',
            Label : 'Change History',
            Target : 'changes/@UI.LineItem',
        }
    ],
);

annotate service.HealthRecordsSrv with {
    animal @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'AnimalsSrv',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : animal_ID,
                ValueListProperty : 'ID',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'name',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'species',
            },
        ],
    }
};



annotate service.HealthRecordChangesSrv with @(
    UI.LineItem : [
        { $Type : 'UI.DataField', Value : changedAt, Label : 'Changed At' },
        { $Type : 'UI.DataField', Value : field,     Label : 'Field' },
        { $Type : 'UI.DataField', Value : oldValue,  Label : 'Old Value' },
        { $Type : 'UI.DataField', Value : newValue,  Label : 'New Value' },
        { $Type : 'UI.DataField', Value : changedBy, Label : 'Changed By' }
    ],
    UI.PresentationVariant : {
        SortOrder : [ { Property : changedAt, Descending : true } ],
        Visualizations : [ '@UI.LineItem' ]
    }
);
