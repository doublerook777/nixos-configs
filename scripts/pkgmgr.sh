#!/bin/bash
SCRIPT_PATH="/home/caelum/nixos-configs/scripts/pkgmgr.sh"
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

pick_target() {
  printf "System (configuration.nix)\nUser (home.nix)" | fzf --prompt="$1" --header="$2"
}

target_file_and_marker() {
  if [[ "$1" == System* ]]; then
    echo "$CONFIG_DIR/configuration.nix|environment.systemPackages = with pkgs; ["
  else
    echo "$CONFIG_DIR/home.nix|home.packages = with pkgs; ["
  fi
}

do_rebuild() {
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
}

install_flow() {
  chosen=$(fzf --disabled \
    --prompt="Search nixpkgs> " \
    --header="Type query · Tab to search · Enter to select · Esc to quit" \
    --delimiter=$'\t' \
    --with-nth=1,2,3 \
    --preview 'printf "Package: %s\nVersion: %s\n\n%s" {1} {2} {3}' \
    --preview-window=down:25%:wrap \
    --bind "tab:reload(bash \"$SCRIPT_PATH\" --search-mode {q} || true)" \
    </dev/null)
  [ -z "$chosen" ] && return

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
  [ "$proceed" != "Continue" ] && return

  target=$(pick_target "Install for: " "Where should $pkgname go?")
  [ -z "$target" ] && return

  IFS='|' read -r file marker <<<"$(target_file_and_marker "$target")"

  pkg_re=$(printf '%s' "$pkgname" | sed 's/[.[\*^$/]/\\&/g')

  if grep -qE "^[[:space:]]*${pkg_re}[[:space:]]*\$" "$file"; then
    echo "$pkgname is already in $(basename "$file")"
    return
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

  do_rebuild
}

uninstall_flow() {
  target=$(pick_target "Remove from: " "Which config?")
  [ -z "$target" ] && return

  IFS='|' read -r file marker <<<"$(target_file_and_marker "$target")"

  installed=$(awk -v marker="$marker" '
    index($0, marker) > 0 { in_block=1; next }
    in_block && /^[[:space:]]*\];/ { in_block=0 }
    in_block {
      line=$0
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", line)
      if (line != "" && line !~ /^#/) print line
    }
  ' "$file")

  if [ -z "$installed" ]; then
    echo "No packages found in $(basename "$file")"
    return
  fi

  pkgname=$(echo "$installed" | fzf --prompt="Remove: " --header="Select a package to remove from $(basename "$file")")
  [ -z "$pkgname" ] && return

  pkg_re=$(printf '%s' "$pkgname" | sed 's/[.[\*^$/]/\\&/g')

  cp "$file" "$file.bak"

  awk -v marker="$marker" -v pkg_re="$pkg_re" '
    index($0, marker) > 0 { in_block=1 }
    in_block && $0 ~ "^[[:space:]]*" pkg_re "[[:space:]]*$" { next }
    in_block && /^[[:space:]]*\];/ { in_block=0 }
    { print }
  ' "$file" >"$file.tmp" && mv "$file.tmp" "$file"

  echo "Removed $pkgname from $(basename "$file"):"
  diff -u "$file.bak" "$file"
  rm "$file.bak"

  do_rebuild
}

action=$(printf "Install\nUninstall" | fzf --prompt="Package Manager> " --header="What do you want to do?")
case "$action" in
Install) install_flow ;;
Uninstall) uninstall_flow ;;
*) exit 0 ;;
esac
