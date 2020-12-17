#!/bin/sh
set -eu
for p in "$@"; do
    if /usr/sbin/zpool scrub -s "$p" 2>/dev/null; then
        echo "Canceled running scrub on ZFS pool '$p'"
    fi
    /usr/sbin/zpool scrub "$p"
    echo "Started scrub on ZFS pool '$p'"
done
