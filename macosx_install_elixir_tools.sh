#!/bin/bash

REF=$(realpath $(dirname $0))

git clone https://github.com/JakeBecker/elixir-ls.git
cd elixir-ls
mix deps.get
mix compile
mix elixir_ls.release -o $HOME/.elixir-ls

cd "$REF"
rm -rf elixir-ls
