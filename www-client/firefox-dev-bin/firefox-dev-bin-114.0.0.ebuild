# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop linux-info optfeature pax-utils xdg
FIREFOX_PKG_NAME="firefox-dev"

MOZ_PV="${PV%.*}b7"
MOZ_PN="firefox-${MOZ_PV}"
MOZ_SRC_BASE_URI="https://download-installer.cdn.mozilla.net/pub/devedition/releases/${MOZ_PV}"


SRC_URI="amd64? ( ${MOZ_SRC_BASE_URI}/linux-x86_64/en-US/${MOZ_PN}.tar.bz2 )
	x86? ( ${MOZ_SRC_BASE_URI}/linux-i686/en-US/${MOZ_PN}.tar.bz2 )"

DESCRIPTION="Firefox Developer  Web Browser"
HOMEPAGE="https://www.mozilla.org/en-US/firefox/developer/"

KEYWORDS="-* amd64 x86"
SLOT="rapid"
LICENSE="MPL-2.0 GPL-2 LGPL-2.1"
IUSE="+alsa +ffmpeg +gmp-autoupdate +pulseaudio selinux wayland"

RESTRICT="strip"

BDEPEND="app-arch/unzip
	alsa? (
		!pulseaudio? (
			dev-util/patchelf
		)
	)"

COMMON_DEPEND="alsa? (
		!pulseaudio? (
			media-sound/apulse
		)
	)"

DEPEND="${COMMON_DEPEND}"

RDEPEND="${COMMON_DEPEND}
	!www-client/firefox-bin:0
	!www-client/firefox-bin:esr
	>=app-accessibility/at-spi2-core-2.46.0:2
	dev-libs/dbus-glib
	>=dev-libs/glib-2.26:2
	media-libs/alsa-lib
	media-libs/fontconfig
	>=media-libs/freetype-2.4.10
	sys-apps/dbus
	virtual/freedesktop-icon-theme
	>=x11-libs/cairo-1.10[X]
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.11:3[wayland?]
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libxcb
	>=x11-libs/pango-1.22.0
	alsa? (
		!pulseaudio? ( media-sound/apulse )
	)
	ffmpeg? ( media-video/ffmpeg )
	pulseaudio? ( media-libs/libpulse )
	selinux? ( sec-policy/selinux-mozilla )
"

QA_PREBUILT="opt/${MOZ_PN}/*"

pkg_setup() {
	config_check="~seccomp"
	warning_seccomp="config_seccomp not set! this system will be unable to play drm-protected content."

	linux-info_pkg_setup
}

src_unpack() {
	local _src_file

	mkdir "${S}" || die

	for _src_file in ${A} ; do
			MY_SRC_FILE=${_src_file}
	done
}

src_install() {
	# Set MOZILLA_FIVE_HOME
	local MOZILLA_FIVE_HOME="/opt/${MOZ_PN}"

	dodir /opt
	pushd "${ED}"/opt &>/dev/null || die
	unpack "${MY_SRC_FILE}"
	popd &>/dev/null || die
	

#	# Install system-wide preferences
#	local PREFS_DIR="${MOZILLA_FIVE_HOME}/browser/defaults/preferences"
#	insinto "${PREFS_DIR}"
#	newins "${FILESDIR}"/gentoo-default-prefs.js all-gentoo.js

	# Install menu
#	local app_name="Mozilla ${MOZ_PN^} (bin)"
#	local desktop_file="${FILESDIR}/${PN}-r3.desktop"
#	local desktop_filename="${PN}.desktop"
#	local exec_command="${PN}"
#	local icon="${PN}"
#	local use_wayland="false"
#
#	if use wayland ; then
#		use_wayland="true"
#	fi
}

pkg_postinst() {
	xdg_pkg_postinst

	use ffmpeg || ewarn "USE=-ffmpeg : HTML5 video will not render without media-video/ffmpeg installed"

	optfeature_header "Optional programs for extra features:"
	optfeature "desktop notifications" x11-libs/libnotify
	optfeature "fallback mouse cursor theme e.g. on WMs" gnome-base/gsettings-desktop-schemas
}
