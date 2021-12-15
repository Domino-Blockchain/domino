#!/usr/bin/env bash
set -ex

[[ $(uname) = Linux ]] || exit 1
[[ $USER = root ]] || exit 1

if grep -q domino /etc/passwd ; then
  echo "User domino already exists"
else
  adduser domino --gecos "" --disabled-password --quiet
  adduser domino sudo
  adduser domino adm
  echo "domino ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
  id domino

  [[ -r /domino-scratch/id_ecdsa ]] || exit 1
  [[ -r /domino-scratch/id_ecdsa.pub ]] || exit 1

  sudo -u domino bash -c "
    echo 'PATH=\"/home/domino/.cargo/bin:$PATH\"' > /home/domino/.profile
    mkdir -p /home/domino/.ssh/
    cd /home/domino/.ssh/
    cp /domino-scratch/id_ecdsa.pub authorized_keys
    umask 377
    cp /domino-scratch/id_ecdsa id_ecdsa
    echo \"
      Host *
      BatchMode yes
      IdentityFile ~/.ssh/id_ecdsa
      StrictHostKeyChecking no
    \" > config
  "
fi
