#!/bin/bash
#
# hide.sh is a bash program to easily hide value of environment variables in
# log file.
#
# Copyright (c) 2018 FX Soubirou
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

VERSION=0.1.0
MASK="**HIDDEN**"
HIDDEN_COUNT=0
VARIABLE_INDEX=0

function check_file() {
  if [[ ! -f "$1" ]] ; then
      echo "File \"$1\" does not exist, aborting."
      exit 1
  fi
}

function init_count() {
  count=$(grep -o "$MASK" "$1" | wc -l)
  HIDDEN_COUNT=$count
}

function display_count() {
  count=$(grep -o "$MASK" "$1" | wc -l)
  delta=$((count - HIDDEN_COUNT))
  echo "Hidden variables [$VARIABLE_INDEX]: $delta matches"
  HIDDEN_COUNT=$count
  (( VARIABLE_INDEX++ ))
}

function mask_value() {
  to_mask_escaped="${1//\//\\/}"
  sed -i -e s/"$to_mask_escaped"/"$MASK"/g "$2"
  display_count "$2"
}

function version() {
  echo "hide.sh, version $VERSION"
  echo "Copyright (C) 2018 FX Soubirou"
  echo "License GPLv3+ : GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>"
}

while getopts m:v option
do
 case "${option}" in
   m)
     check_file "${@: -1}"
     init_count "${@: -1}"
     mask_value "${OPTARG}" "${@: -1}"
     exit 0
     ;;
   v)
     version
     ;;
   *)
     echo "hide.sh usage:"
     exit 1
     ;;
 esac
done
