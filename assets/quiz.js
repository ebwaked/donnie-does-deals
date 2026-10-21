(function () {
  "use strict";
  var cfg = window.DDD_CONFIG || {};

  // ---------- storage that never throws ----------
  function store(kind) {
    try { var s = window[kind]; s.setItem("__t", "1"); s.removeItem("__t"); return s; } catch (e) { return null; }
  }
  var local = store("localStorage"), session = store("sessionStorage");
  function getJSON(s, k) { try { return s ? JSON.parse(s.getItem(k) || "null") : null; } catch (e) { return null; } }
  function setJSON(s, k, v) { try { if (s) s.setItem(k, JSON.stringify(v)); } catch (e) {} }

  // ---------- attribution ----------
  var params = new URLSearchParams(location.search);
  var touch = {
    utm_source: params.get("utm_source") || "",
    utm_medium: params.get("utm_medium") || "",
    utm_campaign: params.get("utm_campaign") || "",
    utm_content: params.get("utm_content") || params.get("c") || "",
    fbclid: params.get("fbclid") || "",
    ttclid: params.get("ttclid") || "",
    referrer: document.referrer || "",
    landed_at: new Date().toISOString()
  };
  var hasTouch = touch.utm_source || touch.fbclid || touch.ttclid;
  if (hasTouch) setJSON(session, "ddd_last", touch);
  if (hasTouch && !getJSON(local, "ddd_first")) setJSON(local, "ddd_first", touch);
  function attribution() {
    return { first: getJSON(local, "ddd_first") || {}, last: getJSON(session, "ddd_last") || touch };
  }

  // ---------- pixels (off unless IDs are set) ----------
  if (cfg.metaPixelId) {
    !function (f, b, e, v, n, t, s) { if (f.fbq) return; n = f.fbq = function () { n.callMethod ? n.callMethod.apply(n, arguments) : n.queue.push(arguments); }; if (!f._fbq) f._fbq = n; n.push = n; n.loaded = !0; n.version = "2.0"; n.queue = []; t = b.createElement(e); t.async = !0; t.src = v; s = b.getElementsByTagName(e)[0]; s.parentNode.insertBefore(t, s); }(window, document, "script", "https://connect.facebook.net/en_US/fbevents.js");
    window.fbq("init", cfg.metaPixelId);
    window.fbq("track", "PageView");
  }
  if (cfg.tiktokPixelId) {
    !function (w, d, t) { w.TiktokAnalyticsObject = t; var ttq = w[t] = w[t] || []; ttq.methods = ["page", "track", "identify", "instances", "debug", "on", "off", "once", "ready", "alias", "group", "enableCookie", "disableCookie"]; ttq.setAndDefer = function (t, e) { t[e] = function () { t.push([e].concat(Array.prototype.slice.call(arguments, 0))); }; }; for (var i = 0; i < ttq.methods.length; i++) ttq.setAndDefer(ttq, ttq.methods[i]); ttq.load = function (e) { var i = "https://analytics.tiktok.com/i18n/pixel/events.js"; ttq._i = ttq._i || {}; ttq._i[e] = []; ttq._i[e]._u = i; var o = d.createElement("script"); o.type = "text/javascript"; o.async = !0; o.src = i + "?sdkid=" + e + "&lib=" + t; var a = d.getElementsByTagName("script")[0]; a.parentNode.insertBefore(o, a); }; ttq.load(cfg.tiktokPixelId); ttq.page(); }(window, document, "ttq");
  }
  function trackLead(hot) {
    try { if (window.fbq) window.fbq("track", "Lead", { content_category: hot ? "hot" : "standard" }); } catch (e) {}
    try { if (window.ttq) window.ttq.track("SubmitForm"); } catch (e) {}
  }

  // ---------- page bits from config ----------
  document.querySelectorAll("[data-contact]").forEach(function (a) {
    if (cfg.contactEmail) a.href = "mailto:" + cfg.contactEmail; else a.hidden = true;
  });
  var disc = document.querySelector("[data-disclosure]");
  if (disc && cfg.disclosure) { disc.textContent = cfg.disclosure; disc.hidden = false; }
  var consent = document.querySelector("[data-consent]");
  if (consent) consent.textContent = cfg.consentText || "";
  var fig = document.querySelector(".portrait");
  if (fig && cfg.portrait) { fig.querySelector("img").src = cfg.portrait; fig.hidden = false; }

  // ---------- quiz ----------
  var STATES = "AL Alabama|AK Alaska|AZ Arizona|AR Arkansas|CA California|CO Colorado|CT Connecticut|DE Delaware|DC District of Columbia|FL Florida|GA Georgia|HI Hawaii|ID Idaho|IL Illinois|IN Indiana|IA Iowa|KS Kansas|KY Kentucky|LA Louisiana|ME Maine|MD Maryland|MA Massachusetts|MI Michigan|MN Minnesota|MS Mississippi|MO Missouri|MT Montana|NE Nebraska|NV Nevada|NH New Hampshire|NJ New Jersey|NM New Mexico|NY New York|NC North Carolina|ND North Dakota|OH Ohio|OK Oklahoma|OR Oregon|PA Pennsylvania|RI Rhode Island|SC South Carolina|SD South Dakota|TN Tennessee|TX Texas|UT Utah|VT Vermont|VA Virginia|WA Washington|WV West Virginia|WI Wisconsin|WY Wyoming".split("|");

  var dialog = document.querySelector(".quiz");
  var form = dialog.querySelector("form");
  var select = form.querySelector("select[name=state]");
  STATES.forEach(function (s) {
    var o = document.createElement("option");
    o.value = s.slice(0, 2); o.textContent = s.slice(3); select.appendChild(o);
  });

  var steps = Array.prototype.slice.call(form.querySelectorAll(".q"));
  var QUESTIONS = steps.length - 1; // the last step is the thank-you
  var answers = {};
  var current = 0;
  var backBtn = form.querySelector("[data-back]");
  var count = form.querySelector(".quiz-count");
  var bar = form.querySelector(".progress span");
  var errorEl = form.querySelector(".error");

  function show(i) {
    current = i;
    steps.forEach(function (s, n) { s.classList.toggle("is-active", n === i); });
    var isDone = i === QUESTIONS;
    backBtn.hidden = i === 0 || isDone;
    count.textContent = isDone ? "" : "Question " + (i + 1) + " of " + QUESTIONS;
    bar.style.width = (isDone ? 100 : (i / QUESTIONS) * 100) + "%";
    var focusTarget = steps[i].querySelector("select, .choices button, input") || steps[i];
    setTimeout(function () { focusTarget.focus({ preventScroll: true }); }, 30);
  }

  function open() {
    if (typeof dialog.showModal === "function") dialog.showModal(); else dialog.setAttribute("open", "");
    show(current === QUESTIONS ? QUESTIONS : current);
  }
  function close() { if (dialog.open) dialog.close(); }

  document.querySelectorAll("[data-open-quiz]").forEach(function (b) { b.addEventListener("click", open); });
  form.querySelectorAll("[data-close]").forEach(function (b) { b.addEventListener("click", close); });
  backBtn.addEventListener("click", function () { if (current > 0) show(current - 1); });

  form.querySelector("[data-next]").addEventListener("click", function () {
    if (!select.value) { select.focus(); return; }
    answers.state = select.value;
    show(current + 1);
  });

  form.querySelectorAll(".choices").forEach(function (group) {
    var key = group.getAttribute("data-key") || group.closest(".q").getAttribute("data-key");
    var advance = !group.hasAttribute("data-key"); // the best-time row doesn't auto-advance
    group.querySelectorAll("button").forEach(function (b) {
      b.setAttribute("aria-pressed", "false");
      b.addEventListener("click", function () {
        group.querySelectorAll("button").forEach(function (x) { x.setAttribute("aria-pressed", "false"); });
        b.setAttribute("aria-pressed", "true");
        answers[key] = b.value;
        if (advance) setTimeout(function () { show(current + 1); }, 140);
      });
    });
  });

  function isHot(a) {
    var soon = a.timeline === "0-3" || a.timeline === "3-6";
    var credit = a.credit === "740+" || a.credit === "680-739" || a.credit === "620-679";
    var licensed = !cfg.licensedStates || !cfg.licensedStates.length || cfg.licensedStates.indexOf(a.state) !== -1;
    return soon && credit && licensed;
  }

  form.addEventListener("submit", function (e) {
    e.preventDefault();
    var el = function (n) { return form.elements.namedItem(n); };
    var name = el("name").value.trim();
    var phone = el("phone").value.trim();
    var email = el("email").value.trim();
    var problems = [];
    if (!name) problems.push("your name");
    if (phone.replace(/\D/g, "").length < 10) problems.push("a phone number with area code");
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) problems.push("an email address");
    if (problems.length) {
      errorEl.textContent = "Add " + problems.join(", ") + " so Donnie can reach you.";
      errorEl.hidden = false;
      return;
    }
    errorEl.hidden = true;
    if (el("company").value) { show(QUESTIONS); return; } // bot

    var hot = isHot(answers);
    var payload = {
      name: name, phone: phone, email: email,
      state: answers.state || "", owned_last_3y: answers.owned || "", timeline: answers.timeline || "",
      credit: answers.credit || "", savings: answers.savings || "", best_time: answers.besttime || "",
      hot: hot, consent_text: cfg.consentText || "", page: location.href,
      attribution: attribution(), submitted_at: new Date().toISOString()
    };

    var btn = form.querySelector("button[type=submit]");
    btn.disabled = true; btn.textContent = "Sending";

    function finish() {
      trackLead(hot);
      var first = name.split(/\s+/)[0];
      form.querySelector("[data-firstname]").textContent = first ? ", " + first : "";
      show(QUESTIONS);
    }

    if (!cfg.leadEndpoint) { console.warn("DDD: leadEndpoint is not set; lead not sent", payload); finish(); return; }

    // text/plain keeps this a simple request (no CORS preflight), which Apps Script needs.
    fetch(cfg.leadEndpoint, { method: "POST", body: JSON.stringify(payload) })
      .then(function (r) { if (!r.ok) throw new Error("HTTP " + r.status); finish(); })
      .catch(function () {
        btn.disabled = false; btn.textContent = "Send to Donnie";
        errorEl.textContent = "That didn't go through. Check your connection and tap Send again.";
        errorEl.hidden = false;
      });
  });
})();
