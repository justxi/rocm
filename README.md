Ebuilds to install ROCm on Gentoo Linux

-> https://github.com/RadeonOpenCompute/ROCm

**Attention: With version 2.x of ROCm the ebuilds will be renamed to comply with the Gentoo naming rules.**<br>
**Please report all problems here first, if you tried ebuilds of this repository.**

Thanks to all contributors.

The following tables show all ebuilds tested (2019-01-03) in this repository. <br>
All other ebuilds can be out of date!

Kernel, driver, libraries, compiler and tools:

|Ebuild|Current Version|State| FHS | in Gentoo portage| 
|---|---|---|---|---|
|sys-kernel/rocm-sources| 2.6 | based on linux kernel 5.0.0-rc1 | (ok) |  |
|dev-util/rocm-cmake| 0.2 | | Yes | :heavy_check_mark: V0.2 |
|dev-libs/roct-thunk-interface| 2.6 |  | Yes | :heavy_check_mark: V2.6.0 |
|dev-libs/rocr-runtime| 2.6 | | Yes | :heavy_check_mark: V2.6.0 |
|dev-libs/rocm-device-libs | 2.6 | | Yes | :heavy_check_mark: V2.6.0 |
|dev-libs/rocm-opencl-driver | 2.6 | | Yes | :heavy_check_mark: V2.6.0 |
|dev-libs/rocm-opencl-runtime| 2.6 | "clinfo" reports suitable informations.<br> Simple "Hello World" program from "OpenCL Programming Guide" works. | (ok) | WIP |
|media-libs/hsa-amd-aqlprofile| 1.0.0 | | (ok) | |
|media-libs/hsa-ext-rocr| 1.1.9 | | (ok) | |
|dev-util/rocm-bandwidth-test| 9999 | Reports suitable informations. | (ok) |  |
|dev-util/rocprofiler| 2.6 | Installs, program not tested yet. | (ok) | |
|dev-libs/rocm-smi-lib| 2.6 |  | (ok) | |
|dev-util/rocm-smi| 2.6 | Reports suitable informations. | (ok) | |
|dev-util/rocminfo| 2.6 | Reports suitable informations. | Yes | :heavy_check_mark: V2.6.0 |
|dev-libs/rocm-comgr| 2.6 | | (ok) | | 
|dev-libs/rocr-debug-agent | 2.6 | fails on a few systems - please report if it works or not | (ok) | |
|dev-util/roctracer| 2.6 |Sources need modification (hardcoded paths, python 2.7 dep., downloads additional sources) | No | |
|dev-util/rcp| |Sources need modification (python 2.7 dep., problems with GCC 9.1, hardcoded paths)   |  | |
|sys-devel/llvm-roc | 2.6 | | Yes |:heavy_check_mark: V2.6.0 | |
|sys-devel/hcc| 2.6 |  | (ok) | |
|sys-devel/hip| 2.6 | currently depends on HCC | (ok) | |
|sys-devel/amd-rocm-meta| 2.6 | | (ok) | |

<br>
ROCm Libraries:

|Ebuild|Current Version|State|FHS|in Gentoo portage|
|---|---|---|---|---|
|sci-libs/rocBLAS| 2.5 | Installs, not tested yet. |  | |
|sci-libs/rocSPARSE|  | No ebuild exist, any help is appreciated. |  | |
|sci-libs/rocALUTION| |No ebuild exist, any help is appreciated.| | |
|sci-libs/rocPRIM| 2.5 | Installs only headers. | | |
|sci-libs/rocThrust| 2.5 | Installs only headers. | | |
|sci-libs/rocFFT| 2.5 | not tested yet | | |
|sci-libs/rocRAND| 2.5 | not tested yet | |  |
|sci-libs/hipBLAS | | No ebuild exist, any help is appreciated. | | |
|sci-libs/hipSPARSE | | No ebuild exist, any help is appreciated. | | |
|sci-libs/hipThrust | | Will be removed in the future, no ebuild will be created. | | |
|sci-libs/hipCub | | No ebuild exist, any help is appreciated. | | |
|sci-libs/MIOpenGEMM | | No ebuild exist, any help is appreciated.| | |
|sci-libs/MIOpen | | No ebuild exist, any help is appreciated. | | |
|sci-libs/MIVisionX | | No ebuild exist, any help is appreciated. | | |
|sci-libs/RCCL | | No ebuild exist, any help is appreciated. | | |

<br>
Systems known to work:

| No | CPU | PCIe |  GPU | additional information |
|---|---|---|---|---|
| 1 | Intel Core i5 8400 | PCIe 3.0 | Radeon RX 560 (POLARIS11) | |
| 2 | Intel Core i7 6700k | PCIe 3.0 over Thunderbolt 3 | Radeon VII | |
