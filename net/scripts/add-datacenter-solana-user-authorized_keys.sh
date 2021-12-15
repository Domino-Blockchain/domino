#!/usr/bin/env bash
set -ex

cd "$(dirname "$0")"

# shellcheck source=net/scripts/domino-user-authorized_keys.sh
source domino-user-authorized_keys.sh

# domino-user-authorized_keys.sh defines the public keys for users that should
# automatically be granted access to ALL datacenter nodes.
for i in "${!DOMINO_USERS[@]}"; do
  echo "environment=\"DOMINO_USER=${DOMINO_USERS[i]}\" ${DOMINO_PUBKEYS[i]}"
done

