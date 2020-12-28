# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="HIP parallel primitives for developing performant GPU-accelerated code on AMD ROCm platform"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocPRIM"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocPRIM/archive/rocm-${PV}.tar.gz -> rocPRIM-${PV}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"
IUSE=""

RDEPEND=">=dev-util/hip-${PV}
	>=dev-util/rocm-cmake-${PV}"
DEPEND="${RDEPEND}
	dev-util/cmake"

S="${WORKDIR}/rocPRIM-rocm-${PV}"

src_prepare() {
	# Update version
	sed -e "s:find_package(HIP 1.5.18263 REQUIRED):find_package(HIP 3.5.20250 REQUIRED):" -i cmake/VerifyCompiler.cmake || die

	# "hcc" is depcreated, new platform ist "rocclr"
	sed -e "s:HIP_PLATFORM STREQUAL \"hcc\":HIP_PLATFORM STREQUAL \"rocclr\":" -i cmake/VerifyCompiler.cmake || die

	# Install according to FHS
	sed -e "s: PREFIX rocprim:# PREFIX rocprim:" -i rocprim/CMakeLists.txt || die
	sed -e "s:\$<INSTALL_INTERFACE\:rocprim/include/>:\$<INSTALL_INTERFACE\:include/rocprim/>:" -i rocprim/CMakeLists.txt || die
	sed -e "s: DESTINATION rocprim/include/: DESTINATION include/:" -i rocprim/CMakeLists.txt || die
	sed -e "s:rocm_install_symlink_subdir(rocprim):#rocm_install_symlink_subdir(rocprim):" -i rocprim/CMakeLists.txt || die

        eapply_user
	cmake_src_prepare
}

src_configure() {
	# Grant access to the device
        addwrite /dev/kfd
        addpredict /dev/dri/

	# Compiler to use
	export CXX=hipcc

	# Let "hipcc" know where the bitcode files are located
	export DEVICE_LIB_PATH="${EPREFIX}/usr/lib/amdgcn/bitcode"

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/"
		-DCMAKE_CXX_FLAGS="--rocm-path=/usr"
		-DAMDGPU_TARGETS="gfx803;gfx900;gfx906;gfx908"
		-DBUILD_TEST=OFF
		-DBUILD_BENCHMARK=OFF
	)

	cmake_src_configure
}
