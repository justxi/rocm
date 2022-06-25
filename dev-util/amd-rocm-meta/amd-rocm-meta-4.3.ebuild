# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Meta package for ROCm 4.3"
LICENSE="metapackage"

SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="debug-tools hip opencl profiling science"

# This ROCm version...
ROCMVER="$(ver_cut 1-2)"

# The next significant (minor) ROCm version...
ROCMNEXTVER="$(ver_cut 1).$(($(ver_cut 2)+1))"

RDEPEND="
	=dev-util/rocminfo-${ROCMVER}*
	=dev-util/rocm-smi-${ROCMVER}*

	=dev-util/rocm-cmake-${ROCMVER}*
	=sys-devel/llvm-roc-${ROCMVER}*
	=dev-libs/rocm-device-libs-${ROCMVER}*
	=dev-libs/rocclr-${ROCMVER}*
	=dev-libs/rocm-comgr-${ROCMVER}*
	=dev-libs/rocm-opencl-runtime-${ROCMVER}*
	=dev-libs/rocr-runtime-${ROCMVER}*
	=dev-libs/rccl-${ROCMVER}*

	opencl? ( =dev-libs/rocm-opencl-runtime-${ROCMVER}* )
	opencl? ( =dev-util/rocm-clang-ocl-${ROCMVER}* )

	hip? ( =dev-util/hip-${ROCMVER}* )

	profiling? ( =dev-util/rocm_bandwidth_test-${ROCMVER}* )

	debug-tools? ( =dev-libs/rocm-debug-agent-${ROCMVER}* )
	debug-tools? ( =dev-util/rocprofiler-${ROCMVER}* )
	debug-tools? ( =dev-util/roctracer-${ROCMVER}* )

	hip? ( science? ( =sci-libs/hipBLAS-${ROCMVER}* ) )
	hip? ( science? ( =sci-libs/hipCUB-${ROCMVER}* ) )
	hip? ( science? ( =sci-libs/hipFFT-${ROCMVER}* ) )
	hip? ( science? ( =sci-libs/hipSPARSE-${ROCMVER}* ) )

	science? ( =sci-libs/hipBLAS-${ROCMVER}* )
	science? ( =sci-libs/rocBLAS-${ROCMVER}* )
	science? ( =sci-libs/hipCUB-${ROCMVER}* )
	science? ( =sci-libs/hipFFT-${ROCMVER}* )
	science? ( =sci-libs/rocFFT-${ROCMVER}* )
	science? ( =sci-libs/rocPRIM-${ROCMVER}* )
	science? ( =sci-libs/rocRAND-${ROCMVER}* )
	science? ( =sci-libs/hipSPARSE-${ROCMVER}* )
	science? ( =sci-libs/rocSPARSE-${ROCMVER}* )
	science? ( =sci-libs/rocThrust-${ROCMVER}* )
	science? ( =sci-libs/rocSOLVER-${ROCMVER}* )

	!dev-libs/rocm-sci-lib
	!<media-libs/hsa-amd-aqlprofile-${ROCMVER} !>=media-libs/hsa-amd-aqlprofile-${ROCMNEXTVER}
	!<dev-libs/rocclr-${ROCMVER} !>=dev-libs/rocclr-${ROCMNEXTVER}

	!<dev-libs/rocm-opencl-runtime-${ROCMVER} !>=dev-libs/rocm-opencl-runtime-${ROCMNEXTVER}
	!<dev-util/rocm-clang-ocl-${ROCMVER} !>=dev-util/rocm-clang-ocl-${ROCMNEXTVER}

	!<dev-util/hip-${ROCMVER} !>=dev-util/hip-${ROCMNEXTVER}

	!<dev-util/rocm_bandwidth_test-${ROCMVER} !>=dev-util/rocm_bandwidth_test-${ROCMNEXTVER}

	!<dev-util/rocprofiler-${ROCMVER} !>=dev-util/rocprofiler-${ROCMNEXTVER}
	!<dev-util/roctracer-${ROCMVER} !>=dev-util/roctracer-${ROCMNEXTVER}
	!<dev-libs/amd-dbgapi-${ROCMVER} !>=dev-libs/amd-dbgapi-${ROCMNEXTVER}
	!<dev-libs/rocm-debug-agent-${ROCMVER} !>=dev-libs/rocm-debug-agent-${ROCMNEXTVER}

	!<sci-libs/hipBLAS-${ROCMVER} !>=sci-libs/hipBLAS-${ROCMNEXTVER}
	!<sci-libs/hipCUB-${ROCMVER} !>=sci-libs/hipCUB-${ROCMNEXTVER}
	!<sci-libs/hipFFT-${ROCMVER} !>=sci-libs/hipFFT-${ROCMNEXTVER}
	!<sci-libs/hipSPARSE-${ROCMVER} !>=sci-libs/hipSPARSE-${ROCMNEXTVER}

	!<sci-libs/rocBLAS-${ROCMVER} !>=sci-libs/rocBLAS-${ROCMNEXTVER}
	!<sci-libs/rocFFT-${ROCMVER} !>=sci-libs/rocFFT-${ROCMNEXTVER}
	!<sci-libs/rocPRIM-${ROCMVER} !>=sci-libs/rocPRIM-${ROCMNEXTVER}
	!<sci-libs/rocRAND-${ROCMVER} !>=sci-libs/rocRAND-${ROCMNEXTVER}
	!<sci-libs/rocSOLVER-${ROCMVER} !>=sci-libs/rocSOLVER-${ROCMNEXTVER}
	!<sci-libs/rocSPARSE-${ROCMVER} !>=sci-libs/rocSPARSE-${ROCMNEXTVER}
	!<sci-libs/rocThrust-${ROCMVER} !>=sci-libs/rocThrust-${ROCMNEXTVER}
"
