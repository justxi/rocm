# Copyright
#

EAPI=7
inherit cmake flag-o-matic

DESCRIPTION="C++ Heterogeneous-Compute Interface for Portability"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/HIP"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ROCm-Developer-Tools/HIP.git"
	EGIT_BRANCH="master"
	inherit git-r3
	S="${WORKDIR}/${P}"
	KEYWORDS="**"
else
	SRC_URI="https://github.com/ROCm-Developer-Tools/HIP/archive/roc-${PV}.tar.gz -> rocm-hip-${PV}.tar.gz"
	S="${WORKDIR}/HIP-roc-${PV}"
	KEYWORDS="~amd64"
fi


LICENSE=""
SLOT="0/$(ver_cut 1-2)"

IUSE="debug +hipify +hcc-backend llvm-roc-backend"
REQUIRED_USE="^^ ( hcc-backend llvm-roc-backend )"

DEPEND=">=dev-libs/rocm-comgr-${PV}
	>=sys-devel/hcc-${PV}
	=dev-util/rocminfo-${PV}*
	hipify? ( >=sys-devel/clang-8.0.0 )
	llvm-roc-backend? ( =dev-libs/rocm-device-libs-${PV}* )
	llvm-roc-backend? ( =sys-devel/llvm-roc-${PV}* )"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply "${FILESDIR}/DisableTest.patch"
	eapply "${FILESDIR}/HIP-2.7.0-ROCM_PATH-LIB_PATH.patch"

	sed -e "s:#!/usr/bin/python:#!/usr/bin/python2:" -i hip_prof_gen.py || die

	# Due to setting HAS_PATH to "/usr", this results in setting "-isystem /usr/include"
	# which results in a "stdlib.h" not found while compiling "rocALUTION"
	# currently comment out, remove in future?
	sed -e "s:    \$HIPCXXFLAGS .= \" -isystem \$HSA_PATH/include\";:#    \$HIPCXXFLAGS .= \" -isystem \$HSA_PATH/include\";:" -i bin/hipcc || die

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
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/hip"
		-DBUILD_HIPIFY_CLANG=$(usex hipify)
		-DHIP_PLATFORM=hcc
		-DHIP_COMPILER=$(usex llvm-roc-backend "clang" "hcc")
		-DHCC_HOME=${HCC_HOME}
		-DHSA_PATH="/usr"
		-DCMAKE_BUILD_TYPE=${buildtype}
	)

	if use llvm-roc-backend; then
		mycmakeargs+=(
			-DCMAKE_PREFIX_PATH="/usr/lib/llvm/roc"
		)
	fi

	cmake_src_configure
}

src_install() {
	echo "HIP_PLATFORM=hcc" > 99hip || die
	echo "PATH=/usr/lib/hip/bin" >> 99hip || die
	echo "HIP_PATH=/usr/lib/hip" >> 99hip || die
	echo "LDPATH=/usr/lib/hip/lib" >> 99hip || die
	echo "ROOTPATH=/usr/lib/hip/bin" >> 99hip || die

	if use llvm-roc-backend; then
		echo "HIP_COMPILER=clang" >> 99hip || die
		echo "HIP_CLANG_PATH=/usr/lib/llvm/roc/bin" >> 99hip || die
		echo "DEVICE_LIB_PATH=/usr/lib/" >> 99hip || die
	fi

	doenvd 99hip

	cmake_src_install
}
