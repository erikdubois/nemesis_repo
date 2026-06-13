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
for pkg in *.pkg.tar.zst; do
    if [[ ! -f "${pkg}.sig" || "${pkg}" -nt "${pkg}.sig" ]]; then
        echo "  signing ${pkg}"
        gpg --detach-sign -u 33B761B0EE5AD4FD --yes "${pkg}" || {
            echo "SIGNING FAILED for ${pkg} — aborting, repo not updated" >&2
            exit 1
        }
    fi
done

echo "repo-add"
# Feed packages in true version order (oldest first) so the newest build of each
# package is processed last and wins in the db; -R then prunes the older files.
# A plain glob sorts lexically (99 sorts after 100), which lets an old build win
# and deletes the newer package file from disk. pacsort sorts by version.
mapfile -t pkgs < <(printf '%s\n' *.pkg.tar.zst | pacsort)
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

cd ..
echo "####################################"
echo "Repo Updated!!"
echo "####################################"
