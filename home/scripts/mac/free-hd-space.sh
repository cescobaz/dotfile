#!/bin/sh

# du -sh ~/Library/Caches/* | sort -h

docker image prune --all
# docker system prune

# https://furbo.org/2022/11/09/managing-xcode-downloads/
# xcrun simctl runtime list
xcrun simctl delete unavailable
# use also Xcode -> settings -> platform -> delete useless simulators

rm -rf $HOME/Library/Developer/Xcode/Archives/
rm -rf $HOME/Library/Developer/Xcode/DerivedData/
rm -rf $HOME/Library/Caches/*

brew autoremove
brew cleanup --prune=all
brew cleanup -s
