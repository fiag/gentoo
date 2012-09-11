# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/monodevelop/monodevelop-3.0.2-r1.ebuild,v 1.1 2012/06/16 11:39:06 pacho Exp $

EAPI=4
inherit fdo-mime gnome2-utils mono versionator eutils autotools

DESCRIPTION="Integrated Development Environment for .NET"
HOMEPAGE="http://www.monodevelop.com/"

if [[ ${PV} == 9999* ]]
then
	EGIT_REPO_URI="git://github.com/mono/${PN}.git"
	inherit git-2 
	S="${WORKDIR}/${PN}"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://download.mono-project.com/sources/${PN}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+subversion +git test"

RDEPEND=">=dev-lang/mono-2.10.9
	>=dev-dotnet/gconf-sharp-2.24.0
	>=dev-dotnet/glade-sharp-2.12.9
	>=dev-dotnet/gnome-sharp-2.24.0
	>=dev-dotnet/gnomevfs-sharp-2.24.0
	>=dev-dotnet/gtk-sharp-2.12.9
	>=dev-dotnet/mono-addins-0.6[gtk]
	>=dev-dotnet/xsp-2
	dev-util/ctags
	sys-apps/dbus[X]
	>=virtual/monodoc-2.0
	|| (
		www-client/firefox
		www-client/firefox-bin
		www-client/seamonkey
		)
	subversion? ( dev-vcs/subversion )
	!<dev-util/monodevelop-boo-$(get_version_component_range 1-2)
	!<dev-util/monodevelop-java-$(get_version_component_range 1-2)
	!<dev-util/monodevelop-database-$(get_version_component_range 1-2)
	!<dev-util/monodevelop-debugger-gdb-$(get_version_component_range 1-2)
	!<dev-util/monodevelop-debugger-mdb-$(get_version_component_range 1-2)
	!<dev-util/monodevelop-vala-$(get_version_component_range 1-2)"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext
	x11-misc/shared-mime-info"

MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	epatch "${FILESDIR}/${PV}-fix-missing-tests.patch"
	eautoreconf
}

src_configure() {
	econf \
		--disable-update-mimedb \
		--disable-update-desktopdb \
		--enable-monoextensions \
		--enable-gnomeplatform \
		$(use_enable subversion) \
		$(use_enable git) \
		$(use_enable test)
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
}
