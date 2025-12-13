# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

DESCRIPTION="A modern C++ Wayland-native GUI toolkit"
HOMEPAGE="https://github.com/hyprwm/hyprtoolkit"

if [[ "${PV}" = *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hyprwm/${PN^}.git"
else
	SRC_URI="https://github.com/hyprwm/${PN^}/releases/download/v${PV}/source-v${PV}.tar.gz -> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}-source"

	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0"
IUSE=""

HYPRPM_RDEPEND="
	>=dev-build/cmake-3.30
	dev-vcs/git
	virtual/pkgconfig
"
RDEPEND="
	${HYPRPM_RDEPEND}
"
DEPEND="
	${RDEPEND}
	media-libs/libjxl
	x11-libs/libdrm
	gui-libs/egl-wayland
	x11-libs/cairo
	dev-libs/hyprgraphics
	dev-libs/iniparser
"
BDEPEND="
	|| ( >=sys-devel/gcc-14:* >=llvm-core/clang-18:* )
	dev-build/cmake
	virtual/pkgconfig
"

pkg_setup() {
	[[ ${MERGE_TYPE} == binary ]] && return

	if tc-is-gcc && ver_test $(gcc-version) -lt 14 ; then
	V	eerror "Hyprland requires >=sys-devel/gcc-14 to build"
		eerror "Please upgrade GCC: emerge -v1 sys-devel/gcc"
		die "GCC version is too old to compile Hyprland!"
	elif tc-is-clang && ver_test $(clang-version) -lt 18 ; then
		eerror "Hyprland requires >=llvm-core/clang-18 to build"
		eerror "Please upgrade Clang: emerge -v1 llvm-core/clang"
		die "Clang version is too old to compile Hyprland!"
	fi
}

src_configure() {

	local mycmakeargs=(
	--no-warn-unused-cli
	-DCMAKE_BUILD_TYPE:STRING=Release
	-DCMAKE_INSTALL_PREFIX:PATH=/usr
	)
	cmake_src_configure

}

src_compile(){
	cmake_src_compile
}

src_install() {
	cmake_src_install
}

