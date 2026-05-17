#!/bin/bash

# Configuration
URL="https://chaoticmirror.com/chaotic-aur/chaotic-aur/x86_64/"
DEST="/home/erik/DATA/EDU/nemesis_repo/x86_64/"
PACKAGES=("chaotic-keyring" "chaotic-mirrorlist")

# Function to extract version string (excluding .pkg.tar.zst)
get_version() {
    echo "$1" | sed -E 's/^.*-([0-9]{8,})-[0-9]+-any\.pkg\.tar\.zst$/\1/'
}

# Get remote package list
remote_list=$(curl -s "$URL" | grep -oP 'href="[^"]*\.pkg\.tar\.zst"' | cut -d'"' -f2)

# Process each target package
for pkg in "${PACKAGES[@]}"; do
    # Get latest remote file
    remote_file=$(echo "$remote_list" | grep "^${pkg}-.*-any\.pkg\.tar\.zst" | sort -Vr | head -n1)
    [[ -z "$remote_file" ]] && echo "No remote version found for $pkg" && continue

    # Get latest local file
    local_file=$(find "$DEST" -maxdepth 1 -type f -name "${pkg}-*-any.pkg.tar.zst" | sort -Vr | head -n1)
    
    remote_version=$(get_version "$remote_file")
    local_version=$(get_version "$local_file")

    if [[ "$remote_version" != "$local_version" ]]; then
        echo "Updating $pkg: $local_version → $remote_version"
        curl -O "$URL/$remote_file"
    else
        echo "$pkg is up to date: $local_version"
    fi
done
