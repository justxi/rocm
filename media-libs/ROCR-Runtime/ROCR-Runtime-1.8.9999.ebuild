# Copyright
# 

EAPI=6
inherit cmake-utils git-r3

DESCRIPTION="ROCKR-runtime"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCR-Runtime/tree/roc-1.8.x"
EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCR-Runtime/"
EGIT_BRANCH="roc-1.8.x"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=">=media-libs/ROCT-Thunk-Interface-1.8"

S="${WORKDIR}/${P}/src"

src_install() {

        dolib.so "${BUILD_DIR}/libhsa-runtime64.so.1.0.0"
        dosym "libhsa-runtime64.so.1.0.0" "/usr/$(get_libdir)/libhsa-runtime64.so"
        dosym "libhsa-runtime64.so.1.0.0" "/usr/$(get_libdir)/libhsa-runtime64.so.1"

        insinto "/usr/include/hsa"
        doins "${S}/inc/amd_hsa_common.h"
        doins "${S}/inc/amd_hsa_elf.h"
        doins "${S}/inc/amd_hsa_kernel_code.h"
        doins "${S}/inc/amd_hsa_queue.h"
        doins "${S}/inc/amd_hsa_signal.h"
        doins "${S}/inc/Brig.h"
        doins "${S}/inc/hsa_api_trace.h"
        doins "${S}/inc/hsa_ext_amd.h"
        doins "${S}/inc/hsa_ext_finalize.h"
        doins "${S}/inc/hsa_ext_image.h"
        doins "${S}/inc/hsa.h"
        doins "${S}/inc/hsa_ven_amd_aqlprofile.h"
        doins "${S}/inc/hsa_ven_amd_loader.h"
}
