#!/usr/bin/env bash

if [[ -f "README.md" ]] ; then
(
  cat INTRO.md
  for script in src/test*.sh ; do
    echo "$script" >&2
      echo "### $(basename "$script")"
      echo " "
      grep '#-#' "$script" | sed 's/#-#/* /'
      echo " "
  done
) > README.md
fi
