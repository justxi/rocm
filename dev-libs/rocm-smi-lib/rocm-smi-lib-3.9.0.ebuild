# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils

DESCRIPTION="User space interface for applications to monitor and control GPU applications."
HOMEPAGE="https://github.com/RadeonOpenCompute/rocm_smi_lib"
SRC_URI="https://github.com/RadeonOpenCompute/rocm_smi_lib/archive/rocm-${PV}.tar.gz -> rocm-smi-lib-${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

PATCHES=(
	"${FILESDIR}/rocm-smi-lib-2.9.0-omit-git-output.patch"
	"${FILESDIR}/rocm-smi-lib-2.9.0-utils-no-repository.patch"
	"${FILESDIR}/rocm-smi-lib-3.9.0-change-smi-install-location.patch"
	"${FILESDIR}/rocm-smi-lib-3.7.0-change-oam-install-location.patch"
)

S="${WORKDIR}/rocm_smi_lib-rocm-${PV}"
