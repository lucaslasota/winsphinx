FILES=pkg/Qt5Core.dll \
	   pkg/Qt5Gui.dll \
	   pkg/Qt5Widgets.dll \
	   pkg/bin2pass.py \
	   pkg/config.py \
		pkg/icon.png \
		pkg/libassuan-0.dll \
		pkg/libgcc_s_seh-1.dll \
		pkg/libgcc_s_sjlj-1.dll \
		pkg/libgpg-error-0.dll \
		pkg/libsodium.dll \
		pkg/libsphinx.dll \
		pkg/libstdc++-6.dll \
		pkg/libwinpthread-1.dll \
		pkg/pinentry-qt.exe \
		pkg/platforms/qwindows.dll \
		pkg/pysodium.py \
		pkg/server-key.pub \
		pkg/sphinx.cfg \
		pkg/sphinx.py \
		pkg/sphinx.wxs \
		pkg/sphinxlib.py \
		pkg/websphinx.chrome.json \
		pkg/websphinx.firefox.json \
		pkg/websphinx.py

GPG4WINVER=3.0.3

pkg.zip: $(FILES)
	zip -r pkg pkg

pkg/libsodium.dll:

pkg/libsphinx.dll:

pkg/libgcc_s_seh-1.dll:

pkg/libgcc_s_sjlj-1.dll:

pkg/libstdc++-6.dll:

pkg/libwinpthread-1.dll:

pkg/pysodium.py: pysodium/pysodium/__init__.py
	cp $< $@

pkg/server-key.pub: cfg/server-key.pub
	cp $< $@

pkg/sphinx.cfg: cfg/sphinx.cfg
	cp $< $@

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

pkg/websphinx.chrome.json: websphinx-chrom/websphinx.json
	cp $< $@

pkg/websphinx.firefox.json: websphinx-firefox/websphinx.json
	cp $< $@

pkg/sphinx.wxs: sphinx.wxs
	cp $< $@

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
	gpg --quiet --verify gpg4win/gpg4win-${GPG4WINVER}.exe.sig gpg4win/gpg4win-${GPG4WINVER}.exe 2>/dev/null

pkg/Qt5Core.dll: gpg4win/gpg4win/bin/Qt5Core.dll
	cp $< $@

pkg/Qt5Gui.dll: gpg4win/gpg4win/bin/Qt5Gui.dll
	cp $< $@

pkg/Qt5Widgets.dll: gpg4win/gpg4win/bin/Qt5Widgets.dll
	cp $< $@

pkg/libassuan-0.dll: gpg4win/gpg4win/bin/libassuan-0.dll
	cp $< $@

pkg/libgpg-error-0.dll: gpg4win/gpg4win/bin/libgpg-error-0.dll
	cp $< $@

pkg/pinentry-qt.exe: gpg4win/gpg4win/bin/pinentry-qt.exe
	cp $< $@

pkg/qwindows.dll: gpg4win/gpg4win/bin/platforms/qwindows.dll
	cp $< $@

clean:
	rm -rf gpg4win

.PHONY: pinentry clean verify-gpg4win
