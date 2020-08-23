# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="ROCm Communication Collectives Library (RCCL)"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rccl"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rccl/archive/rocm-${PV}.tar.gz -> rccl-${PV}.tar.gz"

LICENSE=""
KEYWORDS="~amd64"
SLOT="0"

RDEPEND="=sys-devel/hip-$(ver_cut 1-2)*"
DEPEND="${RDPEND}
	dev-util/cmake
	dev-util/rocm-cmake"

IUSE="+gfx803 gfx900 gfx906 debug"
REQUIRED_USE="^^ ( gfx803 gfx900 gfx906 )"

S="${WORKDIR}/rccl-rocm-${PV}"

PATCHES=(
	"${FILESDIR}/rccl-2.7.0-change_install_location.patch"
)

src_configure() {
#	CMAKE_MAKEFILE_GENERATOR=emake

	export DEVICE_LIB_PATH="${EPREFIX}/usr/lib64"
	export CXX=hipcc

	if use gfx803; then
		CurrentISA="803"
	fi
	if use gfx900; then
		CurrentISA="900"
	fi
	if use gfx906; then
		CurrentISA="906"
	fi

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=${EPREFIX}/usr
		-DCMAKE_CXX_FLAGS="--amdgpu-target=gfx${CurrentISA}"
		-Wno-dev
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	chrpath --delete "${D}/usr/lib64/librccl.so"
}
