#!/usr/bin/env bash
set -ex

[[ $(uname) = Linux ]] || exit 1
[[ $USER = root ]] || exit 1

[[ -d /home/domino/.ssh ]] || exit 1

if [[ ${#DOMINO_PUBKEYS[@]} -eq 0 ]]; then
  echo "Warning: source domino-user-authorized_keys.sh first"
fi

# domino-user-authorized_keys.sh defines the public keys for users that should
# automatically be granted access to ALL testnets
for key in "${DOMINO_PUBKEYS[@]}"; do
  echo "$key" >> /domino-scratch/authorized_keys
done

sudo -u domino bash -c "
  cat /domino-scratch/authorized_keys >> /home/domino/.ssh/authorized_keys
"
