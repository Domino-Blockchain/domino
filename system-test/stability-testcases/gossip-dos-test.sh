#!/usr/bin/env bash

set -e
cd "$(dirname "$0")"
DOMINO_ROOT="$(cd ../..; pwd)"

logDir="$PWD"/logs
rm -rf "$logDir"
mkdir "$logDir"

dominoInstallDataDir=$PWD/releases
dominoInstallGlobalOpts=(
  --data-dir "$dominoInstallDataDir"
  --config "$dominoInstallDataDir"/config.yml
  --no-modify-path
)

# Install all the domino versions
bootstrapInstall() {
  declare v=$1
  if [[ ! -h $dominoInstallDataDir/active_release ]]; then
    sh "$DOMINO_ROOT"/install/domino-install-init.sh "$v" "${dominoInstallGlobalOpts[@]}"
  fi
  export PATH="$dominoInstallDataDir/active_release/bin/:$PATH"
}

bootstrapInstall "edge"
domino-install-init --version
domino-install-init edge
domino-gossip --version
domino-dos --version

killall domino-gossip || true
domino-gossip spy --gossip-port 8001 > "$logDir"/gossip.log 2>&1 &
dominoGossipPid=$!
echo "domino-gossip pid: $dominoGossipPid"
sleep 5
domino-dos --mode gossip --data-type random --data-size 1232 &
dosPid=$!
echo "domino-dos pid: $dosPid"

pass=true

SECONDS=
while ((SECONDS < 600)); do
  if ! kill -0 $dominoGossipPid; then
    echo "domino-gossip is no longer running after $SECONDS seconds"
    pass=false
    break
  fi
  if ! kill -0 $dosPid; then
    echo "domino-dos is no longer running after $SECONDS seconds"
    pass=false
    break
  fi
  sleep 1
done

kill $dominoGossipPid || true
kill $dosPid || true
wait || true

$pass && echo Pass
