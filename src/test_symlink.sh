#!/usr/bin/env bash
source "$(dirname "$0")"/include.sh
#-# SYMLINK RESOLUTION
#-# experiments in resolving symbolic links

resolve_symlink(){
  script_install_path="$1"
  stderr "Input: $script_install_path"
  script_install_folder="$(cd -P "$(dirname "$script_install_path")" >/dev/null 2>&1 && pwd)"
   stderr "Folder: $script_install_folder"
  while [ -h "$script_install_path" ]; do
    # resolve symbolic links
    script_install_path="$(readlink "$script_install_path")"
   stderr "Linked to: $script_install_path"
   script_install_folder="$(cd -P "$(dirname "$script_install_path")" >/dev/null 2>&1 && pwd)"
   stderr "Folder: $script_install_folder"
    [[ "$script_install_path" != /* ]] && script_install_path="$script_install_folder/$(basename "$script_install_path")"
   stderr "Resolved: $script_install_path"
  done
  echo "$script_install_path"
}

recursive_readlink(){
  [[ ! -h "$1" ]] && echo "$1" && return 0
  local file_folder
  local link_folder
  local link_name
  file_folder="$(dirname "$1")"
  local  symlink
  symlink=$(readlink "$1")
  link_folder=$(dirname "$symlink")
  link_name=$(basename "$symlink")
  [[ -z "$link_folder" ]] && link_folder="$file_folder"
  [[ "$link_folder" = \.* ]] && link_folder="$(cd -P "$file_folder" && cd -P "$link_folder" >/dev/null 2>&1 && pwd)"
  #stderr "Symbolic link: $1 -> $symlink -> $link_folder/$link_name"
  recursive_readlink "$link_folder/$link_name"
}

resolve_symlink_recursive(){
  # $1 = input

  local filepath="$1"
  local folder
  local filename
  folder=$(dirname "$filepath")
  filename=$(basename "$filepath")
  [[ -z "$folder" ]] && folder="."
  folder="$(cd -P "$folder" >/dev/null 2>&1 && pwd)"
  resolved="$folder/$filename"
  if [[ ! -f "$resolved" ]] ; then
    echo "$resolved"
    return 0
  fi
  if [[ -h "$resolved" ]] ; then
    symlink=$(readlink "$resolved")
  fi
  script_install_path="$1"
  stderr "Input: $script_install_path"
  script_install_folder="$(cd -P "$(dirname "$script_install_path")" >/dev/null 2>&1 && pwd)"
   stderr "Folder: $script_install_folder"
  while [ -h "$script_install_path" ]; do
    # resolve symbolic links
    script_install_path="$(readlink "$script_install_path")"
   stderr "Linked to: $script_install_path"
   script_install_folder="$(cd -P "$(dirname "$script_install_path")" >/dev/null 2>&1 && pwd)"
   stderr "Folder: $script_install_folder"
    [[ "$script_install_path" != /* ]] && script_install_path="$script_install_folder/$(basename "$script_install_path")"
   stderr "Resolved: $script_install_path"
  done
  echo "$script_install_path"
}

check_results(){
  #$1 = input
  #$2 = expected result
  result=$(resolve_symlink2 "$1")
  if [[ "$2" == "$result" ]] ; then
    success "$1 -> $2"
  else
    fail "$1 -> $result <> $2"
  fi
}


test_basher_note(){
  assert_equals "/Users/pforret/.basher/cellar/packages/pforret/note/note.sh" $(recursive_readlink ~/.basher/cellar/bin/note)
}
test_basher_idea(){
  assert_equals "/Users/pforret/.basher/cellar/packages/pforret/note/note.sh" $(recursive_readlink ~/.basher/cellar/bin/idea)
}
test_bin_sha1sum(){
  assert_equals "/usr/local/Cellar/coreutils/8.32/bin/gsha1sum" $(recursive_readlink /usr/local/bin/sha1sum)
}
