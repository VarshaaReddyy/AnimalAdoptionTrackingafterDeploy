const cds = require("@sap/cds");

module.exports = cds.service.impl(async function () {

    // ==========================================================
    // WHO AM I: login id, display name and roles of the caller
    // ==========================================================

    this.on("whoAmI", async (req) => {

        const email =
            (req.user.attr?.email || req.user.id || "").toLowerCase();

        // Display name from the Users table, else from the login token
        const user = await SELECT.one
            .from("db.Users")
            .columns("firstName", "lastName")
            .where({ email });

        const name =
            (user && user.firstName) ||
            req.user.attr?.givenName ||
            req.user.id;

        return {
            id: req.user.id,
            name,
            isAdmin: req.user.is("Admin"),
            isUser: req.user.is("User")
        };
    });
});
