#!/bin/bash
# SPDX-License-Identifier: LGPL-2.1-or-later
# ***************************************************************************
# *                                                                         *
# *   Copyright (c) 2026 FreeCAD Project.                                  *
# *                                                                         *
# *   This file is part of FreeCAD.                                         *
# *                                                                         *
# *   FreeCAD is free software: you can redistribute it and/or modify it    *
# *   under the terms of the GNU Lesser General Public License as           *
# *   published by the Free Software Foundation, either version 2.1 of the  *
# *   License, or (at your option) any later version.                       *
# *                                                                         *
# *   FreeCAD is distributed in the hope that it will be useful, but        *
# *   WITHOUT ANY WARRANTY; without even the implied warranty of            *
# *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU      *
# *   Lesser General Public License for more details.                       *
# *                                                                         *
# *   You should have received a copy of the GNU Lesser General Public      *
# *   License along with FreeCAD. If not, see                               *
# *   <https://www.gnu.org/licenses/>.                                      *
# *                                                                         *
# ***************************************************************************

# Script to update pixi lock files
# 
# This script ensures that pixi.lock files are synchronized with their
# corresponding pixi.toml manifest files. When the manifest changes
# (e.g., adding/updating dependencies), the lock file needs to be
# regenerated to reflect these changes.
#
# Usage:
#   .github/scripts/update_pixi_lock.sh
#
# The script will:
#   1. Check the root pixi.toml and update pixi.lock if needed
#   2. Check package/rattler-build/pixi.toml and update its pixi.lock if needed
#   3. Exit with an error if pixi is not installed or if the update fails
#
# Note: This script is automatically run in CI workflows when pixi commands
# are executed to ensure lock files are always up-to-date.

set -e

echo "Updating pixi lock files..."

# Update root pixi.lock if pixi.toml exists
if [ -f "pixi.toml" ]; then
    echo "Updating root pixi.lock..."
    pixi install --locked || {
        echo "Lock file out of sync, regenerating..."
        pixi install
    }
fi

# Update package/rattler-build pixi.lock if pixi.toml exists
if [ -f "package/rattler-build/pixi.toml" ]; then
    echo "Updating package/rattler-build/pixi.lock..."
    cd package/rattler-build
    pixi install --locked || {
        echo "Lock file out of sync, regenerating..."
        pixi install
    }
    cd ../..
fi

echo "Pixi lock files updated successfully!"
