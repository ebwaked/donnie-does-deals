// Donnie Does Deals — site settings. Edit these, push, and Cloudflare redeploys.
window.DDD_CONFIG = {
  // Google Apps Script web app URL (Deploy > Web app). Empty = quiz runs but leads are not sent.
  leadEndpoint: "https://script.google.com/macros/s/AKfycbwYT6JvJfDj2FrhlO6ulqFf569p-kGU1AtcII2tYA_SqD16-WRXuvF7yDGRQSsG2nFUUQ/exec",

  // Tracking pixels. Leave empty to keep them off.
  metaPixelId: "",
  tiktokPixelId: "",

  // States Donnie can lend in, as two-letter codes (e.g. ["NJ", "NY"]).
  // Empty = accept every state. Leads outside this list are still sent, just never tagged HOT.
  licensedStates: [],

  // Shown on the privacy page and in the footer.
  contactEmail: "Donnie@neighborhoodloans.com",

  // Licensing / NMLS line for the footer. Empty = hidden.
  disclosure: "",

  // Consent text shown above the submit button. Replace with your approved wording.
  consentText:
    "By sending this, you agree that Donnie and his team can call, text or email you about buying a home. Message and data rates may apply. You can opt out any time.",

  // Set to a photo path (e.g. "assets/donnie.jpg") once we have one.
  portrait: "assets/donnie.jpg"
};
