#

EAPI=7

inherit cmake-utils

DESCRIPTION="Sparse linear algebra library"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocALUTION"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocALUTION/archive/rocm-$(ver_cut 1-2).tar.gz -> rocALUTION-$(ver_cut 1-2).tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE="+openmp mpi hip"

RDEPEND="hip? ( =sys-devel/hip-$(ver_cut 1-2) )"
DEPEND="${RDEPEND}
	dev-util/cmake"

CMAKE_BUILD_TYPE="RelWithDebInfo"

S="${WORKDIR}/${PN}-rocm-$(ver_cut 1-2)"

src_configure() {
	local mycmakeargs=(
		-DSUPPORT_OMP=$(usex openmp ON OFF)
		-DSUPPORT_HIP=$(usex hip ON OFF)
		-DSUPPORT_MPI=$(usex mpi ON OFF)
	)
	cmake-utils_src_configure
}
