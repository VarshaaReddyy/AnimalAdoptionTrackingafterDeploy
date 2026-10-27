// ==========================================================
// APP SERVICE
// Small service open to every logged-in user (Admin or User).
// The start page calls whoAmI() to send each role to its own
// dashboard.
// ==========================================================

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
