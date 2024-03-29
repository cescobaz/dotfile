#!/bin/sh

# du -sh ~/Library/Caches/* | sort -h

docker image prune --all

rm -rf $HOME/Library/Developer/Xcode/Archives
rm -rf $HOME/Library/Caches/*

brew autoremove
brew cleanup --prune=all
brew cleanup -s
