EAPI=7

inherit unpacker savedconfig

HOMEPAGE="https://rocm.github.io/"
DESCRIPTION="Radeon Open Compute (ROCk) firmware"
LICENSE="LICENSE.ucode"
KEYWORDS="amd64"
MY_RPR="${PV//_p/-}" # Remote PR
FN="rock-dkms-firmware_${MY_RPR}_all.deb"
BASE_URL="http://repo.radeon.com/rocm/apt/debian"
FOLDER="pool/main/r/rock-dkms"
SRC_URI="http://repo.radeon.com/rocm/apt/debian/pool/main/r/rock-dkms/${FN}"

SLOT="0/$(ver_cut 1-2)"

IUSE="savedconfig"

S="${WORKDIR}"

src_unpack() {
	unpack_deb ${A}
}

src_prepare() {
	default

	echo "# Remove files that shall not be installed from this list." > ${PN}.conf
	find usr/src/amdgpu-${MY_RPR}/firmware/amdgpu/* ! -type d ! \( -name ${PN}.conf \) >> ${PN}.conf

	if use savedconfig; then
		restore_config ${PN}.conf

		ebegin "Removing all files not listed in config"
		find ! -type d ! \( -name ${PN}.conf \) -printf "%P\n" \
			| grep -Fvx -f <(grep -v '^#' ${PN}.conf \
				|| die "grep failed, empty config file?") \
			| xargs -d '\n' --no-run-if-empty rm
		eend $? || die
	fi

	# remove empty directories, bug #396073
	find -type d -empty -delete || die
}

src_install() {
	save_config ${PN}.conf
	rm ${PN}.conf || die

	insinto /lib/firmware
	doins -r usr/src/amdgpu-${MY_RPR}/firmware/amdgpu
}

pkg_preinst() {
	if use savedconfig; then
		ewarn "USE=savedconfig is active. You must handle file collisions manually."
	fi
}

pkg_postinst() {
	einfo "The original upstream scripts would replace the existing AMD GPU firmware."
	einfo "This installation allows both to exist side-by-side."
	einfo "Replace the old references of firmware to new location with same name."
}
