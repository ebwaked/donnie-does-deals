/**
 * Donnie Does Deals — lead endpoint.
 * Bound to the "Donnie Does Deals — Leads" Google Sheet. Each quiz submission:
 *   1. appends a row to the "Leads" tab
 *   2. emails the lead to everyone in RECIPIENTS
 * Deploy: Extensions > Apps Script > paste this > Deploy > New deployment > Web app,
 *         Execute as: Me, Who has access: Anyone. Copy the /exec URL into config.js (leadEndpoint).
 */
var RECIPIENTS = [
  "Donnie@neighborhoodloans.com",
  "pierce.zajac+ddd@gmail.com",
  "eddiewaked+ddd@gmail.com"
];
var SHEET_NAME = "Leads";
var HEADERS = [
  "Received (ET)", "Hot", "Name", "Phone", "Email", "State", "Owned in last 3 yrs", "Timeline",
  "Credit", "Savings", "Best time", "Source", "Creative", "Campaign", "First-touch source",
  "First-touch creative", "Page", "Consent text shown"
];

var LABELS = {
  owned: { no: "No", yes: "Yes" },
  timeline: { "0-3": "Next 3 months", "3-6": "3 to 6 months", "6-12": "6 to 12 months", looking: "Just looking" },
  credit: { "740+": "740+", "680-739": "680 to 739", "620-679": "620 to 679", "<620": "Under 620", unsure: "Not sure" },
  savings: { "0": "Nothing yet", "<5k": "Under $5,000", "5-20k": "$5,000 to $20,000", "20k+": "More than $20,000" },
  besttime: { morning: "Morning", afternoon: "Afternoon", evening: "Evening" }
};
function label(group, v) { return (LABELS[group] && LABELS[group][v]) || v || ""; }

function doGet() {
  return ContentService.createTextOutput("ok");
}

function doPost(e) {
  var lock = LockService.getScriptLock();
  lock.waitLock(10000);
  try {
    var d = JSON.parse((e && e.postData && e.postData.contents) || "{}");
    if (!d.name || !(d.phone || d.email)) return json({ ok: false, error: "missing contact" });

    var last = (d.attribution && d.attribution.last) || {};
    var first = (d.attribution && d.attribution.first) || {};
    var when = Utilities.formatDate(new Date(), "America/New_York", "yyyy-MM-dd HH:mm");
    var row = [
      when, d.hot ? "HOT" : "", d.name, d.phone, d.email, d.state,
      label("owned", d.owned_last_3y), label("timeline", d.timeline), label("credit", d.credit),
      label("savings", d.savings), label("besttime", d.best_time),
      last.utm_source || "direct", last.utm_content || "", last.utm_campaign || "",
      first.utm_source || "", first.utm_content || "", d.page || "", d.consent_text || ""
    ];

    var sheet = getSheet();
    sheet.appendRow(row);

    var subject = (d.hot ? "[HOT] " : "") + "New first-time buyer: " + d.name + (d.state ? " (" + d.state + ")" : "");
    var body = [
      d.hot ? "HOT lead: wants to buy within 6 months, credit 620+. Call today." : "New lead from the first-time buyer check.",
      "",
      "Name: " + d.name,
      "Phone: " + d.phone,
      "Email: " + d.email,
      "Best time to call: " + (label("besttime", d.best_time) || "No preference"),
      "",
      "Buying in: " + (d.state || ""),
      "Owned a home in the last 3 years: " + label("owned", d.owned_last_3y),
      "Timeline: " + label("timeline", d.timeline),
      "Credit: " + label("credit", d.credit),
      "Saved for down payment: " + label("savings", d.savings),
      "",
      "Came from: " + (last.utm_source || "direct") + (last.utm_content ? " / " + last.utm_content : ""),
      "Received: " + when + " ET"
    ].join("\n");

    MailApp.sendEmail({
      to: RECIPIENTS.join(","),
      subject: subject,
      body: body,
      replyTo: d.email || undefined,
      name: "Donnie Does Deals"
    });

    return json({ ok: true });
  } catch (err) {
    return json({ ok: false, error: String(err) });
  } finally {
    lock.releaseLock();
  }
}

function getSheet() {
  var ss = SpreadsheetApp.getActiveSpreadsheet();
  var sheet = ss.getSheetByName(SHEET_NAME);
  if (!sheet) { sheet = ss.getSheets()[0]; sheet.setName(SHEET_NAME); }
  if (sheet.getLastRow() === 0 || sheet.getRange(1, 1).getValue() !== HEADERS[0]) {
    sheet.clear();
    sheet.appendRow(HEADERS);
    sheet.setFrozenRows(1);
  }
  return sheet;
}

function json(obj) {
  return ContentService.createTextOutput(JSON.stringify(obj)).setMimeType(ContentService.MimeType.JSON);
}

/** Run once from the editor to approve permissions and send yourself a test email. */
function testLead() {
  var fake = {
    postData: { contents: JSON.stringify({
      name: "Test Lead", phone: "555-555-0100", email: "eddiewaked+ddd@gmail.com", state: "NJ",
      owned_last_3y: "no", timeline: "0-3", credit: "680-739", savings: "5-20k", best_time: "evening",
      hot: true, page: "test", attribution: { last: { utm_source: "test", utm_content: "setup-check" } }
    }) }
  };
  Logger.log(doPost(fake).getContent());
}
