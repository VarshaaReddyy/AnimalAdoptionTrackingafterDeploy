using CatalogService as service from '../../srv/cat-service';

using UI from '@sap/cds/common';


annotate CatalogService.UsersSrv with @(
    UI.HeaderInfo : {
        TypeName : 'User',
        TypeNamePlural : 'Users'
    },

    UI.SelectionFields : [
        firstName,
        lastName,
        role,
        status
    ],

    UI.LineItem : [
        { Value : firstName,
            ![@HTML5.CssDefaults] : { width : '8rem' }
        },
        { Value : lastName,
            ![@HTML5.CssDefaults] : { width : '8rem' }
        },
        { Value : email,
            ![@HTML5.CssDefaults] : { width : '14rem' }
        },
        { Value : role,
            ![@HTML5.CssDefaults] : { width : '8rem' }
        },
        { Value : status,
            ![@HTML5.CssDefaults] : { width : '8rem' }
        }
    ]
);

annotate CatalogService.SheltersSrv with @(
    UI.HeaderInfo : {
        TypeName : 'Shelter',
        TypeNamePlural : 'Shelters'
    },

    UI.SelectionFields : [
        shelterName,
        city,
        shelterType
    ],

    UI.LineItem : [
        { Value : shelterName,
            ![@HTML5.CssDefaults] : { width : '11rem' }
        },
        { Value : city,
            ![@HTML5.CssDefaults] : { width : '8rem' }
        },
        { Value : state,
            ![@HTML5.CssDefaults] : { width : '8rem' }
        },
        { Value : capacity,
            ![@HTML5.CssDefaults] : { width : '6rem' }
        },
        { Value : shelterType,
            ![@HTML5.CssDefaults] : { width : '8rem' }
        }
    ]
);




annotate CatalogService.AdoptionsSrv with @(
    UI.HeaderInfo : {
        TypeName : 'Adoption',
        TypeNamePlural : 'Adoptions'
    },

    UI.LineItem : [
        { Value : animal_ID, Label : 'Animal', ![@HTML5.CssDefaults] : { width : '8rem' } },
        { Value : application.applicant.firstName, Label : 'Adopter', ![@HTML5.CssDefaults] : { width : '8rem' } },
        { Value : adoptionDate,
            ![@HTML5.CssDefaults] : { width : '8rem' }
        },
        { Value : status,
            ![@HTML5.CssDefaults] : { width : '8rem' }
        },
        { Value : remarks,
            ![@HTML5.CssDefaults] : { width : '14rem' }
        }
    ]
);



annotate CatalogService.InspectionsSrv with @(
    UI.HeaderInfo : {
        TypeName : 'Inspection',
        TypeNamePlural : 'Inspections'
    },

    UI.LineItem : [
        { Value : adoption_ID, Label : 'Animal', ![@HTML5.CssDefaults] : { width : '8rem' } },
        { Value : inspector_ID, Label : 'Inspector', ![@HTML5.CssDefaults] : { width : '8rem' } },
        { Value : inspectionDate,
            ![@HTML5.CssDefaults] : { width : '8rem' }
        },
        { Value : inspectionType,
            ![@HTML5.CssDefaults] : { width : '8rem' }
        },
        { Value : result,
            ![@HTML5.CssDefaults] : { width : '6rem' }
        }
    ]
);