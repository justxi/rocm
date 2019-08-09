# Copyright
#

EAPI=6
inherit cmake-utils git-r3

DESCRIPTION="Capture the performance characteristics of buffer copying and kernel read/write operations"
HOMEPAGE="https://github.com/RadeonOpenCompute/rocm_bandwidth_test"
EGIT_REPO_URI="https://github.com/RadeonOpenCompute/rocm_bandwidth_test"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="dev-libs/rocr-runtime"

PATCHES=(
        "${FILESDIR}/add_return.patch"
)
