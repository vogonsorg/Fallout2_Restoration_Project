#!/bin/bash

set -xeu -o pipefail

mpack_file="modderspack_$mpack_version.7z"
mpack_url="https://sourceforge.net/projects/sfall/files/Modders%20pack/$mpack_file/download"
compile_exe="compile.exe"
mpack_compile="ScriptEditor/resources/$compile_exe"

sfse_url="http://www.nma-fallout.com/resources/sfall-script-editor.77/download?version=181"
sfse_file="sfse.rar"
sfse_dir="Fallout sFall Script Editor/Resources"

# directories
cache_dir="$HOME/.cache/build"
bin_dir="extra/bin"
mkdir -p "$cache_dir" "$bin_dir"

# packages
curl -s https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add
sudo apt-add-repository -y 'deb https://dl.winehq.org/wine-builds/ubuntu/ xenial main'
sudo apt-get -q update
sudo apt-get -q -y --no-install-recommends install winehq-stable p7zip p7zip-full unrar

# compile.exe, check cache
if [[ ! -f "$cache_dir/$compile_exe" ]]; then
  wget -q "$mpack_url" -O mpack.7z
  7z e mpack.7z "$mpack_compile"
  mv -f "$compile_exe" "$cache_dir/"
fi
# copy
cp -f "$cache_dir/$compile_exe" "$bin_dir/"

# wcc, check cache
if [[ ! -f "$cache_dir/wcc386.exe" || ! -f "$cache_dir/wccd386.dll" ]]; then
  wget -q "$sfse_url" -O "$sfse_file"
  for f in wcc386.exe wccd386.dll; do
    unrar e "$sfse_file" "$sfse_dir/$f"
    mv -f "$f" "$cache_dir/"
  done
fi
# copy
for f in wcc386.exe wccd386.dll; do
  cp -f "$cache_dir/$f" "$bin_dir/"
done