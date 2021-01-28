#!/usr/bin/env bash
source "$(dirname "$0")"/include.sh
#-# SLUGIFY
#-# creating slugs from sentences, urls, accents, ...


notify() {
  # $1 = title
  # $2 = text
  title="$1"
  [[ -z "$title" ]] && title="$(basename "$0" .sh)"
  if [[ -n $(which osascript) ]] ; then
    # MacOs uses osascript
    osa_commands="display notification \"${2:-}\" with title \"$title\" sound name \"Submarine\""
    osascript -e "$osa_commands"
    sleep 1
  fi
  if [[ -n $(which notify-send) ]] ; then
    notify-send "$title" "$2"
    sleep 1
  fi
}


notify "Title" "Text"
notify "Just The Title"
notify ""