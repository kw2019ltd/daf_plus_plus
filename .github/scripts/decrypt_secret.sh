#!/bin/sh

# Decrypt the file
mkdir $HOME/secrets
gpg --quiet --batch --yes --decrypt --passphrase="$SECRET_PASSPHRASE" \
--output $HOME/secrets/secrets.tar secrets.tar.gpg