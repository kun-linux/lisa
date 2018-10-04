#!/bin/bash

################################################################################
# Internal configurations
################################################################################
SCRIPT_DIR=$(dirname $(realpath -s $0))
BASE_DIR="$SCRIPT_DIR/.."
source "${BASE_DIR}/helpers"
source "${DEFINITIONS_PATH}"

DEFAULT_KERNEL="${KERNEL_SRC}/arch/${ARCH}/boot/${KERNEL_IMAGE}"
KERNEL="${KERNEL:-$DEFAULT_KERNEL}"


DEFAULT_DTB="${KERNEL_SRC}/arch/${ARCH}/boot/dts/${KERNEL_DTB}"
DTB="${DTB:-$DEFAULT_DTB}"

BOOT_IMAGE="${ARTIFACTS_PATH}/boot.img"

if ! [ -x "$(command -v abootimg)" ]; then
	c_error "abootimg is not available"
	c_warning "Please install abootimg and try again"
	exit $ENOENT
fi    

if [ ! -f ${KERNEL} ] ; then
	c_error "KERNEL image not found: ${KERNEL}"
	exit $ENOENT
fi

if [ ! -f ${DTB} ] ; then
	c_error "DTB not found: ${DTB}"
	exit $ENOENT
fi

if [ ! -f ${BOOT_IMAGE} ] ; then
	c_error "Boot image not found: ${BOOT_IMAGE}"
	c_warning "Please provide the boot.img to be updated"
	exit $ENOENT
fi

################################################################################
# Report configuration
################################################################################
echo
c_info "Update BOOT image:"
c_info "   $BOOT_IMAGE"
c_info "using this configuration :"
c_info "  KERNEL                 : $KERNEL"
c_info "  DTB                    : $DTB"

set -x
cat $KERNEL $DTB > ${ARTIFACTS_PATH}/Image.gz-dtb
abootimg -u "${BOOT_IMAGE}" -k ${ARTIFACTS_PATH}/Image.gz-dtb
set +x

