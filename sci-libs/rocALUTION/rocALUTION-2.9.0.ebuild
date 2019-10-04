# Copyright
#

EAPI=7

inherit cmake-utils

DESCRIPTION="Next generation library for iterative sparse solvers for ROCm platform"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocALUTION"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocALUTION/archive/rocm-$(ver_cut 1-2).tar.gz -> rocALUTION-${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS=""

IUSE="+hip +openmp mpi +gfx803 gfx900 gfx906"
REQUIRED_USE="|| ( hip openmp mpi )"
REQUIRED_USE="|| ( gfx803 gfx900 gfx906 )"

#RDEPEND="hip? ( =sys-devel/hip-$(ver_cut 1-2)* )
RDEPEND="hip? ( =sys-devel/hip-2.8* )
	 hip? ( =sci-libs/rocSPARSE-$(ver_cut 1-2)* )
	 hip? ( =sci-libs/rocBLAS-$(ver_cut 1-2)* )
	 mpi? ( virtual/mpi )
	 openmp? ( sys-devel/gcc[openmp] )"
DEPEND="${RDEPEND}
	dev-util/cmake"

CMAKE_BUILD_TYPE="RelWithDebInfo"

S="${WORKDIR}/${PN}-rocm-$(ver_cut 1-2)"

src_prepare() {
	export ROCM_TARGET_LST="${TEMP}/target.lst"
	echo "gfx000" > ${ROCM_TARGET_LST}
        if use gfx803; then
		echo "gfx803" > ${ROCM_TARGET_LST}
        fi
        if use gfx900; then
		echo "gfx900" > ${ROCM_TARGET_LST}
        fi
        if use gfx906; then
		echo "gfx906" > ${ROCM_TARGET_LST}
        fi

	sed -e "s:/opt/rocm/hip/cmake:/usr/lib/hip/cmake:" -i ${S}/CMakeLists.txt
	sed -e "s:PREFIX rocalution:#PREFIX rocalution:" -i ${S}/src/CMakeLists.txt
	sed -e "s:rocm_install_symlink_subdir(rocalution):#rocm_install_symlink_subdir(rocalution):" -i ${S}/src/CMakeLists.txt

	cmake-utils_src_prepare
}

src_configure() {
#	export hcc_DIR=/usr/lib/hcc/$(ver_cut 1-2)/lib/cmake/hcc/
	export hcc_DIR=/usr/lib/hcc/2.8/lib/cmake/hcc/

	local mycmakeargs=(
		-DSUPPORT_OMP=$(usex openmp ON OFF)
		-DSUPPORT_HIP=$(usex hip ON OFF)
		-DSUPPORT_MPI=$(usex mpi ON OFF)
		-DCMAKE_INSTALL_INCLUDEDIR="include/rocALUTION"
	)
	cmake-utils_src_configure
}

src_install() {
        cmake-utils_src_install
        chrpath --delete "${D}/usr/lib64/librocalution.so.0.1"
}
