# Delete All Branches Except Main

This document describes how to delete all branches except the main branch from the FreeCAT repository.

## Current Branches to be Deleted

The following branches will be deleted:
1. copilot/build-appimage-occt-7-9-3
2. copilot/check-commit-status
3. copilot/clean-up-workflow-files
4. copilot/delete-all-branches-except-main
5. copilot/fix-action-job-issue
6. copilot/fix-build-failure-smesh-occt
7. copilot/fix-build-release-environment
8. copilot/update-appimage-packaging
9. copilot/update-ci-build-for-occt-7-9-3
10. copilot/update-occt-pin-version
11. copilot/update-occt-version-pin
12. copilot/update-pixi-lock-file
13. copilot/update-workflow-linux-appimage

## Methods to Delete Branches

### Method 1: GitHub Actions Workflow (Recommended)

A GitHub Actions workflow has been created at `.github/workflows/delete-branches.yml` that can be manually triggered to delete all branches except main.

**Steps:**
1. Go to the GitHub repository web interface
2. Navigate to "Actions" tab
3. Select "Delete All Branches Except Main" workflow from the left sidebar
4. Click "Run workflow" button
5. Type "DELETE ALL BRANCHES" in the confirmation field
6. Click "Run workflow" to execute

This workflow will:
- Fetch all remote branches
- Delete each branch except main
- Provide a summary of deleted branches

### Method 2: Shell Script

A shell script has been provided at `tools/delete-all-branches.sh` that can be run locally.

**Steps:**
1. Ensure you have push permissions to the repository
2. Run the script from the repository root:
   ```bash
   ./tools/delete-all-branches.sh
   ```
3. Review the list of branches to be deleted
4. Type "yes" to confirm the deletion

### Method 3: Manual Git Commands

If you prefer to delete branches manually, you can use the following commands:

```bash
# Delete a specific branch
git push origin --delete branch-name

# Delete all branches except main (one-liner)
git ls-remote --heads origin | grep -v 'refs/heads/main$' | awk '{print $2}' | sed 's|refs/heads/||' | xargs -I {} git push origin --delete {}
```

## Important Notes

⚠️ **Warning:** Deleting branches is a permanent operation and cannot be undone easily. Make sure you:
- Have reviewed all branches to be deleted
- Have merged any important changes to main
- Have created backups if needed
- Have the necessary permissions to delete branches

## Verification

After deletion, verify that only the main branch remains:

```bash
git ls-remote --heads origin
```

You should only see the main branch listed.
