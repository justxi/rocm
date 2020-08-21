EAPI=7

inherit cmake-utils flag-o-matic

DESCRIPTION="C++ Heterogeneous-Compute Interface for Portability"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/HIP"
SRC_URI="https://github.com/ROCm-Developer-Tools/HIP/archive/rocm-${PV}.tar.gz -> rocm-hip-${PV}.tar.gz"

KEYWORDS="amd64"
LICENSE="MIT"

SLOT="0/$(ver_cut 1-2)"

IUSE="debug hipify profile"

DEPEND=">=dev-libs/rocclr-${PV}
	>=dev-libs/rocm-comgr-${PV}
	>=dev-util/rocminfo-$(ver_cut 1-2)
	>=dev-libs/rocm-device-libs-$(ver_cut 1-2)
	>=sys-devel/llvm-roc-${PV}
	>=dev-util/rocm-clang-ocl-${PV}
	hipify? ( >=sys-devel/clang-10.0.0 )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-3.7.0-DisableTest.patch"
	"${FILESDIR}/${PN}-3.7.0-config-cmake-in.patch"
	"${FILESDIR}/${PN}-3.7.0-hip_vector_types.patch"
	"${FILESDIR}/${PN}-3.7.0-fp16-failed.patch"
)

S="${WORKDIR}/HIP-rocm-${PV}"

src_prepare() {
	# "hcc" is deprecated and not installed, new platform is "rocclr"
	sed -e "s:\$HIP_PLATFORM eq \"hcc\" and \$HIP_COMPILER eq \"clang\":\$HIP_PLATFORM eq \"rocclr\" and \$HIP_COMPILER eq \"clang\":" -i "${S}/bin/hipcc"

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

	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=${buildtype}
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/hip/$(ver_cut 1-2)"
		-DBUILD_HIPIFY_CLANG=$(usex hipify)
		-DHIP_COMPILER=clang
		-DHIP_PLATFORM=rocclr
		-DHIP_RUNTIME=ROCclr
		-DROCM_PATH=/usr
		-DHSA_PATH=/usr
		-DUSE_PROF_API=$(usex profile 1 0)
		-DROCclr_DIR=/usr/include/rocclr
		-DLIBROCclr_STATIC_DIR=/usr/lib64/cmake/rocclr
	)

	cmake-utils_src_configure
}

src_install() {
	echo "HSA_PATH=/usr" > 99hip || die
	echo "ROCM_PATH=/usr" >> 99hip || die
	echo "HIP_PLATFORM=rocclr" >> 99hip || die
	echo "HIP_RUNTIME=ROCclr" >> 99hip || die
	echo "HIP_COMPILER=clang" >> 99hip || die
	echo "HIP_CLANG_PATH=/usr/lib/llvm/roc/$(ver_cut 1-2)/bin" >> 99hip || die

	echo "PATH=/usr/lib/hip/$(ver_cut 1-2)/bin" >> 99hip || die
	echo "HIP_PATH=/usr/lib/hip/$(ver_cut 1-2)" >> 99hip || die
	echo "LDPATH=/usr/lib/hip/$(ver_cut 1-2)/lib" >> 99hip || die
	echo "ROOTPATH=/usr/lib/hip/$(ver_cut 1-2)/bin" >> 99hip || die

	doenvd 99hip

	cmake-utils_src_install
}
