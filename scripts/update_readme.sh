#!/usr/bin/env bash
set -euo pipefail

CODE_BLOCK=1
[[ "${1:-}" == "--no-code" ]] && CODE_BLOCK=0

SECTION_START="<!-- DRAFT_ORDER_START -->"
SECTION_END="<!-- DRAFT_ORDER_END -->"

payload_file="$(mktemp)"
cat > "$payload_file"

if [[ ! -f README.md ]]; then
  cat > README.md <<'HDR'
[![Draft Order](https://github.com/sevensteves/fantrax-draft-order/actions/workflows/draft-order.yml/badge.svg)](https://github.com/sevensteves/fantrax-draft-order/actions/workflows/draft-order.yml)
# fantrax-draft-order
<!-- DRAFT_ORDER_START -->
(output will appear here after the first run)
<!-- DRAFT_ORDER_END -->
HDR
fi

if [[ $CODE_BLOCK -eq 1 ]]; then
  REPL="$SECTION_START
\`\`\`
$(cat "$payload_file")
\`\`\`
$SECTION_END"
else
  REPL="$SECTION_START
$(cat "$payload_file")
$SECTION_END"
fi

export REPL
perl -0777 -pe 'BEGIN { $r = $ENV{REPL} } s/<!-- DRAFT_ORDER_START -->.*?<!-- DRAFT_ORDER_END -->/$r/s' README.md > README.md.tmp
mv README.md.tmp README.md

rm -f "$payload_file"
echo "README.md updated."
