using CatalogService as service from '../../srv/cat-service';
annotate service.AdoptionsSrv with @(
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
                Label : 'Adoption Date',
                Value : adoptionDate,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Status',
                Value : status,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Remarks',
                Value : remarks,
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
    

    Capabilities.InsertRestrictions : {
        Insertable : false
    },

    Capabilities.UpdateRestrictions : {
        Updatable : false
    },

    Capabilities.DeleteRestrictions : {
        Deletable : false
    }

);

annotate service.AdoptionsSrv with {
    application @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'AdoptionApplicationsSrv',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : application_ID,
                ValueListProperty : 'ID',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'applicationDate',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'reasonForAdoption',
            },
        ],
    }
};

annotate service.AdoptionsSrv with {
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

annotate service.AdoptionsSrv with {
    completedBy @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'UsersSrv',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : completedBy_ID,
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

