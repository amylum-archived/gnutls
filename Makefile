PACKAGE = gnutls
ORG = amylum

BUILD_DIR = /tmp/$(PACKAGE)-build
RELEASE_DIR = /tmp/$(PACKAGE)-release
RELEASE_FILE = /tmp/$(PACKAGE).tar.gz
PATH_FLAGS = --prefix=/usr --infodir=/tmp/trash
CONF_FLAGS = --enable-maintainer-mode --enable-static --disable-padlock-support
CFLAGS = -static -static-libgcc -Wl,-static -lc

PACKAGE_VERSION = $$(git --git-dir=upstream/.git describe --tags | sed 's/gnutls_//;s/_/./g')
PATCH_VERSION = $$(cat version)
VERSION = $(PACKAGE_VERSION)-$(PATCH_VERSION)

GMP_VERSION = 6.1.0-1
GMP_URL = https://github.com/amylum/gmp/releases/download/$(GMP_VERSION)/gmp.tar.gz
GMP_TAR = /tmp/gmp.tar.gz
GMP_DIR = /tmp/gmp
GMP_PATH = -I$(GMP_DIR)/usr/include -L$(GMP_DIR)/usr/lib

NETTLE_VERSION = 3.1.1-1
NETTLE_URL = https://github.com/amylum/nettle/releases/download/$(NETTLE_VERSION)/nettle.tar.gz
NETTLE_TAR = /tmp/nettle.tar.gz
NETTLE_DIR = /tmp/nettle
NETTLE_PATH = -I$(NETTLE_DIR)/usr/include -L$(NETTLE_DIR)/usr/lib

.PHONY : default submodule deps manual container deps build version push local

default: submodule container

submodule:
	git submodule update --init

manual: submodule
	./meta/launch /bin/bash || true

container:
	./meta/launch

deps:
	rm -rf $(GMP_DIR) $(GMP_TAR)
	mkdir $(GMP_DIR)
	curl -sLo $(GMP_TAR) $(GMP_URL)
	tar -x -C $(GMP_DIR) -f $(GMP_TAR)
	rm -rf $(NETTLE_DIR) $(NETTLE_TAR)
	mkdir $(NETTLE_DIR)
	curl -sLo $(NETTLE_TAR) $(NETTLE_URL)
	tar -x -C $(NETTLE_DIR) -f $(NETTLE_TAR)

build: submodule deps
	rm -rf $(BUILD_DIR)
	cp -R upstream $(BUILD_DIR)
	touch $(BUILD_DIR)/ChangeLog
	cd $(BUILD_DIR) && autoreconf -i --force
	cd $(BUILD_DIR) && CC=musl-gcc CFLAGS='$(CFLAGS) $(GMP_PATH) $(NETTLE_PATH)' ./configure $(PATH_FLAGS) $(CONF_FLAGS)
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

