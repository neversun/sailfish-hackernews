Appname:=$(shell cat appname.txt)
prefix:=/usr
temp:=/tmp/fpm-jolla
sdkpath:=$(HOME)/SailfishOS
sourcePath:=$(shell pwd)
dependencies=$(shell for file in `cat dependencies.txt`;do echo "-d "$${file};done;)
arch:=noarch
version:=1.0.0
iteration:=1
rpmname:=$(Appname)-$(version)-$(iteration).$(arch).rpm
ssh_user:=nemo
jolla_usb_ip:=192.168.2.15
jolla_wifi_ip:=Jolla


all: clean build-tmp rpm

make-jolla-usb: build-tmp rpm send-jolla-usb
make-jolla-wifi: build-tmp rpm send-jolla-wifi
make-jolla-ap: build-tmp rpm send-jolla-ap
make-virt: build-tmp rpm send-virt

build-tmp:
	rm -rf $(temp)
	mkdir -p $(temp)/usr/share/applications
	mkdir -p $(temp)/usr/share/$(Appname)/src/pyPackages
	mkdir -p $(temp)/usr/share/icons/hicolor/86x86/apps
	mkdir -p $(temp)/usr/share/icons/hicolor/108x108/apps
	mkdir -p $(temp)/usr/share/icons/hicolor/128x128/apps
	mkdir -p $(temp)/usr/share/icons/hicolor/256x256/apps
	cp -ar ./qml $(temp)/usr/share/$(Appname)
	cp -ar ./src/* $(temp)/usr/share/$(Appname)/src
	cp -ar ./pyPackages/*$(arch) $(temp)/usr/share/$(Appname)/src/pyPackages
	cp ./dat/$(Appname).desktop $(temp)/usr/share/applications/
	cp -ar ./dat/harbour-hackernews-86.png $(temp)/usr/share/icons/hicolor/86x86/apps/$(Appname).png
	cp -ar ./dat/harbour-hackernews-108.png $(temp)/usr/share/icons/hicolor/108x108/apps/$(Appname).png
	cp -ar ./dat/harbour-hackernews-128.png $(temp)/usr/share/icons/hicolor/128x128/apps/$(Appname).png
	cp -ar ./dat/harbour-hackernews-256.png $(temp)/usr/share/icons/hicolor/256x256/apps/$(Appname).png

rpm: build-tmp
	cd $(temp);fpm -f -s dir -t rpm \
		--rpm-changelog $(sourcePath)/changelog.txt\
		--directories "/usr/share/$(Appname)" \
		-v $(version) \
		--iteration $(iteration) \
		$(dependencies) \
		-p $(temp)/$(rpmname) \
		-n $(Appname) \
		-a $(arch) \
		--vendor '' \
		--prefix / *

send-virt:
	cat $(temp)/$(rpmname) | ssh -i '$(sdkpath)/vmshare/ssh/private_keys/SailfishOS_Emulator/nemo' -p2223 $(ssh_user)@localhost \
		cat ">" /tmp/$(rpmname) "&&" \
		pkcon install-local -y /tmp/$(rpmname) "&&" \
		rm /tmp/$(rpmname)

send-jolla-wifi:
	cat $(temp)/$(rpmname) | ssh $(ssh_user)@$(jolla_wifi_ip) \
		cat ">" /tmp/$(rpmname) "&&" \
		pkcon install-local -y /tmp/$(rpmname) "&&" \
		rm /tmp/$(rpmname)

send-jolla-ap: jolla_wifi_ip:=192.168.1.1
send-jolla-ap:
	cat $(temp)/$(rpmname) | ssh $(ssh_user)@$(jolla_wifi_ip) \
		cat ">" /tmp/$(rpmname) "&&" \
		pkcon install-local -y /tmp/$(rpmname) "&&" \
		rm /tmp/$(rpmname)

send-jolla-usb:
	cat $(temp)/$(rpmname) | ssh $(ssh_user)@$(jolla_usb_ip) \
		cat ">" /tmp/$(rpmname) "&&" \
		pkcon install-local -y /tmp/$(rpmname) "&&" \
		rm /tmp/$(rpmname)

send-only-virt:
	cat $(temp)/$(rpmname) | ssh -i '$(sdkpath)/vmshare/ssh/private_keys/SailfishOS_Emulator/nemo' -p2223 $(ssh_user)@localhost \
		cat ">" /tmp/$(rpmname)

clean:
	rm -rf $(temp)
	rm -rf $(builddir)
	rm -rf ./$(rpmname)
