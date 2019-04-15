Ebuilds to install ROCm on Gentoo Linux

-> https://github.com/RadeonOpenCompute/ROCm

**Attention: With version 2.x of ROCm the ebuilds will be renamed to comply with the Gentoo naming rules.**<br>
**Please report all problems here first, if you tried ebuilds of the repository.**

The following table shows all ebuilds tested (2019-04-15) in this repository.<br>
All other ebuilds can be out of date!

|Ebuild|Version|State|in Gentoo portage|
|---|---|---|---|
|sys-kernel/rocm-sources| 2.3 | based on linux kernel 5.0.0-rc1 | - |
|dev-libs/roct-thunk-interface| 2.3 |  | :heavy_check_mark: V2.0.0 |
|dev-libs/rocr-runtime| 2.3 | | :heavy_check_mark: V2.0.0 |
|media-libs/ROCm-OpenCL-Runtime| 2.3 | "clinfo" reports suitable informations.<br> Simple "Hello World" program from "OpenCL Programming Guide" works.<br>Disadvantage: Downloads sources everytime. | - |
|dev-libs/rocm-opencl-runtime| 2.3 | "clinfo" reports suitable informations.<br> Simple "Hello World" program from "OpenCL Programming Guide" works.<br>Advantage: Uses Gentoo git to checkout sources. | WIP |
|media-libs/hsa-amd-aqlprofile| 1.0.0 | | |
|media-libs/hsa-ext-rocr| 1.1.9 | ||
|dev-util/rocprofiler| 2.3.9999 | Installs, program not tested yet. ||
|dev-util/rocm-smi| 2.3.9999 | Reports suitable informations. | |
|dev-util/rocminfo| 9999 | Reports suitable informations. | |
|sys-devel/hcc| 2.3 | fails when "debug" USE flag is set | |
|sys-devel/hip| 2.3 | currently depends on HCC | |


Systems known to work:

| No | CPU | PCIe |  GPU | additional information |
|---|---|---|---|---|
| 1 | Ryzen7 1800x | PCIe 3.0 | Radeon RX 560 (POLARIS11) | |
