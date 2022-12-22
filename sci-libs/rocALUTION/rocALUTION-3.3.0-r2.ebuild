# Copyright
#

EAPI=7

inherit cmake

DESCRIPTION="Next generation library for iterative sparse solvers for ROCm platform"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocALUTION"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocALUTION/archive/rocm-${PV}.tar.gz -> rocALUTION-${PV}.tar.gz"

LICENSE=""
KEYWORDS="~amd64"
SLOT="0"

IUSE="+hip +openmp mpi +gfx803 gfx900 gfx906 gfx908"
REQUIRED_USE="|| ( hip openmp mpi )"
REQUIRED_USE="|| ( gfx803 gfx900 gfx906 gfx908 )"

RDEPEND="hip? ( =sys-devel/hip-$(ver_cut 1-2)* )
	 hip? ( =sci-libs/rocSPARSE-$(ver_cut 1-2)* )
	 hip? ( =sci-libs/rocBLAS-$(ver_cut 1-2)* )
	 mpi? ( virtual/mpi )
	 openmp? ( sys-devel/gcc[openmp] )"
DEPEND="${RDEPEND}
	dev-util/cmake"

CMAKE_BUILD_TYPE="RelWithDebInfo"

S="${WORKDIR}/${PN}-rocm-${PV}"

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
        if use gfx908; then
		echo "gfx908" > ${ROCM_TARGET_LST}
        fi

	sed -e "s:/opt/rocm/hip/cmake:/usr/lib/hip/cmake:" -i ${S}/CMakeLists.txt
	sed -e "s:PREFIX rocalution:#PREFIX rocalution:" -i ${S}/src/CMakeLists.txt
	sed -e "s:rocm_install_symlink_subdir(rocalution):#rocm_install_symlink_subdir(rocalution):" -i ${S}/src/CMakeLists.txt

	cmake_src_prepare
}

src_configure() {
	export hcc_DIR=/usr/lib/hcc/$(ver_cut 1-2)/lib/cmake/hcc/

	local mycmakeargs=(
		-DSUPPORT_OMP=$(usex openmp ON OFF)
		-DSUPPORT_HIP=$(usex hip ON OFF)
		-DSUPPORT_MPI=$(usex mpi ON OFF)
		-DCMAKE_INSTALL_INCLUDEDIR="include/rocALUTION"
		-DBUILD_CLIENTS_TESTS=OFF
		-DBUILD_CLIENTS_BENCHMARKS=OFF
		-DBUILD_CLIENTS_SAMPLES=ON
	)
	# ROCm 3.3: Ebuild fails if set "BUILD_CLIENTS_SAMPLES=ON" when rocBLAS is build -DBUILD_WITH_TENSILE_HOST=ON!

	cmake_src_configure
}

src_install() {
        cmake_src_install
        chrpath --delete "${D}/usr/lib64/librocalution.so.0.1"
}
