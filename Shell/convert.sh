#!/bin/zsh

# to convert tinyfied urls into URLs
curl -I $argv[1] 2>&1 | grep Location
