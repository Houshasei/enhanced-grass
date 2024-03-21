#!/bin/bash

LOCAL_DIR=$(pwd)
GITHUB_REPO=https://github.com/Houshasei/enhanced-grass
APP_NAME=enhanced-grass

# Make sure to change directory to the working app
cd "$LOCAL_DIR" || exit

# Pull from the main branch of the app
git pull origin main

# Update dependencies if necessary
npm install
