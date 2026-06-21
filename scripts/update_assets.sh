#!/bin/bash
set -euo pipefail

ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 INTERNAL_EXPERIMENT_DIRECTORY" >&2
  exit 2
fi

SOURCE=$(cd -- "$1" && pwd -P)
DEST="$ROOT/experiments/formal-cutevents-example/assets"

if [[ ! -d "$SOURCE/assets/figures" || ! -d "$SOURCE/generated" ]]; then
  echo "Error: expected assets/figures and generated below $SOURCE" >&2
  exit 1
fi

mkdir -p "$DEST/figures" "$DEST/generated"
rsync -a --delete "$SOURCE/assets/figures/" "$DEST/figures/"

for name in optimizer_nll.png fit_fractions_channel0.png fit_fractions_channel1.png; do
  if [[ ! -f "$SOURCE/generated/$name" ]]; then
    echo "Error: missing public diagnostic: $SOURCE/generated/$name" >&2
    exit 1
  fi
  cp "$SOURCE/generated/$name" "$DEST/generated/$name"
done

echo "Updated public-safe plot assets from: $SOURCE"

