# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Next generation library for iterative sparse solvers for ROCm platform"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocALUTION"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocALUTION/archive/rocm-${PV}.tar.gz -> rocALUTION-${PV}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"

IUSE="hip +openmp mpi samples"
REQUIRED_USE="|| ( hip openmp mpi )"

RDEPEND="hip? ( =dev-util/hip-$(ver_cut 1-2)* )
	 hip? ( =sci-libs/rocSPARSE-$(ver_cut 1-2)* )
	 hip? ( =sci-libs/rocBLAS-$(ver_cut 1-2)* )
	 mpi? ( virtual/mpi )
	 openmp? ( sys-devel/gcc[openmp] )"
DEPEND="${RDEPEND}
	dev-util/cmake"

CMAKE_BUILD_TYPE="RelWithDebInfo"

S="${WORKDIR}/${PN}-rocm-${PV}"

src_prepare() {
	sed -e "s:/opt/rocm/hip/cmake:\${EPREFIX}/usr/lib/hip/cmake:" -i "${S}/CMakeLists.txt" || die

	sed -e "s: PREFIX rocalution):):" -i "${S}/src/CMakeLists.txt" || die
	sed -e "s:PREFIX rocalution:#PREFIX rocalution:" -i "${S}/src/CMakeLists.txt" || die
	sed -e "s:rocm_install_symlink_subdir(rocalution):#rocm_install_symlink_subdir(rocalution):" -i "${S}/src/CMakeLists.txt" || die

	cmake_src_prepare
}

src_configure() {
        # Grant access to the device to omit a sandbox violation
        addwrite /dev/kfd
        addpredict /dev/dri/

	# Compiler to use
	export CXX="/usr/lib/hip/bin/hipcc";

	local mycmakeargs=(
		-DCMAKE_CXX_FLAGS="--rocm-path=/usr"
		-DSUPPORT_OMP=$(usex openmp ON OFF)
		-DSUPPORT_HIP=$(usex hip ON OFF)
		-DSUPPORT_MPI=$(usex mpi ON OFF)
		-DBUILD_CLIENTS_SAMPLES=$(usex samples ON OFF)
		-DBUILD_CLIENTS_BENCHMARKS=OFF
		-DBUILD_CLIENTS_TESTS=OFF
		-DCMAKE_INSTALL_INCLUDEDIR="include/rocALUTION"
	)

	cmake_src_configure
}

src_install() {
        cmake_src_install
        chrpath --delete "${D}/usr/lib64/librocalution.so.0.1"
}
