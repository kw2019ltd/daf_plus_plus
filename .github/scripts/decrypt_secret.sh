#!/bin/sh

# Decrypt the file
mkdir $HOME/secrets
gpg --quiet --batch --yes --decrypt --passphrase="$SECRET_PASSPHRASE" \
--output $HOME/secrets/secrets.tar secrets.tar.gpg
tar xvf $HOME/secrets/secrets.tar $HOME/work/daf_plus_plus/daf_plus_plus
# ls $HOME/secrets
ls ./android/app
ls $HOME/work/daf_plus_plus
ls $HOME/work/daf_plus_plus/daf_plus_plus
ls $HOME/secrets
tar somthing