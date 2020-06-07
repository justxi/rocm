# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm

DESCRIPTION="AMD ROCm"
HOMEPAGE="https://github.com/RadeonOpenCompute/"
SRC_URI="
http://repo.radeon.com/rocm/yum/3.1/aomp-amdgpu-0.7-6.x86_64.rpm -> ${PN}-${PV}-aomp.rpm
http://repo.radeon.com/rocm/yum/3.1/aomp-amdgpu-tests-0.7-6.x86_64.rpm -> ${PN}-${PV}-aomp-tests.rpm
http://repo.radeon.com/rocm/yum/3.1/atmi-0.7.7-Linux.rpm -> ${PN}-${PV}-1.rpm
http://repo.radeon.com/rocm/yum/3.1/comgr-1.6.0.121-rocm-rel-3.1-35-cbb02f9-Linux.rpm -> ${PN}-${PV}-2.rpm
http://repo.radeon.com/rocm/yum/3.1/half-1.12.0-el7.x86_64.rpm -> ${PN}-${PV}-4.rpm
http://repo.radeon.com/rocm/yum/3.1/hcc-3.1.20023-Linux.rpm -> ${PN}-${PV}-5.rpm
http://repo.radeon.com/rocm/yum/3.1/hip-base-3.1.20065.4514-rocm-rel-3.1-35-2a03c8da.x86_64.rpm -> ${PN}-${PV}-6.rpm
http://repo.radeon.com/rocm/yum/3.1/hipblas-0.20.0.307-rocm-rel-3.1-35-ff35c32-el7.x86_64.rpm -> ${PN}-${PV}-7.rpm
http://repo.radeon.com/rocm/yum/3.1/hipcub-2.9.0.92-rocm-rel-3.1-35-40e1d66-el7.x86_64.rpm -> ${PN}-${PV}-8.rpm
http://repo.radeon.com/rocm/yum/3.1/hip-doc-3.1.20065.4514-rocm-rel-3.1-35-2a03c8da.x86_64.rpm -> ${PN}-${PV}-9.rpm
http://repo.radeon.com/rocm/yum/3.1/hip-hcc-3.1.20065.4514-rocm-rel-3.1-35-2a03c8da.x86_64.rpm -> ${PN}-${PV}-10.rpm
http://repo.radeon.com/rocm/yum/3.1/hip-samples-3.1.20065.4514-rocm-rel-3.1-35-2a03c8da.x86_64.rpm -> ${PN}-${PV}-11.rpm
http://repo.radeon.com/rocm/yum/3.1/hipsparse-1.5.2.229-rocm-rel-3.1-35-3085fe5-el7.x86_64.rpm -> ${PN}-${PV}-12.rpm
http://repo.radeon.com/rocm/yum/3.1/hsa-amd-aqlprofile-1.0.0-Linux.rpm -> ${PN}-${PV}-13.rpm
http://repo.radeon.com/rocm/yum/3.1/hsa-ext-rocr-dev-1.1.30100.0-rocm-rel-3.1-35-ecafeba1-Linux.rpm -> ${PN}-${PV}-14.rpm
http://repo.radeon.com/rocm/yum/3.1/hsa-rocr-dev-1.1.30100.0-rocm-rel-3.1-35-ecafeba1-Linux.rpm -> ${PN}-${PV}-15.rpm
http://repo.radeon.com/rocm/yum/3.1/hsakmt-roct-devel-1.0.9-319-g02e2b30.x86_64.rpm -> ${PN}-${PV}-16.rpm
http://repo.radeon.com/rocm/yum/3.1/hsa-rocr-dev-1.1.30100.0-rocm-rel-3.1-35-ecafeba1-Linux.rpm -> ${PN}-${PV}-17.rpm
http://repo.radeon.com/rocm/yum/3.1/hsakmt-roct-1.0.9-319-g02e2b30.x86_64.rpm -> ${PN}-${PV}-rocrand.rpm
http://repo.radeon.com/rocm/yum/3.1/MIGraphX-0.5.0.3766-rocm-rel-3.1-35-79bfafc1-el7.x86_64.rpm -> ${PN}-${PV}-18.rpm
http://repo.radeon.com/rocm/yum/3.1/miopengemm-1.1.6.647-rocm-rel-3.1-35-b51a125-el7.x86_64.rpm -> ${PN}-${PV}-19.rpm
http://repo.radeon.com/rocm/yum/3.1/MIOpen-HIP-2.2.1.7633-rocm-rel-3.1-35-92186831-el7.x86_64.rpm -> ${PN}-${PV}-20.rpm
http://repo.radeon.com/rocm/yum/3.1/MIOpen-OpenCL-2.2.1.7633-rocm-rel-3.1-35-92186831-el7.x86_64.rpm -> ${PN}-${PV}-21.rpm
http://repo.radeon.com/rocm/yum/3.1/mivisionx-1.6.0-1.x86_64.rpm -> ${PN}-${PV}-22.rpm
http://repo.radeon.com/rocm/yum/3.1/rccl-2.10.0-254-g31648ec-rocm-rel-3.1-35-el7.x86_64.rpm -> ${PN}-${PV}-23.rpm
http://repo.radeon.com/rocm/yum/3.1/rocalution-1.7.1.473-rocm-rel-3.1-35-7220da1-el7.x86_64.rpm -> ${PN}-${PV}-24.rpm
http://repo.radeon.com/rocm/yum/3.1/rocblas-2.14.1.1861-rocm-rel-3.1-35-cc49425-el7.x86_64.rpm -> ${PN}-${PV}-25.rpm
http://repo.radeon.com/rocm/yum/3.1/rocfft-0.9.10.783-rocm-rel-3.1-35-b7f9ebe-el7.x86_64.rpm -> ${PN}-${PV}-26.rpm
http://repo.radeon.com/rocm/yum/3.1/rock-dkms-3.1-35.el7.noarch.rpm -> ${PN}-${PV}-27.rpm
http://repo.radeon.com/rocm/yum/3.1/rocm-bandwidth-test-1.4.0.11-rocm-rel-3.1-35-g1935cf8-Linux.rpm -> ${PN}-${PV}-28.rpm
http://repo.radeon.com/rocm/yum/3.1/rocm-clang-ocl-0.5.0.48-rocm-rel-3.1-35-fa039e7-el7.x86_64.rpm -> ${PN}-${PV}-29.rpm
http://repo.radeon.com/rocm/yum/3.1/rocm-cmake-0.3.0.141-rocm-rel-3.1-35-1b9e698-el7.x86_64.rpm -> ${PN}-${PV}-30.rpm
http://repo.radeon.com/rocm/yum/3.1/rocm-device-libs-1.0.0.563-rocm-rel-3.1-35-8f441a8-Linux.rpm -> ${PN}-${PV}-31.rpm
http://repo.radeon.com/rocm/yum/3.1/rocminfo-1.0.0.0.rocm-rel-3.1-35-a134847.rpm -> ${PN}-${PV}-32.rpm
http://repo.radeon.com/rocm/yum/3.1/rocm-opencl-2.0.0-rocm-rel-3.1-35-8f28d95ad-Linux.rpm -> ${PN}-${PV}-33.rpm
http://repo.radeon.com/rocm/yum/3.1/rocm-opencl-devel-2.0.0-rocm-rel-3.1-35-8f28d95ad-Linux.rpm -> ${PN}-${PV}-34.rpm
http://repo.radeon.com/rocm/yum/3.1/rocm-smi-1.0.0_194_rocm_rel_3.1_35_g840011e-1.x86_64.rpm -> ${PN}-${PV}-36.rpm
http://repo.radeon.com/rocm/yum/3.1/rocm-smi-lib64-2.2.0.8.rocm-rel-3.1-35-a246aac.rpm -> ${PN}-${PV}-37.rpm
http://repo.radeon.com/rocm/yum/3.1/rocm-validation-suite-3.0.30100.rpm -> ${PN}-${PV}-validation-suite.rpm
http://repo.radeon.com/rocm/yum/3.1/rocprim-2.9.0.952-rocm-rel-3.1-35-5fa0c79-el7.x86_64.rpm -> ${PN}-${PV}-38.rpm
http://repo.radeon.com/rocm/yum/3.1/rocprofiler-dev-1.0.0-Linux.rpm -> ${PN}-${PV}-39.rpm
http://repo.radeon.com/rocm/yum/3.1/rocrand-2.10.0.657-rocm-rel-3.1-35-448c673-Linux.rpm -> ${PN}-${PV}-40.rpm
http://repo.radeon.com/rocm/yum/3.1/rocm-debug-agent-1.0.0-Linux.rpm -> ${PN}-${PV}-41.rpm
http://repo.radeon.com/rocm/yum/3.1/rocsolver-2.7.0.66-rocm-rel-3.1-35-aebca24-el7.x86_64.rpm -> ${PN}-${PV}-rocsolver.rpm
http://repo.radeon.com/rocm/yum/3.1/rocsparse-1.8.4.726-rocm-rel-3.1-35-eb854f0-el7.x86_64.rpm -> ${PN}-${PV}-42.rpm
http://repo.radeon.com/rocm/yum/3.1/rocthrust-2.9.0.418-rocm-rel-3.1-35-c4b5328-el7.x86_64.rpm -> ${PN}-${PV}-43.rpm
http://repo.radeon.com/rocm/yum/3.1/roctracer-dev-1.0.0-Linux.rpm -> ${PN}-${PV}-44.rpm
"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
S="${WORKDIR}"

RDEPEND="!dev-libs/rocr-runtime"

src_prepare() {
	default
}

src_install() {
	dodir /opt
	cp -ar opt/* "${D}"/opt/ || die

	echo "/opt/rocm-${PV}/opencl/lib/x86_64/libamdocl64.so" > amdocl64.icd
	insinto /etc/OpenCL/vendors
	doins "amdocl64.icd"

	echo "HSA_PATH=/opt/rocm" > 99rocm || die
	echo "ROCM_PATH=/opt/rocm" >> 99rocm || die
	echo "ROCM_AGENT_ENUM=/opt/rocm/bin/rocm_agent_enumerator" >> 99rocm || die
	echo "HCC_HOME=/opt/rocm/hcc" >> 99rocm || die
	echo "HIP_PATH=/opt/rocm/hip" >> 99rocm || die
	echo "HIP_PLATFORM=hcc" >> 99rocm || die
	echo "LDPATH=/opt/rocm/lib:/opt/rocm/lib64:/opt/rocm/hcc/lib:/opt/rocm/hip/lib:/opt/rocm/hsa/lib:/opt/rocm/opencl/lib/x86_64:/opt/rocm/rocrand/lib" >> 99rocm || die
	echo "PATH=/opt/rocm/bin:/opt/rocm/hcc/bin:/opt/rocm/hip/bin" >> 99rocm || die
	echo "ROOTPATH=/opt/rocm/bin:/opt/rocm/hcc/bin:/opt/rocm/hip/bin" >> 99rocm || die
	doenvd 99rocm
}
