FILES=pkg/Qt5Core.dll \
	   pkg/Qt5Gui.dll \
	   pkg/Qt5Widgets.dll \
	   pkg/bin2pass.py \
	   pkg/config.py \
		pkg/libassuan-0.dll \
		pkg/libgcc_s_seh-1.dll \
		pkg/libgcc_s_sjlj-1.dll \
		pkg/libgpg-error-0.dll \
		pkg/libsodium.dll \
		pkg/libsphinx.dll \
		pkg/libstdc++-6.dll \
		pkg/libwinpthread-1.dll \
		pkg/pinentry-qt.exe \
		pkg/qwindows.dll \
		pkg/pysodium.py \
		pkg/server-key.pub \
		pkg/sphinx.cfg \
		pkg/sphinx.py \
		pkg/sphinx.wxs \
		pkg/sphinxlib.py \
		pkg/websphinx.chrome.json \
		pkg/websphinx.firefox.json \
		pkg/websphinx.py \
		pkg/websphinx/_locales/en/messages.json \
		pkg/websphinx/popup.js \
		pkg/websphinx/popup.html \
		pkg/websphinx/popup.css \
		pkg/websphinx/manifest.json \
		pkg/websphinx/inject.js \
		pkg/websphinx/icon.png \
		pkg/websphinx/background.js

GPG=gpg1
GPG4WINVER=3.0.3
SODIUMVER=1.0.16

all: pkg.zip

pkg.zip: pkg $(FILES)
	zip -r pkg pkg

pkg:
	mkdir pkg

#### libsphinx

pkg/libsphinx.dll: libsphinx libsphinx/src/libsphinx.dll
	cp libsphinx/src/libsphinx.dll $@

libsphinx:
	git submodule init libsphinx; git submodule update libsphinx

libsphinx/src/libsphinx.dll: libsphinx/src/goldilocks
	cd libsphinx/src/goldilocks; make clean_generated; cd ..; make clean win

libsphinx/src/goldilocks: libsphinx
	cd libsphinx/src; git submodule init goldilocks; git submodule update goldilocks

#### pysodium

pkg/pysodium.py: pysodium pysodium/pysodium/__init__.py
	cp pysodium/pysodium/__init__.py $@

pysodium:
	git submodule init pysodium; git submodule update pysodium

#### config for the sphinx server

pkg/server-key.pub: cfg/server-key.pub
	cp $< $@

pkg/sphinx.cfg: cfg/sphinx.cfg
	cp $< $@

#### sphinx python wrapper

pkg/bin2pass.py: pwdsphinx pwdsphinx/pwdsphinx/bin2pass.py
	cp pwdsphinx/pwdsphinx/bin2pass.py $@

pkg/config.py: pwdsphinx pwdsphinx/pwdsphinx/config.py
	cp pwdsphinx/pwdsphinx/config.py $@

pkg/sphinx.py: pwdsphinx pwdsphinx/pwdsphinx/sphinx.py
	cp pwdsphinx/pwdsphinx/sphinx.py $@

pkg/sphinxlib.py: pwdsphinx pwdsphinx/pwdsphinx/sphinxlib.py
	cp pwdsphinx/pwdsphinx/sphinxlib.py $@

pkg/websphinx.py: pwdsphinx pwdsphinx/pwdsphinx/websphinx.py
	cp pwdsphinx/pwdsphinx/websphinx.py $@

pwdsphinx:
	git submodule init pwdsphinx; git submodule update pwdsphinx

#### the native messaging manifests

pkg/websphinx.chrome.json: websphinx-chrom websphinx-chrom/websphinx.json
	sed -s 's/\%PATH\%/C:\\\\Program Files\\\\Sphinx 1.0\\\\websphinx.py/' websphinx-chrom/websphinx.json >pkg/websphinx.chrome.json

websphinx-chrom:
	git submodule init websphinx-chrom; git submodule update websphinx-chrom

pkg/websphinx.firefox.json: websphinx-firefox websphinx-firefox/websphinx.json
	sed -s 's/\%PATH\%/C:\\\\Program Files\\\\Sphinx 1.0\\\\websphinx.py/' <websphinx-firefox/websphinx.json >$@

websphinx-firefox:
	git submodule init websphinx-firefox; git submodule update websphinx-firefox

#### the windows installer

pkg/sphinx.wxs: sphinx.wxs
	cp $< $@

#### pinentry from gpg4win

gpg4win/gpg4win-$(GPG4WINVER): gpg4win gpg4win/gpg4win-$(GPG4WINVER).exe gpg4win/gpg4win-$(GPG4WINVER).exe.sig
	# get the two signing keys from
	# https://ssl.intevation.de/Intevation-Distribution-Key.asc
	# and https://ssl.intevation.de/Intevation-Distribution-Key-2016.asc
	$(GPG) --quiet --verify gpg4win/gpg4win-${GPG4WINVER}.exe.sig gpg4win/gpg4win-${GPG4WINVER}.exe 2>/dev/null
	7z x -ogpg4win/gpg4win-$(GPG4WINVER) -aou -y gpg4win/gpg4win-3.0.3.exe >/dev/null

gpg4win:
	mkdir gpg4win

gpg4win/gpg4win-$(GPG4WINVER).exe:
	cd gpg4win; wget -c -q https://files.gpg4win.org/gpg4win-${GPG4WINVER}.exe

gpg4win/gpg4win-$(GPG4WINVER).exe.sig:
	cd gpg4win; wget -c -q https://files.gpg4win.org/gpg4win-${GPG4WINVER}.exe.sig

pkg/Qt5Core.dll: gpg4win/gpg4win-$(GPG4WINVER) gpg4win/gpg4win-$(GPG4WINVER)/bin/Qt5Core.dll
	cp gpg4win/gpg4win-$(GPG4WINVER)/bin/Qt5Core.dll $@

pkg/Qt5Gui.dll: gpg4win/gpg4win-$(GPG4WINVER) gpg4win/gpg4win-$(GPG4WINVER)/bin/Qt5Gui.dll
	cp gpg4win/gpg4win-$(GPG4WINVER)/bin/Qt5Gui.dll $@

pkg/Qt5Widgets.dll: gpg4win/gpg4win-$(GPG4WINVER) gpg4win/gpg4win-$(GPG4WINVER)/bin/Qt5Widgets.dll
	cp gpg4win/gpg4win-$(GPG4WINVER)/bin/Qt5Widgets.dll $@

pkg/libassuan-0.dll: gpg4win/gpg4win-$(GPG4WINVER) gpg4win/gpg4win-$(GPG4WINVER)/bin/libassuan-0.dll
	cp gpg4win/gpg4win-$(GPG4WINVER)/bin/libassuan-0.dll $@

pkg/libgpg-error-0.dll: gpg4win/gpg4win-$(GPG4WINVER) gpg4win/gpg4win-$(GPG4WINVER)/bin/libgpg-error-0.dll
	cp gpg4win/gpg4win-$(GPG4WINVER)/bin/libgpg-error-0.dll $@

pkg/pinentry-qt.exe: gpg4win/gpg4win-$(GPG4WINVER) gpg4win/gpg4win-$(GPG4WINVER)/bin/pinentry-qt.exe
	cp gpg4win/gpg4win-$(GPG4WINVER)/bin/pinentry-qt.exe $@

pkg/qwindows.dll: gpg4win/gpg4win-$(GPG4WINVER) gpg4win/gpg4win-$(GPG4WINVER)/bin/platforms/qwindows.dll
	cp gpg4win/gpg4win-$(GPG4WINVER)/bin/platforms/qwindows.dll $@

pkg/libstdc++-6.dll: gpg4win/gpg4win-$(GPG4WINVER) gpg4win/gpg4win-$(GPG4WINVER)/bin/libstdc++-6.dll
	cp gpg4win/gpg4win-$(GPG4WINVER)/bin/libstdc++-6.dll $@

###### libsodium

libsodium/libsodium-win64: libsodium libsodium/libsodium-${SODIUMVER}-mingw.tar.gz libsodium/libsodium-${SODIUMVER}-mingw.tar.gz.sig
	$(GPG) --quiet --verify libsodium/libsodium-${SODIUMVER}-mingw.tar.gz.sig libsodium/libsodium-${SODIUMVER}-mingw.tar.gz 2>/dev/null
	cd libsodium; tar xaf libsodium-${SODIUMVER}-mingw.tar.gz
	touch libsodium/libsodium-win64

libsodium:
	mkdir libsodium

libsodium/libsodium-${SODIUMVER}-mingw.tar.gz:
	cd libsodium; wget -c -q https://download.libsodium.org/libsodium/releases/libsodium-${SODIUMVER}-mingw.tar.gz

libsodium/libsodium-${SODIUMVER}-mingw.tar.gz.sig:
	cd libsodium; wget -c -q https://download.libsodium.org/libsodium/releases/libsodium-${SODIUMVER}-mingw.tar.gz.sig

pkg/libsodium.dll: libsodium/libsodium-win64 libsodium/libsodium-win64/bin/libsodium-23.dll
	cp libsodium/libsodium-win64/bin/libsodium-23.dll $@

#### websphinx-chrom* extension

pkg/websphinx:
	mkdir -p $@

pkg/websphinx/_locales/en: pkg/websphinx
	mkdir -p $@

pkg/websphinx/popup.js: pkg/websphinx websphinx-chrom/websphinx/popup.js
	cp websphinx-chrom/websphinx/popup.js $@

pkg/websphinx/popup.html: pkg/websphinx websphinx-chrom/websphinx/popup.html
	cp websphinx-chrom/websphinx/popup.html $@

pkg/websphinx/popup.css: pkg/websphinx websphinx-chrom/websphinx/popup.css
	cp websphinx-chrom/websphinx/popup.css $@

pkg/websphinx/manifest.json: pkg/websphinx websphinx-chrom/websphinx/manifest.json
	cp websphinx-chrom/websphinx/manifest.json $@

pkg/websphinx/inject.js: pkg/websphinx websphinx-chrom/websphinx/inject.js
	cp websphinx-chrom/websphinx/inject.js $@

pkg/websphinx/icon.png: pkg/websphinx websphinx-chrom/websphinx/icon.png
	cp websphinx-chrom/websphinx/icon.png $@

pkg/websphinx/background.js: pkg/websphinx websphinx-chrom/websphinx/background.js
	cp websphinx-chrom/websphinx/background.js $@

pkg/websphinx/_locales/en/messages.json: pkg/websphinx/_locales/en websphinx-chrom/websphinx/_locales/en/messages.json
	cp websphinx-chrom/websphinx/_locales/en/messages.json $@

#### blobs

pkg/libgcc_s_seh-1.dll: blobs/libgcc_s_seh-1.dll
	#cp /usr/lib/gcc/x86_64-w64-mingw32/7.2-posix/libgcc_s_seh-1.dll $@
	cp $< $@

pkg/libgcc_s_sjlj-1.dll: blobs/libgcc_s_sjlj-1.dll
	#cp /usr/lib/gcc/i686-w64-mingw32/7.2-posix/libgcc_s_sjlj-1.dll $@
	cp $< $@

pkg/libwinpthread-1.dll: blobs/libwinpthread-1.dll
	cp $< $@

##### house-keeping

clean:
	rm -rf gpg4win/gpg4win-$(GPG4WINVER) libsodium/libsodium-win32 libsodium/libsodium-win64 pkg

.PHONY: clean
