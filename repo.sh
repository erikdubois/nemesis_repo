#!/bin/bash

cd x86_64
rm nemesis_repo*

echo "#############################################################################################"
echo "Let us sign the packages without a .sig"
echo "#############################################################################################"

count=0
cd x86_64
for name in $(ls *.tar.zst); do
	count=$[count+1]
	if [ ! -f $name.sig ];then	
		tput setaf 6;echo $count " : signing " $name;tput sgr0;
		gpg --detach-sign $name
	fi
done

echo "#############################################################################################"
echo "Signing finished"
echo "#############################################################################################"
sleep 2

echo "repo-add"
repo-add -n -R -v -s nemesis_repo.db.tar.gz *.pkg.tar.zst
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
