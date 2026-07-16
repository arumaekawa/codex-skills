#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -P "$(dirname "$0")" && pwd)
repo_root=$(CDPATH= cd -P "$script_dir/.." && pwd)

: "${HOME:?HOME must be set}"
case "$HOME" in
  /*) ;;
  *) printf '%s\n' "Error: HOME must be an absolute path." >&2; exit 1 ;;
esac

codex_home=${CODEX_HOME:-"$HOME/.codex"}
case "$codex_home" in
  /*) ;;
  *) printf '%s\n' "Error: CODEX_HOME must be an absolute path." >&2; exit 1 ;;
esac

state_root="$codex_home/codex-skills-install"

die() {
  printf '%s\n' "Error: $*" >&2
  exit 1
}

path_exists() {
  [ -e "$1" ] || [ -L "$1" ]
}

same_content() (
  left=$1
  right=$2

  if [ -f "$left" ] && [ -f "$right" ]; then
    cmp -s "$left" "$right"
  elif [ -d "$left" ] && [ -d "$right" ]; then
    diff -qr "$left" "$right" >/dev/null 2>&1
  else
    return 1
  fi
)

copy_path() (
  source_path=$1
  target_path=$2

  if [ -d "$source_path" ]; then
    cp -R "$source_path" "$target_path"
  else
    cp "$source_path" "$target_path"
  fi
)

validate_component_name() (
  name=$1
  case "$name" in
    ""|.|..|*/*|*[!A-Za-z0-9._-]*) return 1 ;;
  esac
)

validate_component() {
  case "$1" in
    agents|templates) ;;
    *) return 1 ;;
  esac
}

component_state_dir() {
  validate_component "$1" || return 1
  printf '%s/%s\n' "$state_root" "$1"
}

validate_state_root() {
  path_exists "$state_root" || return 0
  [ -d "$state_root" ] || die "Installation state is not a directory: $state_root"
  [ ! -L "$state_root" ] || die "Installation state must not be a symbolic link: $state_root"

  for entry in "$state_root"/.[!.]* "$state_root"/..?* "$state_root"/*; do
    path_exists "$entry" || continue
    name=$(basename "$entry")
    case "$name" in
      agents|templates)
        [ -d "$entry" ] && [ ! -L "$entry" ] || die "Installation state entry is not a regular directory: $entry"
        ;;
      *)
        die "Unsupported installation state entry: $entry. Remove the previous installation before using component-scoped commands."
        ;;
    esac
  done
}

recorded_components() {
  validate_state_root
  for component in agents templates; do
    [ -d "$(component_state_dir "$component")" ] && printf '%s\n' "$component"
  done
  return 0
}

validate_managed_target() (
  kind=$1
  target=$2

  case "$kind" in
    agent)
      case "$target" in
        "$codex_home/agents/"*) name=${target#"$codex_home/agents/"} ;;
        *) return 1 ;;
      esac
      validate_component_name "$name" || return 1
      case "$name" in
        ?*.toml) ;;
        *) return 1 ;;
      esac
      ;;
    global-template)
      [ "$target" = "$codex_home/AGENTS.md" ] || return 1
      ;;
    project-template)
      [ "$target" = "$codex_home/templates/AGENTS.md" ] || return 1
      ;;
    *)
      return 1
      ;;
  esac
)

validate_manifest_entry() (
  kind=$1
  source_path=$2
  target_path=$3

  validate_managed_target "$kind" "$target_path" || return 1
  case "$kind" in
    agent)
      name=${target_path#"$codex_home/agents/"}
      [ "$source_path" = "$repo_root/agents/$name" ]
      ;;
    global-template)
      [ "$source_path" = "$repo_root/templates/AGENTS_global.md" ]
      ;;
    project-template)
      [ "$source_path" = "$repo_root/templates/AGENTS_project.md" ]
      ;;
  esac
)

validate_manifest_snapshot() (
  kind=$1
  target_path=$2
  snapshot=$3
  mode=$4
  component_state=$5

  if [ "$mode" = link ]; then
    [ "$snapshot" = - ]
    return
  fi
  [ "$mode" = copy ] || return 1

  case "$kind" in
    agent)
      name=${target_path#"$codex_home/agents/"}
      [ "$snapshot" = "$component_state/snapshot/agents/$name" ]
      ;;
    global-template)
      [ "$snapshot" = "$component_state/snapshot/templates/AGENTS_global.md" ]
      ;;
    project-template)
      [ "$snapshot" = "$component_state/snapshot/templates/AGENTS_project.md" ]
      ;;
  esac
)

write_component_plan() (
  component=$1
  output=$2
  : >"$output"

  case "$component" in
    agents)
      for source_path in "$repo_root"/agents/*.toml; do
        [ -f "$source_path" ] || continue
        name=$(basename "$source_path")
        validate_component_name "$name" || die "Invalid agent file name: $name"
        printf 'agents/%s|agent|%s|%s/agents/%s\n' "$name" "$source_path" "$codex_home" "$name" >>"$output"
      done
      ;;
    templates)
      [ -f "$repo_root/templates/AGENTS_global.md" ] || die "Missing templates/AGENTS_global.md"
      [ -f "$repo_root/templates/AGENTS_project.md" ] || die "Missing templates/AGENTS_project.md"
      printf 'templates/AGENTS_global.md|global-template|%s/templates/AGENTS_global.md|%s/AGENTS.md\n' "$repo_root" "$codex_home" >>"$output"
      printf 'templates/AGENTS_project.md|project-template|%s/templates/AGENTS_project.md|%s/templates/AGENTS.md\n' "$repo_root" "$codex_home" >>"$output"
      ;;
    *) die "Unknown component: $component" ;;
  esac

  [ -s "$output" ] || die "No files found for the $component component."
)

component_set_matches() (
  component=$1
  component_state=$2
  manifest=$3
  mode=$4
  plan=$(mktemp "${TMPDIR:-/tmp}/codex-skills-components.XXXXXX")
  expected=$(mktemp "${TMPDIR:-/tmp}/codex-skills-expected.XXXXXX")
  actual=$(mktemp "${TMPDIR:-/tmp}/codex-skills-actual.XXXXXX")
  trap 'rm -f "$plan" "$expected" "$actual"' 0 HUP INT TERM

  while IFS='|' read -r kind source_path target_path snapshot; do
    [ -n "$kind" ] || continue
    validate_manifest_entry "$kind" "$source_path" "$target_path" || return 1
    case "$component:$kind" in
      agents:agent|templates:global-template|templates:project-template) ;;
      *) return 1 ;;
    esac
    validate_manifest_snapshot "$kind" "$target_path" "$snapshot" "$mode" "$component_state" || return 1
    path_exists "$source_path" || return 1
  done <"$manifest"

  write_component_plan "$component" "$plan" || return 1
  cut -d '|' -f 2-4 "$plan" | LC_ALL=C sort >"$expected"
  cut -d '|' -f 1-3 "$manifest" | LC_ALL=C sort >"$actual"
  cmp -s "$expected" "$actual"
)
