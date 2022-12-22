# Copyright
#

EAPI=7

inherit cmake

DESCRIPTION="ROC profiler library."
HOMEPAGE="https://github.com/ROCm-Developer-Tools/rocprofiler.git"
SRC_URI="https://github.com/ROCm-Developer-Tools/rocprofiler/archive/roc-${PV}.tar.gz -> rocprofiler-${PV}.tar.gz"

LICENSE=""
KEYWORDS="~amd64"
SLOT="0"

IUSE="debug"

RDEPEND="media-libs/hsa-amd-aqlprofile
         dev-libs/rocr-runtime"
DEPEND="dev-util/cmake
	${RDEPEND}"

PATCHES=(
        "${FILESDIR}/${P}-install.patch"
)

S="${WORKDIR}/rocprofiler-roc-${PV}"


src_configure() {
	export CMAKE_PREFIX_PATH=/usr/include/hsa:/usr/lib/

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
        )

	if use debug; then
		mycmakeargs+=(
			export CMAKE_BUILD_TYPE=debug
#			export CMAKE_DEBUG_TRACE=1
#			export CMAKE_LD_AQLPROFILE=1
		)
	fi

	cmake_src_configure
}

pkg_postinst() {
        elog "If there is an error about \"aqlprofile ...\", try to preload the library libhsa-amd-aqlprofile64.so"
        elog "> LD_PRELOAD=/usr/lib64/libhsa-amd-aqlprofile64.so.1.0.0 [command]"
}
