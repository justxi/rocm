# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Meta package for ROCm 5.0"
LICENSE="metapackage"

SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="debug-tools hip opencl profiling science"
ROCMVER="$(ver_cut 1-2)"

RDEPEND="
	=dev-util/rocminfo-${ROCMVER}*
	=dev-util/rocm-smi-${ROCMVER}*

	=dev-util/rocm-cmake-${ROCMVER}*
	=sys-devel/llvm-roc-${ROCMVER}*
	=dev-libs/rocm-device-libs-${ROCMVER}*
	=dev-libs/rocm-comgr-${ROCMVER}*
	=dev-libs/rocm-opencl-runtime-${ROCMVER}*
	=dev-libs/rocr-runtime-${ROCMVER}*
	=dev-libs/rccl-${ROCMVER}*

	opencl? ( =dev-libs/rocm-opencl-runtime-${ROCMVER}* )
	opencl? ( =dev-util/rocm-clang-ocl-${ROCMVER}* )

	hip? ( =dev-util/hip-${ROCMVER}* )

	profiling? ( =dev-util/rocm_bandwidth_test-${ROCMVER}* )

	debug-tools? ( =dev-util/rocprofiler-${ROCMVER}* )
	debug-tools? ( =dev-util/roctracer-${ROCMVER}* )

	hip? ( science? ( =sci-libs/hipBLAS-${ROCMVER}* ) )
	hip? ( science? ( =sci-libs/hipCUB-${ROCMVER}* ) )
	hip? ( science? ( =sci-libs/hipFFT-${ROCMVER}* ) )
	hip? ( science? ( =sci-libs/hipSPARSE-${ROCMVER}* ) )

	science? ( =sci-libs/hipBLAS-${ROCMVER}* )
	science? ( =sci-libs/rocBLAS-${ROCMVER}* )
	science? ( =sci-libs/hipCUB-${ROCMVER}* )
	science? ( =sci-libs/rocPRIM-${ROCMVER}* )
	science? ( =sci-libs/rocRAND-${ROCMVER}* )
	science? ( =sci-libs/hipFFT-${ROCMVER}* )
	science? ( =sci-libs/rocFFT-${ROCMVER}* )
	science? ( =sci-libs/hipSPARSE-${ROCMVER}* )
	science? ( =sci-libs/rocSPARSE-${ROCMVER}* )
	science? ( =sci-libs/rocThrust-${ROCMVER}* )
	science? ( =sci-libs/rocSOLVER-${ROCMVER}* )
"
