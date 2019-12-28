EAPI=7

DESCRIPTION="Meta package for ROCm"
LICENSE="metapackage"

SLOT="0/$(ver_cut 1-2)"

KEYWORDS="~amd64"

IUSE="debug-tools hip opencl profiling science"

RDEPEND="
	=dev-util/rocminfo-$(ver_cut 1-2)*
	=dev-libs/rocm-smi-lib-$(ver_cut 1-2)*
	=dev-util/rocm-smi-$(ver_cut 1-2)*
	=sys-devel/hcc-$(ver_cut 1-2)*

	opencl? ( >=dev-libs/rocm-opencl-runtime-$(ver_cut 1-2) )
	opencl? ( =dev-util/rocm-clang-ocl-$(ver_cut 1-2)* )

	hip? ( =sys-devel/hip-$(ver_cut 1-2)* )
	hip? ( =sci-libs/hipBLAS-$(ver_cut 1-2)* )
	hip? ( =sci-libs/hipCUB-$(ver_cut 1-2)* )
	hip? ( =sci-libs/hipSPARSE-$(ver_cut 1-2)* )

	science? ( =sci-libs/rocALUTION-$(ver_cut 1-2)* )
	science? ( =sci-libs/rocBLAS-$(ver_cut 1-2)* )
	science? ( =sci-libs/rocRAND-$(ver_cut 1-2)* )
	science? ( =sci-libs/rocFFT-$(ver_cut 1-2)* )
	science? ( =sci-libs/rocPRIM-$(ver_cut 1-2)* )
	science? ( =sci-libs/rocRAND-$(ver_cut 1-2)* )
	science? ( =sci-libs/rocSPARSE-$(ver_cut 1-2)* )
	science? ( =sci-libs/rocThrust-$(ver_cut 1-2)* )
	science? ( =sci-libs/rocSOLVER-$(ver_cut 1-2)* )

	profiling? ( =dev-util/rocm-bandwidth-test-$(ver_cut 1-2)* )

	debug-tools? ( =dev-libs/rocr-debug-agent-$(ver_cut 1-2)* )
	debug-tools? ( =dev-util/rocprofiler-$(ver_cut 1-2)* )
	debug-tools? ( =dev-util/roctracer-$(ver_cut 1-2)* )
"




