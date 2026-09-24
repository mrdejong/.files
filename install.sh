#!/usr/bin/env bash
shopt -s nullglob

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
search_dir="$script_dir/artifects"
destination="$HOME"

link() {
  local path=$1 dest=$2
  printf "Installing %s\n" "$path"

  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$path" ]; then
    echo "-> Already linked, skipping."
    return
  fi

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    local backup
    backup="${dest}.backup.$(date +%s)"
    echo "-> Backing up $dest to $backup"
    mv "$dest" "$backup"
  fi

  mkdir -p "$(dirname "$dest")"
  ln -s "$path" "$dest"
  echo "-> Linked $dest -> $path"
  echo
}

echo "Installing .files"
echo
for entry in "$search_dir"/*; do
  if [ -d "$entry" ]; then
    for sub in "$entry"/*; do
      link "$sub" "$destination/.${entry##*/}/${sub##*/}"
    done
  else
    link "$entry" "$destination/.${entry##*/}"
  fi
done

echo "All done"
