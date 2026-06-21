#!/bin/bash
set -euo pipefail

ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: $0 INTERNAL_EXPERIMENT_DIRECTORY [PUBLIC_ID]" >&2
  exit 2
fi

SOURCE=$(cd -- "$1" && pwd -P)
PUBLIC_ID=${2:-$(basename "$SOURCE")}

if ! [[ "$PUBLIC_ID" =~ ^[a-z0-9][a-z0-9-]*$ ]]; then
  echo "Error: PUBLIC_ID may contain only lowercase letters, digits and dashes" >&2
  exit 2
fi

DEST="$ROOT/experiments/$PUBLIC_ID/assets"

if [[ ! -d "$SOURCE/assets/figures" || ! -d "$SOURCE/generated" ]]; then
  echo "Error: expected assets/figures and generated below $SOURCE" >&2
  exit 1
fi

mkdir -p "$DEST/figures" "$DEST/generated"
rsync -a --delete "$SOURCE/assets/figures/" "$DEST/figures/"

for name in optimizer_nll.png memory_growth.png fit_fractions_channel0.png fit_fractions_channel1.png; do
  if [[ ! -f "$SOURCE/generated/$name" ]]; then
    echo "Error: missing public diagnostic: $SOURCE/generated/$name" >&2
    exit 1
  fi
  cp "$SOURCE/generated/$name" "$DEST/generated/$name"
done

echo "Updated public-safe plot assets for: $PUBLIC_ID"
