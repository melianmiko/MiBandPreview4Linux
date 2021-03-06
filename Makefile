#!/usr/bin/make -f
DESTDIR=/

all: qt clean

qt:
	cd mibandpreview_qt && pyuic5 qt/app.ui -o MainWindow.py
	cd mibandpreview_qt/qt && lupdate app.pro && lrelease app.pro

clean:
	rm -rf build

install:
	mkdir -p $(DESTDIR)/opt/mibandpreview
	mkdir -p $(DESTDIR)/usr/share/applications
	cp tools/mibandpreview-qt.desktop $(DESTDIR)/usr/share/applications/mibandpreview-qt.desktop
	cp -r mibandpreview $(DESTDIR)/opt/mibandpreview
	cp -r mibandpreview_qt $(DESTDIR)/opt/mibandpreview
	cp *.py $(DESTDIR)/opt/mibandpreview

uninstall:
	rm $(DESTDIR)/usr/share/applications/mibandpreview-qt.desktop
	rm -rf $(DESTDIR)/opt/mibandpreview

deb:
	dpkg-buildpackage -sa

windows: qt
	rm -rf dist/mibandpreview
	pyinstaller --name mibandpreview --icon mibandpreview_qt/res/icon.ico -w \
		--hidden-import=certifi \
		--add-data "mibandpreview/res;res" \
		--add-data "mibandpreview_qt/res;mibandpreview_qt/res" \
		--add-data "mibandpreview_qt/qt;mibandpreview_qt/qt" \
		--path "mibandpreview" --path "mibandpreview_qt" \
		__main__.py
	cp tools/installer.nsi dist/installer.nsi
	cd dist && makensis installer.nsi
