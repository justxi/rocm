# Copyright
#

EAPI=6
inherit cmake-utils

DESCRIPTION="Capture the performance characteristics of buffer copying and kernel read/write operations"
HOMEPAGE="https://github.com/RadeonOpenCompute/rocm_bandwidth_test"
SRC_URI="https://github.com/RadeonOpenCompute/rocm_bandwidth_test/archive/roc-${PV}.tar.gz -> rocm-bandwidth-test-${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="dev-libs/rocr-runtime"

S="${WORKDIR}/rocm_bandwidth_test-roc-${PV}"
