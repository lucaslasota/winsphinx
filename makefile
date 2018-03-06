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
		pkg/websphinx.py

GPG=gpg1
GPG4WINVER=3.0.3
SODIUMVER=1.0.16

pkg.zip: pkg $(FILES)
	zip -r pkg pkg

pkg:
	mkdir pkg

pkg/libgcc_s_seh-1.dll: blobs/libgcc_s_seh-1.dll
	#cp /usr/lib/gcc/x86_64-w64-mingw32/7.2-posix/libgcc_s_seh-1.dll $@
	cp $< $@

pkg/libgcc_s_sjlj-1.dll: blobs/libgcc_s_sjlj-1.dll
	#cp /usr/lib/gcc/i686-w64-mingw32/7.2-posix/libgcc_s_sjlj-1.dll $@
	cp $< $@

pkg/libsphinx.dll: libsphinx/src/libsphinx.dll
	cp $< $@

libsphinx/src/libsphinx.dll:
	cd libsphinx/src/goldilocks; make clean_generated; cd ..; make clean win

pkg/pysodium.py: pysodium/pysodium/__init__.py
	cp $< $@

#### config for the sphinx server

pkg/server-key.pub: cfg/server-key.pub
	cp $< $@

pkg/sphinx.cfg: cfg/sphinx.cfg
	cp $< $@

#### sphinx python wrapper

pkg/bin2pass.py: pwdsphinx/pwdsphinx/bin2pass.py
	cp $< $@

pkg/config.py: pwdsphinx/pwdsphinx/config.py
	cp $< $@

pkg/sphinx.py: pwdsphinx/pwdsphinx/sphinx.py
	cp $< $@

pkg/sphinxlib.py: pwdsphinx/pwdsphinx/sphinxlib.py
	cp $< $@

pkg/websphinx.py: pwdsphinx/pwdsphinx/websphinx.py
	cp $< $@

#### the native messaging manifests

pkg/websphinx.chrome.json: websphinx-chrom/websphinx.json
	cp $< $@

pkg/websphinx.firefox.json: websphinx-firefox/websphinx.json
	cp $< $@

#### the windows installer

pkg/sphinx.wxs: sphinx.wxs
	cp $< $@

#### pinentry from gpg4win

pinentry: gpg4win gpg4win/gpg4win-$(GPG4WINVER).exe gpg4win/gpg4win-$(GPG4WINVER).exe.sig verify-gpg4win
	7z x -ogpg4win/gpg4win -aou -y gpg4win/gpg4win-3.0.3.exe >/dev/null

gpg4win:
	mkdir gpg4win

gpg4win/gpg4win-$(GPG4WINVER).exe:
	cd gpg4win; wget -c -q https://files.gpg4win.org/gpg4win-${GPG4WINVER}.exe

gpg4win/gpg4win-$(GPG4WINVER).exe.sig:
	cd gpg4win; wget -c -q https://files.gpg4win.org/gpg4win-${GPG4WINVER}.exe.sig

verify-gpg4win:
	# get the two signing keys from
	# https://ssl.intevation.de/Intevation-Distribution-Key.asc
	# and https://ssl.intevation.de/Intevation-Distribution-Key-2016.asc
	$(GPG) --quiet --verify gpg4win/gpg4win-${GPG4WINVER}.exe.sig gpg4win/gpg4win-${GPG4WINVER}.exe 2>/dev/null

pkg/Qt5Core.dll: pinentry gpg4win/gpg4win/bin/Qt5Core.dll
	cp gpg4win/gpg4win/bin/Qt5Core.dll $@

pkg/Qt5Gui.dll: pinentry gpg4win/gpg4win/bin/Qt5Gui.dll
	cp gpg4win/gpg4win/bin/Qt5Gui.dll $@

pkg/Qt5Widgets.dll: pinentry gpg4win/gpg4win/bin/Qt5Widgets.dll
	cp gpg4win/gpg4win/bin/Qt5Widgets.dll $@

pkg/libassuan-0.dll: pinentry gpg4win/gpg4win/bin/libassuan-0.dll
	cp gpg4win/gpg4win/bin/libassuan-0.dll $@

pkg/libgpg-error-0.dll: pinentry gpg4win/gpg4win/bin/libgpg-error-0.dll
	cp gpg4win/gpg4win/bin/libgpg-error-0.dll $@

pkg/pinentry-qt.exe: pinentry gpg4win/gpg4win/bin/pinentry-qt.exe
	cp gpg4win/gpg4win/bin/pinentry-qt.exe $@

pkg/qwindows.dll: pinentry gpg4win/gpg4win/bin/platforms/qwindows.dll
	cp gpg4win/gpg4win/bin/platforms/qwindows.dll $@

pkg/libstdc++-6.dll: pinentry gpg4win/gpg4win/bin/libstdc++-6.dll
	cp gpg4win/gpg4win/bin/libstdc++-6.dll $@

pkg/libwinpthread-1.dll: pinentry gpg4win/gpg4win/bin/libwinpthread-1.dll
	cp gpg4win/gpg4win/bin/libwinpthread-1.dll $@

###### libsodium

sodium: libsodium libsodium/libsodium-${SODIUMVER}-mingw.tar.gz libsodium/libsodium-${SODIUMVER}-mingw.tar.gz.sig verify-libsodium
	cd libsodium; tar xaf libsodium-${SODIUMVER}-mingw.tar.gz

libsodium:
	mkdir libsodium

libsodium/libsodium-${SODIUMVER}-mingw.tar.gz:
	cd libsodium; wget -c -q https://download.libsodium.org/libsodium/releases/libsodium-${SODIUMVER}-mingw.tar.gz

libsodium/libsodium-${SODIUMVER}-mingw.tar.gz.sig:
	cd libsodium; wget -c -q https://download.libsodium.org/libsodium/releases/libsodium-${SODIUMVER}-mingw.tar.gz.sig

verify-libsodium:
	$(GPG) --quiet --verify libsodium/libsodium-${SODIUMVER}-mingw.tar.gz.sig libsodium/libsodium-${SODIUMVER}-mingw.tar.gz 2>/dev/null

pkg/libsodium.dll: sodium libsodium/libsodium-win64/bin/libsodium-23.dll
	cp libsodium/libsodium-win64/bin/libsodium-23.dll $@

##### house-keeping

clean:
	rm -rf gpg4win/gpg4win libsodium/libsodium-win32 libsodium/libsodium-win64 pkg

.PHONY: clean verify-gpg4win verify-libsodium
