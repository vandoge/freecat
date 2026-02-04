#!/bin/bash

# Script to delete all branches except main from the FreeCAT repository
# This script will delete all remote branches except the main branch

set -e

echo "========================================"
echo "Delete All Branches Except Main"
echo "========================================"
echo ""

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Error: Not in a git repository"
    exit 1
fi

# Fetch all branches
echo "Fetching all branches..."
git fetch --all

# Get all remote branches except main
branches=$(git ls-remote --heads origin | grep -v 'refs/heads/main$' | awk '{print $2}' | sed 's|refs/heads/||')

# Count branches
branch_count=$(echo "$branches" | wc -l)

if [ -z "$branches" ]; then
    echo "No branches to delete. Only main branch exists."
    exit 0
fi

echo "Found $branch_count branches to delete:"
echo "$branches"
echo ""

# Ask for confirmation
echo "WARNING: This will permanently delete all branches except main!"
echo "Are you sure you want to continue? (yes/no)"
read -r confirmation

if [ "$confirmation" != "yes" ]; then
    echo "Operation cancelled."
    exit 0
fi

echo ""
echo "Deleting branches..."

# Delete each branch
deleted=0
failed=0

for branch in $branches; do
    echo -n "Deleting branch: $branch ... "
    if git push origin --delete "$branch" 2>/dev/null; then
        echo "✓ Deleted"
        ((deleted++))
    else
        echo "✗ Failed"
        ((failed++))
    fi
done

echo ""
echo "========================================"
echo "Summary:"
echo "  Successfully deleted: $deleted"
echo "  Failed: $failed"
echo "========================================"

# Show remaining branches
echo ""
echo "Remaining branches:"
git ls-remote --heads origin | awk '{print $2}' | sed 's|refs/heads/||'
