#!/usr/bin/env bash

here=$(dirname "$0")
# shellcheck source=multinode-demo/common.sh
source "$here"/common.sh

set -e

rm -rf "$DOMINO_CONFIG_DIR"/latest-testnet-snapshot
mkdir -p "$DOMINO_CONFIG_DIR"/latest-testnet-snapshot
(
  cd "$DOMINO_CONFIG_DIR"/latest-testnet-snapshot || exit 1
  set -x
  wget http://api.testnet.dominochain.com/genesis.tar.bz2
  wget --trust-server-names http://testnet.dominochain.com/snapshot.tar.bz2
)

snapshot=$(ls "$DOMINO_CONFIG_DIR"/latest-testnet-snapshot/snapshot-[0-9]*-*.tar.zst)
if [[ -z $snapshot ]]; then
  echo Error: Unable to find latest snapshot
  exit 1
fi

if [[ ! $snapshot =~ snapshot-([0-9]*)-.*.tar.zst ]]; then
  echo Error: Unable to determine snapshot slot for "$snapshot"
  exit 1
fi

snapshot_slot="${BASH_REMATCH[1]}"

rm -rf "$DOMINO_CONFIG_DIR"/bootstrap-validator
mkdir -p "$DOMINO_CONFIG_DIR"/bootstrap-validator


# Create genesis ledger
if [[ -r $FAUCET_KEYPAIR ]]; then
  cp -f "$FAUCET_KEYPAIR" "$DOMINO_CONFIG_DIR"/faucet.json
else
  $domino_keygen new --no-passphrase -fso "$DOMINO_CONFIG_DIR"/faucet.json
fi

if [[ -f $BOOTSTRAP_VALIDATOR_IDENTITY_KEYPAIR ]]; then
  cp -f "$BOOTSTRAP_VALIDATOR_IDENTITY_KEYPAIR" "$DOMINO_CONFIG_DIR"/bootstrap-validator/identity.json
else
  $domino_keygen new --no-passphrase -so "$DOMINO_CONFIG_DIR"/bootstrap-validator/identity.json
fi

$domino_keygen new --no-passphrase -so "$DOMINO_CONFIG_DIR"/bootstrap-validator/vote-account.json
$domino_keygen new --no-passphrase -so "$DOMINO_CONFIG_DIR"/bootstrap-validator/stake-account.json

$domino_ledger_tool create-snapshot \
  --ledger "$DOMINO_CONFIG_DIR"/latest-testnet-snapshot \
  --faucet-pubkey "$DOMINO_CONFIG_DIR"/faucet.json \
  --faucet-lamports 500000000000000000 \
  --bootstrap-validator "$DOMINO_CONFIG_DIR"/bootstrap-validator/identity.json \
                        "$DOMINO_CONFIG_DIR"/bootstrap-validator/vote-account.json \
                        "$DOMINO_CONFIG_DIR"/bootstrap-validator/stake-account.json \
  --hashes-per-tick sleep \
  "$snapshot_slot" "$DOMINO_CONFIG_DIR"/bootstrap-validator

$domino_ledger_tool modify-genesis \
  --ledger "$DOMINO_CONFIG_DIR"/latest-testnet-snapshot \
  --hashes-per-tick sleep \
  "$DOMINO_CONFIG_DIR"/bootstrap-validator
