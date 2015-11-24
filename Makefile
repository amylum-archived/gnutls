PACKAGE = gnutls
ORG = amylum

BUILD_DIR = /tmp/$(PACKAGE)-build
RELEASE_DIR = /tmp/$(PACKAGE)-release
RELEASE_FILE = /tmp/$(PACKAGE).tar.gz
PATH_FLAGS = --prefix=/usr --infodir=/tmp/trash
CONF_FLAGS = --without-idn --disable-shared --disable-local-libopts --enable-guile --with-guile-site-dir=no --with-zlib --with-libz-prefix=/tmp/zlib/usr
CFLAGS = -static -static-libgcc -Wl,-static

PACKAGE_VERSION = 3.4.7
PATCH_VERSION = $$(cat version)
VERSION = $(PACKAGE_VERSION)-$(PATCH_VERSION)

SOURCE_URL = http://ftp.gnutls.org/gcrypt/gnutls/v3.4/$(PACKAGE)-$(PACKAGE_VERSION).tar.xz
SOURCE_PATH = /tmp/source
SOURCE_TARBALL = /tmp/source.tar.gz

GMP_VERSION = 6.1.0-1
GMP_URL = https://github.com/amylum/gmp/releases/download/$(GMP_VERSION)/gmp.tar.gz
GMP_TAR = /tmp/gmp.tar.gz
GMP_DIR = /tmp/gmp
GMP_PATH = -I$(GMP_DIR)/usr/include -L$(GMP_DIR)/usr/lib

NETTLE_VERSION = 3.1.1-2
NETTLE_URL = https://github.com/amylum/nettle/releases/download/$(NETTLE_VERSION)/nettle.tar.gz
NETTLE_TAR = /tmp/nettle.tar.gz
NETTLE_DIR = /tmp/nettle
NETTLE_PATH = -I$(NETTLE_DIR)/usr/include -L$(NETTLE_DIR)/usr/lib

LIBTASN1_VERSION = 4.7-2
LIBTASN1_URL = https://github.com/amylum/libtasn1/releases/download/$(LIBTASN1_VERSION)/libtasn1.tar.gz
LIBTASN1_TAR = /tmp/libtasn1.tar.gz
LIBTASN1_DIR = /tmp/libtasn1
LIBTASN1_PATH = -I$(LIBTASN1_DIR)/usr/include -L$(LIBTASN1_DIR)/usr/lib

AUTOGEN_VERSION = 5.18.6-1
AUTOGEN_URL = https://github.com/amylum/autogen/releases/download/$(AUTOGEN_VERSION)/autogen.tar.gz
AUTOGEN_TAR = /tmp/autogen.tar.gz
AUTOGEN_DIR = /tmp/autogen
AUTOGEN_PATH = -I$(AUTOGEN_DIR)/usr/include -L$(AUTOGEN_DIR)/usr/lib

P11-KIT_VERSION = 0.23.1-1
P11-KIT_URL = https://github.com/amylum/p11-kit/releases/download/$(P11-KIT_VERSION)/p11-kit.tar.gz
P11-KIT_TAR = /tmp/p11-kit.tar.gz
P11-KIT_DIR = /tmp/p11-kit
P11-KIT_PATH = -I$(P11-KIT_DIR)/usr/include -L$(P11-KIT_DIR)/usr/lib -lpthread -ldl

GUILE_VERSION = 2.0.11-2
GUILE_URL = https://github.com/amylum/guile/releases/download/$(GUILE_VERSION)/guile.tar.gz
GUILE_TAR = /tmp/guile.tar.gz
GUILE_DIR = /tmp/guile
GUILE_PATH = -I$(GUILE_DIR)/usr/include/guile/2.0 -L$(GUILE_DIR)/usr/lib -lguile-2.0

GC_VERSION = 7.4.2-2
GC_URL = https://github.com/amylum/gc/releases/download/$(GC_VERSION)/gc.tar.gz
GC_TAR = /tmp/gc.tar.gz
GC_DIR = /tmp/gc
GC_PATH = -I$(GC_DIR)/usr/include -L$(GC_DIR)/usr/lib

LIBUNISTRING_VERSION = 0.9.6-1
LIBUNISTRING_URL = https://github.com/amylum/libunistring/releases/download/$(LIBUNISTRING_VERSION)/libunistring.tar.gz
LIBUNISTRING_TAR = /tmp/libunistring.tar.gz
LIBUNISTRING_DIR = /tmp/libunistring
LIBUNISTRING_PATH = -I$(LIBUNISTRING_DIR)/usr/include -L$(LIBUNISTRING_DIR)/usr/lib

LIBFFI_VERSION = 3.2.1-1
LIBFFI_URL = https://github.com/amylum/libffi/releases/download/$(LIBFFI_VERSION)/libffi.tar.gz
LIBFFI_TAR = /tmp/libffi.tar.gz
LIBFFI_DIR = /tmp/libffi
LIBFFI_PATH = -I$(LIBFFI_DIR)/usr/lib/libffi-3.2.1/include -L$(LIBFFI_DIR)/usr/lib

LIBTOOL_VERSION = 2.4.6-1
LIBTOOL_URL = https://github.com/amylum/libtool/releases/download/$(LIBTOOL_VERSION)/libtool.tar.gz
LIBTOOL_TAR = /tmp/libtool.tar.gz
LIBTOOL_DIR = /tmp/libtool
LIBTOOL_PATH = -I$(LIBTOOL_DIR)/usr/include -L$(LIBTOOL_DIR)/usr/lib

ZLIB_VERSION = 1.2.8-1
ZLIB_URL = https://github.com/amylum/zlib/releases/download/$(ZLIB_VERSION)/zlib.tar.gz
ZLIB_TAR = /tmp/zlib.tar.gz
ZLIB_DIR = /tmp/zlib
ZLIB_PATH = -I$(ZLIB_DIR)/usr/include -L$(ZLIB_DIR)/usr/lib

export PATH := $(AUTOGEN_DIR)/usr/bin:$(GUILE_DIR)/usr/bin:$(PATH)

.PHONY : default build_container source deps manual container deps build version push local

default: container

build_container:
	docker build -t gnutls-pkg meta

manual: build_container
	./meta/launch /bin/bash || true

container: build_container
	./meta/launch

source:
	rm -rf $(SOURCE_PATH) $(SOURCE_TARBALL)
	mkdir $(SOURCE_PATH)
	curl -sLo $(SOURCE_TARBALL) $(SOURCE_URL)
	tar -x -C $(SOURCE_PATH) -f $(SOURCE_TARBALL) --strip-components=1

deps:
	rm -rf $(GMP_DIR) $(GMP_TAR)
	mkdir $(GMP_DIR)
	curl -sLo $(GMP_TAR) $(GMP_URL)
	tar -x -C $(GMP_DIR) -f $(GMP_TAR)
	rm -rf $(NETTLE_DIR) $(NETTLE_TAR)
	mkdir $(NETTLE_DIR)
	curl -sLo $(NETTLE_TAR) $(NETTLE_URL)
	tar -x -C $(NETTLE_DIR) -f $(NETTLE_TAR)
	rm -rf $(LIBTASN1_DIR) $(LIBTASN1_TAR)
	mkdir $(LIBTASN1_DIR)
	curl -sLo $(LIBTASN1_TAR) $(LIBTASN1_URL)
	tar -x -C $(LIBTASN1_DIR) -f $(LIBTASN1_TAR)
	rm -rf $(AUTOGEN_DIR) $(AUTOGEN_TAR)
	mkdir $(AUTOGEN_DIR)
	curl -sLo $(AUTOGEN_TAR) $(AUTOGEN_URL)
	tar -x -C $(AUTOGEN_DIR) -f $(AUTOGEN_TAR)
	rm /tmp/autogen/usr/lib/libopts.la
	rm -rf $(P11-KIT_DIR) $(P11-KIT_TAR)
	mkdir $(P11-KIT_DIR)
	curl -sLo $(P11-KIT_TAR) $(P11-KIT_URL)
	tar -x -C $(P11-KIT_DIR) -f $(P11-KIT_TAR)
	rm -rf $(GUILE_DIR) $(GUILE_TAR)
	mkdir $(GUILE_DIR)
	curl -sLo $(GUILE_TAR) $(GUILE_URL)
	tar -x -C $(GUILE_DIR) -f $(GUILE_TAR)
	rm /tmp/guile/usr/lib/libguile-2.0.la
	rm -rf $(GC_DIR) $(GC_TAR)
	mkdir $(GC_DIR)
	curl -sLo $(GC_TAR) $(GC_URL)
	tar -x -C $(GC_DIR) -f $(GC_TAR)
	rm /tmp/gc/usr/lib/libgc.la
	rm -rf $(LIBUNISTRING_DIR) $(LIBUNISTRING_TAR)
	mkdir $(LIBUNISTRING_DIR)
	curl -sLo $(LIBUNISTRING_TAR) $(LIBUNISTRING_URL)
	tar -x -C $(LIBUNISTRING_DIR) -f $(LIBUNISTRING_TAR)
	rm -rf $(LIBFFI_DIR) $(LIBFFI_TAR)
	mkdir $(LIBFFI_DIR)
	curl -sLo $(LIBFFI_TAR) $(LIBFFI_URL)
	tar -x -C $(LIBFFI_DIR) -f $(LIBFFI_TAR)
	rm -rf $(LIBTOOL_DIR) $(LIBTOOL_TAR)
	mkdir $(LIBTOOL_DIR)
	curl -sLo $(LIBTOOL_TAR) $(LIBTOOL_URL)
	tar -x -C $(LIBTOOL_DIR) -f $(LIBTOOL_TAR)
	rm -rf $(ZLIB_DIR) $(ZLIB_TAR)
	mkdir $(ZLIB_DIR)
	curl -sLo $(ZLIB_TAR) $(ZLIB_URL)
	tar -x -C $(ZLIB_DIR) -f $(ZLIB_TAR)

build: source deps
	rm -rf $(BUILD_DIR)
	cp -R $(SOURCE_PATH) $(BUILD_DIR)
	echo "echo -n '$(GMP_PATH) $(NETTLE_PATH) $(LIBTASN1_PATH) $(AUTOGEN_PATH) $(P11-KIT_PATH) $(GUILE_PATH) $(GC_PATH) $(LIBUNISTRING_PATH) $(LIBFFI_PATH) $(LIBTOOL_PATH) $(ZLIB_PATH) -lltdl -ldl -lgc -lunistring -lgmp -lffi -lz'" > $(GUILE_DIR)/usr/bin/guile-config
	cd $(BUILD_DIR) && make autoreconf
	cd $(BUILD_DIR) && CC=musl-gcc AUTOGEN='autogen -L/tmp/autogen/usr/share/autogen/' LIBS='-lunistring -lgmp -lffi' CFLAGS='$(CFLAGS) $(GMP_PATH) $(NETTLE_PATH) $(LIBTASN1_PATH) $(AUTOGEN_PATH) $(P11-KIT_PATH) $(GUILE_PATH) $(GC_PATH) $(LIBUNISTRING_PATH) $(LIBFFI_PATH) $(LIBTOOL_PATH) $(ZLIB_PATH)' ./configure $(PATH_FLAGS) $(CONF_FLAGS)
	cd $(BUILD_DIR) && make
	cd $(BUILD_DIR) && make DESTDIR=$(RELEASE_DIR) install
	rm -rf $(RELEASE_DIR)/tmp
	mkdir -p $(RELEASE_DIR)/usr/share/licenses/$(PACKAGE)
	cp $(BUILD_DIR)/COPYING $(RELEASE_DIR)/usr/share/licenses/$(PACKAGE)/LICENSE
	cd $(RELEASE_DIR) && tar -czvf $(RELEASE_FILE) *

version:
	@echo $$(($(PATCH_VERSION) + 1)) > version

push: version
	git commit -am "$(VERSION)"
	ssh -oStrictHostKeyChecking=no git@github.com &>/dev/null || true
	git tag -f "$(VERSION)"
	git push --tags origin master
	@sleep 3
	targit -a .github -c -f $(ORG)/$(PACKAGE) $(VERSION) $(RELEASE_FILE)
	@sha512sum $(RELEASE_FILE) | cut -d' ' -f1

local: build push

