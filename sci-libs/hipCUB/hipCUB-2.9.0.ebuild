# Copyright
#

EAPI=7

inherit cmake-utils git-r3

DESCRIPTION=""
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipCUB"
SRC_URI="https://github.com/ROCmSoftwarePlatform/hipCUB/archive/${PV}.tar.gz -> hipCUB-$(ver_cut 1-2).tar.gz"
#EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/hipCUB"
#EGIT_BRANCH="master-rocm-2.9"
#EGIT_COMMIT=""

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE=""

S="${WORKDIR}/hipCUB-rocm-$(ver_cut 1-2)"

RDEPEND="=sys-devel/hip-$(ver_cut 1-2)*
         =sci-libs/rocPRIM-${PV}*"
DEPEND="${RDEPEND}
	dev-util/cmake"

src_prepare() {
	eapply "${FILESDIR}/master-disable2ndfindhcc.patch"

        sed -e "s:find_package(HIP 1.5.18263 REQUIRED):find_package(HIP 2.8.19386 REQUIRED):" -i cmake/VerifyCompiler.cmake

	sed -e "s: PREFIX hipcub:# PREFIX hipcub:" -i ${S}/hipcub/CMakeLists.txt
	sed -e "s:  DESTINATION hipcub/include/:  DESTINATION include/:" -i ${S}/hipcub/CMakeLists.txt
	sed -e "s:rocm_install_symlink_subdir(hipcub):#rocm_install_symlink_subdir(hipcub):" -i ${S}/hipcub/CMakeLists.txt
	sed -e "s:<INSTALL_INTERFACE\:hipcub/include/:<INSTALL_INTERFACE\:include/hipcub/:" -i ${S}/hipcub/CMakeLists.txt

	# TODO: Install to "/usr/lib64/cmake" instead of "/usr/lib/cmake"?

	eapply_user
	cmake-utils_src_prepare
}

src_configure() {
#	export hip_DIR=/usr/lib/hip/$(ver_cut 1-2)/lib/cmake/

	export HCC_ROOT=/usr/lib/hcc/$(ver_cut 1-2)
	export hcc_DIR=${HCC_ROOT}/lib/cmake/
	export CXX=${HCC_ROOT}/bin/hcc

	local mycmakeargs=(
		-DHIP_PLATFORM=hcc
		-DBUILD_TEST=OFF
		-Drocprim_DIR=/usr
		-DCMAKE_INSTALL_PREFIX=/usr
	)

	cmake-utils_src_configure
}
