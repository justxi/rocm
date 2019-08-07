EAPI=7

DESCRIPTION="Meta package for ROCm"
LICENSE="metapackage"

SLOT="0/$(ver_cut 1-2)"

KEYWORDS="~amd64"

IUSE="debug-tools extra"

RDEPEND="=dev-libs/rocm-opencl-runtime-${PV}*
	=sys-devel/hcc-${PV}*
	=sys-devel/hip-${PV}*
	=dev-util/rocminfo-${PV}*
	=dev-util/rocm-smi-${PV}*
	debug-tools? ( =dev-libs/rocr-debug-agent-${PV}* )
	debug-tools? ( =dev-util/rocprofiler-${PV}* )
	extra? ( =sci-libs/hipCUB-$(ver_cut 1-2)* )
	extra? ( =sci-libs/rocPRIM-$(ver_cut 1-2)* )
	extra? ( =sci-libs/rocRAND-$(ver_cut 1-2)* )
	extra? ( =sci-libs/rocThrust-$(ver_cut 1-2)* )
"

#disabled since not working
#	debug-tools? ( =dev-util/roctracer-${PV}* )
#	extra? ( =sci-libs/rocBLAS-$(ver_cut 1-2)* )
#	extra? ( =sci-libs/rocFFT-$(ver_cut 1-2)* )
