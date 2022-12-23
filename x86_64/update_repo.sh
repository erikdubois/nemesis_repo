#!/bin/bash

rm nemesis_repo*

echo "repo-add"
repo-add -n -R nemesis_repo.db.tar.gz *.pkg.tar.zst
sleep 5

echo "####################################"
echo "Repo Updated!!"
echo "####################################"
