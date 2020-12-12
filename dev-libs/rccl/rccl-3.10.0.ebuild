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
	export DEVICE_LIB_PATH="${EPREFIX}/usr/lib/amdgcn/bitcode/"
	export CXX=hipcc
	export HIPCC_VERBOSE=7

	if use gfx803; then
		CurrentISA="803"
		echo "gfx803" >> ${WORKDIR}/target.lst
	fi
	if use gfx900; then
		CurrentISA="900"
		echo "gfx900" >> ${WORKDIR}/target.lst
	fi
	if use gfx906; then
		CurrentISA="906"
		echo "gfx906" >> ${WORKDIR}/target.lst
	fi

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=${EPREFIX}/usr
		-DCMAKE_CXX_FLAGS="--rocm-path=/usr --amdgpu-target=gfx${CurrentISA} --rocm-device-lib-path=/usr/lib/amdgcn/bitcode/"
		-DBUILD_TESTS=OFF
		-Wno-dev
	)

        export ROCM_TARGET_LST="${WORKDIR}/target.lst"

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	chrpath --delete "${D}/usr/lib64/librccl.so"
}


