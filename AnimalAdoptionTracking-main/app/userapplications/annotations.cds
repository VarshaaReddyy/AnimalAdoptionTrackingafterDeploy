using UserCatalogService as service from '../../srv/user-service';
annotate service.AdoptionApplicationsSrv with @(
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
                Label : 'Application Date',
                Value : applicationDate,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Reason for Adoption',
                Value : reasonForAdoption,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Housing Details',
                Value : housingDetails,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Pet Experience',
                Value : petExperience,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Status',
                Value : status,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Reviewer Comments',
                Value : staffRemarks,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'Application Details',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
        // FR-USR-011: status history of the application
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'HistoryFacet',
            Label : 'Status History',
            Target : 'history/@UI.LineItem',
        },
    ],
    // FR-USR-009 / 010: animal, status and reviewer comments at a glance
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'Animal',
            Value : animal.name,
            ![@HTML5.CssDefaults] : { width : '8rem' }
        },
        {
            $Type : 'UI.DataField',
            Label : 'Application Date',
            Value : applicationDate,
            ![@HTML5.CssDefaults] : { width : '8rem' }
        },
        {
            $Type : 'UI.DataField',
            Label : 'Status',
            Value : status,
            ![@HTML5.CssDefaults] : { width : '8rem' }
        },
        {
            $Type : 'UI.DataField',
            Label : 'Reviewer Comments',
            Value : staffRemarks,
            ![@HTML5.CssDefaults] : { width : '14rem' }
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'UserCatalogService.withdrawApplication',
            Label : 'Withdraw',
            Inline : true
        },
    ],
    UI.Identification : [
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'UserCatalogService.withdrawApplication',
            Label : 'Withdraw Application'
        }
    ],
    UI.SelectionFields : [ status ],
    // Applications are created with "Apply for Adoption" on an animal,
    // and withdrawn instead of deleted
    Capabilities.InsertRestrictions : { Insertable : false },
    Capabilities.DeleteRestrictions : { Deletable : false },
);

annotate service.AdoptionApplicationsSrv with {
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

annotate service.AdoptionApplicationsSrv with {
    applicant @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'UsersSrv',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : applicant_ID,
                ValueListProperty : 'ID',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'firstName',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'lastName',
            },
        ],
    }
};

annotate service.AdoptionApplicationsSrv with {
    reviewedBy @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'UsersSrv',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : reviewedBy_ID,
                ValueListProperty : 'ID',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'firstName',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'lastName',
            },
        ],
    }
};


// ==========================================================
// STATUS HISTORY TABLE (FR-USR-011)
// ==========================================================

annotate service.ApplicationStatusHistorySrv with @(
    UI.LineItem : [
        { $Type : 'UI.DataField', Value : changedAt, Label : 'Changed At' },
        { $Type : 'UI.DataField', Value : oldStatus, Label : 'From' },
        { $Type : 'UI.DataField', Value : newStatus, Label : 'To' },
        { $Type : 'UI.DataField', Value : remarks,   Label : 'Remarks',
            ![@HTML5.CssDefaults] : { width : '14rem' }
        }
    ],
    UI.PresentationVariant : {
        SortOrder : [ { Property : changedAt, Descending : true } ],
        Visualizations : [ '@UI.LineItem' ]
    }
);


// Page title = animal name; Withdraw is enabled only while Submitted
annotate service.AdoptionApplicationsSrv with @(
    UI.HeaderInfo : {
        TypeName       : 'Application',
        TypeNamePlural : 'My Applications',
        Title          : { Value : animal.name },
        Description    : { Value : status }
    }
);

annotate service.AdoptionApplicationsSrv actions {
    withdrawApplication @Core.OperationAvailable : { $edmJson : { $Eq : [ { $Path : 'in/status' }, 'SUBMITTED' ] } };
};
