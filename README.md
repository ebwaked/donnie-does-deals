# Donnie Does Deals — site

Live at **https://donniedeals.com** (once Cloudflare is connected). Instagram: @donniedoesdeals.

Static landing page + 60-second first-time buyer check. No build step.

## Files
| Path | What it is |
|---|---|
| `site/` | Everything that's published (Cloudflare serves only this folder) |
| `site/index.html` | Landing page and quiz |
| `site/config.js` | **The only file you normally edit**: lead endpoint, pixel IDs, licensed states, contact email, disclosure line, consent text, portrait |
| `site/assets/site.css`, `site/assets/quiz.js` | Styles and quiz logic |
| `site/ig/ tt/ yt/ fb/` | Short links for bios and captions, e.g. `/tt` or `/fb?c=therapy-20pct` → tags the visit with utm_source/utm_content |
| `site/privacy.html` | Plain-language privacy page (needed for Meta lead ads) |
| `apps-script/Code.gs` | Lead endpoint: logs each lead to the Leads sheet and emails it (not published) |
| `brand/` | Endcard template for videos (not published) |

## Hosting: Cloudflare, no Azure
1. Cloudflare dashboard → Workers & Pages → Create → connect GitHub → pick `ebwaked/donnie-does-deals`.
2. Framework preset: none. Build command: empty. Output directory: `site`.
3. Every push to `main` redeploys.
4. Project → Custom domains → add `donniedeals.com` (and `www.donniedeals.com`). DNS is set automatically because the domain is on Cloudflare.

## Lead capture (one-time, ~5 minutes)
1. Open the Google Sheet **"Donnie Does Deals — Leads"** (Rabbitt Engineering/clients/donnie-does-deals in Drive).
2. Extensions → Apps Script → replace the editor contents with `apps-script/Code.gs` → Save.
3. Pick `testLead` in the function menu → Run → approve the permissions. A test row and a test email should arrive.
4. Deploy → New deployment → type: Web app. Execute as: **Me**. Who has access: **Anyone**. Deploy.
5. Copy the `/exec` URL into `leadEndpoint` in `site/config.js` (or send it to Claude to push).

Changing who gets lead emails: edit `RECIPIENTS` at the top of `Code.gs`, then Deploy → Manage deployments → edit → New version.

## Pixels
Paste the Meta pixel ID and TikTok pixel ID into `config.js`. Page views fire on load; Meta `Lead` / TikTok `SubmitForm` fire on a completed check.
