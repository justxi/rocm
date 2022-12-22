# Copyright
#

EAPI=7

inherit cmake flag-o-matic

DESCRIPTION="AMD's library for BLAS on ROCm."
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocBLAS"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocBLAS/archive/rocm-$(ver_cut 1-2).tar.gz -> rocm-rocBLAS-${PV}.tar.gz
		https://github.com/ROCmSoftwarePlatform/Tensile/archive/rocm-$(ver_cut 1-2).tar.gz -> rocm-Tensile-${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE="+gfx803 gfx900 gfx906 debug"
REQUIRED_USE="^^ ( gfx803 gfx900 gfx906 )"

RDEPEND="=sys-devel/hip-$(ver_cut 1-2)*"
DEPEND="${RDEPEND}
	dev-util/cmake
	dev-util/rocm-cmake
	=dev-lang/python-2.7*
	>=dev-python/virtualenv-15.1.0
	dev-python/pyyaml"

# stripped library is not working
RESTRICT="strip"

S="${WORKDIR}/rocBLAS-rocm-$(ver_cut 1-2)"

src_prepare() {

	cd "${WORKDIR}/Tensile-rocm-$(ver_cut 1-2)"

	# if the ISA is not set previous to the autodetection,
	# /opt/rocm/bin/rocm_agent_enumerator is executed,
	# this leads to a sandbox violation
	if use gfx803; then
		eapply "${FILESDIR}/Tensile-CurrentISA-803.patch"
	fi
	if use gfx900; then
		eapply "${FILESDIR}/Tensile-CurrentISA-900.patch"
	fi
	if use gfx906; then
		eapply "${FILESDIR}/Tensile-CurrentISA-906.patch"
	fi

	eapply "${FILESDIR}/Tensile-2.7-add_HIP_include_path.patch"

	sed -e "s: PREFIX rocblas:# PREFIX rocblas:" -i ${S}/library/src/CMakeLists.txt || die
	sed -e "s:<INSTALL_INTERFACE\:include:<INSTALL_INTERFACE\:include/rocblas:" -i ${S}/library/src/CMakeLists.txt || die

	# disable tests - a patch already exist on github
	sed -e "s:COMMAND \${CMAKE_HOME_DIRECTORY}/header_compilation_tests.sh:COMMAND true:" -i ${S}/library/src/CMakeLists.txt || die

	cd ${S}
	eapply_user
	cmake_src_prepare
}

src_configure() {
	strip-flags

	if use gfx803; then
		CurrentISA="803"
	fi
	if use gfx900; then
		CurrentISA="900"
	fi
	if use gfx906; then
		CurrentISA="906"
	fi

	CXX=/usr/lib/hcc/$(ver_cut 1-2)/bin/hcc
	HCC_HOME=/usr/lib/hcc/$(ver_cut 1-2)

	if use debug; then
		buildtype="Debug"
	else
		buildtype="Release"
	fi

	local mycmakeargs=(
		-DDETECT_LOCAL_VIRTUALENV=1
		-DTensile_TEST_LOCAL_PATH="${WORKDIR}/Tensile-rocm-$(ver_cut 1-2)"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/"
		-DCMAKE_INSTALL_INCLUDEDIR="include/rocblas"
		-DCMAKE_CXX_FLAGS="--amdgpu-target=gfx${CurrentISA}"
		-DCMAKE_BUILD_TYPE=${buildtype}
	)

	cmake_src_configure
}
