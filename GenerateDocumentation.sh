#!/bin/bash
cd "${0%/*}"
cd BLT
echo "Setting Ruby Enviroment"
eval "$(rbenv init -)"
echo "Starting Jazzy"
jazzy
