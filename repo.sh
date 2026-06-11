#!/bin/bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

cd "${SCRIPT_DIR}/x86_64"
rm nemesis_repo*

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
cd ..
echo "####################################"
echo "Repo Updated!!"
echo "####################################"
