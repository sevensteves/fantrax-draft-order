#!/usr/bin/env bash
set -euo pipefail

seed_text="${2:-}"
if [[ "${1:-}" == "--seed" && -n "$seed_text" ]]; then
  :
else
  seed_text=""
fi

seed_num=""
if [[ -n "$seed_text" ]]; then
  seed_num="$(printf '%s' "$seed_text" | cksum | awk '{print $1}')"
fi

TEAMS="$(cat <<'EOF'
Bananaananas
BigForrest FC
FC Colin Hendry
FC Gummi Magg
FC Pascal Gross
Greenkeeper
Run Train F.C.
Show me the Mané
SJ Warriors
The Mbuemo's
EOF
)"

printf '%s\n' "$TEAMS" | awk -v seed="${seed_num}" -v seed_text="${seed_text}" '
BEGIN { if (seed != "") srand(seed); else srand(); }
{ a[++n] = $0 }
END {
  for (i = n; i > 1; i--) { j = int(rand()*i) + 1; tmp=a[i]; a[i]=a[j]; a[j]=tmp }
  printf "Random Draft Order%s:\n\n", (seed_text != "" ? " (seed=\"" seed_text "\")" : "")
  for (i = 1; i <= n; i++) printf "%d. %s\n", i, a[i]
}
'
