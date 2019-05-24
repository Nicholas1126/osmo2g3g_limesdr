#!/bin/sh

# These components are built
reposes="
libosmocore
libosmo-abis
libosmo-netif
libosmo-sccp
libasn1c
libsmpp34
osmo-mgw
osmo-ggsn
osmo-iuh
osmo-hlr
osmo-msc
osmo-sgsn
osmo-trx
osmo-pcu
osmo-sip-connector
osmo-bsc
openbsc
"

# Set 'prefix' to a path of your choice to install to a prefix
prefix=""

# (don't change this)
opt_prefix=""
if [ -n "$prefix" ]; then
	export LD_LIBRARY_PATH="$prefix"/lib
	export PKG_CONFIG_PATH="$prefix"/lib/pkgconfig
	opt_prefix="--prefix=$prefix"
fi

do_clean="1"

if [ "$1" = "noclean" ]; then
	do_clean="0"
elif [ -n "$1" ]; then
	echo "unknown argument: '$1'"
	echo "
Args:
  noclean   skip the 'make clean' step
"
	exit 1
fi

set -x -e
base="$PWD"
#builddir="build-2G3G"
for r in $reposes; do
	echo "======================= $r ======================"
	cd "$base"

	if ! [ -d "$r" ]; then
		git clone git://git.osmocom.org/$r
	fi

	cd "$base/$r"
	if [ "$do_clean" = "1" ]; then
		set +e
		make distclean
		#rm -rf "$builddir"
		set -e
		autoreconf -fi
	fi

	#mkdir -p "$builddir"
	#cd "$builddir"

	if [ "$do_clean" = "1" ]; then
		opt_enable=""
		if [ "$r" = 'openbsc' ]; then
			cd ./openbsc
			opt_enable="--enable-smpp --enable-osmo-bsc --enable-nat"
		fi
		if [ "$r" = 'osmo-sgsn' ]; then
			opt_enable="--enable-iu"
		fi
		if [ "$r" = 'osmo-msc' ]; then
			opt_enable="--enable-iu"
		fi

		./configure "$opt_prefix" $opt_enable
		set +e
		make clean
		set -e
	fi

	make -j5 || make || make
	sudo make install
	sudo ldconfig
done
