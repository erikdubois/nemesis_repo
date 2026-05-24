# Ideas — nemesis_repo

Future ideas for this repo. One idea appended per `/end-session` (per global rule).

## Claude's Ideashop

**Idea [arch]: Site↔repo drift guard — fail commit if the site advertises a package or screenshot the repo doesn't ship**
A `pre-commit` hook (or tiny CI step) that parses `README.md` + `index.html` and asserts: every image they reference exists in `assets/`, and every package named in the overview grid actually exists as a `*.pkg.tar.zst` in `x86_64/`. The nemesis site is hand-maintained, so it can silently drift from real repo contents after a package is added/removed or a screenshot renamed. A read-only checker keeps the public page honest with near-zero effort.

