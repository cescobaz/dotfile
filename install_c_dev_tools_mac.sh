#!/bin/bash

set -e

sudo port install ccls-clang-11

ln -s /opt/local/bin/clang-mp-11 /Users/cescobaz/.local/bin/clang
ln -s /opt/local/bin/clang-format-mp-11 /Users/cescobaz/.local/bin/clang-format
