#!/bin/sh

# Decrypt the file
gpg --quiet --batch --yes --decrypt --passphrase="$SECRET_PASSPHRASE" \
--output $HOME/daf_plus_plus/daf_plus_plus/secrets.tar secrets.tar.gpg
tar xvf  $HOME/daf_plus_plus/daf_plus_plus/secrets.tar
ls $HOME/daf_plus_plus/daf_plus_plus/android/app
tar somthing