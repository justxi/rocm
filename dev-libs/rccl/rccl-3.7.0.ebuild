EAPI=7

inherit cmake-utils

DESCRIPTION="ROCm Communication Collectives Library (RCCL)"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rccl"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rccl/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="amd64"
SLOT="0/$(ver_cut 1-2)"

RDEPEND="sys-devel/hip"
DEPEND="${RDPEND}
	dev-util/rocm-cmake"

IUSE="gfx803 +gfx900 gfx906 gfx908 debug"
REQUIRED_USE="^^ ( gfx803 gfx900 gfx906 gfx908 )"

PATCHES=(
	"${FILESDIR}/${P}-change_install_location.patch"
)

S="${WORKDIR}/${PN}-rocm-${PV}"

src_configure() {
	export DEVICE_LIB_PATH="/usr/lib"
	export CXX="${HIP_PATH}/bin/hipcc"

	AMDGPU_TARGETS=""
	if use gfx803; then
		AMDGPU_TARGETS+="gfx803;"
	fi
	if use gfx900; then
		AMDGPU_TARGETS+="gfx900;"
	fi
	if use gfx906; then
		AMDGPU_TARGETS+="gfx906;"
	fi
	if use gfx908; then
		AMDGPU_TARGETS+="gfx908;"
	fi

	local mycmakeargs=(
		-DCMAKE_PREFIX_PATH=/usr/lib/llvm/roc/$(ver_cut 1-2)/lib/cmake/llvm
		-DAMDGPU_TARGETS="${AMDGPU_TARGETS}"
		-DCMAKE_INSTALL_LIBDIR="/usr/$(get_libdir)"
		-DBUILD_TESTS=OFF
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	chrpath --delete "${D}/usr/lib64/librccl.so"
}
