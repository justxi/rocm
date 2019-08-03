EAPI=7

DESCRIPTION="Meta package for ROCm"
LICENSE="metapackage"

SLOT="0/$(ver_cut 1-2)"

KEYWORDS="~amd64"

IUSE="debug-tools"

RDEPEND="=dev-libs/rocm-opencl-runtime-${PV}*
	=sys-devel/hcc-${PV}*
	=sys-devel/hip-${PV}*
	=dev-util/rocminfo-${PV}*
	=dev-util/rocm-smi-${PV}*
	=dev-util/rocprofiler-${PV}*
	debug-tools? ( =dev-libs/rocr-debug-agent-${PV}* )"
