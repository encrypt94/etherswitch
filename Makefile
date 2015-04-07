PKG_NAME="etherswitch"
PKG_VERSION=`git rev-parse HEAD`
PKG_DEPENDS=swconfig
PKG_MAINTAINER="encrypt <encrypt@labr.xyz>"
PKG_ARCH=all
PKG_DESCRIPTION="Simple daemon to control a toggle switch attached to a router."
BUILD_DIR=/tmp/etherswitch-$(PKG_VERSION)

ipk: tmpdir data control
	@echo "2.0" > $(BUILD_DIR)/package/debian-binary
	tar -cvzf etherswitch.ipk -C $(BUILD_DIR)/package .

data: tmpdir
	cp -R etc/ $(BUILD_DIR)/data
	mkdir -p $(BUILD_DIR)/data/usr/bin/
	cp ./etherswitch $(BUILD_DIR)/data/usr/bin/
	tar -cvzf $(BUILD_DIR)/package/data.tar.gz -C $(BUILD_DIR)/data/ .

control: tmpdir control-file
	echo "/etc/config/etherswitch" > $(BUILD_DIR)/control/conffiles
	tar -cvzf $(BUILD_DIR)/package/control.tar.gz -C $(BUILD_DIR)/control/ .

tmpdir:
	mkdir -p $(BUILD_DIR)/{control,data,package}
	find . -type f -name '*~' -delete #remove editor backup files

control-file: tmpdir
	$(eval CONTROL_FILE=$(BUILD_DIR)/control/control)
	@echo "Package: "$(PKG_NAME) > $(CONTROL_FILE)
	@echo "Version: "$(PKG_VERSION) >> $(CONTROL_FILE)
	@echo "Depends: "$(PKG_DEPENDS) >> $(CONTROL_FILE)
	@echo "Maintainer: "$(PKG_MAINTAINER) >> $(CONTROL_FILE)
	@echo "Architecture: "$(PKG_ARCH) >> $(CONTROL_FILE)
	@echo "Description: "$(PKG_DESCRIPTION) >> $(CONTROL_FILE)

clean: clean-tmpdir
	rm -f etherswitch.ipk

clean-tmpdir:
	rm -rf $(BUILD_DIR)
