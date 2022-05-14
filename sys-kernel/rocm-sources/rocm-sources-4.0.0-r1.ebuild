# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# kernel-2 eclass related...
ETYPE=sources
K_USEPV=1
K_SECURITY_UNSUPPORTED=1
K_WANT_GENPATCHES=0
EXTRAVERSION="-rocm${SLOT}"
CKV="5.6.0"
# CKV populated with kernel version in tarball root directory Makefile at top.

inherit kernel-2
detect_version
detect_arch

# Ebuild information...
DESCRIPTION="ROCm kernel sources"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver"
SRC_URI="https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64"
LICENSE=""
IUSE=""

src_unpack() {
	unpack "${A}"
	mv "${WORKDIR}/ROCK-Kernel-Driver-rocm-${PV}" "${WORKDIR}/linux-${KV_FULL}"
	unpack_set_extraversion
}
