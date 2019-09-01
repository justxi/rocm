Ebuilds to install ROCm on Gentoo Linux

-> https://github.com/RadeonOpenCompute/ROCm

**Please report all problems here first, if you tried ebuilds of this repository.**<br>
If you have a problem with an ebuild from Gentoo portage then submit a bugreport at https://bugs.gentoo.org/.

**The ebuilds for ROCm 2.7 in this repository are in an experimental state!**<br>
**Please report all problems to help to stabilise them.**

**All ebuilds which are already exist in Gentoo portage will be removed from this repository.**

Thanks to all contributors.

The following tables show all ebuilds tested (2019-08-29) in this repository. <br>
All other ebuilds can be out of date!

Kernel, driver, libraries, compiler and tools:

|Ebuild|Current Version|State| FHS | in Gentoo portage| 
|---|---|---|---|---|
|sys-kernel/rocm-sources| 2.7 | based on linux kernel 5.0.0-rc1 | (ok) |  |
|dev-util/rocm-cmake| 2.7 | | Yes | :heavy_check_mark:<br> V0.2, V2.7.0 |
|dev-libs/roct-thunk-interface| 2.7 |  | Yes | :heavy_check_mark:<br> V2.6.0, V2.7.0 |
|dev-libs/rocr-runtime| 2.7 | | Yes | :heavy_check_mark:<br> V2.6.0, V2.7.0 |
|dev-libs/rocm-device-libs | 2.7 | | Yes | :heavy_check_mark:<br> V2.6.0, V2.7.0 |
|dev-libs/rocm-opencl-driver | 2.7 | | Yes | :heavy_check_mark:<br> V2.6.0, V2.7.0 |
|dev-libs/rocm-opencl-runtime| 2.7 | "clinfo" reports suitable informations.<br> Simple "Hello World" program from "OpenCL Programming Guide" works. | Yes | :heavy_check_mark:<br> V2.6.0 |
|media-libs/hsa-amd-aqlprofile| 1.0.0 | | (ok) | |
|media-libs/hsa-ext-rocr| 1.1.9.99 | | (ok) | :heavy_check_mark:<br> V1.1.9.99 |
|dev-util/rocm-bandwidth-test| 9999 | Reports suitable informations. | (ok) |  |
|dev-util/rocprofiler| 2.6 | Installs, program not tested yet. | (ok) | |
|dev-libs/rocm-smi-lib| 2.7 |  | (ok) | |
|dev-util/rocm-smi| 2.7 | Reports suitable informations. | (ok) | |
|dev-util/rocminfo| 2.7 | Reports suitable informations. | Yes | :heavy_check_mark:<br> V2.6.0, V2.7.0 |
|dev-libs/rocm-comgr| 2.7 | | Yes | :heavy_check_mark:<br> V2.6.0, V2.7.0 | 
|dev-libs/rocr-debug-agent | 2.7 | fails on a few systems - please report if it works or not | (ok) | |
|dev-util/roctracer| 2.7 | Installs a library, not tested yet. | (ok) | |
|dev-utilrocm-clang-ocl| 2.7 | | (ok) | |
|dev-util/rcp| 5.6 | Installs, not tested yet.  | (ok) | |
|sys-devel/llvm-roc | 2.7 | | Yes |:heavy_check_mark:<br> V2.6.0, V2.7.0 | |
|sys-devel/hcc| 2.7 |  | (ok) | |
|sys-devel/hip| 2.7 | currently depends on HCC, building based on clang (HIP-clang) is currently under test | (ok) | |
|sys-devel/amd-rocm-meta| 2.7 | | (ok) | |

<br>
ROCm Libraries:

|Ebuild|Current Version|State|FHS|in Gentoo portage|
|---|---|---|---|---|
|sci-libs/rocBLAS| 2.7 | Installs, not tested yet. | (ok) | |
|sci-libs/rocPRIM| 2.7 | Installs, not tested yet. | (ok) | |
|sci-libs/rocSPARSE| 2.7 | Uses master branch to build, because released files do not work. | (ok) | |
|sci-libs/rocALUTION| 2.7 | Ebuild under test... | (ok) | |
|sci-libs/rocThrust| 2.7 | Installs, not tested yet. | (ok) | |
|sci-libs/rocFFT| 2.7 | Installs, not tested yet | (ok) | |
|sci-libs/rocRAND| 2.7 | Installs, not tested yet | (ok) |  |
|sci-libs/rocSOLVER| 9999 | Installs, not tested yet | (ok) | |
|sci-libs/hipCub | 2.7 | Installs, not tested yet. | (ok)| |
|sci-libs/MIOpenGEMM | 9999 | Installs, not tested yet. (Uses master, releases are too old) | (ok) | |
|sci-libs/MIOpen | 2.7 | Installs, not tested yet. | (ok) | |
|sci-libs/RCCL | 2.7 | Ebuild under test. | (ok) | |
|sci-libs/hipBLAS | | No ebuild exist, any help is appreciated. | | |
|sci-libs/hipSPARSE | | No ebuild exist, any help is appreciated. | | |
|sci-libs/MIVisionX | | No ebuild exist, any help is appreciated. | | |

<br>
Systems known to work:

| No | CPU | PCIe |  GPU | additional information |
|---|---|---|---|---|
| 1 | Intel Core i5 8400 | PCIe 3.0 | Radeon RX 560 (POLARIS11) | |
| 2 | Intel Core i7 6700k | PCIe 3.0 over Thunderbolt 3 | Radeon VII | |
| 3 | AMD Ryzen 1700 | PCIe 3.0 | Radeon RX 580 | |
