#!/bin/bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

cd "${SCRIPT_DIR}/x86_64"
rm nemesis_repo*

# Detach-sign every package with the Kiro signing subkey before building the db.
# Packages-only signing (db stays unsigned → SigLevel = Required DatabaseOptional
# on the client), so repo-add runs without -s. Sign only when the .sig is missing
# or older than the package, to avoid re-signing the whole repo on every run.
# Fail loud: a signing error must stop the run, never publish a half-signed repo.
echo "signing packages"
# Sign from a throwaway cwd, and force loopback pinentry. Background: gpg-agent
# launches the configured GUI pinentry (pinentry-qt), whose Qt X11 connection
# drops an xauth_XXXXXX cookie file into the current dir — and the current dir
# here is the tracked x86_64/ tree, so the cookie kept landing in the repo.
# loopback makes gpg prompt on the tty instead of launching any GUI pinentry
# (no X connection, no cookie); the temp cwd is a belt-and-suspenders net so any
# stray temp file can't land in the tree even if loopback is ever removed. Sign
# via an absolute path so the .sig still lands next to the package in x86_64/.
sign_cwd="$(mktemp -d)"
for pkg in *.pkg.tar.zst; do
    if [[ ! -f "${pkg}.sig" || "${pkg}" -nt "${pkg}.sig" ]]; then
        echo "  signing ${pkg}"
        ( cd "${sign_cwd}" && gpg --pinentry-mode loopback --detach-sign \
            -u 33B761B0EE5AD4FD --yes "${SCRIPT_DIR}/x86_64/${pkg}" ) || {
            echo "SIGNING FAILED for ${pkg} — aborting, repo not updated" >&2
            exit 1
        }
    fi
done
rmdir "${sign_cwd}" 2>/dev/null || true

echo "repo-add"
# Feed packages in true version order (oldest first) so the newest build of each
# package is processed last and wins in the db; -R then prunes the older files.
# A plain glob sorts lexically (99 sorts after 100), which lets an old build win
# and deletes the newer package file from disk. pacsort -f parses the package
# FILENAME (name-epoch:ver-rel-arch.pkg.tar.zst) and sorts by version — without
# -f it sorts the raw lines and mis-ranks the epoch form (e.g. 1:26.06-16 lands
# before 26.06-14), which is exactly how an old build can clobber a newer one.
mapfile -t pkgs < <(printf '%s\n' *.pkg.tar.zst | pacsort -f)
repo-add -n -R -v nemesis_repo.db.tar.gz "${pkgs[@]}"
rm -v nemesis_repo.db
rm -v nemesis_repo.files
mv -v nemesis_repo.db.tar.gz nemesis_repo.db
mv -v nemesis_repo.files.tar.gz nemesis_repo.files

# repo-add -R prunes superseded package files; drop any .sig left orphaned so the
# repo never serves a signature whose package is gone.
for sig in *.pkg.tar.zst.sig; do
    [[ -e "${sig}" ]] || continue
    [[ -e "${sig%.sig}" ]] || rm -v "${sig}"
done

# Refresh the package counts on index.html from the freshly-built db so the
# website can never drift from what the repo actually serves. Each db entry is
# one directory ("name-ver/"); arc theme variants are the arcolinux-arc-* set.
# Markers in index.html: <!--PKG-->N<!--/PKG--> and <!--ARC-->N<!--/ARC-->.
pkg_count=$(tar tzf nemesis_repo.db | grep -c '/$' || true)
arc_count=$(tar tzf nemesis_repo.db | grep -c '^arcolinux-arc-.*/$' || true)
echo "updating index.html counts: ${pkg_count} packages, ${arc_count} arc variants"
sed -i -E \
    -e "s|<!--PKG-->[0-9]+<!--/PKG-->|<!--PKG-->${pkg_count}<!--/PKG-->|g" \
    -e "s|<!--ARC-->[0-9]+<!--/ARC-->|<!--ARC-->${arc_count}<!--/ARC-->|g" \
    "${SCRIPT_DIR}/index.html"

cd ..
echo "####################################"
echo "Repo Updated!!"
echo "####################################"
