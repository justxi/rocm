# Copyright
#

EAPI=7

inherit git-r3 cmake-utils

DESCRIPTION="Common interface that provides Basic Linear Algebra Subroutines for sparse computation"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocSPARSE"
#SRC_URI="https://github.com/ROCmSoftwarePlatform/rocSPARSE/archive/rocm-$(ver_cut 1-2).tar.gz -> rocSPARSE-${PV}.tar.gz"
# Build does not work with archive file... using git master instead to test the installation...
EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/rocSPARSE"
EGIT_BRANCH="master"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE="+gfx803 gfx900 gfx906 debug"
REQUIRED_USE="^^ ( gfx803 gfx900 gfx906 )"

RDEPEND="=sys-devel/hip-$(ver_cut 1-2)*
	 =sci-libs/rocPRIM-$(ver_cut 1-2)*"
DEPEND="${RDPEND}
	dev-util/cmake"

#S="${WORKDIR}/rocSPARSE-rocm-$(ver_cut 1-2)"
S="${WORKDIR}/rocSPARSE-${PV}"

BUILD_DIR="${S}/build/release"

src_prepare() {
        cd ${S}

        sed -e "s: PREFIX rocsparse:# PREFIX rocsparse:" -i library/CMakeLists.txt
        sed -e "s:rocm_install_symlink_subdir(rocsparse):#rocm_install_symlink_subdir(rocsparse):" -i library/CMakeLists.txt

        eapply_user
	cmake-utils_src_prepare
}

src_configure() {
        # if the ISA is not set previous to the autodetection,
        # /opt/rocm/bin/rocm_agent_enumerator is executed,
        # this leads to a sandbox violation
        if use gfx803; then
                CurrentISA="gfx803"
        fi
        if use gfx900; then
                CurrentISA="gfx900"
        fi
        if use gfx906; then
                CurrentISA="gfx906"
        fi

	export hcc_DIR=/usr/lib/hcc/$(ver_cut 1-2)/lib/cmake/hcc/
	export CXX=/usr/lib/hcc/$(ver_cut 1-2)/bin/hcc

	local mycmakeargs=(
		-DBUILD_CLIENTS_SAMPLES=OFF
		-DAMDGPU_TARGETS="${CurrentISA}"
		-DCMAKE_INSTALL_PREFIX="/usr"
		-DCMAKE_INSTALL_INCLUDEDIR="include/rocsparse"
	)

	cmake-utils_src_configure
}
