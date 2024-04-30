#!/bin/bash

# Define your branches here

branches=("main")

# Directory of your project
project_dir="/Users/mrudula/AndroidStudioProjects/landandplot/"

# Source branch with the code to copy

source_branch="project_running"

cd "$project_dir"

# Stashing any uncommitted changes
git stash

# Check if the source_branch has an upstream set
if git rev-parse --verify --quiet $source_branch@{u}; then
    git checkout $source_branch
    git pull
else
    echo "No tracking information for $source_branch. Please set upstream before pulling."
fi

# Copy changes to each branch
for branch in "${branches[@]}"; do
    git checkout $branch
    if git merge $source_branch; then
        echo "Merged $source_branch into $branch successfully."
        # Uncomment the line below if you want to push after confirming successful merge
        # git push --set-upstream origin $branch
    else
        echo "Merge failed. Please resolve conflicts in $branch, then commit and push manually."
    fi
done

# Return to the source branch and apply stashed changes
git checkout $source_branch
git stash pop
