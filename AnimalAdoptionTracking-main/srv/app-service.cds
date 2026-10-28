

@requires: 'authenticated-user'
@path: '/odata/v4/app'
service AppService {

    type CurrentUser {
        id      : String;
        name    : String;
        isAdmin : Boolean;
        isUser  : Boolean;
    }

    function whoAmI() returns CurrentUser;
}
