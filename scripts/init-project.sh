#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -P "$(dirname "$0")" && pwd)
. "$script_dir/common.sh"

if [ "$#" -ne 1 ]; then
  printf '%s\n' "Usage: init-project.sh <project-directory>" >&2
  exit 1
fi

project_dir=$1
[ -d "$project_dir" ] || die "Project directory does not exist: $project_dir"
project_dir=$(CDPATH= cd -P "$project_dir" && pwd)
target="$project_dir/AGENTS.md"

[ ! -e "$target" ] && [ ! -L "$target" ] || die "Refusing to overwrite existing $target"
cp "$repo_root/templates/AGENTS_project.md" "$target"
printf '%s\n' "Created $target. Customize its placeholders from repository evidence."
