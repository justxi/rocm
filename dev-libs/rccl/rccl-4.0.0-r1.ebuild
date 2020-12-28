# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="ROCm Communication Collectives Library (RCCL)"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rccl"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rccl/archive/rocm-${PV}.tar.gz -> rccl-${PV}.tar.gz"

LICENSE=""
KEYWORDS="~amd64"
SLOT="0"

RDEPEND="=dev-util/hip-$(ver_cut 1-2)*"
DEPEND="${RDPEND}
	dev-util/cmake
	dev-util/rocm-cmake"

IUSE="debug"

S="${WORKDIR}/rccl-rocm-${PV}"

PATCHES=(
	"${FILESDIR}/rccl-2.7.0-change_install_location.patch"
)

src_configure() {
	addwrite /dev/kfd
	addpredict /dev/dri/

	export DEVICE_LIB_PATH="${EPREFIX}/usr/lib/amdgcn/bitcode/"
	export CXX=hipcc

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DCMAKE_CXX_FLAGS="--rocm-path=/usr --rocm-device-lib-path=${DEVICE_LIB_PATH}"
		-DBUILD_TESTS=OFF
		-Wno-dev
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	chrpath --delete "${D}/usr/lib64/librccl.so"
}
