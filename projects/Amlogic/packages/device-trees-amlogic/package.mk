# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-2018 Team LibreELEC (https://libreelec.tv)
# Copyright (C) 2018-present Team CoreELEC (https://coreelec.org)

PKG_NAME="device-trees-amlogic"
PKG_VERSION="f16d0406dfcfd2fd7a04fd0f00ce1880ff1f8863"
PKG_SHA256="c740f150b1f1bb4c2213b4829eceda7bc5c07ac6e864c921ea408385cf1e5b9b"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/CoreELEC/device-trees-amlogic"
PKG_URL="https://github.com/CoreELEC/device-trees-amlogic/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Device trees for Amlogic devices."
PKG_IS_KERNEL_PKG="yes"
PKG_TOOLCHAIN="manual"

make_target() {
  # Enter kernel directory
  pushd $BUILD/linux-$(kernel_version) > /dev/null

  # Device trees already present in kernel tree we want to include
  EXTRA_TREES=( \
                gxbb_p200 gxbb_p200_2G gxbb_p201 gxbb_p200_1G_wetek_hub gxbb_p200_2G_wetek_play_2 \
                gxl_p212_1g gxl_p212_2g gxl_p230_2g gxl_p281_1g gxm_q200_2g gxm_q201_1g gxm_q201_2g \
	      )

  # Add trees to the list
  for f in ${EXTRA_TREES[@]}; do
    DTB_LIST="$DTB_LIST $f.dtb"
  done

  # Copy all device trees to kernel source folder and create a list
  cp -f $PKG_BUILD/*.dts* arch/$TARGET_KERNEL_ARCH/boot/dts/amlogic/
  for f in $PKG_BUILD/*.dts; do
    DTB_NAME="$(basename $f .dts).dtb"
    DTB_LIST="$DTB_LIST $DTB_NAME"
  done

  # Compile device trees
  kernel_make $DTB_LIST
  cp arch/$TARGET_KERNEL_ARCH/boot/dts/amlogic/*.dtb $PKG_BUILD

  popd > /dev/null
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/share/bootloader/device_trees
  cp -a $PKG_BUILD/*.dtb $INSTALL/usr/share/bootloader/device_trees
}
