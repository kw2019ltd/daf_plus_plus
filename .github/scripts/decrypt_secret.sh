#!/bin/sh

# Decrypt the file
gpg --quiet --batch --yes --decrypt --passphrase="$SECRET_PASSPHRASE" \
--output $HOME/secrets.tar secrets.tar.gpg
tar xvf  $HOME/secrets.tar
ls $HOME/android/app
tar somthing