using CatalogService as service from '../../srv/cat-service';
annotate service.SheltersSrv with @(
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
                Label : 'Shelter Name',
                Value : shelterName,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Shelter Code',
                Value : shelterCode,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Address Line 1',
                Value : addressLine1,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Address Line 2',
                Value : addressLine2,
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
                Label : 'Country',
                Value : country,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Contact Number',
                Value : contactNumber,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Email',
                Value : email,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Website',
                Value : website,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Capacity',
                Value : capacity,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Current Occupancy',
                Value : currentOccupancy,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Opening Time',
                Value : operatingTime,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Closing Time',
                Value : closingTime,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Shelter Type',
                Value : shelterType,
            },
            {
                $Type : 'UI.DataField',
                Label : 'License Number',
                Value : licenseNumber,
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

