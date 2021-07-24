# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic

DESCRIPTION="AMD's library for BLAS on ROCm."
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocBLAS"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocBLAS/archive/rocm-${PV}.tar.gz -> rocm-rocBLAS-${PV}.tar.gz
	https://github.com/ROCmSoftwarePlatform/Tensile/archive/rocm-${PV}.tar.gz -> rocm-Tensile-${PV}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"

IUSE="debug +tensile +tensile_host +gfx803 gfx900 gfx906 gfx908"
REQUIRED_USE="|| ( gfx803 gfx900 gfx906 gfx908 )"

RDEPEND="=dev-util/hip-$(ver_cut 1-2)*"
DEPEND="${RDEPEND}
	dev-util/cmake
	dev-util/rocm-cmake
	dev-libs/msgpack
	=dev-lang/python-3*
	>=dev-python/virtualenv-15.1.0
	dev-python/msgpack
	dev-python/pyyaml
	dev-perl/File-Which"

# stripped library is not working
RESTRICT="strip"

S="${WORKDIR}/rocBLAS-rocm-${PV}"

rocBLAS_V="0.1"

src_prepare() {
	# Changes in Tensile ...
	cd "${WORKDIR}/Tensile-rocm-${PV}"

	# add "--rocm-path=/usr" to hipFlags
	eapply "${FILESDIR}/Tensile-4.0-add-rocm-path.patch"
	eapply "${FILESDIR}/Tensile-rocm-4.2.0-help-locate-llvm-roc-bundler.patch"

	# Changes in rocBLAS ...
	cd ${S}
	eapply "${FILESDIR}/rocBLAS-4.2.0-fix-glob-pattern-cmake.patch"

	sed -e "s: PREFIX rocblas:# PREFIX rocblas:" -i "${S}/library/src/CMakeLists.txt" || die
	sed -e "s:<INSTALL_INTERFACE\:include:<INSTALL_INTERFACE\:include/rocblas:" -i "${S}/library/src/CMakeLists.txt" || die
	sed -e "s:rocblas/include:include/rocblas:" -i "${S}/library/src/CMakeLists.txt" || die
	sed -e "s:\\\\\${CPACK_PACKAGING_INSTALL_PREFIX}rocblas/lib:/usr/lib64/rocblas:" -i "${S}/library/src/CMakeLists.txt" || die
	sed -e "s:rocm_install_symlink_subdir( rocblas ):#rocm_install_symlink_subdir( rocblas ):" -i "${S}/library/src/CMakeLists.txt" || die

	eapply_user
	cmake_src_prepare
}

src_configure() {
	# allow acces to hardware
#	addread /dev/kfd
	addwrite /dev/kfd
#	addread /dev/dri/
	addpredict /dev/dri/

	# Process flags
	strip-flags
	filter-flags '*march*'

	# Compiler to use
	export CXX="/usr/lib/hip/bin/hipcc"

	# Target to use
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

	export HCC_AMDGPU_TARGET="${AMDGPU_TARGETS}"

	if use debug; then
		buildtype="Debug"
	else
		buildtype="Release"
	fi

	local mycmakeargs=(
		-DTensile_LOGIC="asm_full"
		-DTensile_COMPILER="hipcc"
		-DTensile_ARCHITECTURE="${AMDGPU_TARGETS}"
		-DTensile_LIBRARY_FORMAT="msgpack"
		-DTensile_CODE_OBJECT_VERSION="V3"
		-DTensile_TEST_LOCAL_PATH="${WORKDIR}/Tensile-rocm-${PV}"
		-DBUILD_WITH_TENSILE=$(usex tensile ON OFF)
		-DBUILD_WITH_TENSILE_HOST=$(usex tensile_host ON OFF)
		-DCMAKE_BUILD_TYPE="${buildtype}"
		-DCMAKE_CXX_FLAGS="--rocm-path=/usr"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/"
		-DCMAKE_INSTALL_INCLUDEDIR="include/rocblas"
		-DBUILD_TESTING=OFF
		-DBUILD_CLIENTS_SAMPLES=OFF
		-DBUILD_CLIENTS_TESTS=OFF
		-DBUILD_CLIENTS_BENCHMARKS=OFF
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	chrpath --delete "${D}/usr/lib64/librocblas.so.${rocBLAS_V}"
}
