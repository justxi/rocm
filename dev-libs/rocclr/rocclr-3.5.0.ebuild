#
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="Radeon Open Compute Common Language Runtime"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCclr"
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

src_unpack() {
	EGIT_COMMIT="roc-3.5.0"
	git-r3_fetch "https://github.com/ROCm-Developer-Tools/ROCclr"

	EGIT_COMMIT="roc-3.5.0"
	git-r3_fetch "https://github.com/radeonopencompute/ROCm-OpenCL-Runtime"

	git-r3_checkout "https://github.com/ROCm-Developer-Tools/ROCclr"
	git-r3_checkout "https://github.com/radeonopencompute/ROCm-OpenCL-Runtime" ${WORKDIR}/opencl-on-vdi
}

src_configure() {
	local mycmakeargs=(
		-DUSE_COMGR_LIBRARY=YES
		-DOPENCL_DIR=${WORKDIR}/opencl-on-vdi/
		-DCMAKE_INSTALL_PREFIX="/usr"
	)
	cmake_src_configure
}

src_install() {
	# CMakeLists.txt should be fixed in the CMakeLists.txt to get this installed automaticaly...
	sed -e "s:/var/tmp/portage/dev-libs/rocclr-3.5.0/work/rocclr-3.5.0_build:/usr/lib64:" -i ${BUILD_DIR}/amdrocclr_staticTargets.cmake
	mkdir -p ${D}/usr/lib64/cmake/rocclr
	cp ${BUILD_DIR}/amdrocclr_staticTargets.cmake ${D}/usr/lib64/cmake/rocclr || die

	cmake_src_install
}
