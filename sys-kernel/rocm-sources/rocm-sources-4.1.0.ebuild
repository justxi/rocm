# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="ROCm kernel sources"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver"
SRC_URI="https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/archive/rocm-${PV}.tar.gz -> rocm-sources-${PV}.tar.gz"

LICENSE=""
SLOT="4.1.0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

KERNEL_VERSION="5.9.0-rc2"

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}/ROCK-Kernel-Driver-rocm-${PV}" "${WORKDIR}/linux-${KERNEL_VERSION}_roc${SLOT}"
}

src_compile() {
	einfo "Nothing to compile..."
}

src_install() {
	dodir "/usr/src/"
	insinto "/usr/src/"
	doins -r "${WORKDIR}/linux-${KERNEL_VERSION}_roc${SLOT}" || die "Install failed!"
}


