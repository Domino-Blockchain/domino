#!/usr/bin/env bash
#
# Starts an instance of domino-faucet
#
here=$(dirname "$0")

# shellcheck source=multinode-demo/common.sh
source "$here"/common.sh

[[ -f "$DOMINO_CONFIG_DIR"/faucet.json ]] || {
  echo "$DOMINO_CONFIG_DIR/faucet.json not found, create it by running:"
  echo
  echo "  ${here}/setup.sh"
  exit 1
}

set -x
# shellcheck disable=SC2086 # Don't want to double quote $domino_faucet
exec $domino_faucet --keypair "$DOMINO_CONFIG_DIR"/faucet.json "$@"
