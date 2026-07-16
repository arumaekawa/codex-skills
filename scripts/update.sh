#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -P "$(dirname "$0")" && pwd)
. "$script_dir/common.sh"

pull=true

usage() {
  printf '%s\n' "Usage: update.sh [--no-pull]"
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --no-pull) pull=false ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; die "Unknown argument: $1" ;;
  esac
  shift
done

validate_state_root
components=$(recorded_components)
[ -n "$components" ] || die "No codex-skills local components are recorded. Run install.sh first."
"$script_dir/uninstall.sh" --check >/dev/null

for current in $components; do
  state_dir=$(component_state_dir "$current")
  [ -d "$state_dir" ] || die "The $current component is not recorded. Run install.sh $current first."
  [ -f "$state_dir/repository" ] && [ -f "$state_dir/mode" ] || die "Installation state is incomplete for $current."
  installed_repo=$(cat "$state_dir/repository")
  [ "$installed_repo" = "$repo_root" ] || die "The $current component is managed by $installed_repo, not $repo_root."
done

if [ "$pull" = true ]; then
  command -v git >/dev/null 2>&1 || die "git is required for updates."
  git -C "$repo_root" rev-parse --is-inside-work-tree >/dev/null 2>&1 || die "$repo_root is not a Git working tree."
  git -C "$repo_root" pull --ff-only
fi

"$script_dir/verify.sh"

for current in $components; do
  state_dir=$(component_state_dir "$current")
  mode=$(cat "$state_dir/mode")
  case "$mode" in link|copy) ;; *) die "Invalid installation mode in $current state: $mode" ;; esac
  component_set_matches "$current" "$state_dir" "$state_dir/manifest" "$mode" || die "Installed $current components no longer match this repository. Uninstall and reinstall $current to reconcile added, removed, or missing components."
done

for current in $components; do
  state_dir=$(component_state_dir "$current")
  mode=$(cat "$state_dir/mode")
  if [ "$mode" = link ]; then
    printf '%s\n' "Linked $current component is up to date."
    continue
  fi

  while IFS='|' read -r kind source_path target_path snapshot; do
    [ -n "$kind" ] || continue
    [ -e "$source_path" ] || die "Installed component no longer exists: $source_path. Uninstall and reinstall $current to reconcile component changes."

    staged="$target_path.codex-skills-new.$$"
    old="$target_path.codex-skills-old.$$"
    [ ! -e "$staged" ] && [ ! -e "$old" ] || die "Temporary update path already exists for $target_path."

    copy_path "$source_path" "$staged"
    if path_exists "$target_path"; then
      mv "$target_path" "$old"
    fi
    if mv "$staged" "$target_path"; then
      if path_exists "$old"; then
        rm -rf "$old"
      fi
    else
      if path_exists "$old"; then
        mv "$old" "$target_path"
      fi
      die "Could not replace $target_path"
    fi

    rm -rf "$snapshot"
    mkdir -p "$(dirname "$snapshot")"
    copy_path "$target_path" "$snapshot"
  done <"$state_dir/manifest"
  printf '%s\n' "Copied $current component is up to date."
done

"$script_dir/verify.sh" --installed
printf '%s\n' "Start a new Codex task to load changes."
