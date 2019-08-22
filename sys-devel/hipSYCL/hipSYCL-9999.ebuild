#

EAPI=7
inherit cmake-utils flag-o-matic

DESCRIPTION="Implementation of SYCL 1.2.1 over AMD HIP/NVIDIA CUDA"
HOMEPAGE="https://github.com/illuhad/hipSYCL"

if [[ ${PV} == *9999 ]] ; then
        EGIT_REPO_URI="https://github.com/illuhad/hipSYCL"
        EGIT_BRANCH="master"
        inherit git-r3
        S="${WORKDIR}/${P}"
        KEYWORDS="**"
fi

LICENSE="BSD 2-Clause \"Simplified\" License"
SLOT="0"
IUSE="+rocm nvidia"
REQUIRED_USE="^^ ( rocm nvidia )"

DEPEND="rocm? ( =sys-devel/hip-2.7.9999-r100 )
	rocm? ( =sys-devel/llvm-roc-2.7.9999[!debug] )
	nvidia? ( >=dev-util/nvidia-cuda-toolkit-9.0 )"
RDEPEND="${DEPEND}
	 dev-util/cmake"

CMAKE_BUILD_TYPE=Release

#src_prepare() {
#	sed -e "s:LIBRARY DESTINATION lib:LIBRARY DESTINATION lib64" -i src/libhipSYCL/CMakeLists.txt
#
#	eapply_user
#	cmake-utils_src_prepare
#}

src_configure() {

	append-cxxflags -I/usr/lib/hip/include
	append-ldflags  -L/usr/lib/hip/lib/

	if use rocm; then
		local mycmakeargs=(
			-DLLVM_DIR=/usr/lib/llvm/roc/lib/cmake/llvm/
			-DCLANG_EXECUTABLE_PATH=/usr/lib/llvm/roc/bin/clang++
			-DCLANG_INCLUDE_PATH=/usr/lib64/llvm/roc/lib/clang/10.0.0/include/
			-DROCM_PATH=/usr/
			-DCMAKE_INSTALL_PREFIX=/usr/local
		)
	fi

	cmake-utils_src_configure
}
