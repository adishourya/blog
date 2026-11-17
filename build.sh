#!/usr/bin/env bash
# Build the whole site into dist/ using Typst's (experimental) HTML bundle export.
set -euo pipefail
cd "$(dirname "$0")"
rm -rf dist
typst compile --features html,bundle --format bundle main.typ dist/
echo "Built: $(find dist -type f | wc -l) files in dist/"
