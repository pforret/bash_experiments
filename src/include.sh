#!/usr/bin/env bash

col_reset="\e[0m"
col_red="\e[1;31m"
col_grn="\e[1;32m"
col_ylw="\e[1;33m"
char_succ="✔"
char_fail="✖"
char_alrt="➨"
char_wait="…"

stderr(){
  echo -e "${col_ylw}$char_succ $* ${col_reset}" >&2
}

success(){
  echo -e "${col_grn}$char_wait $* ${col_reset}"
}

fail(){
  echo -e "${col_red}$char_fail $* ${col_reset}"
}
