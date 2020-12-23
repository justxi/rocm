# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="ROC profiler library."
HOMEPAGE="https://github.com/ROCm-Developer-Tools/rocprofiler.git"
SRC_URI="https://github.com/ROCm-Developer-Tools/rocprofiler/archive/rocm-${PV}.tar.gz -> rocprofiler-${PV}.tar.gz"

LICENSE=""
KEYWORDS="~amd64"
SLOT="0"

IUSE="debug"

RDEPEND="media-libs/hsa-amd-aqlprofile
         dev-libs/rocr-runtime
	 dev-util/roctracer"
DEPEND="dev-util/cmake
	${RDEPEND}"

PATCHES=(
        "${FILESDIR}/rocprofiler-4.0.0-install.patch"
)

S="${WORKDIR}/rocprofiler-rocm-${PV}"

src_prepare() {
	# header "string" is not included...
	sed -e "s:#include <vector>:#include <vector>\n#include <string>:" -i "${S}/test/simple_convolution/simple_convolution.h"

	cmake-utils_src_prepare
}

src_configure() {
	export CMAKE_PREFIX_PATH=/usr/include/hsa:/usr/lib/

#	export CMAKE_DEBUG_TRACE=1
#	export CMAKE_LD_AQLPROFILE=1

	local mycmakeargs=(
		-DUSE_PROF_API=OFF
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DPROF_API_HEADER_PATH="/usr/include/roctracer/ext/"
        )

	if use debug; then
		mycmakeargs+=(
			-DCMAKE_BUILD_TYPE=debug
		)
	fi

	cmake-utils_src_configure
}

pkg_postinst() {
        elog "If there is an error about \"aqlprofile ...\", try to preload the library libhsa-amd-aqlprofile64.so"
        elog "> LD_PRELOAD=/usr/lib64/libhsa-amd-aqlprofile64.so.1.0.0 [command]"
}
