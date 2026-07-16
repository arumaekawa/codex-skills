#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -P "$(dirname "$0")" && pwd)
. "$script_dir/common.sh"

mode=link
backup_conflicts=false
component=

usage() {
  cat <<'EOF'
Usage: install.sh <agents|templates> [--link|--copy] [--backup]

Install one local codex-skills component.
Existing targets are refused unless --backup is given.
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --link) mode=link ;;
    --copy) mode=copy ;;
    --backup) backup_conflicts=true ;;
    -h|--help) usage; exit 0 ;;
    agents|templates)
      [ -z "$component" ] || { usage >&2; die "Specify exactly one component."; }
      component=$1
      ;;
    *) usage >&2; die "Unknown argument: $1" ;;
  esac
  shift
done

[ -n "$component" ] || { usage >&2; die "A component is required."; }
validate_state_root
state_dir=$(component_state_dir "$component")
[ ! -e "$state_dir" ] || die "The $component component is already recorded at $state_dir. Run update.sh or uninstall.sh first."

case "$repo_root$HOME$codex_home" in
  *'|'*) die "Repository and home paths must not contain '|'." ;;
esac

plan_file=$(mktemp "${TMPDIR:-/tmp}/codex-skills-plan.XXXXXX")
state_tmp=
rollback_log=
backup_root=
committed=false

rollback_install() {
  [ -n "$rollback_log" ] && [ -f "$rollback_log" ] || return 0
  rollback_failed=false
  set +e
  while IFS='|' read -r target_path backup_path; do
    [ -n "$target_path" ] || continue
    if [ "$backup_path" = - ]; then
      if path_exists "$target_path"; then
        rm -rf "$target_path" || rollback_failed=true
      fi
    elif path_exists "$backup_path"; then
      if path_exists "$target_path"; then
        rm -rf "$target_path" || rollback_failed=true
      fi
      mkdir -p "$(dirname "$target_path")" || rollback_failed=true
      mv "$backup_path" "$target_path" || rollback_failed=true
    fi
  done <"$rollback_log"
  if [ "$rollback_failed" = false ] && [ -n "$backup_root" ]; then
    rm -rf "$backup_root"
  fi
  if [ "$rollback_failed" = true ]; then
    printf '%s\n' "Error: install rollback was incomplete; inspect $backup_root" >&2
  fi
  set -e
}

cleanup_install() {
  status=$?
  trap - 0 HUP INT TERM
  if [ "$status" -ne 0 ] && [ "$committed" != true ]; then
    rollback_install
  fi
  rm -f "$plan_file"
  if [ -n "$state_tmp" ] && [ -e "$state_tmp" ]; then
    rm -rf "$state_tmp"
  fi
  exit "$status"
}

trap cleanup_install 0
trap 'exit 1' HUP INT TERM

write_component_plan "$component" "$plan_file"

conflicts=0
while IFS='|' read -r label kind source_path target_path; do
  [ -n "$label" ] || continue
  validate_managed_target "$kind" "$target_path" || die "Refusing unsafe target: $target_path"
  if path_exists "$target_path"; then
    printf '%s\n' "Conflict: $target_path" >&2
    conflicts=$((conflicts + 1))
  fi
done <"$plan_file"

if [ "$conflicts" -gt 0 ] && [ "$backup_conflicts" != true ]; then
  die "Found $conflicts existing target(s). Re-run with --backup to preserve and replace them."
fi

mkdir -p "$codex_home"
state_tmp=$(mktemp -d "$codex_home/.codex-skills-install.XXXXXX")
rollback_log="$state_tmp/rollback"
: >"$rollback_log"
printf '%s\n' "$mode" >"$state_tmp/mode"
printf '%s\n' "$repo_root" >"$state_tmp/repository"
: >"$state_tmp/manifest"

if [ "$conflicts" -gt 0 ]; then
  backup_root="$codex_home/backups/codex-skills-$(date '+%Y%m%d-%H%M%S')-$$"
fi

while IFS='|' read -r label kind source_path target_path; do
  [ -n "$label" ] || continue
  mkdir -p "$(dirname "$target_path")"

  backup_path=-
  if path_exists "$target_path"; then
    backup_path="$backup_root/$label"
    mkdir -p "$(dirname "$backup_path")"
    printf '%s|%s\n' "$target_path" "$backup_path" >>"$rollback_log"
    mv "$target_path" "$backup_path"
  else
    printf '%s|-\n' "$target_path" >>"$rollback_log"
  fi

  if [ "$mode" = link ]; then
    ln -s "$source_path" "$target_path"
    snapshot=-
  else
    copy_path "$source_path" "$target_path"
    snapshot="$state_dir/snapshot/$label"
    snapshot_tmp="$state_tmp/snapshot/$label"
    mkdir -p "$(dirname "$snapshot_tmp")"
    copy_path "$target_path" "$snapshot_tmp"
  fi

  printf '%s|%s|%s|%s\n' "$kind" "$source_path" "$target_path" "$snapshot" >>"$state_tmp/manifest"
done <"$plan_file"

mkdir -p "$state_root"
mv "$state_tmp" "$state_dir"
committed=true
state_tmp=
rollback_log="$state_dir/rollback"
rm -f "$rollback_log"

printf '%s\n' "Installed codex-skills $component in $mode mode:"
while IFS='|' read -r label kind source_path target_path; do
  [ -n "$label" ] || continue
  printf '  %s -> %s\n' "$label" "$target_path"
done <"$plan_file"
[ -z "$backup_root" ] || printf '%s\n' "Previous files were backed up to $backup_root."
printf '%s\n' "Start a new Codex task to load the installed configuration."
