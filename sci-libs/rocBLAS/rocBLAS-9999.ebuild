# Copyright
#

EAPI=6

inherit git-r3

DESCRIPTION=""
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocBLAS"
EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/rocBLAS.git"
EGIT_BRANCH="develop"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE="+gfx803 gfx900 gfx906 debug"
REQUIRED_USE="^^ ( gfx803 gfx900 gfx906 )"

RDEPEND="=dev-lang/python-2.7*
	dev-python/pyyaml
	=sys-devel/hip-1.9*"
DEPEND="${RDPEND}
	dev-util/cmake"

# stripped library is not working
RESTRICT="strip"

src_unpack() {
	git-r3_fetch ${EGIT_REPO_URI}
	git-r3_fetch "https://github.com/ROCmSoftwarePlatform/Tensile.git"

        git-r3_checkout ${EGIT_REPO_URI}
        git-r3_checkout https://github.com/ROCmSoftwarePlatform/Tensile.git "${WORKDIR}"/Tensile

        ROCM_SETUP_VERSION=`grep rocm_setup_version ${S}/CMakeLists.txt`
        rocBLAS_V=`echo ${ROCM_SETUP_VERSION} | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\).*$/\1/'`
        einfo "Current version is: ${rocBLAS_V}"
}

src_prepare() {
        # Use only the flags from rocBLAS - this should be fixed
        CFLAGS=""
        CXXFLAGS=""
        LDFLAGS=""

	cd ${WORKDIR}/Tensile
	# if the ISA is not set previous to the autodetection, /opt/rocm/bin/rocm_agent_enumerator is executed,
	# this leads to a sandbox violation
	if use gfx803; then
		eapply "${FILESDIR}/Tensile-setCurrentISA_gfx803.patch"
	fi
	if use gfx900; then
		eapply "${FILESDIR}/Tensile-setCurrentISA_gfx900.patch"
	fi
	if use gfx906; then
		eapply "${FILESDIR}/Tensile-setCurrentISA_gfx906.patch"
	fi

	cd ${S}
        eapply "${FILESDIR}/master-usePython27.patch"
        eapply "${FILESDIR}/master-addTensileIncludePath.patch"
        eapply_user
}

src_configure() {
        mkdir -p "${WORKDIR}/build/release"
        cd "${WORKDIR}/build/release"

	export PATH=$PATH:/usr/lib/hcc/1.9/bin
	export hcc_DIR=/usr/lib/hcc/1.9/lib/cmake/
	export hip_DIR=/usr/lib/hip/1.9/lib/cmake/
	export CXX=/usr/lib/hcc/1.9/bin/hcc

	if use debug; then
		buildtype="-DCMAKE_BUILD_TYPE=Debug"
	else
		buildtype="-DCMAKE_BUILD_TYPE=Release"
	fi

	cmake -DTensile_TEST_LOCAL_PATH=${WORKDIR}/Tensile -DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/" ${buildtype}  ${S}
}

src_compile() {
        cd "${WORKDIR}/build/release"
        make VERBOSE=1
}

src_install() {
	chrpath --delete "${WORKDIR}/build/release/library/src/librocblas.so.${rocBLAS_V}"

        cd "${WORKDIR}/build/release"
	emake DESTDIR="${D}" install
}


