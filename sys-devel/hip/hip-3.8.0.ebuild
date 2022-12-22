# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake flag-o-matic

DESCRIPTION="C++ Heterogeneous-Compute Interface for Portability"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/HIP"
SRC_URI="https://github.com/ROCm-Developer-Tools/HIP/archive/rocm-${PV}.tar.gz -> rocm-hip-${PV}.tar.gz"

KEYWORDS="~amd64"
LICENSE=""
SLOT="0/$(ver_cut 1-2)"

IUSE="debug hipify profile"
# Currently enabling "hipify" is known to fail!

# Don't strip to prevent some tests failure
RESRICT="strip"

DEPEND=">=dev-libs/rocclr-$(ver_cut 1-2)
	>=dev-util/rocminfo-$(ver_cut 1-2)
	=sys-devel/llvm-roc-${PV}*[runtime]
	hipify? ( >=sys-devel/clang-10.0.0 )"
RDEPEND="${DEPEND}"


PATCHES=(
	"${FILESDIR}/${PN}-3.7.0-DisableTest.patch"
	"${FILESDIR}/${PN}-3.7.0-add-include-directories.patch"
	"${FILESDIR}/${PN}-3.5.1-config-cmake-in.patch"
	"${FILESDIR}/${PN}-3.5.1-hip_vector_types.patch"
	"${FILESDIR}/${PN}-3.5.1-detect_offload-arch_for_clang-roc.patch"
)

S="${WORKDIR}/HIP-rocm-${PV}"

src_prepare() {
	# "hcc" is deprecated and not installed, new platform is "rocclr"
	sed -e "s:\$HIP_PLATFORM eq \"hcc\" and \$HIP_COMPILER eq \"clang\":\$HIP_PLATFORM eq \"rocclr\" and \$HIP_COMPILER eq \"clang\":" -i "${S}/bin/hipcc" || die

	# Due to setting HAS_PATH to "/usr", this results in setting "-isystem /usr/include"
	# which results in a "stdlib.h" not found while compiling "rocALUTION"
	# currently comment out, remove in future?
	sed -e "s:    \$HIPCXXFLAGS .= \" -isystem \$HSA_PATH/include\";:#    \$HIPCXXFLAGS .= \" -isystem \$HSA_PATH/include\";:" -i bin/hipcc || die

	#prefixing hipcc and its utils
	grep -rl --exclude-dir=build/ "/usr" ${S} | xargs sed -e "s:/usr:${EPREFIX}/usr:g" -i || die

	eapply_user
	cmake_src_prepare
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
		-DHIP_PLATFORM=rocclr
		-DHIP_COMPILER=clang
		-DHIP_RUNTIME=ROCclr
		-DROCM_PATH="${EPREFIX}/usr"
		-DHSA_PATH="${EPREFIX}/usr"
		-DUSE_PROF_API=$(usex profile 1 0)
		-DROCclr_DIR=${EPREFIX}/usr/include/rocclr
		-DLIBROCclr_STATIC_DIR=${EPREFIX}/usr/lib64/cmake/rocclr
	)

	cmake_src_configure
}

src_install() {
	echo "HSA_PATH=${EPREFIX}/usr" > 99hip || die
	echo "ROCM_PATH=${EPREFIX}/usr" >> 99hip || die
#	echo "HIP_PLATFORM=hcc" >> 99hip || die
	echo "HIP_PLATFORM=rocclr" >> 99hip || die
	echo "HIP_RUNTIME=ROCclr" >> 99hip || die
	echo "HIP_COMPILER=clang" >> 99hip || die
	echo "HIP_CLANG_PATH=${EPREFIX}/usr/lib/llvm/roc/bin" >> 99hip || die

	echo "PATH=${EPREFIX}/usr/lib/hip/$(ver_cut 1-2)/bin" >> 99hip || die
	echo "HIP_PATH=${EPREFIX}/usr/lib/hip/$(ver_cut 1-2)" >> 99hip || die
	echo "LDPATH=${EPREFIX}/usr/lib/hip/$(ver_cut 1-2)/lib" >> 99hip || die
	echo "ROOTPATH=${EPREFIX}/usr/lib/hip/$(ver_cut 1-2)/bin" >> 99hip || die

	doenvd 99hip

	cmake_src_install
}
