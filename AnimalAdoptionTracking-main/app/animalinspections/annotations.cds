using CatalogService as service from '../../srv/cat-service';
annotate service.InspectionsSrv with @(
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
                Label : 'Inspection Date',
                Value : inspectionDate,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Inspection Type',
                Value : inspectionType,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Existing Pet Details',
                Value : existingPetDetails,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Result',
                Value : result,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Remarks',
                Value : remarks,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Inspection Document',
                Value : inspectionDocument,
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
    ],
);

annotate service.InspectionsSrv with {
    adoption @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'AdoptionsSrv',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : adoption_ID,
                ValueListProperty : 'ID',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'adoptionDate',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'status',
            },
        ],
    }
};

annotate service.InspectionsSrv with {
    inspector @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'UsersSrv',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : inspector_ID,
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

