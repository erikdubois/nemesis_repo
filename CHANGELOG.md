# Changelog

## 2026.06.13

### What Changed
- `repo.sh` now **PGP-signs every package** before building the database — the
  repo-build step of Phase A signing for `nemesis_repo`. Closes the gap where the
  whole fleet pulled binaries from GitHub Pages with no cryptographic proof of who
  built them. SigLevel on the client stays `Never` for now (sigs present but
  ignored → no risk to existing installs); the `Optional → Required` flips come
  once `kiro-keyring` is deployed across the fleet.

### Technical Details
- Detach-sign loop before `repo-add`, scoped to the Kiro signing subkey
  (`gpg --detach-sign -u 33B761B0EE5AD4FD`); signs only when the `.sig` is missing
  or older than the package, so re-runs don't re-sign the whole repo (avoids git
  churn). Fail-loud: a signing error aborts the run rather than publish a
  half-signed repo.
- **Packages-only** signing — `repo-add` stays without `-s` (db unsigned), so the
  client uses `SigLevel = Required DatabaseOptional` later and the
  `.db.tar.gz → .db` rename is untouched.
- Orphan-sig cleanup after `repo-add -R` prunes superseded packages, so no `.sig`
  is served without its package.
- First run: 246/246 packages signed, 0 missing, 0 orphans; db built clean. Key:
  master `149ABD0C3A0563EE [C]` (offline) + signing subkey `33B761B0EE5AD4FD [S]`,
  UID `Kiro Signing Key`. Not pushed from here — Erik's build flow runs `repo.sh`
  + `up.sh` to publish.

### Files Modified
- `repo.sh`

## 2026.06.03

### Rolled back the broken plymouth-theme-kiro-logo package
- Reverted the served `plymouth-theme-kiro-logo` package `26.06-02 → 26.06-01`
  via `git revert` (new revert commit, no force-push). The `-02` build broke the
  boot splash (logo dropped out, prompt fell back to text), so the repo serves
  `-01` again. GitHub Pages confirmed serving `-01`; `-02` returns 404.
- Note: pacman won't auto-downgrade; boxes already on `-02` need
  `pacman -S nemesis_repo/plymouth-theme-kiro-logo` to return to `-01`.
- The reverted theme source and the card/wedge rework live in the separate
  `plymouth-theme-kiro-logo` and `plymouth-theme-kiro-logo-nemesis` repos.

## 2026.05.29

### Adopted the canonical shared web design system
- `css/style.css` is now synced byte-identical from the canonical
  `Kiro-HQ/web-shared/style.css` via the new HQ `propagate-web-shared.sh` — no
  longer hand-edited here (header now points to the canonical source).
- Wrapped the footer in `<!-- KIRO:FOOTER START -->` / `<!-- KIRO:FOOTER END -->`
  markers so the sync script can manage it, and **de-duplicated** it: removed the
  second "Part of the Kiro project" link that pointed to the same
  `https://kiroproject.be` URL as the existing `kiroproject.be` link.
- Files: `index.html`, `css/style.css`.

## 2026.05.24

### Shared-asset propagation + Patreon + wrap fixes (later session)
- Synced the canonical web assets via the new HQ `propagate-assets.sh`: added
  `assets/branding/youtube-banner.png` (the repo already used
  `assets/screenshots/`).
- Added a **Patreon** support pill (https://www.patreon.com/c/kiroproject) with
  coral `.pill-patreon` styling to `index.html`.
- Added `white-space:nowrap` to `.pill` (Ko-fi label) and `.nav a` ("Add the
  repo") so labels and nav items no longer wrap to two lines.
- Left the `Server = https://erikdubois.github.io/$repo/$arch` line untouched —
  it's correct pacman config (the 404 is browser-only on the bare directory).

### What Changed
- Rewrote `README.md` to state the repo's identity: a pacman repo of extras you add **after** a clean install (Spotify and friends), not part of the base system.
- Added a plain-language note distinguishing nemesis_repo from `kiro_repo` (the install-time Calamares repo that disappears after reboot), so the sibling repos no longer read as interchangeable.
- Updated the walkthrough video to https://youtu.be/ocKZIzAb7GQ (was `guHmlOP0MQo`).
- Added a screenshots gallery to the README (six `.webp` desktop/tool shots in a table) and the same gallery to the Pages site (`index.html`) as a new `#gallery` section that the existing nav link already pointed at, with a `.shot-grid` / `.shot` block in `css/style.css` reusing the slate/accent tokens.
- Fixed the footer website link in `index.html` from `erikdubois.be` to `https://kiroproject.be`.

### Technical Details
- Kept all working content (pacman.conf snippet, `bit.ly/nemesis-repo` curl one-liner, websites, social links); grouped the two install methods under a new "Add the repository" heading.
- Deliberately avoided HQ-internal terms and EDU/KIRO tree paths since this is a public-facing README.
- Gallery markup/CSS mirror the kiro_repo site so the two sibling Pages stay consistent.

### Files Modified
- README.md (rewritten + screenshots gallery)
- index.html (gallery section + footer link → kiroproject.be)
- css/style.css (.shot-grid / .shot gallery styles)
- CHANGELOG.md (updated)

## 2026.05.23

### What Changed
- Added a proper GitHub Pages landing page (`index.html`) to replace the default Jekyll-rendered README at https://erikdubois.github.io/nemesis_repo/.
- Page now matches the kiro-website design: dark slate-950 surface, sky accent with the visitor-switchable 5-colour palette, shared Kiro branding/favicons, hero, copy-to-clipboard install steps, a package overview grid, and a YouTube walkthrough embed.

### Technical Details
- Self-contained design (no Tailwind build step) so the CSS can be committed and served straight from the Pages repo. Hand-written `css/style.css` reproduces the kiro design tokens with semantic class names; `dist/` build tooling deliberately avoided to keep a pacman package repo free of Node tooling.
- Accent switcher and copy-button JS mirror kiro-website (localStorage key `nemesis-accent`); palette tokens are CSS variables `--accent-200..500`.
- Added `.nojekyll` so `assets/` and the `x86_64/` package files are served verbatim. "Browse packages" links point at the GitHub file tree because Pages does not generate directory listings.
- Copied shared branding (`logo.png` + favicons) from kiro-website into `assets/branding/`.

### Files Modified
- index.html (created)
- css/style.css (created)
- .nojekyll (created)
- assets/branding/* (logo + favicons, copied from kiro-website)
- CHANGELOG.md (updated)

## 2026.05.21

### What Changed
- Initial markdown scaffold added per the ecosystem MD-scaffold rule ([HQ/CLAUDE.md](/home/erik/Insync/Kiro/Kiro-HQ/CLAUDE.md#required-markdown-scaffold-every-repo)).
- Stubs created for `CHANGELOG.md`, `CLAUDE.md`, `IDEAS.md`, `TODO.md` (whichever were missing).
- README rewritten with real install/usage content (replaced earlier one-line stub) where applicable.

### Files Modified
- CHANGELOG.md (created)
- CLAUDE.md (created where missing)
- IDEAS.md (created where missing)
- TODO.md (created where missing)
- README.md (rewritten where it was a stub)
