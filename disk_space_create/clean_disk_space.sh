#!/bin/bash
# command to execute
# sh /Users/mrudula/AndroidStudioProjects/landandplot/disk_space_create/clean_disk_space.sh

echo "Cleaning Xcode DerivedData..."
sudo rm -rf ~/Library/Developer/Xcode/DerivedData/*

echo "Deleting unused simulators..."
xcrun simctl delete unavailable

echo "Cleaning system caches..."
sudo rm -rf ~/Library/Caches/*
sudo rm -rf /Library/Caches/*

echo "Changing ownership and permissions for Developer directory..."
sudo chown -R $(whoami):staff ~/Library/Developer
sudo chmod -R u+rw ~/Library/Developer

echo "Cleaning CoreSimulator directories..."
sudo rm -rf ~/Library/Developer/CoreSimulator/Caches/*
sudo rm -rf ~/Library/Developer/CoreSimulator/Devices/*

echo "Cleaning Flutter project..."
cd /Users/mrudula/androidstudioprojects/landandplot
flutter clean

echo "Getting Flutter packages..."
flutter pub get

echo "All cleaning tasks completed successfully!"
