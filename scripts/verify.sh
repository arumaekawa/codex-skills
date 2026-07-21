#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -P "$(dirname "$0")" && pwd)
. "$script_dir/common.sh"

installed=false
component=

usage() {
  printf '%s\n' "Usage: verify.sh [--installed [agents|templates]]"
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --installed) installed=true ;;
    -h|--help) usage; exit 0 ;;
    agents|templates)
      [ -z "$component" ] || { usage >&2; die "Specify at most one component."; }
      component=$1
      ;;
    *) usage >&2; die "Unknown argument: $1" ;;
  esac
  shift
done

[ -z "$component" ] || [ "$installed" = true ] || { usage >&2; die "A component can be selected only with --installed."; }

if [ "$installed" = true ]; then
  validate_state_root
  if [ -n "$component" ]; then
    components=$component
  else
    components=$(recorded_components)
  fi
  [ -n "$components" ] || die "No codex-skills local components are recorded."

  for current in $components; do
    state_dir=$(component_state_dir "$current")
    [ -d "$state_dir" ] || die "The $current component is not recorded at $state_dir."
    [ -f "$state_dir/mode" ] && [ -f "$state_dir/manifest" ] || die "Installation state is incomplete for $current."
    mode=$(cat "$state_dir/mode")
    case "$mode" in link|copy) ;; *) die "Invalid installation mode in $current state: $mode" ;; esac
    component_set_matches "$current" "$state_dir" "$state_dir/manifest" "$mode" || die "Installed $current components no longer match this repository. Uninstall and reinstall $current to reconcile added, removed, or missing components."

    while IFS='|' read -r kind source_path target_path snapshot; do
      [ -n "$kind" ] || continue
      validate_manifest_entry "$kind" "$source_path" "$target_path" || die "Unsafe or inconsistent entry recorded in $current state: $target_path"
      validate_manifest_snapshot "$kind" "$target_path" "$snapshot" "$mode" "$state_dir" || die "Unsafe or inconsistent snapshot recorded in $current state: $snapshot"
      path_exists "$source_path" || die "Missing component source: $source_path. Uninstall and reinstall $current to reconcile components."
      path_exists "$target_path" || die "Missing installed target: $target_path"
      if [ "$mode" = link ]; then
        [ -L "$target_path" ] && [ "$(readlink "$target_path")" = "$source_path" ] || die "Changed installed link: $target_path"
      else
        [ "$snapshot" != - ] && same_content "$snapshot" "$target_path" || die "Changed installed copy: $target_path"
      fi
    done <"$state_dir/manifest"
  done
fi

expected_skills='build-incremental
code-simplify
design-first
implementation-workflow
plan-driven-development
subagent-supervision
task-brief
tidy-first
write-personal-wiki
write-project-wiki'

actual_skills=$(
  for path in "$repo_root"/skills/*; do
    [ -d "$path" ] || continue
    basename "$path"
  done | LC_ALL=C sort
)
[ "$actual_skills" = "$expected_skills" ] || die "skills/ does not contain the expected custom skill set."

for name in $expected_skills; do
  [ -f "$repo_root/skills/$name/SKILL.md" ] || die "Missing skills/$name/SKILL.md"
  [ -f "$repo_root/skills/$name/agents/openai.yaml" ] || die "Missing skills/$name/agents/openai.yaml"
done

[ -f "$repo_root/agents/code-reviewer.toml" ] || die "Missing code-reviewer.toml"
[ -f "$repo_root/templates/AGENTS_global.md" ] || die "Missing AGENTS_global.md"
[ -f "$repo_root/templates/AGENTS_project.md" ] || die "Missing AGENTS_project.md"
[ -f "$repo_root/.codex-plugin/plugin.json" ] || die "Missing plugin manifest"
[ -f "$repo_root/.agents/plugins/marketplace.json" ] || die "Missing marketplace manifest"

command -v python3 >/dev/null 2>&1 || die "python3 is required to validate JSON files."
python3 -m json.tool "$repo_root/.codex-plugin/plugin.json" >/dev/null
python3 -m json.tool "$repo_root/.agents/plugins/marketplace.json" >/dev/null

for shell_script in "$repo_root"/scripts/*.sh; do
  sh -n "$shell_script" || die "Shell syntax check failed: $shell_script"
done

unix_home_pattern='(/Users|/home)/''[A-Za-z0-9._-]+'
windows_home_pattern='[A-Za-z]:\\Users\\''[A-Za-z0-9._-]+'
scan_pattern="$unix_home_pattern|$windows_home_pattern|sk-[A-Za-z0-9_-]{20,}|gh[pousr]_[A-Za-z0-9]{20,}|BEGIN (RSA |OPENSSH )?PRIVATE KEY"
if grep -R -n -E "$scan_pattern" \
  "$repo_root/skills" "$repo_root/agents" "$repo_root/templates" "$repo_root/scripts" \
  "$repo_root/.codex-plugin" "$repo_root/.agents" "$repo_root/README.md" >/dev/null 2>&1; then
  die "Found a personal absolute path or credential-like value in distributed files."
fi

if [ "$installed" = true ]; then
  printf '%s\n' "Verification passed for source and installed files."
else
  printf '%s\n' "Source verification passed."
fi
