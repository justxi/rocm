# Copyright
#

EAPI=7

inherit git-r3

DESCRIPTION="Common interface that provides Basic Linear Algebra Subroutines for sparse computation"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocSPARSE"
#SRC_URI="https://github.com/ROCmSoftwarePlatform/rocSPARSE/archive/rocm-$(ver_cut 1-2).tar.gz -> rocSPARSE-${PV}.tar.gz"
# Build does not work with archive file... using git master instead to test the installation...
EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/rocSPARSE"
EGIT_BRANCH="master"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="=sys-devel/hip-2.6*"
DEPEND="${RDPEND}
	dev-util/cmake"

#S="${WORKDIR}/rocSPARSE-rocm-2.6"
S="${WORKDIR}/rocSPARSE-2.6.0"

BUILD_DIR="${S}/build/release"

src_prepare() {
        cd ${S}

        sed -e "s: PREFIX rocsparse:# PREFIX rocsparse:" -i library/CMakeLists.txt
        sed -e "s:rocm_install_symlink_subdir(rocsparse):#rocm_install_symlink_subdir(rocsparse):" -i library/CMakeLists.txt

        eapply_user
}


src_configure() {
        mkdir -p "${BUILD_DIR}"
        cd ${BUILD_DIR}

	export hcc_DIR=/usr/lib/hcc/2.6/lib/cmake/hcc/
	export CXX=/usr/lib/hcc/2.6/bin/hcc
	cmake -DBUILD_CLIENTS_SAMPLES=OFF -DAMDGPU_TARGETS=gfx803 -DCMAKE_INSTALL_PREFIX=/usr/ -DCMAKE_INSTALL_INCLUDEDIR="include/rocsparse" ../..
}

src_compile() {
        cd ${BUILD_DIR}
        make VERBOSE=1
}

src_install() {
        cd ${BUILD_DIR}
	emake DESTDIR="${D}" install
}


