# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils flag-o-matic

DESCRIPTION="AMD's library for BLAS on ROCm."
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocBLAS"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocBLAS/archive/rocm-${PV}.tar.gz -> rocm-rocBLAS-${PV}.tar.gz
	https://github.com/ROCmSoftwarePlatform/Tensile/archive/rocm-${PV}.tar.gz -> rocm-Tensile-${PV}.tar.gz"

LICENSE=""
KEYWORDS="~amd64"
SLOT="0"

IUSE="debug +tensile +tensile_host"
#+gfx803 gfx900 gfx906 gfx908 tensile_asm_ci
#REQUIRED_USE="|| ( gfx803 gfx900 gfx906 gfx908 )"

RDEPEND="=dev-util/hip-$(ver_cut 1-2)*"
DEPEND="${RDEPEND}
	dev-util/cmake
	dev-util/rocm-cmake
	dev-libs/msgpack
	=dev-lang/python-3*
	>=dev-python/virtualenv-15.1.0
	dev-python/msgpack[python_targets_python3_6]
	dev-python/pyyaml
	dev-perl/File-Which"

# stripped library is not working
RESTRICT="strip"

S="${WORKDIR}/rocBLAS-rocm-${PV}"

rocBLAS_V="0.1"

src_prepare() {
	cd "${WORKDIR}/Tensile-rocm-${PV}"

	# add "--rocm-path=/usr" to hipFlags
	eapply "${FILESDIR}/Tensile-4.0-add-rocm-path.patch"

	# Changes in Tensile ...
	sed -e "s:hipFlags = \[\"--genco\", :hipFlags = \[:" -i "${WORKDIR}/Tensile-rocm-${PV}/Tensile/TensileCreateLibrary.py" || die

	sed -e "s/Impl::inputOne(io, key, \*value)/Impl::inputOne(io, key.str(), \*value)/g" \
		-i "${WORKDIR}/Tensile-rocm-${PV}/Tensile/Source/lib/include/Tensile/llvm/YAML.hpp" || die

	sed -e "s:locateExe(\"/opt/rocm/llvm/bin\", \"clang-offload-bundler\"):\"/usr/lib/llvm/roc/bin/clang-offload-bundler\":" -i "${WORKDIR}/Tensile-rocm-${PV}/Tensile/Common.py" || die

	# Changes in rocBLAS ...
	sed -e "s: PREFIX rocblas:# PREFIX rocblas:" -i ${S}/library/src/CMakeLists.txt || die
	sed -e "s:<INSTALL_INTERFACE\:include:<INSTALL_INTERFACE\:include/rocblas:" -i ${S}/library/src/CMakeLists.txt || die
	sed -e "s:rocblas/include:include/rocblas:" -i ${S}/library/src/CMakeLists.txt || die
	sed -e "s:\\\\\${CPACK_PACKAGING_INSTALL_PREFIX}rocblas/lib:/usr/lib64/rocblas:" -i ${S}/library/src/CMakeLists.txt || die
	sed -e "s:rocm_install_symlink_subdir( rocblas ):#rocm_install_symlink_subdir( rocblas ):" -i ${S}/library/src/CMakeLists.txt || die

	cd ${S}
	eapply_user
	cmake-utils_src_prepare
}

src_configure() {
	# allow acces to hardware
	addread /dev/kfd
	addwrite /dev/kfd
	addread /dev/dri/
	addpredict /dev/dri/

	strip-flags
	filter-flags '*march*'

	export CXX="/usr/lib/hip/4.0/bin/hipcc"

	if use debug; then
		buildtype="Debug"
	else
		buildtype="Release"
	fi

#	AMDGPU_TARGETS=""
#	if use gfx803; then
#		AMDGPU_TARGETS+="gfx803;"
#	fi
#	if use gfx900; then
#		AMDGPU_TARGETS+="gfx900;"
#	fi
#	if use gfx906; then
#		AMDGPU_TARGETS+="gfx906;"
#	fi
#	if use gfx908; then
#		AMDGPU_TARGETS+="gfx908;"
#	fi

	local mycmakeargs=(
		-DTensile_LOGIC="asm_full"
		-DTensile_COMPILER="hipcc"
		-DTensile_ARCHITECTURE="all"
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
#		-DAMDGPU_TARGETS="${AMDGPU_TARGETS}"
#		-DTensile_LIBRARY_FORMAT="yaml"
#		-Damd_comgr_DIR="/usr/lib/cmake/amd_comgr"

#	if use gfx803; then
#		mycmakeargs+=(
#			-DTensile_ARCHITECTURE="gfx803"
#		)
#	fi

#	if use gfx900; then
#		mycmakeargs+=(
#			-DTensile_ARCHITECTURE="gfx900"
#		)
#	fi

#	if use gfx906; then
#		mycmakeargs+=(
#			-DTensile_ARCHITECTURE="gfx906"
#		)
#	fi

#	if use gfx908; then
#		mycmakeargs+=(
#			-DTensile_ARCHITECTURE="gfx908"
#		)
#	fi

#	if use tensile_asm_ci; then
#		mycmakeargs+=(
#			-DTensile_LOGIC="asm_ci"
#		)
#	fi

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	chrpath --delete "${D}/usr/lib64/librocblas.so.${rocBLAS_V}"
}
