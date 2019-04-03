#!/bin/bash
# This script resets the repo to prepare for rebuild

git clean -df
git reset --hard HEAD
git pull
git reset --hard HEAD
chmod +x start.sh