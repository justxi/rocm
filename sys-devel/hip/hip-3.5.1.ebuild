# Copyright
#

EAPI=7
inherit cmake-utils flag-o-matic

DESCRIPTION="C++ Heterogeneous-Compute Interface for Portability"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/HIP"
SRC_URI="https://github.com/ROCm-Developer-Tools/HIP/archive/rocm-${PV}.tar.gz -> rocm-hip-${PV}.tar.gz"

KEYWORDS="~amd64"
LICENSE=""
SLOT="0/$(ver_cut 1-2)"

IUSE="debug hipify profile"

# Don't strip to prevent some tests failure
RESRICT="strip"

DEPEND=">=dev-libs/rocclr-$(ver_cut 1-2)
	>=dev-util/rocminfo-$(ver_cut 1-2)
	=sys-devel/llvm-roc-${PV}*
	hipify? ( >=sys-devel/clang-10.0.0 )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-3.5.0-DisableTest.patch"
	"${FILESDIR}/${PN}-3.5.0-hipcc.patch"
)

S="${WORKDIR}/HIP-rocm-${PV}"

src_prepare() {
	# Due to setting HAS_PATH to "/usr", this results in setting "-isystem /usr/include"
	# which results in a "stdlib.h" not found while compiling "rocALUTION"
	# currently comment out, remove in future?
	sed -e "s:    \$HIPCXXFLAGS .= \" -isystem \$HSA_PATH/include\";:#    \$HIPCXXFLAGS .= \" -isystem \$HSA_PATH/include\";:" -i bin/hipcc || die

	eapply_user
	cmake-utils_src_prepare
}

src_configure() {
	strip-flags
	if ! use debug; then
		append-cflags "-DNDEBUG"
		append-cxxflags "-DNDEBUG"
		buildtype="Release"
	else
		buildtype="Debug"
	fi

	# TODO: Currently a GENTOO configuration is build,
	# this is also used in the cmake configuration files
	# which will be installed to find HIP;
	# Other ROCm packages expect a "RELEASE" configuration,
	# see "hipBLAS"
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=${buildtype}
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/hip/$(ver_cut 1-2)"
		-DBUILD_HIPIFY_CLANG=$(usex hipify)
		-DHIP_COMPILER=clang
		-DHIP_PLATFORM=rocclr
		-DROCM_PATH=/usr
		-DHSA_PATH="/usr"
		-DUSE_PROF_API=$(usex profile 1 0)
		-DROCclr_DIR=/usr/include/rocclr
		-DLIBROCclr_STATIC_DIR=/usr/lib64/cmake/rocclr
	)

	cmake-utils_src_configure
}

src_install() {
	echo "ROCM_PATH=/usr" > 99hip || die
	echo "HIP_PLATFORM=rocclr" > 99hip || die
	echo "HIP_RUNTIME=ROCclr" >> 99hip || die
	echo "HIP_COMPILER=clang" >> 99hip || die
	echo "HIP_CLANG_PATH=/usr/lib/llvm/roc/bin" >> 99hip || die

	echo "PATH=/usr/lib/hip/$(ver_cut 1-2)/bin" >> 99hip || die
	echo "HIP_PATH=/usr/lib/hip/$(ver_cut 1-2)" >> 99hip || die
	echo "LDPATH=/usr/lib/hip/$(ver_cut 1-2)/lib" >> 99hip || die
	echo "ROOTPATH=/usr/lib/hip/$(ver_cut 1-2)/bin" >> 99hip || die

	doenvd 99hip

	cmake-utils_src_install
}
