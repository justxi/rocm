EAPI=7
inherit cmake-utils

DESCRIPTION="Capture the performance characteristics of buffer copying and kernel read/write operations"
HOMEPAGE="https://github.com/RadeonOpenCompute/rocm_bandwidth_test"
SRC_URI="https://github.com/RadeonOpenCompute/rocm_bandwidth_test/archive/rocm-${PV}.tar.gz -> rocm-bandwidth-test-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="amd64"
IUSE=""

DEPEND=""
RDEPEND=">=dev-libs/rocr-runtime-${PV}"

S="${WORKDIR}/rocm_bandwidth_test-rocm-${PV}"
