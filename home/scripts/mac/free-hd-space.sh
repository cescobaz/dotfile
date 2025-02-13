#!/bin/sh

set -x

rm -rf ~/.local/state/nvim/lsp.log

# du -sh ~/Library/Caches/* | sort -h

# https://docs.docker.com/engine/manage-resources/pruning/
# docker container prune
docker volume prune
docker image prune --all
# the following docker command prune really anything!
# https://apple.stackexchange.com/questions/391377/what-is-the-purpose-of-docker-raw-file-on-mac-os-catalina
# A lot of space is here
# /System/Volumes/Data/Users/buro/Library/Containers/com.docker.docker/Data
# docker system prune

# https://furbo.org/2022/11/09/managing-xcode-downloads/
# xcrun simctl runtime list
xcrun simctl delete unavailable
# use also Xcode -> settings -> platform -> delete useless simulators

# rm -rf $HOME/Library/Developer/Xcode/iOS\ DeviceSupport
# rm -rf $HOME/Library/Developer/Xcode/Archives/
# rm -rf $HOME/Library/Developer/Xcode/DerivedData/
# rm -rf $HOME/Library/Caches/*

brew autoremove
brew cleanup --prune=all
