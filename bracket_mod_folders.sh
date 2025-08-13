#!/bin/bash
# Script to rename parent folders of directories named "exefs", "romfs", or "cheats"
# Usage: ./script.sh /path/to/search/directory

# Check if root directory is provided
ROOT_DIR="$1"
if [[ -z "$ROOT_DIR" ]]; then
    echo "Usage: $0 /path/to/root/directory"
    echo "This script will find all folders named 'exefs', 'romfs', or 'cheats' and rename their parent directories to [FOLDER_NAME]."
    exit 1
fi

# Check if root directory exists
if [[ ! -d "$ROOT_DIR" ]]; then
    echo "Error: Directory '$ROOT_DIR' does not exist."
    exit 1
fi

# Find all directories named "exefs", "romfs", or "cheats" and process their parents
find "$ROOT_DIR" -type d \( -name "exefs" -o -name "romfs" -o -name "cheats" \) -print0 | while IFS= read -r -d '' target_dir; do
    # Get the parent directory
    parent_dir=$(dirname "$target_dir")
    parent_name=$(basename "$parent_dir")
    
    # Skip if parent is the root directory itself
    if [[ "$parent_dir" == "$ROOT_DIR" ]]; then
        echo "Skipping: $target_dir (parent is root directory)"
        continue
    fi
    
    # Check if parent directory name already has brackets
    if [[ "$parent_name" =~ ^\[.*\]$ ]]; then
        echo "Skipping: $parent_name (already has brackets)"
        continue
    fi
    
    # Get the directory where the parent folder is located
    parent_parent_dir=$(dirname "$parent_dir")
    
    # Create new name with brackets
    new_name="[$parent_name]"
    new_path="$parent_parent_dir/$new_name"
    
    # Skip if target name already exists
    if [[ -e "$new_path" ]]; then
        echo "Skipping: $parent_name (target [$parent_name] already exists)"
        continue
    fi
    
    echo "Found: $target_dir"
    echo "Renaming parent: $parent_name -> [$parent_name]"
    
    # Rename the parent directory
    if mv "$parent_dir" "$new_path" 2>/dev/null; then
        echo "✓ Successfully renamed: $parent_name -> [$parent_name]"
    else
        echo "✗ Error: Failed to rename $parent_name"
    fi
    
    echo "----------------------------------------"
done

echo "Rename operation complete!"