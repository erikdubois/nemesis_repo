#!/bin/bash

cd x86_64
rm nemesis_repo*

echo "repo-add"
repo-add -n -R -v nemesis_repo.db.tar.gz *.pkg.tar.zst
rm -v nemesis_repo.db
rm -v nemesis_repo.db.sig
rm -v nemesis_repo.files
rm -v nemesis_repo.files.sig
mv -v nemesis_repo.db.tar.gz nemesis_repo.db
mv -v nemesis_repo.db.tar.gz.sig nemesis_repo.db.sig
mv -v nemesis_repo.files.tar.gz nemesis_repo.files
mv -v nemesis_repo.files.tar.gz.sig nemesis_repo.files.sig
cd ..
echo "####################################"
echo "Repo Updated!!"
echo "####################################"
