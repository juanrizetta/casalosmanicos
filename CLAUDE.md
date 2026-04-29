# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Static website for a rural lodging ("Casa Rural Los Manicos", Moratalla, Murcia), plus shell scripts that provision an Ubuntu VPS (Nginx + Let's Encrypt) to serve it. No build step, no package manager, no test suite — vanilla HTML/CSS/JS served directly.

## Architecture

- [public/index.html](public/index.html) is the single page. It contains all markup **and** a large inline `<script>` (around line 329 onward) that does all rendering: `initApp`, `initCarousels`, `initPricing`, `initCalendar`, `sendEmail`, `moveSlide`/`setSlide`. There is no module bundler — the inline script reads the global `CONFIG` object.
- [public/js/config.js](public/js/config.js) is the **only** content source. Editing copy, prices, images, contact info, Formspree ID, or Google Calendar credentials is done here — `index.html` should not be edited for content changes. The carousels grid (`#carousel-grid`), the pricing tables, hero text, etc. are all injected at runtime from `CONFIG`.
- [public/css/styles.css](public/css/styles.css) — single stylesheet. Cache-busted via `?v=` query param in the `<link>`/`<script>` tags in `index.html`; bump these when shipping CSS/JS changes that need to invalidate browser caches.
- [public/assets/](public/assets/) — image filenames are referenced literally from `config.js` (`assets/interior_1.png`, etc.). Replacing images means either keeping the same filenames or updating `config.js`.
- External runtime deps (loaded from CDN in `index.html`): FullCalendar 6.1.10 + its Google Calendar plugin, Formspree (for the contact form). No npm install, no lockfile.

## Deployment model

The site is deployed by `git pull` on the VPS — there is no CI/CD or build artifact.

- [scripts/setup_vps.sh](scripts/setup_vps.sh) is **idempotent** and does the full bootstrap: creates user `juanri`, installs Nginx/UFW/Certbot, clones the repo to `/home/juanri/appl/casalosmanicos`, symlinks `/var/www/casalosmanicos.es` → `public/`, writes a base Nginx config (skipped if Certbot has already taken over the file), requests/renews the LE cert, and installs a weekly cron for `refresh_cert.sh`.
- The symlink is the deploy mechanism: a `git pull` on the VPS instantly updates the live site. There is no copy step.
- Requires `GITHUB_TOKEN` exported before running (used to clone via HTTPS).
- Domain in script is `casalosmanicos.es` (note: README/meta tags reference `.com` — script is the source of truth for what's actually deployed).

## Common commands

```bash
# Local preview (any static server works, no build):
cd public && python3 -m http.server 8000

# Provision/refresh the VPS (run on the server, not locally):
export GITHUB_TOKEN='...'
bash scripts/setup_vps.sh

# Cache-bust after CSS/JS edits: bump the ?v= in index.html's
#   <link rel="stylesheet" href="css/styles.css?v=1.4">
#   <script src="js/config.js?v=1.2" defer></script>
```

## Editing notes

- Content changes → edit `public/js/config.js` only.
- Layout/behavior changes → the inline `<script>` at the bottom of `index.html` (not a separate file).
- The Google Calendar integration is gated by `CONFIG.calendar.show`; the `apiKey` currently committed in `config.js` is a real key restricted to this domain — be aware before rotating or exposing.
- The contact form uses Formspree; the form ID lives in `CONFIG.contact.formspreeId`. If empty, the JS falls back to a `mailto:` link.
