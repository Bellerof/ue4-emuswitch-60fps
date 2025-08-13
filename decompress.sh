#!/bin/bash
# Script to decompress zip archives inside their parent directories
# Usage: ./script.sh /path/to/search/directory

set -euo pipefail
IFS=$'\n\t'

ROOT_DIR="$1"

if [[ -z "$ROOT_DIR" ]]; then
    echo "Usage: $0 /path/to/root/directory"
    exit 1
fi

if [[ ! -d "$ROOT_DIR" ]]; then
    echo "Error: Directory '$ROOT_DIR' does not exist."
    exit 1
fi

export LC_ALL=C

find "$ROOT_DIR" -type f -name '*.zip' -print0 |
while IFS= read -r -d '' zip_file; do
    parent_dir=$(dirname "$zip_file")
    zip_name=$(basename "$zip_file")

    echo "Found: $zip_file"
    echo "Decompressing into: $parent_dir"

    if (cd "$parent_dir" && unzip -oq -- "$zip_name"); then
        echo "✓ Successfully decompressed: $zip_name"
        # Uncomment to remove after decompression
        # rm -f -- "$zip_file"
        # echo "✓ Removed original zip: $zip_name"
    else
        echo "✗ Error: Failed to decompress $zip_name" >&2
    fi

    echo "----------------------------------------"
done

echo "Decompression complete!"
