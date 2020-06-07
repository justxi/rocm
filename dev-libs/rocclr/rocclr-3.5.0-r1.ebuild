#
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Radeon Open Compute Common Language Runtime"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCclr"
SRC_URI="https://github.com/ROCm-Developer-Tools/ROCclr/archive/roc-${PV}.tar.gz -> ${P}.tar.gz
         https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime/archive/roc-${PV}.tar.gz -> rocm-opencl-runtime-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

RDEPEND=">=dev-libs/rocm-comgr-${PV}
	>=sys-devel/llvm-roc-${PV}"
DEPEND="${RDEPEND}
	>=dev-util/rocm-cmake-${PV}"

PATCHES=(
	${FILESDIR}/rocclr-3.5.0-cmake-install-destination.patch
)

S="${WORKDIR}/ROCclr-roc-${PV}"

src_configure() {
	local mycmakeargs=(
		-DUSE_COMGR_LIBRARY=YES
		-DOPENCL_DIR=${WORKDIR}/ROCm-OpenCL-Runtime-roc-${PV}
		-DCMAKE_INSTALL_PREFIX="/usr"
	)
	cmake_src_configure
}

src_install() {
	# CMakeLists.txt should be fixed in the CMakeLists.txt to get this installed automaticaly... but how?
	sed -e "s:/var/tmp/portage/dev-libs/rocclr-3.5.0/work/rocclr-3.5.0_build:/usr/lib64:" -i ${BUILD_DIR}/amdrocclr_staticTargets.cmake
	mkdir -p ${D}/usr/lib64/cmake/rocclr
	cp ${BUILD_DIR}/amdrocclr_staticTargets.cmake ${D}/usr/lib64/cmake/rocclr || die

	cmake_src_install
}
