sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/model/json/JSONModel",
    "sap/m/MessageToast"
], function (Controller, JSONModel, MessageToast) {

    "use strict";

    // Readable text + colour for each status value
    var STATUS_TEXT = {
        SUBMITTED: "Submitted",
        UNDER_REVIEW: "Under Review",
        APPROVED: "Approved",
        REJECTED: "Rejected",
        WITHDRAWN: "Withdrawn",
        AVAILABLE: "Available",
        RESERVED: "Reserved",
        ADOPTED: "Adopted",
        MEDICAL_HOLD: "Under Treatment",
        QUARANTINE: "Under Treatment",
        PENDING: "Pending",
        COMPLETED: "Completed",
        CANCELLED: "Cancelled"
    };

    var STATUS_STATE = {
        SUBMITTED: "Information",
        UNDER_REVIEW: "Warning",
        APPROVED: "Success",
        REJECTED: "Error",
        WITHDRAWN: "None",
        AVAILABLE: "Success",
        RESERVED: "Warning",
        ADOPTED: "Information",
        MEDICAL_HOLD: "Error",
        QUARANTINE: "Error",
        PENDING: "Warning",
        COMPLETED: "Success",
        CANCELLED: "None"
    };

    return Controller.extend(
        "animal.adoption.animaladoption.controller.Dashboard",
        {

            // =====================================================
            // FORMATTERS (used in the view)
            // =====================================================

            formatStatusText: function (sStatus) {
                return STATUS_TEXT[sStatus] || sStatus || "";
            },

            formatStatusState: function (sStatus) {
                return STATUS_STATE[sStatus] || "None";
            },

            formatOccupancyState: function (fPercent) {
                if (fPercent >= 90) { return "Error"; }
                if (fPercent >= 75) { return "Warning"; }
                return "Success";
            },

            formatPercent: function (fPercent) {
                return Math.round(Number(fPercent) || 0) + "%";
            },

            formatDate: function (sDate) {
                if (!sDate) { return ""; }
                return new Date(sDate).toLocaleDateString("en-US", {
                    month: "short", day: "numeric", year: "numeric"
                });
            },

            // Same colours as the donut's colorPalette, in the same order
            formatLegendColor: function (sStatus) {
                return {
                    "Submitted": "#5B8DEF",
                    "Under Review": "#F0A32F",
                    "Approved": "#3AA757",
                    "Rejected": "#E5484D",
                    "Withdrawn": "#9AA4B2"
                }[sStatus] || "#9AA4B2";
            },

            formatShortId: function (sId) {
                return sId ? sId.substring(0, 8).toUpperCase() : "";
            },


            // =====================================================
            // INIT
            // =====================================================

            onInit: function () {

                var oView = this.getView();

                oView.setModel(new JSONModel({
                    greeting: this._getGreeting(),
                    name: "",
                    lastUpdated: new Date().toLocaleString("en-US", {
                        month: "short", day: "numeric", year: "numeric",
                        hour: "numeric", minute: "2-digit"
                    }),
                    errorText: "",
                    statusTotal: 0
                }), "view");

                oView.setModel(new JSONModel({}), "dashboard");
                oView.setModel(new JSONModel([]), "chart");
                oView.setModel(new JSONModel([]), "category");
                oView.setModel(new JSONModel([]), "trend");
                oView.setModel(new JSONModel([]), "shelter");
                oView.setModel(new JSONModel([]), "recentApplications");
                oView.setModel(new JSONModel([]), "recentAnimals");
                oView.setModel(new JSONModel([]), "recentAdoptions");

                this._start();
            },


            _getGreeting: function () {
                var iHour = new Date().getHours();
                if (iHour < 12) { return "Good morning"; }
                if (iHour < 17) { return "Good afternoon"; }
                return "Good evening";
            },


            // Adopters (User role only) are sent to their own dashboard
            _start: async function () {

                try {
                    var oResponse = await fetch("/odata/v4/app/whoAmI()");

                    if (oResponse.ok) {
                        var oMe = await oResponse.json();

                        if (!oMe.isAdmin && oMe.isUser) {
                            window.location.replace("/userdashboard/index.html");
                            return;
                        }

                        this.getView().getModel("view")
                            .setProperty("/name", oMe.name || "");
                    }
                } catch (oError) {
                    // whoAmI is optional; the dashboard still loads
                    console.error("whoAmI error:", oError);
                }

                this._loadAll();
            },


            // =====================================================
            // DATA LOADING
            // =====================================================

            _loadAll: function () {

                var that = this;

                Promise.allSettled([
                    this._loadList("/DashboardStats", 1, "dashboard", true),
                    this._loadList("/ApplicationStatusSummary", 50, "chart"),
                    this._loadList("/AnimalCategorySummary", 50, "category"),
                    this._loadList("/AdoptionTrend", 50, "trend"),
                    this._loadList("/ShelterOccupancy", 50, "shelter"),
                    this._loadList("/AdoptionApplicationsSrv", 4, "recentApplications", false, {
                        $expand: "applicant($select=firstName,lastName),animal($select=name)",
                        $orderby: "applicationDate desc"
                    }),
                    this._loadList("/AnimalsSrv", 4, "recentAnimals", false, {
                        $expand: "shelter($select=shelterName)",
                        $orderby: "arrivalDate desc"
                    }),
                    this._loadList("/AdoptionsSrv", 4, "recentAdoptions", false, {
                        $expand: "animal($select=name;$expand=shelter($select=shelterName))," +
                                 "application($select=ID;$expand=applicant($select=firstName,lastName))",
                        $orderby: "adoptionDate desc"
                    })
                ]).then(function (aResults) {

                    var aFailed = aResults.filter(function (oResult) {
                        return oResult.status === "rejected";
                    });

                    // Total for the centre of the donut
                    var iTotal = (that.getView().getModel("chart").getData() || [])
                        .reduce(function (iSum, oItem) {
                            return iSum + (Number(oItem.count) || 0);
                        }, 0);

                    that.getView().getModel("view").setProperty("/statusTotal", iTotal);

                    // Show a clear message instead of silent zeros
                    if (aFailed.length) {
                        var sReason = String(aFailed[0].reason && aFailed[0].reason.message || "");
                        that.getView().getModel("view").setProperty("/errorText",
                            /403|Forbidden|lacking required roles/i.test(sReason)
                                ? "You do not have the Admin role, so dashboard data cannot be loaded. Ask an administrator to assign the AnimalAdoption_Admin role collection, then log in again."
                                : "Some dashboard data could not be loaded: " + sReason
                        );
                    }
                });
            },


            // Reads an entity set into a JSON model.
            // bSingle = put the first row (not the array) into the model.
            _loadList: async function (sPath, iTop, sModelName, bSingle, mParameters) {

                var oModel = this.getOwnerComponent().getModel();

                var oBinding = oModel.bindList(sPath, null, null, null, mParameters);

                var aContexts = await oBinding.requestContexts(0, iTop);

                var aData = aContexts.map(function (oContext) {
                    return oContext.getObject();
                });

                this.getView().getModel(sModelName)
                    .setData(bSingle ? (aData[0] || {}) : aData);

                return aData;
            },


            onRefresh: function () {
                this.getView().getModel("view").setProperty("/errorText", "");
                this._loadAll();
                MessageToast.show("Dashboard refreshed");
            },


            // =====================================================
            // NAVIGATION
            // =====================================================

            onUsersPress: function () {
                window.location.href = "/animalusers/index.html";
            },

            onSheltersPress: function () {
                window.location.href = "/animalshelters/index.html";
            },

            onAnimalsPress: function () {
                window.location.href = "/animalanimals/index.html";
            },

            onApplicationsPress: function () {
                window.location.href = "/animalapplications/index.html";
            },

            onAdoptionsPress: function () {
                window.location.href = "/animaladoptions/index.html";
            },

            onHealthRecordsPress: function () {
                window.location.href = "/animalhealth/index.html";
            },

            onInspectionsPress: function () {
                window.location.href = "/animalinspections/index.html";
            }
        }
    );
});
