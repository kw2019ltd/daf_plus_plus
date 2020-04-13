#!/bin/sh

# Decrypt the file
mkdir $HOME/secrets
gpg --quiet --batch --yes --decrypt --passphrase="$SECRET_PASSPHRASE" \
--output $HOME/secrets/secrets.tar secrets.tar.gpg
tar xvf $HOME/secrets/secrets.tar
# ls $HOME/secrets
ls ./android/app
# tar somthing