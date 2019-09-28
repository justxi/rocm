# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm

DESCRIPTION="AMD ROCm"
HOMEPAGE="https://github.com/RadeonOpenCompute/"
SRC_URI="
http://repo.radeon.com/rocm/yum/2.8.0/atmi-0.7.1-0.7.1-553-gf785be6-Linux.rpm -> ${PN}-${PV}-1.rpm
http://repo.radeon.com/rocm/yum/2.8.0/comgr-1.3.0.92-rocm-rel-2.8-13-a73e4ce-Linux.rpm -> ${PN}-${PV}-2.rpm
http://repo.radeon.com/rocm/yum/2.8.0/cxlactivitylogger-5.6.7259-gf50cd35.x86_64.rpm -> ${PN}-${PV}-3.rpm
http://repo.radeon.com/rocm/yum/2.8.0/half-1.12.0-Linux.rpm -> ${PN}-${PV}-4.rpm
http://repo.radeon.com/rocm/yum/2.8.0/hcc-2.8.19356-Linux.rpm -> ${PN}-${PV}-5.rpm
http://repo.radeon.com/rocm/yum/2.8.0/hip_base-2.8.19354.4039-rocm-rel-2.8-13-ebdbe12a.rpm -> ${PN}-${PV}-6.rpm
http://repo.radeon.com/rocm/yum/2.8.0/hipblas-0.14.1.210-rocm-rel-2.8-13-7f35e60-Linux.rpm -> ${PN}-${PV}-7.rpm
http://repo.radeon.com/rocm/yum/2.8.0/hipcub-2.7.0.78-rocm-rel-2.8-13-d9d849a-Linux.rpm -> ${PN}-${PV}-8.rpm
http://repo.radeon.com/rocm/yum/2.8.0/hip_doc-2.8.19354.4039-rocm-rel-2.8-13-ebdbe12a.rpm -> ${PN}-${PV}-9.rpm
http://repo.radeon.com/rocm/yum/2.8.0/hip_hcc-2.8.19354.4039-rocm-rel-2.8-13-ebdbe12a.rpm -> ${PN}-${PV}-10.rpm
http://repo.radeon.com/rocm/yum/2.8.0/hip_samples-2.8.19354.4039-rocm-rel-2.8-13-ebdbe12a.rpm -> ${PN}-${PV}-11.rpm
http://repo.radeon.com/rocm/yum/2.8.0/hipsparse-1.1.0.186-rocm-rel-2.8-13-9228589-Linux.rpm -> ${PN}-${PV}-12.rpm
http://repo.radeon.com/rocm/yum/2.8.0/hsa-amd-aqlprofile-1.0.0-Linux.rpm -> ${PN}-${PV}-13.rpm
http://repo.radeon.com/rocm/yum/2.8.0/hsa-ext-rocr-dev-1.1.9-112-g3d9d98f5-Linux.rpm -> ${PN}-${PV}-14.rpm
http://repo.radeon.com/rocm/yum/2.8.0/hsakmt-roct-1.0.9-230-ga968539-Linux.rpm -> ${PN}-${PV}-15.rpm
http://repo.radeon.com/rocm/yum/2.8.0/hsakmt-roct-dev-1.0.9-230-ga968539-Linux.rpm -> ${PN}-${PV}-16.rpm
http://repo.radeon.com/rocm/yum/2.8.0/hsa-rocr-dev-1.1.9-112-g3d9d98f5-Linux.rpm -> ${PN}-${PV}-17.rpm
http://repo.radeon.com/rocm/yum/2.8.0/MIGraphX-0.4.0.3706-rocm-rel-2.8-13-51bd00b3-Linux.rpm -> ${PN}-${PV}-18.rpm
http://repo.radeon.com/rocm/yum/2.8.0/miopengemm-1.1.6.645-rocm-rel-2.8-13-6275a87-Linux.rpm -> ${PN}-${PV}-19.rpm
http://repo.radeon.com/rocm/yum/2.8.0/MIOpen-HIP-2.1.0.7487-rocm-rel-2.8-13-a5a4129f-Linux.rpm -> ${PN}-${PV}-20.rpm
http://repo.radeon.com/rocm/yum/2.8.0/MIOpen-OpenCL-2.1.0.7487-rocm-rel-2.8-13-a5a4129f-Linux.rpm -> ${PN}-${PV}-21.rpm
http://repo.radeon.com/rocm/yum/2.8.0/mivisionx-1.3.0-1.x86_64.rpm -> ${PN}-${PV}-22.rpm
http://repo.radeon.com/rocm/yum/2.8.0/rccl-2.7.0.465-rocm-rel-2.8-13-9c547c0-Linux.rpm -> ${PN}-${PV}-23.rpm
http://repo.radeon.com/rocm/yum/2.8.0/rocalution-1.5.1.445-rocm-rel-2.8-13-1f7464e-Linux.rpm -> ${PN}-${PV}-24.rpm
http://repo.radeon.com/rocm/yum/2.8.0/rocblas-2.6.3.1503-rocm-rel-2.8-13-39b5e1e-Linux.rpm -> ${PN}-${PV}-25.rpm
http://repo.radeon.com/rocm/yum/2.8.0/rocfft-0.9.6.706-rocm-rel-2.8-13-655899d-Linux.rpm -> ${PN}-${PV}-26.rpm
http://repo.radeon.com/rocm/yum/2.8.0/rock-dkms-2.8-13.el7.noarch.rpm -> ${PN}-${PV}-27.rpm
http://repo.radeon.com/rocm/yum/2.8.0/rocm_bandwidth_test-1.2.1.0-rocm-rel-2.8-13-gd162747-Linux.rpm -> ${PN}-${PV}-28.rpm
http://repo.radeon.com/rocm/yum/2.8.0/rocm-clang-ocl-0.4.0.35-rocm-rel-2.8-13-7ce124f-Linux.rpm -> ${PN}-${PV}-29.rpm
http://repo.radeon.com/rocm/yum/2.8.0/rocm-cmake-0.3.0.119-rocm-rel-2.8-13-89eaa3c-Linux.rpm -> ${PN}-${PV}-30.rpm
http://repo.radeon.com/rocm/yum/2.8.0/rocm-device-libs-1.0.0-Linux.rpm -> ${PN}-${PV}-31.rpm
http://repo.radeon.com/rocm/yum/2.8.0/rocminfo-1.0.0.0.rocm-rel-2.8-13-f1181e0.rpm -> ${PN}-${PV}-32.rpm
http://repo.radeon.com/rocm/yum/2.8.0/rocm-opencl-1.2.0-rocm-rel-2.8-13-e1b27c110-Linux.rpm -> ${PN}-${PV}-33.rpm
http://repo.radeon.com/rocm/yum/2.8.0/rocm-opencl-devel-1.2.0-rocm-rel-2.8-13-e1b27c110-Linux.rpm -> ${PN}-${PV}-34.rpm
http://repo.radeon.com/rocm/yum/2.8.0/rocm-profiler-5.6.7262-g93fb592.x86_64.rpm -> ${PN}-${PV}-35.rpm
http://repo.radeon.com/rocm/yum/2.8.0/rocm-smi-1.0.0_173_g15c25dc-1.x86_64.rpm -> ${PN}-${PV}-36.rpm
http://repo.radeon.com/rocm/yum/2.8.0/rocm_smi_lib64-1.1.0.9.rocm-rel-2.8-13-01e0800.rpm -> ${PN}-${PV}-37.rpm
http://repo.radeon.com/rocm/yum/2.8.0/rocprim-2.7.0.932-rocm-rel-2.8-13-a220074-Linux.rpm -> ${PN}-${PV}-38.rpm
http://repo.radeon.com/rocm/yum/2.8.0/rocprofiler-dev-1.0.0-Linux.rpm -> ${PN}-${PV}-39.rpm
http://repo.radeon.com/rocm/yum/2.8.0/rocrand-2.8.0.646-rocm-rel-2.8-13-4a22e75-Linux.rpm -> ${PN}-${PV}-40.rpm
http://repo.radeon.com/rocm/yum/2.8.0/rocr_debug_agent-1.0.0-Linux.rpm -> ${PN}-${PV}-41.rpm
http://repo.radeon.com/rocm/yum/2.8.0/rocsparse-1.3.0.607-rocm-rel-2.8-13-e00532a-Linux.rpm -> ${PN}-${PV}-42.rpm
http://repo.radeon.com/rocm/yum/2.8.0/rocthrust-2.7.0.405-rocm-rel-2.8-13-3a462e0-Linux.rpm -> ${PN}-${PV}-43.rpm
http://repo.radeon.com/rocm/yum/2.8.0/roctracer-dev-1.0.0-Linux.rpm -> ${PN}-${PV}-44.rpm
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
	echo "HCC_HOME=/opt/rocm/hcc" >> 99rocm || die
	echo "HIP_PATH=/opt/rocm/hip" >> 99rocm || die
	echo "HIP_PLATFORM=hcc" >> 99rocm || die
	echo "LDPATH=/opt/rocm/lib:/opt/rocm/lib64:/opt/rocm/hcc/lib:/opt/rocm/hip/lib:/opt/rocm/hsa/lib" >> 99rocm || die
	echo "PATH=/opt/rocm/bin:/opt/rocm/hcc/bin:/opt/rocm/hip/bin" >> 99rocm || die
	echo "ROOTPATH=/opt/rocm/bin:/opt/rocm/hcc/bin:/opt/rocm/hip/bin" >> 99rocm || die
	doenvd 99rocm
}
