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
# wait for release...

LICENSE="BSD 2-Clause \"Simplified\" License"
SLOT="0"

# Currently different branches of clang are necessary to build for nVidia or ROCm backend
# there only one of the backends can be enabled
IUSE="+rocm nvidia +cuda9 cuda10"
REQUIRED_USE="^^ ( rocm nvidia )"

# only selected versions of CUDA in combination with clang are supported
# see: https://github.com/illuhad/hipSYCL/blob/master/doc/install-cuda.md
REQUIRED_USE="^^ ( cuda9 cuda10 )"

# While the needed dependencies for CUDA are almost in Gentoo portage,
# the dependencies for ROCm are not completely stable
DEPEND="rocm? ( =sys-devel/hip-2.7.9999-r100 )
	rocm? ( =sys-devel/llvm-roc-2.7.9999[-debug] )
	nvidia? ( >=dev-util/nvidia-cuda-toolkit-9.0 )
	nvidia? (
		cuda9? (
			=sys-devel/clang-8*[llvm_targets_NVPTX,-debug]
			=dev-util/nvidia-cuda-toolkit-9* )
		cuda10? (
			=sys-devel/clang-9*[llvm_targets_NVPTX,-debug]
			=dev-util/nvidia-cuda-toolkit-10.0* )
	)"
RDEPEND="${DEPEND}
	 dev-util/cmake"

CMAKE_BUILD_TYPE=Release

src_prepare() {
	sed -e "s:LIBRARY DESTINATION lib:LIBRARY DESTINATION lib64:" -i src/libhipSYCL/CMakeLists.txt || die
	sed -e "s:LIBRARY DESTINATION lib:LIBRARY DESTINATION lib64:" -i src/hipsycl_clang_plugin/CMakeLists.txt || die
	sed -e "s:os.path.join(config.hipsycl_installation_path,\"lib/\"):os.path.join(config.hipsycl_installation_path,\"lib64/\"):" -i bin/syclcc-clang || die
	eapply_user
	cmake-utils_src_prepare
}

src_configure() {

	append-cxxflags -I/usr/lib/hip/include
	append-ldflags  -L/usr/lib/hip/lib/

	if use rocm; then
		local mycmakeargs=(
			-DLLVM_DIR=/usr/lib/llvm/roc/lib/cmake/llvm/
			-DCLANG_EXECUTABLE_PATH=/usr/lib/llvm/roc/bin/clang++
			-DCLANG_INCLUDE_PATH=/usr/lib64/llvm/roc/lib/clang/10.0.0/include/
			-DROCM_PATH=/usr/
		)
	fi

	if use nvidia; then
		local mycmakeargs=(
			-DCLANG_INCLUDE_PATH=/usr/lib/llvm/8/include/clang/
		)
	fi

	mycmakeargs+=(
		-DSYCLCC_CONFIG_FILE_GLOBAL_INSTALLATION=true
		-DCMAKE_INSTALL_PREFIX=/usr
	)

	cmake-utils_src_configure
}
