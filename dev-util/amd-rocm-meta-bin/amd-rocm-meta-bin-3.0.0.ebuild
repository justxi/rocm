# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm

DESCRIPTION="AMD ROCm"
HOMEPAGE="https://github.com/RadeonOpenCompute/"
SRC_URI="
http://repo.radeon.com/rocm/yum//3.0/aomp-amdgpu-0.7-5.x86_64.rpm -> ${PN}-${PV}-aomp.rpm
http://repo.radeon.com/rocm/yum//3.0/aomp-amdgpu-tests-0.7-5.x86_64.rpm -> ${PN}-${PV}-aomp-tests.rpm
http://repo.radeon.com/rocm/yum//3.0/atmi-0.7.6-Linux.rpm -> ${PN}-${PV}-1.rpm
http://repo.radeon.com/rocm/yum//3.0/comgr-1.6.0.116-rocm-rel-3.0-6-7665c20-Linux.rpm -> ${PN}-${PV}-2.rpm
http://repo.radeon.com/rocm/yum//3.0/cxlactivitylogger-5.6.7259-gf50cd35.x86_64.rpm -> ${PN}-${PV}-3.rpm
http://repo.radeon.com/rocm/yum//3.0/half-1.12.0-Linux.rpm -> ${PN}-${PV}-4.rpm
http://repo.radeon.com/rocm/yum//3.0/hcc-3.0.19493-Linux.rpm -> ${PN}-${PV}-5.rpm
http://repo.radeon.com/rocm/yum//3.0/hip-base-3.0.19493.4438-rocm-rel-3.0-6-36529b16.x86_64.rpm -> ${PN}-${PV}-6.rpm
http://repo.radeon.com/rocm/yum//3.0/hipblas-0.18.0.281-rocm-rel-3.0-6-da8f5a2-el7.x86_64.rpm -> ${PN}-${PV}-7.rpm
http://repo.radeon.com/rocm/yum//3.0/hipcub-2.9.0.88-rocm-rel-3.0-6-6ee0aed-el7.x86_64.rpm -> ${PN}-${PV}-8.rpm
http://repo.radeon.com/rocm/yum//3.0/hip-doc-3.0.19493.4438-rocm-rel-3.0-6-36529b16.x86_64.rpm -> ${PN}-${PV}-9.rpm
http://repo.radeon.com/rocm/yum//3.0/hip-hcc-3.0.19493.4438-rocm-rel-3.0-6-36529b16.x86_64.rpm -> ${PN}-${PV}-10.rpm
http://repo.radeon.com/rocm/yum//3.0/hip-samples-3.0.19493.4438-rocm-rel-3.0-6-36529b16.x86_64.rpm -> ${PN}-${PV}-11.rpm
http://repo.radeon.com/rocm/yum//3.0/hipsparse-1.3.3.208-rocm-rel-3.0-6-f98f82e-el7.x86_64.rpm -> ${PN}-${PV}-12.rpm
http://repo.radeon.com/rocm/yum//3.0/hsa-amd-aqlprofile-1.0.0-Linux.rpm -> ${PN}-${PV}-13.rpm
http://repo.radeon.com/rocm/yum//3.0/hsa-ext-rocr-dev-1.1.9.0-rocm-rel-3.0-6-7128d0dc-Linux.rpm -> ${PN}-${PV}-14.rpm
http://repo.radeon.com/rocm/yum//3.0/hsakmt-roct-1.0.9-298-gea01eb3-Linux.rpm -> ${PN}-${PV}-15.rpm
http://repo.radeon.com/rocm/yum//3.0/hsakmt-roct-dev-1.0.9-298-gea01eb3-Linux.rpm -> ${PN}-${PV}-16.rpm
http://repo.radeon.com/rocm/yum//3.0/hsa-rocr-dev-1.1.9.0-rocm-rel-3.0-6-7128d0dc-Linux.rpm -> ${PN}-${PV}-17.rpm
http://repo.radeon.com/rocm/yum//3.0/MIGraphX-0.5.0.3764-rocm-rel-3.0-6-a4672389-el7.x86_64.rpm -> ${PN}-${PV}-18.rpm
http://repo.radeon.com/rocm/yum//3.0/miopengemm-1.1.6.645-rocm-rel-3.0-6-6275a87-el7.x86_64.rpm -> ${PN}-${PV}-19.rpm
http://repo.radeon.com/rocm/yum//3.0/MIOpen-HIP-2.2.0.7617-rocm-rel-3.0-6-948938de-el7.x86_64.rpm -> ${PN}-${PV}-20.rpm
http://repo.radeon.com/rocm/yum//3.0/MIOpen-OpenCL-2.2.0.7617-rocm-rel-3.0-6-948938de-el7.x86_64.rpm -> ${PN}-${PV}-21.rpm
http://repo.radeon.com/rocm/yum//3.0/mivisionx-1.5.0-1.x86_64.rpm -> ${PN}-${PV}-22.rpm
http://repo.radeon.com/rocm/yum//3.0/rccl-2.10.0-241-g8ccaa92-rocm-rel-3.0-6-el7.x86_64.rpm -> ${PN}-${PV}-23.rpm
http://repo.radeon.com/rocm/yum//3.0/rocalution-1.6.3.460-rocm-rel-3.0-6-2382876-el7.x86_64.rpm -> ${PN}-${PV}-24.rpm
http://repo.radeon.com/rocm/yum//3.0/rocblas-2.12.1.1749-rocm-rel-3.0-6-ca5535b-el7.x86_64.rpm -> ${PN}-${PV}-25.rpm
http://repo.radeon.com/rocm/yum//3.0/rocfft-0.9.9.760-rocm-rel-3.0-6-aee1339-el7.x86_64.rpm -> ${PN}-${PV}-26.rpm
http://repo.radeon.com/rocm/yum//3.0/rock-dkms-3.0-6.el7.noarch.rpm -> ${PN}-${PV}-27.rpm
http://repo.radeon.com/rocm/yum//3.0/rocm-bandwidth-test-1.4.0.9-rocm-rel-3.0-6-g8c2ce31-Linux.rpm -> ${PN}-${PV}-28.rpm
http://repo.radeon.com/rocm/yum//3.0/rocm-clang-ocl-0.5.0.47-rocm-rel-3.0-6-cfddddb-el7.x86_64.rpm -> ${PN}-${PV}-29.rpm
http://repo.radeon.com/rocm/yum//3.0/rocm-cmake-0.3.0.134-rocm-rel-3.0-6-e6d1ef3-el7.x86_64.rpm -> ${PN}-${PV}-30.rpm
http://repo.radeon.com/rocm/yum//3.0/rocm-device-libs-1.0.0.559-rocm-rel-3.0-6-628eea4-Linux.rpm -> ${PN}-${PV}-31.rpm
http://repo.radeon.com/rocm/yum//3.0/rocminfo-1.0.0.0.rocm-rel-3.0-6-f1181e0.rpm -> ${PN}-${PV}-32.rpm
http://repo.radeon.com/rocm/yum//3.0/rocm-opencl-2.0.0-rocm-rel-3.0-6-9a4afec13-Linux.rpm -> ${PN}-${PV}-33.rpm
http://repo.radeon.com/rocm/yum//3.0/rocm-opencl-devel-2.0.0-rocm-rel-3.0-6-9a4afec13-Linux.rpm -> ${PN}-${PV}-34.rpm
http://repo.radeon.com/rocm/yum//3.0/rocm-profiler-5.6.7262-g93fb592.x86_64.rpm -> ${PN}-${PV}-35.rpm
http://repo.radeon.com/rocm/yum//3.0/rocm-smi-1.0.0_192_rocm_rel_3.0_6_g01752f2-1.x86_64.rpm -> ${PN}-${PV}-36.rpm
http://repo.radeon.com/rocm/yum//3.0/rocm-smi-lib64-2.2.0.8.rocm-rel-3.0-6-8ffe1bc.rpm -> ${PN}-${PV}-37.rpm
http://repo.radeon.com/rocm/yum//3.0/rocm-validation-suite-0.0.33.rpm -> ${PN}-${PV}-validation-suite.rpm
http://repo.radeon.com/rocm/yum//3.0/rocprim-2.9.0.950-rocm-rel-3.0-6-b85751b-el7.x86_64.rpm -> ${PN}-${PV}-38.rpm
http://repo.radeon.com/rocm/yum//3.0/rocprofiler-dev-1.0.0-Linux.rpm -> ${PN}-${PV}-39.rpm
http://repo.radeon.com/rocm/yum//3.0/rocrand-2.10.0.656-rocm-rel-3.0-6-b9f838b-Linux.rpm -> ${PN}-${PV}-40.rpm
http://repo.radeon.com/rocm/yum//3.0/rocm-debug-agent-1.0.0-Linux.rpm -> ${PN}-${PV}-41.rpm
http://repo.radeon.com/rocm/yum//3.0/rocrand-2.10.0.656-rocm-rel-3.0-6-b9f838b-Linux.rpm -> ${PN}-${PV}-rocrand.rpm
http://repo.radeon.com/rocm/yum//3.0/rocsolver-2.7.0.57-rocm-rel-3.0-6-7983da3-el7.x86_64.rpm -> ${PN}-${PV}-rocsolver.rpm
http://repo.radeon.com/rocm/yum//3.0/rocsparse-1.5.15.691-rocm-rel-3.0-6-aee785e-el7.x86_64.rpm -> ${PN}-${PV}-42.rpm
http://repo.radeon.com/rocm/yum//3.0/rocthrust-2.9.0.413-rocm-rel-3.0-6-957b1e9-el7.x86_64.rpm -> ${PN}-${PV}-43.rpm
http://repo.radeon.com/rocm/yum//3.0/roctracer-dev-1.0.0-Linux.rpm -> ${PN}-${PV}-44.rpm
"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
S="${WORKDIR}"

RDEPEND="!dev-libs/rocr-runtime"

PATCHES=(
        "${FILESDIR}/fix-python.patch"
)

src_prepare() {
	default
}

src_install() {
	dodir /opt
	cp -ar opt/* "${D}"/opt/ || die

	insinto /etc/OpenCL/vendors
	doins "${FILESDIR}/amdocl64.icd"

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
