Ebuilds to install ROCm on Gentoo Linux

-> https://github.com/RadeonOpenCompute/ROCm

**Attention: With version 2.x of ROCm the ebuilds will be renamed to comply with the Gentoo naming rules.**<br>
**Please report all problems here first, if you tried ebuilds of this repository.**

Thanks to all contributors.

The following table shows all ebuilds tested (2019-05-10) in this repository.<br>
All other ebuilds can be out of date!

|Ebuild|Current Version|State|in Gentoo portage|
|---|---|---|---|
|sys-kernel/rocm-sources| 2.6 | based on linux kernel 5.0.0-rc1 | - |
|dev-libs/rocm-cmake|9999| | |
|dev-libs/roct-thunk-interface| 2.6 |  | :heavy_check_mark: V2.0.0 |
|dev-libs/rocr-runtime| 2.6 | | :heavy_check_mark: V2.0.0 |
|dev-libs/rocm-opencl-runtime| 2.6 | "clinfo" reports suitable informations.<br> Simple "Hello World" program from "OpenCL Programming Guide" works. | WIP |
|media-libs/hsa-amd-aqlprofile| 1.0.0 | | |
|media-libs/hsa-ext-rocr| 1.1.9 | ||
|dev-util/rocprofiler| 2.5 | Installs, program not tested yet. ||
|dev-util/rocm-smi| 2.5 | Reports suitable informations. | |
|dev-util/rocminfo| 9999 | Reports suitable informations. | |
|dev-libs/rocm-comgr| | | |
|sys-devel/hcc| 2.5 | fails when "debug" USE flag is set | |
|sys-devel/hip| 2.5 | currently depends on HCC | |
|sys-devel/amd-rocm-meta| 2.5 | | |
|sci-libs/rocBLAS| 2.5 | Installs, not tested yet. |  |
|sci-libs/rocPRIM| 2.5 | Installs only headers. | |
|sci-libs/rocThrust| 2.5 | Installs only headers. | |
|sci-libs/rocFFT| 2.5 | not tested yet | |
|sci-libs/rocRAND| 2.5 | not tested yet | | 


Systems known to work:

| No | CPU | PCIe |  GPU | additional information |
|---|---|---|---|---|
| 1 | Core i5 8400 | PCIe 3.0 | Radeon RX 560 (POLARIS11) | |
