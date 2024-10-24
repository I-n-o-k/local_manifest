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
rm -rf kernel/xiaomi/sm6150
git clone https://github.com/crdroidandroid/android_kernel_xiaomi_courbet kernel/xiaomi/sm6150
cp kernel/xiaomi/sm6150/arch/arm64/configs/courbet_defconfig kernel/xiaomi/sm6150/arch/arm64/configs/vendor/courbet.config
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
