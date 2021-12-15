#!/usr/bin/env bash

set -x
! tmux list-sessions || tmux kill-session
declare sudo=
if sudo true; then
  sudo="sudo -n"
fi

echo "pwd: $(pwd)"
for pid in domino/*.pid; do
  pgid=$(ps opgid= "$(cat "$pid")" | tr -d '[:space:]')
  if [[ -n $pgid ]]; then
    $sudo kill -- -"$pgid"
  fi
done
if [[ -f domino/netem.cfg ]]; then
  domino/scripts/netem.sh delete < domino/netem.cfg
  rm -f domino/netem.cfg
fi
domino/scripts/net-shaper.sh cleanup
for pattern in validator.sh boostrap-leader.sh domino- remote- iftop validator client node; do
  echo "killing $pattern"
  pkill -f $pattern
done
