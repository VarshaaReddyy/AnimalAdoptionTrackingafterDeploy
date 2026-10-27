using CatalogService as service from '../../srv/cat-service';


annotate service.AdoptionApplicationsSrv with @(

    UI.HeaderInfo : {
        TypeName : 'Application',
        TypeNamePlural : 'Applications',
        Title : { Value : animal.name },
        Description : { Value : applicant.email }
    },
    UI.LineItem : [
    // FRD Fiori UI #4: applicant, animal, status, date
    {
        $Type : 'UI.DataField',
        Value : applicationDate,
        Label : 'Application Date',
            ![@HTML5.CssDefaults] : { width : '8rem' }
        },
    {
        $Type : 'UI.DataField',
        Value : applicant.firstName,
        Label : 'Applicant',
            ![@HTML5.CssDefaults] : { width : '8rem' }
        },
    {
        $Type : 'UI.DataField',
        Value : animal.name,
        Label : 'Animal',
            ![@HTML5.CssDefaults] : { width : '8rem' }
        },
    {
        $Type : 'UI.DataField',
        Value : status,
        Label : 'Status',
            ![@HTML5.CssDefaults] : { width : '8rem' }
        },
    {
        $Type : 'UI.DataField',
        Value : reasonForAdoption,
        Label : 'Reason for Adoption',
            ![@HTML5.CssDefaults] : { width : '14rem' }
        },
    {
        $Type : 'UI.DataFieldForAction',
        Action : 'CatalogService.markUnderReview',
        Label : 'Start Review'
    },
    {
        $Type : 'UI.DataFieldForAction',
        Action : 'CatalogService.approveApplication',
        Label : 'Approve',
        Inline :true

    },
    {
        $Type : 'UI.DataFieldForAction',
        Action : 'CatalogService.rejectApplication',
        Label : 'Reject',
        Inline : true
    },
    
],
    UI.SelectionFields : [
        status,
        applicationDate
    ],
    // Approve / Reject / Start Review also on the object page header
    UI.Identification : [
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'CatalogService.markUnderReview',
            Label : 'Start Review'
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'CatalogService.approveApplication',
            Label : 'Approve'
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'CatalogService.rejectApplication',
            Label : 'Reject'
        }
    ],
    // FRD Fiori UI #5: applicant and animal information
    UI.FieldGroup #Applicant : {
        $Type : 'UI.FieldGroupType',
        Data : [
            { $Type : 'UI.DataField', Value : applicant.firstName,   Label : 'First Name' },
            { $Type : 'UI.DataField', Value : applicant.lastName,    Label : 'Last Name' },
            { $Type : 'UI.DataField', Value : applicant.email,       Label : 'Email' },
            { $Type : 'UI.DataField', Value : applicant.phoneNumber, Label : 'Phone' },
            { $Type : 'UI.DataField', Value : applicant.city,        Label : 'City' }
        ]
    },
    UI.FieldGroup #Animal : {
        $Type : 'UI.FieldGroupType',
        Data : [
            { $Type : 'UI.DataField', Value : animal.name,         Label : 'Name' },
            { $Type : 'UI.DataField', Value : animal.species,      Label : 'Species' },
            { $Type : 'UI.DataField', Value : animal.breed,        Label : 'Breed' },
            { $Type : 'UI.DataField', Value : animal.age,          Label : 'Age (years)' },
            { $Type : 'UI.DataField', Value : animal.animalStatus, Label : 'Adoption Status' }
        ]
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
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'ApplicantFacet',
            Label : 'Applicant Information',
            Target : '@UI.FieldGroup#Applicant',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'AnimalFacet',
            Label : 'Animal Information',
            Target : '@UI.FieldGroup#Animal',
        },
        // FRD Fiori UI #6: application audit history
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'HistoryFacet',
            Label : 'Status History',
            Target : 'history/@UI.LineItem',
        },
    ],
  

    Capabilities.InsertRestrictions : {
        Insertable : false
    },


    Capabilities.DeleteRestrictions : {
        Deletable : false
    }


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
// STATUS HISTORY TABLE (shown on the application object page)
// ==========================================================

annotate service.ApplicationStatusHistorySrv with @(
    UI.LineItem : [
        { $Type : 'UI.DataField', Value : changedAt, Label : 'Changed At' },
        { $Type : 'UI.DataField', Value : oldStatus, Label : 'From' },
        { $Type : 'UI.DataField', Value : newStatus, Label : 'To' },
        { $Type : 'UI.DataField', Value : changedBy, Label : 'Changed By' },
        { $Type : 'UI.DataField', Value : remarks,   Label : 'Remarks',
            ![@HTML5.CssDefaults] : { width : '14rem' }
        }
    ],
    UI.PresentationVariant : {
        SortOrder : [ { Property : changedAt, Descending : true } ],
        Visualizations : [ '@UI.LineItem' ]
    }
);

// Label of the parameter in the Reject dialog
annotate service.AdoptionApplicationsSrv actions {
    rejectApplication(reason @title : 'Rejection Reason' @UI.MultiLineText);
};


// Actions enabled only for the right statuses
annotate service.AdoptionApplicationsSrv actions {
    markUnderReview    @Core.OperationAvailable : { $edmJson : { $Eq : [ { $Path : 'in/status' }, 'SUBMITTED' ] } };
    approveApplication @Core.OperationAvailable : { $edmJson : { $Or : [
                            { $Eq : [ { $Path : 'in/status' }, 'SUBMITTED' ] },
                            { $Eq : [ { $Path : 'in/status' }, 'UNDER_REVIEW' ] } ] } };
    rejectApplication  @Core.OperationAvailable : { $edmJson : { $Or : [
                            { $Eq : [ { $Path : 'in/status' }, 'SUBMITTED' ] },
                            { $Eq : [ { $Path : 'in/status' }, 'UNDER_REVIEW' ] } ] } };
};
