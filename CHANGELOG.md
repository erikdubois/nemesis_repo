# Changelog

## 2026.05.24

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
