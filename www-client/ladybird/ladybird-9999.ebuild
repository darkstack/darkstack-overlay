# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Serenity is bundled right now
# https://github.com/SerenityOS/ladybird/issues/55

inherit cmake

DESCRIPTION="Ladybird web browser using SerenityOS LibWeb engine with a Qt GUI"
HOMEPAGE="https://awesomekling.github.io/Ladybird-a-new-cross-platform-browser-project/"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/SerenityOS/ladybird"
	EGIT_SUBMODULES=( '*' )
	inherit git-r3
else
	KEYWORDS=""
fi

LICENSE="BSD-2"
SLOT="0"

RDEPEND="
	dev-qt/qtbase:6
	dev-qt/qttools:6
	dev-qt/qtwayland:6
	virtual/libcrypt:=
"
DEPEND="${RDEPEND}"

src_unpack() {
	if [[ ${PV} == *9999 ]] ; then
		git-r3_src_unpack

		git-r3_fetch https://github.com/SerenityOS/serenity.git
		git-r3_checkout https://github.com/SerenityOS/serenity.git "${WORKDIR}"/serenity
	fi
}

src_configure() {
	# TODO: Fix RPATH

	local mycmakeargs=(
		-DCCACHE_PROGRAM=OFF

		-DENABLE_TIME_ZONE_DATABASE_DOWNLOAD=OFF
		-DENABLE_UNICODE_DATABASE_DOWNLOAD=OFF

		-DSERENITY_SOURCE_DIR="${WORKDIR}"/serenity
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	dolib.so "${BUILD_DIR}"/_deps/lagom-build/*.so*

	# TODO: Refine the # of files we install
	insinto /usr/share
	doins -r "${WORKDIR}"/serenity

	newenvd - 10serenity <<-EOF
		SERENITY_SOURCE_DIR="${EPREFIX}"/usr/share/serenity
	EOF
}

pkg_postinst() {
	ewarn "This ebuild is very much a draft. Please submit improvements"
	ewarn "to the overlay and report bugs (ideally with patches)."
	ewarn
	ewarn "There's a reason this ebuild is not (yet?) in ::gentoo!"

	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		einfo "You must run 'env-update && . /etc/profile' before trying to launch ${PN}!"
	fi
}

