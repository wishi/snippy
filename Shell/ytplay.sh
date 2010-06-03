#! /usr/bin/zsh


cclive -f mp4 --stream-exec="mplayer -really-quiet %i" --stream=20 $argv[1]
