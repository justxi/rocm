EAPI=6

inherit versionator
SLOT="2.1"

P_RELEASE="$(get_version_components 2)"

DESCRIPTION="Meta package for ROCm"
LICENSE="metapackage"

KEYWORDS="amd64 ~ia64 ~ppc ~ppc64 x86"

RDEPEND="=sys-devel/hcc-${PV}*
	=sys-devel/hip-${PV}*
	=dev-libs/rocm-opencl-runtime-${PV}*
	=dev-util/rocm-smi-${PV}*
	=dev-util/rocprofiler-${PV}*
"

S="${WORKDIR}"
