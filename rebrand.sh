#!/usr/bin/env bash
# rebrand.sh — Squadra (Amabile AI) rebrand of Lukem121/paperclip-railway-template.
# Idempotent. Runs in Docker build (after Paperclip SPA is built into /app/ui/dist).
# Mutations:
#   1. wrapper/src/server.js   → setupHtml() strings "Paperclip Setup" -> "Squadra Setup"
#   2. /app/ui/dist/**/*.{html,json,js}  → user-facing "Paperclip" strings -> "Squadra" (anchored, never bare)
#   3. brand/* assets          → /wrapper/public/static/squadra/
#   4. /app/ui/dist/index.html → inject <link rel=stylesheet href=/static/squadra/custom.css> + favicon overrides
# Fails (exit 1) if 0 mutations occur (detects upstream drift).

set -euo pipefail

BRAND_NAME="${BRAND_NAME:-Squadra}"
ROOT="${ROOT:-$(pwd)}"
BRAND_DIR="${ROOT}/brand"
WRAPPER_DIR="${WRAPPER_DIR:-/wrapper}"
WRAPPER_SRC="${WRAPPER_SRC:-${ROOT}/src}"
SPA_DIST="${SPA_DIST:-/app/ui/dist}"
WRAPPER_PUBLIC="${WRAPPER_PUBLIC:-/wrapper/public/static/squadra}"
TOTAL=0

log() { printf '{"phase":"%s","file":"%s","matches":%s,"status":"%s"}\n' "$1" "$2" "$3" "$4"; }

safe_sed() {
  local pattern="$1" replacement="$2" file="$3" phase="$4"
  [[ -f "$file" ]] || { log "$phase" "$file" 0 "skip-missing"; return 0; }
  local n
  n=$(grep -cE "$pattern" "$file" || true)
  if [[ "$n" -gt 0 ]]; then
    sed -i.bak -E "s|${pattern}|${replacement}|g" "$file"
    rm -f "${file}.bak"
    TOTAL=$((TOTAL + n))
    log "$phase" "$file" "$n" "ok"
  else
    log "$phase" "$file" 0 "no-match"
  fi
}

# --- 1. Patch wrapper setup page (server.js setupHtml()) ----------------------
patch_wrapper() {
  local f="${WRAPPER_SRC}/server.js"
  [[ -f "$f" ]] || { log wrapper "$f" 0 "skip-missing-dev-mode"; return 0; }
  safe_sed '<title>Paperclip Setup</title>'    "<title>${BRAND_NAME} Setup</title>"     "$f" wrapper
  safe_sed '<h1>Paperclip Setup</h1>'          "<h1>${BRAND_NAME} Setup</h1>"           "$f" wrapper
  safe_sed 'Paperclip health:'                 "${BRAND_NAME} health:"                  "$f" wrapper
  safe_sed 'Open Paperclip'                    "Open ${BRAND_NAME}"                     "$f" wrapper
  # also patch the installed copy in container (Docker context)
  local g="${WRAPPER_DIR}/src/server.js"
  if [[ -f "$g" && "$g" != "$f" ]]; then
    safe_sed '<title>Paperclip Setup</title>'    "<title>${BRAND_NAME} Setup</title>"     "$g" wrapper
    safe_sed '<h1>Paperclip Setup</h1>'          "<h1>${BRAND_NAME} Setup</h1>"           "$g" wrapper
    safe_sed 'Paperclip health:'                 "${BRAND_NAME} health:"                  "$g" wrapper
    safe_sed 'Open Paperclip'                    "Open ${BRAND_NAME}"                     "$g" wrapper
  fi
}

# --- 2. Patch built SPA (Paperclip core UI) ----------------------------------
patch_spa_dist() {
  [[ -d "$SPA_DIST" ]] || { log spa "$SPA_DIST" 0 "skip-no-dist"; return 0; }
  while IFS= read -r -d '' f; do
    # HTML title + apple meta
    safe_sed '<title>Paperclip</title>'                                          "<title>${BRAND_NAME}</title>"                                       "$f" spa-html
    safe_sed '<meta name="apple-mobile-web-app-title" content="Paperclip" />'    "<meta name=\"apple-mobile-web-app-title\" content=\"${BRAND_NAME}\" />" "$f" spa-html
    # JSON manifest fields (quoted exact match)
    safe_sed '"name":[[:space:]]*"Paperclip"'                                    "\"name\": \"${BRAND_NAME}\""                                        "$f" spa-manifest
    safe_sed '"short_name":[[:space:]]*"Paperclip"'                              "\"short_name\": \"${BRAND_NAME}\""                                  "$f" spa-manifest
    # JS user-facing copy (quoted strings only, never bare identifiers — `paperclipReady` survives)
    safe_sed 'Sign in to Paperclip'                                              "Sign in to ${BRAND_NAME}"                                           "$f" spa-js
    safe_sed 'Create your Paperclip account'                                     "Create your ${BRAND_NAME} account"                                  "$f" spa-js
    # Bare quoted string — catches React children, document.title="Paperclip", labels, etc.
    safe_sed '"Paperclip"'                                                       "\"${BRAND_NAME}\""                                                  "$f" spa-js-strings
    # Lowercase case label `case"paperclip"` → `case"squadra"` (icon mapping)
    safe_sed '"paperclip"'                                                       "\"squadra\""                                                        "$f" spa-js-case
    safe_sed 'Paperclip managed'                                                 "${BRAND_NAME} managed"                                              "$f" spa-js
  done < <(find "$SPA_DIST" \( -name '*.html' -o -name '*.json' -o -name '*.js' \) -print0)
}

# --- 3. Copy brand assets into wrapper static path ---------------------------
copy_assets() {
  [[ -d "$BRAND_DIR" ]] || { log assets "$BRAND_DIR" 0 "skip-no-src"; return 0; }
  mkdir -p "$WRAPPER_PUBLIC"
  cp -rf "$BRAND_DIR"/. "$WRAPPER_PUBLIC/"
  local n
  n=$(find "$WRAPPER_PUBLIC" -type f | wc -l)
  TOTAL=$((TOTAL + n))
  log assets "$WRAPPER_PUBLIC" "$n" "ok"
}

# --- 4. Inject custom.css + favicon overrides into SPA index.html ------------
inject_css() {
  [[ -d "$SPA_DIST" ]] || return 0
  local marker="<!-- SQUADRA-BRAND-START -->"
  local block="${marker}<link rel=\"stylesheet\" href=\"/static/squadra/custom.css\"><link rel=\"icon\" type=\"image/x-icon\" href=\"/static/squadra/favicon.ico\"><link rel=\"apple-touch-icon\" href=\"/static/squadra/apple-touch-icon.png\"><link rel=\"manifest\" href=\"/static/squadra/squadra-manifest.webmanifest\"><meta name=\"theme-color\" content=\"#A78BFA\"><!-- SQUADRA-BRAND-END -->"
  while IFS= read -r -d '' f; do
    if grep -q 'SQUADRA-BRAND-START' "$f"; then
      log inject-css "$f" 0 "already-injected"
      continue
    fi
    if grep -q '</head>' "$f"; then
      # escape replacement for sed
      python3 - "$f" "$block" <<'PY' || sed -i.bak "s|</head>|${block}</head>|" "$f"
import sys, re
p, blk = sys.argv[1], sys.argv[2]
with open(p, 'r', encoding='utf-8') as fh: s = fh.read()
s = s.replace('</head>', blk + '</head>', 1)
with open(p, 'w', encoding='utf-8') as fh: fh.write(s)
PY
      rm -f "${f}.bak"
      TOTAL=$((TOTAL + 1))
      log inject-css "$f" 1 "ok"
    fi
  done < <(find "$SPA_DIST" -name '*.html' -print0)
}

main() {
  echo "{\"phase\":\"start\",\"brand\":\"${BRAND_NAME}\",\"root\":\"${ROOT}\"}"
  patch_wrapper
  patch_spa_dist
  copy_assets
  inject_css
  if [[ "$TOTAL" -eq 0 ]]; then
    echo '{"phase":"summary","status":"fail","reason":"zero mutations — upstream drift or wrong cwd?"}' >&2
    exit 1
  fi
  printf '{"phase":"summary","status":"ok","total":%d}\n' "$TOTAL"
}

main "$@"
