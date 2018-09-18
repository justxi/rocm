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
IUSE=""

RDEPEND="=dev-lang/python-2.7*
	dev-python/pyyaml"
DEPEND="dev-util/cmake"
	${RDPEND}

src_unpack() {

	git-r3_fetch ${EGIT_REPO_URI}
	git-r3_fetch "https://github.com/ROCmSoftwarePlatform/Tensile.git"

        git-r3_checkout ${EGIT_REPO_URI}
        git-r3_checkout https://github.com/ROCmSoftwarePlatform/Tensile.git "${S}"/Tensile
}

src_prepare() {
	eapply "${FILESDIR}/Tensile-setCurrentISA.patch"
        eapply "${FILESDIR}/development-usePython27.patch"
        eapply "${FILESDIR}/development-addTensileIncludePath.patch"
        eapply_user
}

src_configure() {
        mkdir -p "${WORKDIR}/build/release"
        cd "${WORKDIR}/build/release"

	export PATH=$PATH:/usr/lib/hcc/1.9/bin
	export hcc_DIR=/usr/lib/hcc/1.9/lib/cmake/
	export hip_DIR=/usr/lib/hip/1.9/lib/cmake/
	export CXX=/usr/lib/hcc/1.9/bin/hcc

	cmake -DTensile_TEST_LOCAL_PATH=${S}/Tensile -DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/"  ${S}
}

src_compile() {
        cd "${WORKDIR}/build/release"
        make VERBOSE=1
}

src_install() {

	chrpath --delete "${WORKDIR}/build/release/library/src/librocblas.so.0.15.1.3"

        cd "${WORKDIR}/build/release"
	emake DESTDIR="${D}" install
}


