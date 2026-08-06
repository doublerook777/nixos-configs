#!/bin/bash
SCRIPT_PATH="/home/caelum/nixos-configs/scripts/pkg-install.sh"
CONFIG_DIR="/home/caelum/nixos-configs"
FLAKE_REF="nixpkgs/nixos-25.11"
if [ "$1" = "--search-mode" ]; then
  query="$2"
  [ -z "$query" ] && exit 0
  nix search "$FLAKE_REF" "$query" --json 2>/dev/null | jq -r '
    to_entries[] |
    "\(.key | sub("^legacyPackages\\.[^.]+\\."; ""))\t\(.value.version // "?")\t\(.value.description // "no description")"
  ' | awk -v q="$query" -F'\t' '
    {
      lname = tolower($1); lq = tolower(q)
      if (lname == lq) rank = 0
      else if (index(lname, lq) == 1) rank = 1
      else rank = 2
      print rank "\t" $0
    }
  ' | sort -t $'\t' -k1,1n -k2,2 | cut -f2-
  exit 0
fi
chosen=$(fzf --disabled \
  --prompt="Search nixpkgs> " \
  --header="Type query · Tab to search · Enter to select · Esc to quit" \
  --delimiter=$'\t' \
  --with-nth=1,2,3 \
  --preview 'printf "Package: %s\nVersion: %s\n\n%s" {1} {2} {3}' \
  --preview-window=down:25%:wrap \
  --bind "tab:reload(bash \"$SCRIPT_PATH\" --search-mode {q} || true)" \
  </dev/null)
[ -z "$chosen" ] && exit 0
pkgname=$(echo "$chosen" | awk -F'\t' '{print $1}')
meta=$(nix eval --json "$FLAKE_REF#legacyPackages.x86_64-linux.$pkgname.meta" 2>/dev/null)
homepage=$(echo "$meta" | jq -r '(.homepage // (.homepages[0]? )) // "n/a"')
license=$(echo "$meta" | jq -r '
  if (.license == null) then "n/a"
  elif (.license | type) == "array" then ([.license[] | (.shortName // .fullName // tostring)] | join(", "))
  else (.license.shortName // .license.fullName // (.license | tostring))
  end
')
position=$(echo "$meta" | jq -r '.position // "n/a"')
if [ "$position" != "n/a" ]; then
  src_path="${position%%:*}"
  src_line="${position##*:}"
  source_url="https://github.com/NixOS/nixpkgs/blob/nixos-25.11/$src_path#L$src_line"
else
  source_url="n/a"
fi
details_header="Package:  $pkgname
Homepage: $homepage
Source:   $source_url
License:  $license"
proceed=$(printf "Continue\nCancel" | fzf --prompt="> " --header="$details_header" --header-first)
[ "$proceed" != "Continue" ] && exit 0
target=$(printf "System (configuration.nix)\nUser (home.nix)" | fzf --prompt="Install for: " --header="Where should $pkgname go?")
[ -z "$target" ] && exit 0
if [[ "$target" == System* ]]; then
  file="$CONFIG_DIR/configuration.nix"
  marker="environment.systemPackages = with pkgs; ["
else
  file="$CONFIG_DIR/home.nix"
  marker="home.packages = with pkgs; ["
fi
pkg_re=$(printf '%s' "$pkgname" | sed 's/[.[\*^$/]/\\&/g')
if grep -qE "^[[:space:]]*${pkg_re}[[:space:]]*\$" "$file"; then
  echo "$pkgname is already in $(basename "$file")"
  exit 0
fi
cp "$file" "$file.bak"
awk -v pkg="$pkgname" -v marker="$marker" '
  index($0, marker) > 0 { in_block=1 }
  in_block && /^[[:space:]]*\];/ && !inserted {
    print "    " pkg
    inserted=1
  }
  { print }
' "$file" >"$file.tmp" && mv "$file.tmp" "$file"
echo "Added $pkgname to $(basename "$file"):"
diff -u "$file.bak" "$file"
rm "$file.bak"
confirm=$(printf "Yes\nNo" | fzf --prompt="Rebuild now? " --header="Apply the config change immediately?")
if [ "$confirm" = "Yes" ]; then
  (
    cd "$CONFIG_DIR" || exit 1
    git add -A
    git add -f files/
    trap 'git reset' EXIT
    sudo nixos-rebuild switch --flake "$CONFIG_DIR#caelums-nix"
  )
else
  echo "Skipped rebuild. cd into ~/nixos-configs and run 'rebuild' manually when ready."
fi
