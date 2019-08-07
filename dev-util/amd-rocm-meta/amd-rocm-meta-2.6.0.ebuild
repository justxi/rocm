EAPI=7

SLOT="0/$(ver_cut 1-2)"

DESCRIPTION="Meta package for ROCm"
LICENSE="metapackage"

KEYWORDS="amd64 ~ia64 ~ppc ~ppc64 x86"

RDEPEND="=sys-devel/hcc-${PV}*
	=sys-devel/hip-${PV}*
	=dev-libs/rocm-opencl-runtime-${PV}*
	=dev-util/rocm-smi-${PV}*
	=dev-util/rocprofiler-${PV}*
	=dev-libs/rocr-debug-agent-${PV}*
	=dev-util/rocminfo-${PV}*
"

S="${WORKDIR}"
