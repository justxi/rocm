EAPI=7

inherit cmake-utils

DESCRIPTION="ROC profiler library"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/rocprofiler"
SRC_URI="https://github.com/ROCm-Developer-Tools/rocprofiler/archive/rocm-${PV}.tar.gz -> rocprofiler-${PV}.tar.gz"

LICENSE="MIT"
KEYWORDS="amd64"
SLOT="0/$(ver_cut 1-2)"

IUSE="debug"

RDEPEND="media-libs/hsa-amd-aqlprofile
	dev-libs/rocr-runtime"
DEPEND="dev-util/rocm-cmake
	${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-install.patch"
)

S="${WORKDIR}/rocprofiler-rocm-${PV}"


src_configure() {
	export CMAKE_PREFIX_PATH=/usr/include/hsa:/usr/lib/

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
        )

	if use debug; then
		mycmakeargs+=(
			-DCMAKE_BUILD_TYPE=debug
#			-DCMAKE_DEBUG_TRACE=1
#			-DCMAKE_LD_AQLPROFILE=1
		)
	fi

	cmake-utils_src_configure
}

pkg_postinst() {
	elog "If there is an error about \"aqlprofile ...\", try to preload the library libhsa-amd-aqlprofile64.so"
	elog "> LD_PRELOAD=/usr/lib64/libhsa-amd-aqlprofile64.so.1.0.0 [command]"
}
