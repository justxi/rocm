EAPI=7

inherit cmake

DESCRIPTION="Radeon Open Compute Common Language Runtime"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/ROCclr"
SRC_URI="https://github.com/ROCm-Developer-Tools/ROCclr/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime/archive/rocm-${PV}.tar.gz -> rocm-opencl-runtime-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="amd64"

RDEPEND="dev-libs/rocm-comgr
	sys-devel/llvm-roc
	media-libs/mesa"
DEPEND="${RDEPEND}
	dev-util/rocm-cmake"

IUSE="" # +pal

PATCHES=(
	${FILESDIR}/${P}-cmake-install-destination.patch
#	${FILESDIR}/hsa-runtime.patch
)

S="${WORKDIR}/ROCclr-rocm-${PV}"

src_prepare() {
	mv compiler/lib/include/* include || die
	rmdir compiler/lib/include || die
	sed -e "s:@ROCCLR_TARGETS_PATH@:\${CMAKE_CURRENT_LIST_DIR}/rocclr-targets.cmake:g" -i cmake/ROCclrConfig.cmake.in || die
	sed -e "s|INSTALL_INTERFACE:include|INSTALL_INTERFACE:include/rocclr|g" -i {,device/pal/,device/rocm/}CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DUSE_COMGR_LIBRARY=ON
#		-DBUILD_PAL=ON
		-DOPENCL_DIR="${WORKDIR}/ROCm-OpenCL-Runtime-rocm-${PV}"
		-DCMAKE_INSTALL_PREFIX=/usr
	)
	cmake_src_configure
}
