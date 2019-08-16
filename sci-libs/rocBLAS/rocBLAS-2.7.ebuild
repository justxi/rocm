# Copyright
#

EAPI=6

DESCRIPTION=""
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocBLAS"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocBLAS/archive/rocm-${PV}.tar.gz -> rocm-rocBLAS-${PV}.tar.gz
         https://github.com/ROCmSoftwarePlatform/Tensile/archive/rocm-${PV}.tar.gz -> rocm-Tensile-${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE="+gfx803 gfx900 gfx906 debug"
REQUIRED_USE="^^ ( gfx803 gfx900 gfx906 )"

RDEPEND="=sys-devel/hip-${PV}*"
DEPEND="${RDPEND}
	dev-util/cmake
	dev-libs/rocm-cmake
	=dev-lang/python-2.7*
	>=dev-python/virtualenv-15.1.0
	dev-python/pyyaml"

# stripped library is not working
RESTRICT="strip"

S="${WORKDIR}/rocBLAS-rocm-${PV}"
BUILDDIR="${WORKDIR}/build/release"

rocBLAS_V="2.2.11.0"

src_prepare() {
        # Use only the flags from rocBLAS - this should be fixed
        CFLAGS=""
        CXXFLAGS=""
        LDFLAGS=""

	cd "${WORKDIR}/Tensile-rocm-${PV}"

	# if the ISA is not set previous to the autodetection,
	# /opt/rocm/bin/rocm_agent_enumerator is executed,
	# this leads to a sandbox violation
	if use gfx803; then
		eapply "${FILESDIR}/Tensile-CurrentISA-803.patch"
		CurrentISA="803"
	fi
	if use gfx900; then
		eapply "${FILESDIR}/Tensile-CurrentISA-900.patch"
		CurrentISA="900"
	fi
	if use gfx906; then
		eapply "${FILESDIR}/Tensile-CurrentISA-906.patch"
		CurrentISA="906"
	fi

	sed -e "s: PREFIX rocblas:# PREFIX rocblas:" -i ${S}/library/src/CMakeLists.txt || die

	cd ${S}
        eapply "${FILESDIR}/master-addTensileIncludePath.patch"
#	eapply "${FILESDIR}/rocBLAS-${PV}-use_local_virtualenv.patch"
        eapply_user
}

src_configure() {
        mkdir -p ${BUILDDIR}
        cd ${BUILDDIR}

	export PATH=$PATH:/usr/lib/hcc/${PV}/bin
	export hcc_DIR=/usr/lib/hcc/${PV}/lib/cmake/
	export hip_DIR=/usr/lib/hip/${PV}/lib/cmake/
	export CXX=/usr/lib/hcc/${PV}/bin/hcc

	if use debug; then
		buildtype="-DCMAKE_BUILD_TYPE=Debug"
	else
		buildtype="-DCMAKE_BUILD_TYPE=Release"
	fi

	cmake -DDETECT_LOCAL_VIRTUALENV=1 -DTensile_TEST_LOCAL_PATH="${WORKDIR}/Tensile-rocm-${PV}" -DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/" -DCMAKE_CXX_FLAGS="--amdgpu-target=gfx${CurrentISA}"  ${buildtype}  ${S}
}

src_compile() {
        cd ${BUILDDIR}
        make VERBOSE=1
}

src_install() {
	cd ${BUILDDIR}

	chrpath --delete "${BUILDDIR}/library/src/librocblas.so.${rocBLAS_V}"

        # install to /usr/lib/rocblas
        emake DESTDIR="${D}" install
}
