# Copyright
#

EAPI=7

inherit cmake-utils

DESCRIPTION="HIP parallel primitives for developing performant GPU-accelerated code on AMD ROCm platform"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocPRIM"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocPRIM/archive/rocm-${PV}.tar.gz -> rocPRIM-${PV}.tar.gz"

LICENSE=""
KEYWORDS="~amd64"
SLOT="0"

IUSE=""

RDEPEND=">=sys-devel/hip-${PV}
	>=dev-util/rocm-cmake-${PV}"
DEPEND="${RDEPEND}
	dev-util/cmake"

#PATCHES=(
#	"${FILESDIR}/master-disable2ndfindhcc.patch"
#)

S="${WORKDIR}/rocPRIM-rocm-${PV}"

src_prepare() {
	# Update version
	sed -e "s:find_package(HIP 1.5.18263 REQUIRED):find_package(HIP 3.5.20250 REQUIRED):" -i cmake/VerifyCompiler.cmake

	# "hcc" is depcreated, new platform ist "rocclr"
	# sed -e "s:HIP_PLATFORM STREQUAL \"hcc\":HIP_PLATFORM STREQUAL \"rocclr\":" -i cmake/VerifyCompiler.cmake

	# Install according to FHS
	sed -e "s: PREFIX rocprim:# PREFIX rocprim:" -i rocprim/CMakeLists.txt
	sed -e "s:\$<INSTALL_INTERFACE\:rocprim/include/>:\$<INSTALL_INTERFACE\:include/rocprim/>:" -i rocprim/CMakeLists.txt
	sed -e "s: DESTINATION rocprim/include/: DESTINATION include/:" -i rocprim/CMakeLists.txt
	sed -e "s:rocm_install_symlink_subdir(rocprim):#rocm_install_symlink_subdir(rocprim):" -i rocprim/CMakeLists.txt

        eapply_user
	cmake-utils_src_prepare
}

src_configure() {
	# Compiler to use...
	export CXX=hipcc

	# Let "hipcc" know where the bitcode files are located
	export DEVICE_LIB_PATH="${EPREFIX}/usr/lib64"

	local mycmakeargs=(
		-DHIP_PLATFORM=hcc
		-DCMAKE_INSTALL_PREFIX=${EPREFIX}/usr/
		-DBUILD_TEST=OFF
		-DBUILD_BENCHMARK=OFF
	)

	# ... testing ...
        echo "gfx803" >> ${WORKDIR}/target.lst
        export ROCM_TARGET_LST="${WORKDIR}/target.lst"

	cmake-utils_src_configure
}
