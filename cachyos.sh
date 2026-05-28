#!/bin/bash

# Configuration
URL="https://mirror.cachyos.org/repo/x86_64/cachyos/"
DEST="/home/erik/EDU/nemesis_repo/x86_64/"
PACKAGES=("chwd")

# Function to extract version string (strip "${pkg}-" prefix and "-x86_64.pkg.tar.zst" / "-any.pkg.tar.zst" suffix)
get_version() {
    local pkg="$1" file="$2"
    file="${file##*/}"
    file="${file#${pkg}-}"
    file="${file%-x86_64.pkg.tar.zst}"
    file="${file%-any.pkg.tar.zst}"
    echo "$file"
}

# Get remote package list
remote_list=$(curl -s "$URL" | grep -oP 'href="[^"]*\.pkg\.tar\.zst"' | cut -d'"' -f2)

# Process each target package
for pkg in "${PACKAGES[@]}"; do
    # Get latest remote file
    remote_file=$(echo "$remote_list" | grep "^${pkg}-[0-9].*\.pkg\.tar\.zst" | sort -Vr | head -n1)
    [[ -z "$remote_file" ]] && echo "No remote version found for $pkg" && continue

    # Get latest local file
    local_file=$(find "$DEST" -maxdepth 1 -type f \( -name "${pkg}-[0-9]*-x86_64.pkg.tar.zst" -o -name "${pkg}-[0-9]*-any.pkg.tar.zst" \) | sort -Vr | head -n1)

    remote_version=$(get_version "$pkg" "$remote_file")
    local_version=$(get_version "$pkg" "$local_file")

    if [[ "$remote_version" != "$local_version" ]]; then
        echo "Updating $pkg: ${local_version:-<missing>} → $remote_version"
        curl -o "${DEST}${remote_file}" "$URL/$remote_file"
        # Remove stale local copy if there was one and it's a different file
        if [[ -n "$local_file" && "$(basename "$local_file")" != "$remote_file" ]]; then
            rm -v "$local_file"
        fi
    else
        echo "$pkg is up to date: $local_version"
    fi
done
