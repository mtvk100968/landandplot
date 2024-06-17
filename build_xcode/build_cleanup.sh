#!/bin/bash

PROJECT_ROOT="/Users/mrudula/AndroidStudioProjects/landandplot"

# Create a RAM disk for DerivedData
diskutil erasevolume HFS+ 'XcodeRAMDisk' `hdiutil attach -nomount ram://$((2 * 1024 * 1024))`
mkdir -p /Volumes/XcodeRAMDisk/DerivedData
defaults write com.apple.dt.Xcode IDECustomDerivedDataLocation -string "/Volumes/XcodeRAMDisk/DerivedData"

IOS_DIR="$PROJECT_ROOT/ios"
cd "$IOS_DIR"

# Remove existing Pods and Podfile.lock
rm -rf Pods Podfile.lock

# Clean derived data
rm -rf ~/Library/Developer/Xcode/DerivedData

# Ensure you have the latest version of CocoaPods
sudo gem install cocoapods

## Install the pods again:
#pod install --repo-update

# Reinstall Pods
pod install --repo-update

# Open the Xcode workspace
open "$IOS_DIR/Runner.xcworkspace"

# Wait for a few seconds
sleep 10

# List available devices
xcrun simctl list devices

# Prompt user to select a device
echo "Enter the device ID to use for the build (e.g., 'iPhone-11, iOS 14.5'): "
read DEVICE_ID

# Clean build folder
xcodebuild clean -workspace "$IOS_DIR/Runner.xcworkspace" -scheme Runner -configuration Debug

# Enable concurrent builds and parallelize build
defaults write com.apple.dt.Xcode IDEBuildOperationMaxNumberOfConcurrentCompileTasks `sysctl -n hw.ncpu`

# Build the project
xcodebuild build -workspace "$IOS_DIR/Runner.xcworkspace" -scheme Runner -configuration Debug

echo "Build process completed."
