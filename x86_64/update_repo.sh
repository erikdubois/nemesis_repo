#!/bin/bash

rm nemesis_repo*

echo "repo-add"
repo-add -n -R nemesis_repo.db.tar.gz *.pkg.tar.zst
sleep 5

rm nemesis_repo.db


rm nemesis_repo.files


mv nemesis_repo.db.tar.gz nemesis_repo.db


mv nemesis_repo.files.tar.gz nemesis_repo.files


echo "####################################"
echo "Repo Updated!!"
echo "####################################"
