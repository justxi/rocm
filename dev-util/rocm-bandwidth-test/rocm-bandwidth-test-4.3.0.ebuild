# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake

DESCRIPTION="Capture the performance characteristics of buffer copying and kernel read/write operations"
HOMEPAGE="https://github.com/RadeonOpenCompute/rocm_bandwidth_test"
SRC_URI="https://github.com/RadeonOpenCompute/rocm_bandwidth_test/archive/rocm-${PV}.tar.gz -> rocm-bandwidth-test-${PV}.tar.gz"

LICENSE="NCSA"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="dev-libs/rocr-runtime"

PATCHES=(
	"${FILESDIR}/rocm-bandwidth-test-4.3-using_delete_operator.patch"
)

S="${WORKDIR}/rocm_bandwidth_test-rocm-${PV}"


