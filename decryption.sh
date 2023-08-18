#!/usr/bin/env sh

set -euo pipefail

usage() {
  echo "Parameters Usage:  -s [source_dir] -d [destination_dir]"
  exit 1
}

source_dir=''
destination_dir=''

while getopts "s:d:" OPTIONS; do
    case $OPTIONS in
         s) source_dir=${OPTARG};;
         d) destination_dir=${OPTARG};;
        \?) usage;;
    esac
done

if [ -z $source_dir ];
then
    echo "ERROR: Source dir parameter is not set"
    usage
    exit 1
fi

if [ -z $destination_dir ];
then
    echo "ERROR: Destionation dir parameter is not set"
    usage
    exit 1
fi

if [ ! -f $source_dir ];
then
    echo "ERROR: Directory $source_dir doesn't seem to exist"
    usage
    exit 1
fi

source_name=$(basename "${source_dir}")
source_parent_dir=$(dirname "$(readlink -f "$source_dir")")

mkdir $destination_dir >/dev/null 2>&1 || true

destination_name=$(basename "${destination_dir}")
destination_parent_dir=$(dirname "$(readlink -f "$destination_dir")")

password=''
echo "Enter encryption password"
while IFS= read -r -s -n1 char; do
  [ -z $char ] && { printf '\n'; break; } # ENTER pressed; output \n and break.
  if [ $char == $'\x7f' ]; then # backspace was pressed
      # Remove last char from output variable.
      [ -n "$password" ] && password=${password%?}
      # Erase '*' to the left.
      printf '\b \b'
  else
    # Add typed char to output variable.
    password+=$char
    # Print '*' in its stead.
    printf '*'
  fi
done

cd $destination_name > /dev/null 2>&1
dir_name=$(openssl enc -aes-256-cbc -k $password -d -in $source_parent_dir/$source_name | tar -tz | head -1 | cut -f1 -d"/")
openssl enc -aes-256-cbc -k $password -d -in $source_parent_dir/$source_name | tar xz -C .
chmod 0700 $dir_name
cd - > /dev/null 2>&1

echo "$source_parent_dir/$source_name is decrypted in: $destination_name"
