EAPI=7

DESCRIPTION="Meta package for ROCm"
LICENSE="metapackage"

SLOT="0/$(ver_cut 1-2)"

KEYWORDS="amd64"

IUSE="debug-tools hip opencl profiling science"

RDEPEND="
	>=dev-util/rocminfo-${PV}
	>=dev-libs/rocm-smi-lib-${PV}
	>=dev-util/rocm-smi-${PV}

	opencl? (
		>=dev-libs/rocm-opencl-runtime-${PV}
		>=dev-util/rocm-clang-ocl-${PV}
	)

	hip? (
		>=sys-devel/hip-${PV}
		science? (
			>=sci-libs/hipBLAS-${PV}
			>=sci-libs/hipCUB-${PV}
			>=sci-libs/hipSPARSE-${PV}
		)
	)

	profiling? ( >=dev-util/rocm-bandwidth-test-${PV} )

	debug-tools? (
		>=dev-libs/rocr-debug-agent-${PV}
		>=dev-util/rocprofiler-${PV}
		>=dev-util/roctracer-${PV}
	)

	science? (
		>=sci-libs/rocALUTION-${PV}
		>=sci-libs/rocBLAS-${PV}
		>=sci-libs/rocRAND-${PV}
		>=sci-libs/rocFFT-${PV}
		>=sci-libs/rocPRIM-${PV}
		>=sci-libs/rocRAND-${PV}
		>=sci-libs/rocSPARSE-${PV}
		>=sci-libs/rocThrust-${PV}
		>=sci-libs/rocSOLVER-${PV}
	)
"
