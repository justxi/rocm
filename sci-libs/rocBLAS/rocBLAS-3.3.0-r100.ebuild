# Copyright
#

EAPI=7

inherit cmake flag-o-matic

DESCRIPTION="AMD's library for BLAS on ROCm."
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocBLAS"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocBLAS/archive/rocm-${PV}.tar.gz -> rocm-rocBLAS-${PV}.tar.gz
	https://github.com/ROCmSoftwarePlatform/Tensile/archive/rocm-${PV}.tar.gz -> rocm-Tensile-${PV}.tar.gz"

LICENSE=""
KEYWORDS="~amd64"
SLOT="0"

IUSE="debug +gfx803 gfx900 gfx906 gfx908 +tensile tensile_architecture_gfx803 tensile_asm_ci tensile_host"
REQUIRED_USE="|| ( gfx803 gfx900 gfx906 gfx908 )"

RDEPEND="=sys-devel/hip-$(ver_cut 1-2)*"
DEPEND="${RDEPEND}
	dev-util/cmake
	dev-util/rocm-cmake
	=dev-lang/python-2.7*
	>=dev-python/virtualenv-15.1.0
	dev-python/pyyaml
	dev-perl/File-Which"

# stripped library is not working
RESTRICT="strip"

S="${WORKDIR}/rocBLAS-rocm-${PV}"

rocBLAS_V="0.1"

src_prepare() {
	cd "${WORKDIR}/Tensile-rocm-${PV}"

	eapply "${FILESDIR}/Tensile-2.8-add_HIP_include_path.patch"

	# Test to change LLVM used by Tensile, but with these changes it does not compile
#	sed -e "s:find_package(LLVM 6.0 REQUIRED CONFIG):find_package(LLVM REQUIRED CONFIG HINTS \"/usr/lib/llvm/roc/\"):" -i ${WORKDIR}/Tensile-rocm-${PV}/HostLibraryTests/CMakeLists.txt
#	sed -e "s:find_package(LLVM 6.0 QUIET CONFIG):find_package(LLVM QUIET CONFIG HINTS \"/usr/lib/llvm/roc/\"):" -i -i ${WORKDIR}/Tensile-rocm-${PV}/Tensile/Source/lib/CMakeLists.txt


	sed -e "s: PREFIX rocblas:# PREFIX rocblas:" -i ${S}/library/src/CMakeLists.txt || die
	sed -e "s:<INSTALL_INTERFACE\:include:<INSTALL_INTERFACE\:include/rocblas:" -i ${S}/library/src/CMakeLists.txt || die

	sed -e "s:\\\\\${CPACK_PACKAGING_INSTALL_PREFIX}rocblas/lib:/usr/lib64/rocblas:" -i ${S}/library/src/CMakeLists.txt || die
	sed -e "s:rocm_install_symlink_subdir( rocblas ):#rocm_install_symlink_subdir( rocblas ):" -i ${S}/library/src/CMakeLists.txt || die

	# patch patch to hcc
	sed -e "s:HCC=\${rocm_path}/hcc/bin/hcc:HCC=${HCC_HOME}/bin/hcc:" -i ${S}/header_compilation_tests.sh

	# add architectures to target.lst file to allow "autodetection" of the architecture
	if use gfx803; then
		echo "gfx803" >> ${WORKDIR}/target.lst
	fi
	if use gfx900; then
		echo "gfx900" >> ${WORKDIR}/target.lst
	fi
	if use gfx906; then
		echo "gfx906" >> ${WORKDIR}/target.lst
	fi
	if use gfx908; then
		echo "gfx908" >> ${WORKDIR}/target.lst
	fi

	cd ${S}
	eapply_user
	cmake_src_prepare
}

src_configure() {
	strip-flags
	filter-flags '*march*'

	CXX=${HCC_HOME}/bin/hcc

	if use debug; then
		buildtype="Debug"
	else
		buildtype="Release"
	fi

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
		-DDETECT_LOCAL_VIRTUALENV=1
		-DTensile_TEST_LOCAL_PATH="${WORKDIR}/Tensile-rocm-${PV}"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/"
		-DCMAKE_INSTALL_INCLUDEDIR="include/rocblas"
		-DCMAKE_BUILD_TYPE=${buildtype}
		-DAMDGPU_TARGETS="${AMDGPU_TARGETS}"
		-DBUILD_WITH_TENSILE_HOST=$(usex tensile_host ON OFF)
	)

	if ! use tensile; then
		mycmakeargs+=(
			-DBUILD_WITH_TENSILE=OFF
		)
	fi

	if use tensile_architecture_gfx803; then
		mycmakeargs+=(
			-DTensile_ARCHITECTURE="gfx803"
		)
	fi

	if use tensile_asm_ci; then
		mycmakeargs+=(
			-DTensile_LOGIC="asm_ci"
		)
	fi

	export ROCM_TARGET_LST="${WORKDIR}/target.lst"

	cmake_src_configure
}

src_install() {
	cmake_src_install
	chrpath --delete "${D}/usr/lib64/librocblas.so.${rocBLAS_V}"
}
