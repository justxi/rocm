# Copyright
#

EAPI=7

inherit cmake-utils

DESCRIPTION="Implementation of a subset of LAPACK functionality on the ROCm platform"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocSOLVER"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocSOLVER/archive/${PV}.tar.gz -> rocSOLVER-${PV}.tar.gz"

LICENSE=""
KEYWORDS="~amd64"
SLOT="0"

IUSE="+gfx803 gfx900 gfx906"
REQUIRED_USE="^^ ( gfx803 gfx900 gfx906 )"

RDEPEND=">=sys-devel/hip-${PV}
	 >=sci-libs/rocBLAS-${PV}"
DEPEND="${RDEPEND}
	dev-util/cmake
	sys-devel/hcc
	>=dev-util/ninja-1.9.0"

src_prepare() {
	eapply "${FILESDIR}/rocSOLVER-3.0.0-add_include_path.patch"

	sed -e "s: PREFIX rocsolver:# PREFIX rocsolver:" -i library/src/CMakeLists.txt
	sed -e "s:\$<INSTALL_INTERFACE\:include>:\$<INSTALL_INTERFACE\:include/rocsolver>:" -i library/src/CMakeLists.txt
	sed -e "s:rocm_install_symlink_subdir( rocsolver ):#rocm_install_symlink_subdir( rocsolver ):" -i library/src/CMakeLists.txt

	cmake-utils_src_prepare
}

src_configure() {
	export CXX=${HCC_HOME}/bin/hcc

        # if the ISA is not set previous to the autodetection,
        # /opt/rocm/bin/rocm_agent_enumerator is executed,
        # this leads to a sandbox violation
        if use gfx803; then
                CurrentISA="803"
        fi
        if use gfx900; then
                CurrentISA="900"
        fi
        if use gfx906; then
                CurrentISA="906"
        fi

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=/usr/
		-DCMAKE_INSTALL_INCLUDEDIR=/usr/include/rocsolver
		-DCMAKE_CXX_FLAGS="--amdgpu-target=gfx${CurrentISA}"
		-DBUILD_CLIENTS_SAMPLES=NO
		-DBUILD_CLIENTS_TESTS=NO
		-DBUILD_CLIENTS_BENCHMARKS=NO
		-Wno-dev
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	chrpath --delete "${D}/usr/lib64/librocsolver.so.2.7.0.50-a038b53-dirty"
}
