#!/bin/sh

set -ex

if type "podman" >/dev/null; then
  container_runner=podman
else
  container_runner=docker
fi

$container_runner start postgresql

# Use Chrome for this session only; system default stays Firefox.
# BROWSER covers CLI tools (gh, python webbrowser...), open_url_with
# covers links clicked in kitty, andromedai-bin/xdg-open covers tools
# that call xdg-open directly.
# Resolve the repo scripts dir through the ~/.local/bin/buro-* symlink.
scripts_dir=$(dirname "$(readlink -f "$0")")
chrome="$scripts_dir/linux/google-chrome.sh"
export BROWSER="$chrome"
export PATH="$scripts_dir/andromedai-bin:$PATH"

kitty -o open_url_with="$chrome" --session andromedai
