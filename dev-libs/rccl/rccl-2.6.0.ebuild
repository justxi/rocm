# Copyright
#

EAPI=7

inherit cmake-utils

DESCRIPTION="ROCm Communication Collectives Library (RCCL)"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rccl"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rccl/archive/${PV}.tar.gz -> rccl-${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="=sys-devel/hip-${PV}*"
DEPEND="${RDEPEND}
	dev-util/cmake"

IUSE="+gfx803 gfx900 gfx906 debug"
REQUIRED_USE="^^ ( gfx803 gfx900 gfx906 )"

S="${WORKDIR}/rccl-${PV}"

src_prepare() {
	if use gfx803; then
		CurrentISA="803"
	fi
	if use gfx900; then
		CurrentISA="900"
	fi
	if use gfx906; then
		CurrentISA="906"
	fi
	cmake-utils_src_prepare
}

src_configure() {
	CMAKE_MAKEFILE_GENERATOR=emake
	CMAKE_PREFIX_PATH="/usr/lib/hcc/$(ver_cut 1-2)/lib/cmake/hcc/:/usr/lib/hip/$(ver_cut 1-2)/lib/cmake/hip/"
	CXX="/usr/lib/hcc/$(ver_cut 1-2)/bin/hcc"
	local mycmakeargs=(
		-DCMAKE_CXX_FLAGS="--amdgpu-target=gfx${CurrentISA}"
	)
	cmake-utils_src_configure
}
