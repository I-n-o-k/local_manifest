#!/bin/bash

rm -rf .repo/local_manifests/

# Local manifests
git clone https://github.com/I-n-o-k/local_manifest -b main .repo/local_manifests
echo "============================"
echo "Local manifest clone success"
echo "============================"

# Sync
/opt/crave/resync.sh
echo "============="
echo "Sync success"
echo "============="

# Export
export BUILD_USERNAME=I-n-o-k
export BUILD_HOSTNAME=crave
echo "======= Export Done ======"

# Set up build environment
source build/envsetup.sh
echo "====== Envsetup Done ======="

# Lunch
riseup courbet userdebug
echo "============="

# Make cleaninstall
make installclean
echo "============="

# Build rom
rise b
