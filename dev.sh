#!/usr/bin/env bash
# Live preview while writing: rebuilds on every save and auto-reloads the browser.
# Also renders draft guides (status "ongoing"/"planned" that have a `body`).
# Output goes to dist-dev/, so it never mixes with the production build in dist/.
#
#   ./dev.sh            → http://127.0.0.1:3000
#   ./dev.sh 8000       → custom port
set -euo pipefail
cd "$(dirname "$0")"
rm -rf dist-dev
exec typst watch --features html,bundle --format bundle \
  --input drafts=true \
  --port "${1:-3000}" \
  main.typ dist-dev/
