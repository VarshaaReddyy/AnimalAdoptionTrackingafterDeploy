sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/model/json/JSONModel",
    "sap/m/MessageToast"
], function (
    Controller,
    JSONModel,
    MessageToast
) {
    "use strict";

    var SERVICE = "/odata/v4/user-catalog/";

    var STATUS_TEXT = {
        SUBMITTED: "Submitted",
        UNDER_REVIEW: "Under Review",
        APPROVED: "Approved",
        REJECTED: "Rejected",
        WITHDRAWN: "Withdrawn",
        AVAILABLE: "Available",
        RESERVED: "Reserved",
        ADOPTED: "Adopted"
    };

    var STATUS_STATE = {
        SUBMITTED: "Information",
        UNDER_REVIEW: "Warning",
        APPROVED: "Success",
        REJECTED: "Error",
        WITHDRAWN: "None",
        AVAILABLE: "Success",
        RESERVED: "Warning",
        ADOPTED: "Information"
    };

    var STATUS_ICON = {
        SUBMITTED: "sap-icon://paper-plane",
        UNDER_REVIEW: "sap-icon://search",
        APPROVED: "sap-icon://accept",
        REJECTED: "sap-icon://decline",
        WITHDRAWN: "sap-icon://undo"
    };

    return Controller.extend(
        "animal.adoption.userdashboard.controller.Dashboard",
        {

            // =====================================================
            // FORMATTERS
            // =====================================================

            formatStatusText: function (sStatus) {
                return STATUS_TEXT[sStatus] || sStatus || "";
            },

            formatStatusState: function (sStatus) {
                return STATUS_STATE[sStatus] || "None";
            },

            formatStatusIcon: function (sStatus) {
                return STATUS_ICON[sStatus] || "sap-icon://history";
            },

            formatDate: function (sDate) {
                if (!sDate) { return ""; }
                return new Date(sDate).toLocaleDateString("en-US", {
                    month: "short", day: "numeric", year: "numeric"
                });
            },

            formatDateTime: function (sDate) {
                if (!sDate) { return ""; }
                return new Date(sDate).toLocaleString("en-US", {
                    month: "short", day: "numeric", hour: "numeric", minute: "2-digit"
                });
            },

            formatAnimalImage: function (sSpecies) {
                return (sSpecies === "Cat") ? "images/cat.jpg"
                    : (sSpecies === "Dog") ? "images/dog.jpg"
                    : "images/pets.jpg";
            },


            // =====================================================
            // INIT
            // =====================================================

            onInit: function () {

                var oView = this.getView();

                oView.setModel(new JSONModel({
                    name: "",
                    availableCount: 0,
                    errorText: ""
                }), "view");

                oView.setModel(new JSONModel({
                    myApplications: 0,
                    pendingApplications: 0,
                    approvedApplications: 0,
                    myAdoptions: 0
                }), "dashboard");

                oView.setModel(new JSONModel([]), "applications");
                oView.setModel(new JSONModel([]), "animals");
                oView.setModel(new JSONModel([]), "updates");

                this._loadAll();
            },


            // =====================================================
            // DATA LOADING (backend filters everything by the
            // logged-in user)
            // =====================================================

            _get: function (sUrl) {
                return fetch(sUrl).then(function (oResponse) {
                    if (!oResponse.ok) {
                        throw new Error("HTTP " + oResponse.status);
                    }
                    return oResponse.json();
                });
            },

            _loadAll: function () {

                var that = this;
                var oView = this.getView();

                // Display name for the welcome banner
                this._get("/odata/v4/app/whoAmI()").then(function (oMe) {
                    oView.getModel("view").setProperty("/name", oMe.name || "");
                }).catch(function () { /* optional */ });

                Promise.allSettled([

                    this._get(SERVICE + "UserDashboardStats").then(function (oResult) {
                        oView.getModel("dashboard").setData((oResult.value || [])[0] || {});
                    }),

                    this._get(SERVICE + "AdoptionApplicationsSrv" +
                        "?$expand=animal($select=name,breed,species)" +
                        "&$orderby=applicationDate desc").then(function (oResult) {
                        oView.getModel("applications").setData(oResult.value || []);
                    }),

                    this._get(SERVICE + "AnimalsSrv" +
                        "?$filter=animalStatus eq 'AVAILABLE'" +
                        "&$orderby=arrivalDate desc&$top=3&$count=true" +
                        "&$expand=shelter($select=shelterName)").then(function (oResult) {
                        oView.getModel("animals").setData(oResult.value || []);
                        oView.getModel("view").setProperty("/availableCount", oResult["@odata.count"] || 0);
                    }),

                    this._get(SERVICE + "ApplicationStatusHistorySrv" +
                        "?$orderby=changedAt desc&$top=4" +
                        "&$expand=application($select=ID;$expand=animal($select=name))").then(function (oResult) {
                        oView.getModel("updates").setData(oResult.value || []);
                    })

                ]).then(function (aResults) {

                    var oFailed = aResults.find(function (oResult) {
                        return oResult.status === "rejected";
                    });

                    if (oFailed) {
                        var sReason = String(oFailed.reason && oFailed.reason.message || "");
                        oView.getModel("view").setProperty("/errorText",
                            /403/.test(sReason)
                                ? "Your login does not have the User role, so your data cannot be loaded. Ask an administrator to assign the AnimalAdoption_User role collection, then log in again."
                                : "Unable to load dashboard data (" + sReason + ")."
                        );
                    }

                    that._loaded = true;
                });
            },


            // =====================================================
            // REFRESH
            // =====================================================

            onRefresh: function () {

                this.getView().getModel("view").setProperty("/errorText", "");
                this._loadAll();

                MessageToast.show("Dashboard refreshed");
            },


            // =====================================================
            // BACK
            // =====================================================

            onNavBack: function () {

                window.history.back();
            },


            // =====================================================
            // NAVIGATION
            // =====================================================

            onBrowseAnimalsPress: function () {

                window.location.href =
                    "/useranimals/index.html";
            },

            onMyApplicationsPress: function () {

                window.location.href =
                    "/userapplications/index.html";
            },

            onMyAdoptionsPress: function () {

                window.location.href =
                    "/useradoptions/index.html";
            },

            onProfilePress: function () {

                window.location.href =
                    "/userprofile/index.html";
            }

        }
    );
});
