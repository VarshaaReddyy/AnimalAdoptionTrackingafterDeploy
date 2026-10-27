using CatalogService as service from '../../srv/cat-service';
annotate service.UsersSrv with @(
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
                Label : 'First Name',
                Value : firstName,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Last Name',
                Value : lastName,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Email',
                Value : email,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Phone',
                Value : phoneNumber,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Address',
                Value : address,
            },
            {
                $Type : 'UI.DataField',
                Label : 'City',
                Value : city,
            },
            {
                $Type : 'UI.DataField',
                Label : 'State',
                Value : state,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Postal Code',
                Value : postalCode,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Role',
                Value : role,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Status',
                Value : status,
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

