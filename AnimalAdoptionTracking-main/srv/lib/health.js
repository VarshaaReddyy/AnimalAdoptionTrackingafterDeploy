const cds = require("@sap/cds");


const DUE_SOON_DAYS = 7;

const asArray = (results) =>
    Array.isArray(results) ? results : (results ? [results] : []);

const today = () => new Date().toISOString().slice(0, 10);

async function latestHealthByAnimal(animalIDs) {

    const { HealthRecords } = cds.entities("db");

    if (!animalIDs.length) {
        return {};
    }

    const records = await SELECT.from(HealthRecords)
        .columns("ID", "animal_ID", "checkupDate", "healthStatus", "nextCheckupDate")
        .where({ animal_ID: { in: animalIDs } })
        .orderBy("checkupDate desc");

    const latest = {};
    for (const record of records) {
        if (!latest[record.animal_ID]) {
            latest[record.animal_ID] = record;
        }
    }
    return latest;
}



async function addAdoptionEligibility(results) {

    const rows = asArray(results).filter(row => row && row.ID);
    if (!rows.length) {
        return;
    }

    const { Animals } = cds.entities("db");
    const ids = [...new Set(rows.map(row => row.ID))];

    const animals = await SELECT.from(Animals)
        .columns("ID", "animalStatus", "vaccinationStatus")
        .where({ ID: { in: ids } });

    const byID = Object.fromEntries(animals.map(a => [a.ID, a]));
    const latest = await latestHealthByAnimal(ids);

    for (const row of rows) {

        const animal = { ...byID[row.ID], ...row };
        const health = latest[row.ID];

        let text = "Eligible for adoption";
        let criticality = 3;

        if (animal.animalStatus === "ADOPTED") {
            text = "Already adopted";
            criticality = 0;
        } else if (animal.animalStatus === "RESERVED") {
            text = "Reserved for an applicant";
            criticality = 2;
        } else if (["MEDICAL_HOLD", "QUARANTINE"].includes(animal.animalStatus)) {
            text = "Not eligible: medical hold / quarantine";
            criticality = 1;
        } else if (health && ["UNDER_TREATMENT", "CRITICAL"].includes(health.healthStatus)) {
            text = "Not eligible: under treatment";
            criticality = 1;
        } else if (animal.vaccinationStatus !== "COMPLETED") {
            text = "Not eligible: vaccination incomplete";
            criticality = 2;
        }

        row.adoptionEligibility = text;
        row.eligibilityCriticality = criticality;
    }
}



async function addCheckupStatus(results) {

    const rows = asArray(results).filter(row => row && row.ID);
    if (!rows.length) {
        return;
    }

    const { HealthRecords } = cds.entities("db");
    const ids = [...new Set(rows.map(row => row.ID))];

    const records = await SELECT.from(HealthRecords)
        .columns("ID", "animal_ID", "nextCheckupDate")
        .where({ ID: { in: ids } });

    const byID = Object.fromEntries(records.map(r => [r.ID, r]));
    const animalIDs = [...new Set(records.map(r => r.animal_ID).filter(Boolean))];
    const latest = await latestHealthByAnimal(animalIDs);

    const now = today();
    const soon = new Date(Date.now() + DUE_SOON_DAYS * 86400000).toISOString().slice(0, 10);

    for (const row of rows) {

        // Drafts that are not saved yet have no stored record
        const record = { ...byID[row.ID], ...row };
        const isLatest = latest[record.animal_ID] && latest[record.animal_ID].ID === row.ID;

        let text, criticality;

        if (!byID[row.ID] || !isLatest) {
            text = byID[row.ID] ? "Completed" : "";
            criticality = 0;
        } else if (!record.nextCheckupDate) {
            text = "Not scheduled";
            criticality = 2;
        } else if (record.nextCheckupDate < now) {
            text = "Overdue";
            criticality = 1;
        } else if (record.nextCheckupDate <= soon) {
            text = "Due soon";
            criticality = 2;
        } else {
            text = "Scheduled";
            criticality = 3;
        }

        row.checkupStatus = text;
        row.checkupCriticality = criticality;
    }
}


const TRACKED_FIELDS = [
    "animal_ID", "checkupDate", "healthStatus", "diagnosis", "treatment",
    "medication", "veterinarianName", "weight", "nextCheckupDate",
    "remarks", "medicalDocument"
];

async function logHealthRecordChanges(req, before, after) {

    const { HealthRecordChanges } = cds.entities("db");
    const rows = [];

    for (const field of TRACKED_FIELDS) {

        const oldValue = before ? before[field] : null;
        const newValue = after[field];

        if (newValue === undefined) {
            continue;   // field not part of this save
        }
        if (String(oldValue ?? "") === String(newValue ?? "")) {
            continue;   // unchanged
        }

        rows.push({
            ID: cds.utils.uuid(),
            healthRecord_ID: after.ID,
            field,
            oldValue: oldValue == null ? null : String(oldValue),
            newValue: newValue == null ? null : String(newValue),
            changedBy: req.user.id,
            changedAt: new Date()
        });
    }

    if (rows.length) {
        await INSERT.into(HealthRecordChanges).entries(rows);
    }
}


module.exports = {
    addAdoptionEligibility,
    addCheckupStatus,
    logHealthRecordChanges
};
