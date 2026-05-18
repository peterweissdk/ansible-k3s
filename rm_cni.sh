#!/bin/bash

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "Error: This script must be run as root."
   exit 1
fi

SCRIPT_NAME=$(basename "$0")

echo "Searching for files containing 'calico', 'flannel', or 'cilium' (excluding /run and this script)..."

# 1. -not -path "/run/*" skips the run directory
# 2. -not -name "$SCRIPT_NAME" skips the script itself
# 3. Uses -name with \( ... -o ... \) to search for multiple CNI patterns in one pass
mapfile -t CNI_FILES < <(find / \
    -not -path "/run/*" \
    -not -name "$SCRIPT_NAME" \
    \( -name "*calico*" -o -name "*flannel*" -o -name "*cilium*" \) 2>/dev/null)

if [ ${#CNI_FILES[@]} -eq 0 ]; then
    echo "No files found."
    exit 0
fi

# List files with numbers
echo "--- Found Files ---"
for i in "${!CNI_FILES[@]}"; do
    printf "[%d] %s\n" "$((i+1))" "${CNI_FILES[$i]}"
done
echo "-------------------"

echo "Options:"
echo " (a)      - Delete ALL files listed above"
echo " (1,3,5)  - Exclude specific numbers (comma separated)"
echo " (e)      - EXIT (No action)"
echo ""
read -p "Your choice: " USER_INPUT

if [[ "$USER_INPUT" == "e" ]]; then
    echo "Exiting."
    exit 0
fi

EXCLUDES=()
if [[ "$USER_INPUT" == "a" ]]; then
    read -p "Are you sure you want to delete ALL ${#CNI_FILES[@]} files? (y/n): " CONFIRM
    [[ "$CONFIRM" != "y" ]] && echo "Aborted." && exit 0
else
    # Parse comma separated numbers
    IFS=',' read -r -a EXCLUDES <<< "$USER_INPUT"
fi

echo "Processing..."
for i in "${!CNI_FILES[@]}"; do
    FILE_NUM=$((i+1))
    
    # Check if current number is in the exclusion list
    SKIP=false
    for EX in "${EXCLUDES[@]}"; do
        if [[ "${EX// /}" == "$FILE_NUM" ]]; then
            SKIP=true
            break
        fi
    done

    if [ "$SKIP" = true ]; then
        echo "Skipping [$FILE_NUM]: ${CNI_FILES[$i]}"
    else
        # Using -v to show exactly what is happening during removal
        rm -rfv "${CNI_FILES[$i]}"
    fi
done

echo "Cleanup complete."