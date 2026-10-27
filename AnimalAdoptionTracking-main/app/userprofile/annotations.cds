using UserCatalogService as service from '../../srv/user-service';
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
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'First Name',
            Value : firstName,
            ![@HTML5.CssDefaults] : { width : '8rem' }
        },
        {
            $Type : 'UI.DataField',
            Label : 'Last Name',
            Value : lastName,
            ![@HTML5.CssDefaults] : { width : '8rem' }
        },
        {
            $Type : 'UI.DataField',
            Label : 'Email',
            Value : email,
            ![@HTML5.CssDefaults] : { width : '14rem' }
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'UserCatalogService.editProfile',
            Label : 'Edit Profile'
        }
    ],
);



// Edit Profile dialog opens pre-filled with the current values;
// email is the login identity and is not editable here
annotate service.UsersSrv actions {
    editProfile(
        firstName   @UI.ParameterDefaultValue : { $edmJson : { $Path : 'in/firstName' } }   @title : 'First Name',
        lastName    @UI.ParameterDefaultValue : { $edmJson : { $Path : 'in/lastName' } }    @title : 'Last Name',
        email       @UI.Hidden,
        phoneNumber @UI.ParameterDefaultValue : { $edmJson : { $Path : 'in/phoneNumber' } } @title : 'Phone',
        address     @UI.ParameterDefaultValue : { $edmJson : { $Path : 'in/address' } }     @title : 'Address',
        city        @UI.ParameterDefaultValue : { $edmJson : { $Path : 'in/city' } }        @title : 'City',
        state       @UI.ParameterDefaultValue : { $edmJson : { $Path : 'in/state' } }       @title : 'State',
        postalCode  @UI.ParameterDefaultValue : { $edmJson : { $Path : 'in/postalCode' } }  @title : 'Postal Code'
    );
};
