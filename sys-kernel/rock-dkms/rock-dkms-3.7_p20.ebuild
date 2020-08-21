EAPI=7

MULTILIB_COMPAT=( abi_x86_64 )
inherit eutils linux-info multilib-build unpacker

DESCRIPTION="ROCk DKMS kernel module"
HOMEPAGE="https://rocm-documentation.readthedocs.io/en/latest/Installation_Guide/ROCk-kernel.html"
LICENSE="GPL-2 MIT"
KEYWORDS="amd64"
MY_RPR="${PV//_p/-}" # Remote PR
FN="${PN}_${MY_RPR}_all.deb"
SRC_URI="http://repo.radeon.com/rocm/apt/debian/pool/main/r/rock-dkms/${FN}"
SLOT="0/$(ver_cut 1-2)"
IUSE="firmware"
RDEPEND="firmware? ( sys-firmware/rock-firmware )
	sys-kernel/dkms"

S="${WORKDIR}"

PATCHES=( "${FILESDIR}/rock-dkms-3.7_p20-makefile-recognize-gentoo.patch"
	  "${FILESDIR}/rock-dkms-3.7_p20-enable-mmu_notifier.patch"
	  "${FILESDIR}/rock-dkms-3.7_p20-no-firmware-install.patch"
	  "${FILESDIR}/rock-dkms-3.7_p20-add-header-to-kcl_fence_c.patch"
)

src_prepare() {
	rm -rf "${S}/firmware" || die

	linux-info_pkg_setup

	pushd ./usr/src/amdgpu-${MY_RPR} > /dev/null

	default

	eapply_user

	popd > /dev/null

	mkdir -p ./inst/usr/src
	cp -R ./usr/src/amdgpu-${MY_RPR} ./inst/usr/src
}

src_install() {
	cp -R -t "${D}" ./inst/* || die "Install failed!"
}

pkg_postinst() {
	einfo "To install the kernel module, you need to do the following:"
	einfo ""
	einfo "  dkms add -m amdgpu -v ${MY_RPR}"
	einfo "  dkms build -m amdgpu -v ${MY_RPR}"
	einfo "  dkms install -m amdgpu -v ${MY_RPR} -k ${KV_FULL}"
}

pkg_postrm() {
	einfo "If you have built and installed the kernel module, to remove it, you need to do the following:"
	einfo ""
	einfo "  dkms remove -m amdgpu -v ${MY_RPR} -k ${KV_FULL}"
	einfo ""
	einfo "If you haven't, just:"
	einfo "  rm -rf /var/lib/dkms/amdgpu"
}
