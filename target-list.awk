#!/usr/bin/env awk
# target-list.awk — extract "<targets>  <description>" from the main Makefile.
#
# Example Makefile usage:
# ----------------------------------
# NOTE: Recipe lines below are written as "#<space><tab>cmd".
#       If you delete the leading "# ", the tab is preserved,
#       so you get a valid Makefile with proper tabs.
#
# .PHONY: help h H compile c clean
# 
# help h H: ## Show this help message
# 	@echo "Manage the building and testing this project"
# 	@echo ""
# 	@echo "Usage:"
# 	@echo "   make <target>  Examples make compile hw.c"
# 	@echo "                           make c hw.c"
# 	@echo ""
# 	@echo "Targets:"
# 	@awk -f support/target-list.awk $(lastword $(MAKEFILE_LIST))
# 
# lib.%: ## `make lib.<cmd> PKG=<pkg>` -> `arduino-cli lib <cmd> "$(PKG)"`. For lib help `make lib.help`. Example: `make lib.install PKG="ArduinoJson"`
# 	@[ -n "$*" ] && arduino-cli lib "$*" "$(PKG)" \
# 	 || { echo "Error: missing cmd in lib.<cmd>" >&2; exit 1; }
#
# compile c: ## Build the project from source
# 	@echo "Translate source files to object files."
# 
# clean: ## Remove build artifacts
# 	@echo "Remove any and all build artifacts."
# ----------------------------------
#
# Rules:
# - Parse ONLY the file passed as argv[1] (typically $(lastword $(MAKEFILE_LIST))).
# - Candidate line must match:
#       <targets> ":" <space+> ... <space+> "##" <space+> <desc>
#   In other words, the delimiter is exactly [[:space:]]+##[[:space:]]+ after the colon.
# - Ignore recipe lines (start with a tab).
# - UTF-8, case-sensitive. No multi-line target lists.
# - Ignore lines where desc begins with "@internal".
# - Render "name.%" as "name.<cmd>" in the left column.
# - Preserve order. Columns aligned with spaces.

BEGIN { n=0; maxw=0; if (indent == 0) indent=3 }

# --- helpers (avoid DRY) ---
function ltrim(s){ sub(/^[[:space:]]+/, "", s); return s }      # remove leading spaces
function rtrim(s){ sub(/[[:space:]]+$/, "", s); return s }      # remove trailing spaces
function trim(s){ return rtrim(ltrim(s)) }                      # remove both
function is_recipe(line){ return line ~ /^\t/ }                 # true if line starts with a tab
function is_internal(desc){ d=ltrim(desc); return d ~ /^@internal([[:space:]]|$)/ }
function render_target(t){ if (t ~ /\.%$/) sub(/\.%$/, ".<cmd>", t); return t }

{
  line = $0
  if (is_recipe(line)) next   # skip recipe lines

  # Candidate line regex:
  #   verifies the structure; extraction below is POSIX-awk friendly (no submatch array)
  re = "^[[:space:]]*([^:]+):[[:space:]]+[^#]*[[:space:]]+##[[:space:]]+(.*)$"
  if (line !~ re) next

  # Extract targets_raw (left of first ':') and desc (right of first delimiter)
  col = index(line, ":")
  if (!col) next

  # Require at least one whitespace after ':'
  if (col >= length(line)) next
  if (substr(line, col+1, 1) !~ /[[:space:]]/) next

  targets_raw = trim(substr(line, 1, col-1))
  rest = substr(line, col+1)

  # Find the first delimiter [[:space:]]+##[[:space:]]+
  if (match(rest, /[[:space:]]+##[[:space:]]+/) == 0) next
  desc = substr(rest, RSTART + RLENGTH)

  if (targets_raw == "" || is_internal(desc)) next

  # Split target list on whitespace, rewrite any ".%" to ".<cmd>", then rejoin
  nt = split(targets_raw, T, /[[:space:]]+/)
  left = ""
  for (i=1; i<=nt; i++) {
    t = render_target(T[i])
    left = (left=="" ? t : left " " t)
  }

  # Save results, track widest left column
  L[++n] = left
  D[n]   = desc
  if (length(left) > maxw) maxw = length(left)
}

END {
  for (i=1; i<=n; i++) {
    pad = maxw - length(L[i]) + 2
    printf "%*s%s", indent, "", L[i]
    while (pad-- > 0) printf " "
    printf "%s\n", D[i]
  }
}
