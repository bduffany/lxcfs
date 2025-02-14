# SPDX-License-Identifier: LGPL-2.1-or-later

.PHONY: all
all: meson
	ninja -C build

.PHONY: meson
meson:
	[ -d build ] || meson setup build/

.PHONY: dist
dist: meson
	meson dist -C build/ --formats=gztar
	cp build/meson-dist/*.tar.gz .

.PHONY: install
install:
	DESTDIR=$(DESTDIR) ninja -C build install

.apt-install: apt_deps.txt
	sudo apt update
	cat apt_deps.txt | xargs sudo apt install -y
	touch .apt-install

.docker-build: Dockerfile
	docker build . -t lxcfs-debug
	touch .docker-build

.PHONY: test
test: all .apt-install .docker-build test.sh
	./test.sh