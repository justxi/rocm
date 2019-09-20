# Copyright
#

EAPI=6

#inherit git-r3

DESCRIPTION="HIP parallel primitives for developing performant GPU-accelerated code on AMD ROCm platform"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocPRIM"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocPRIM/archive/${PV}.tar.gz -> rocPRIM-${PV}.tar.gz"
#EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/rocPRIM.git"
#EGIT_BRANCH="master-rocm-2.6"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="=sys-devel/hip-2.6*
	dev-util/rocm-cmake"
DEPEND="${RDEPEND}
	dev-util/cmake"

src_prepare() {
	cd ${S}
        eapply "${FILESDIR}/master-disable2ndfindhcc.patch"

	sed -e "s: PREFIX rocprim:# PREFIX rocprim:" -i rocprim/CMakeLists.txt
	sed -e "s:\$<INSTALL_INTERFACE\:rocprim/include/>:\$<INSTALL_INTERFACE\:include/>:" -i rocprim/CMakeLists.txt

	sed -e "s: DESTINATION rocprim/include/: DESTINATION include/:" -i rocprim/CMakeLists.txt
	sed -e "s:rocm_install_symlink_subdir(rocprim):#rocm_install_symlink_subdir(rocprim):" -i rocprim/CMakeLists.txt

        eapply_user
}

src_configure() {
        mkdir -p "${WORKDIR}/build/"
        cd "${WORKDIR}/build/"

#	export PATH=$PATH:/usr/lib/hcc/2.6/bin
	export hip_DIR=/usr/lib/hip/2.6/cmake/
	export HIP_DIR=/usr/lib/hip/2.6/cmake/
	export hcc_DIR=/usr/lib/hcc/2.6/lib/cmake/hcc/
	export CXX=/usr/lib/hcc/2.6/bin/hcc
#	export CXX=/usr/lib/hip/2.6/bin/hipcc

	export HIP_IGNORE_HCC_VERSION=1

	cmake -DCMAKE_CXX_COMPILER_FORCED=1 -DCMAKE_MODULE_PATH="/usr/lib/hip/2.6/cmake/" -DHIP_PLATFORM=hcc -DHIP_ROOT_DIR=/usr/lib/hip/2.6/ -DBUILD_TEST=OFF -DCMAKE_INSTALL_PREFIX=/usr/ ${S}
}

src_compile() {
        cd "${WORKDIR}/build/"
        make VERBOSE=1
}

src_install() {
        cd "${WORKDIR}/build/"
	emake DESTDIR="${D}" install
}


