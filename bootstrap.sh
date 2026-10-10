#!/bin/sh
# Sake - Minimalist build system written in GNU Guile.
# Copyright (C) 2026 shad1k1
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Bootstrap script for Sake (Guile implementation)
# Strict adherence to POSIX shell standards

set -e

echo "[SAKE BOOTSTRAP] Initializing build environment..."

if ! command -v guile >/dev/null 2>&1; then
    echo "[ERROR] GNU Guile is required but not installed." >&2
    exit 1
fi

if [ ! -f "sakefile.scm" ]; then
    echo "[ERROR] sakefile.scm not found in current directory." >&2
    exit 1
fi

echo "[SAKE BOOTSTRAP] Compiling and running Sake via Guile..."

guile --no-auto-compile -s sake.scm "$@"

echo "[SAKE BOOTSTRAP] Done successfully!"
