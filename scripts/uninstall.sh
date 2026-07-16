#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -P "$(dirname "$0")" && pwd)
. "$script_dir/common.sh"

check_only=false
component=

usage() {
  printf '%s\n' "Usage: uninstall.sh [agents|templates] [--check]"
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --check) check_only=true ;;
    -h|--help) usage; exit 0 ;;
    agents|templates)
      [ -z "$component" ] || { usage >&2; die "Specify at most one component."; }
      component=$1
      ;;
    *) usage >&2; die "Unknown argument: $1" ;;
  esac
  shift
done

validate_state_root
if [ -n "$component" ]; then
  components=$component
else
  components=$(recorded_components)
fi
[ -n "$components" ] || die "No codex-skills local components are recorded at $state_root."

unsafe=0
for current in $components; do
  state_dir=$(component_state_dir "$current")
  [ -d "$state_dir" ] || die "The $current component is not recorded at $state_dir."
  [ -f "$state_dir/mode" ] && [ -f "$state_dir/manifest" ] || die "Installation state is incomplete for $current."

  mode=$(cat "$state_dir/mode")
  case "$mode" in link|copy) ;; *) die "Invalid installation mode in $current state: $mode" ;; esac

  while IFS='|' read -r kind source_path target_path snapshot; do
    [ -n "$kind" ] || continue
    validate_manifest_entry "$kind" "$source_path" "$target_path" || die "Refusing unsafe or inconsistent entry recorded in $current state: $target_path"
    case "$current:$kind" in
      agents:agent|templates:global-template|templates:project-template) ;;
      *) die "Refusing component mismatch recorded in $current state: $kind" ;;
    esac
    validate_manifest_snapshot "$kind" "$target_path" "$snapshot" "$mode" "$state_dir" || die "Refusing unsafe or inconsistent snapshot recorded in $current state: $snapshot"
    path_exists "$target_path" || continue

    if [ "$mode" = link ]; then
      if [ ! -L "$target_path" ] || [ "$(readlink "$target_path")" != "$source_path" ]; then
        printf '%s\n' "Modified or replaced target: $target_path" >&2
        unsafe=$((unsafe + 1))
      fi
    else
      if [ "$snapshot" = - ] || ! same_content "$snapshot" "$target_path"; then
        printf '%s\n' "Modified target: $target_path" >&2
        unsafe=$((unsafe + 1))
      fi
    fi
  done <"$state_dir/manifest"
done

[ "$unsafe" -eq 0 ] || die "Refusing to remove $unsafe changed target(s). Preserve or restore them first."

if [ "$check_only" = true ]; then
  printf '%s\n' "Installed targets are safe to update or uninstall."
  exit 0
fi

for current in $components; do
  state_dir=$(component_state_dir "$current")
  while IFS='|' read -r kind source_path target_path snapshot; do
    [ -n "$kind" ] || continue
    if path_exists "$target_path"; then
      rm -rf "$target_path"
    fi
  done <"$state_dir/manifest"
  rm -rf "$state_dir"
done

rmdir "$state_root" 2>/dev/null || true
printf '%s\n' "Removed the selected codex-skills local component(s). Backups, if any, were left unchanged."
