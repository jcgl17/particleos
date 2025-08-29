BIN_DIR := mkosi.profiles/custom/mkosi.extra/usr/local/bin
PACKAGES_DIR := mkosi.profiles/custom/mkosi.packages
btdu := $(BIN_DIR)/btdu
jj := $(BIN_DIR)/jj
opensnitch := $(PACKAGES_DIR)/opensnitch.rpm
opensnitch_ui := $(PACKAGES_DIR)/opensnitch_ui.rpm
ALL := $(btdu) $(jj) $(opensnitch) $(opensnitch_ui)
LATEST_VERSION = $(shell mkosi summary --json | jq -r '.Images[] | select(.Image == "main") | .ImageVersion')
INSTALLED_VERSION = $(shell grep IMAGE_VERSION /etc/os-release | cut -d= -f2 | tr -d \")

.PHONY: deps
deps: $(PACKAGES_DIR) $(BIN_DIR) $(ALL)

.PHONY: clean
clean:
	rm -fv $(ALL)

$(BIN_DIR) $(PACKAGES_DIR):
	mkdir -p $@

$(jj): $(MAKE_TMPDIR)/jj.tar.gz
	echo 9967a240e3294a0bce4444c55d40a35b70af44c69b558689aced95e4e497cef2 $(MAKE_TMPDIR)/jj.tar.gz | sha256sum --check
	tar -xzf $(MAKE_TMPDIR)/jj.tar.gz -C $(MAKE_TMPDIR) --one-top-level=jj_out --overwrite
	cp $(MAKE_TMPDIR)/jj_out/jj $@

$(MAKE_TMPDIR)/jj.tar.gz:
	wget https://github.com/jj-vcs/jj/releases/download/v0.35.0/jj-v0.35.0-x86_64-unknown-linux-musl.tar.gz -O $(MAKE_TMPDIR)/jj.tar.gz

$(btdu): $(MAKE_TMPDIR)/btdu
	echo 35b9bb752e6aa902b8281e92a5411b2f1cfb9fa251089adf909dc95efc011c48 $(MAKE_TMPDIR)/btdu | sha256sum --check
	cp $(MAKE_TMPDIR)/btdu $@
	chmod +x $@

$(MAKE_TMPDIR)/btdu:
	wget https://github.com/CyberShadow/btdu/releases/download/v0.6.0/btdu-static-x86_64 -O $(MAKE_TMPDIR)/btdu

$(opensnitch): $(MAKE_TMPDIR)/opensnitch.rpm
	echo 2caf4e13ffd1b7af48306a2e9e979042f526823720b42bee4c00194f140d64dd $(MAKE_TMPDIR)/opensnitch.rpm | sha256sum --check
	cp $(MAKE_TMPDIR)/opensnitch.rpm $@

$(MAKE_TMPDIR)/opensnitch.rpm:
		wget https://github.com/evilsocket/opensnitch/releases/download/v1.7.2/opensnitch-1.7.2-1.x86_64.rpm -O $(MAKE_TMPDIR)/opensnitch.rpm

$(opensnitch_ui): $(MAKE_TMPDIR)/opensnitch_ui.rpm
	echo b26029cbc83880ebc92170035d50237c13b17ffc0b3cf52b89fa1348edfdfb43 $(MAKE_TMPDIR)/opensnitch_ui.rpm | sha256sum --check
	cp $(MAKE_TMPDIR)/opensnitch_ui.rpm $@

$(MAKE_TMPDIR)/opensnitch_ui.rpm:
	wget https://github.com/evilsocket/opensnitch/releases/download/v1.7.2/opensnitch-ui-1.7.2-1.noarch.rpm -O $(MAKE_TMPDIR)/opensnitch_ui.rpm

mkosi.crt:
	ln -s ~/Vaults/particleos_keys/sbctl/var/keys/db/db.pem mkosi.crt

mkosi.key:
	ln -s ~/Vaults/particleos_keys/sbctl/var/keys/db/db.key mkosi.key

.PHONY: build
build: deps
	mkosi build --auto-bump --cache-only never

.PHONY: systemd
systemd:
	sh -c 'cd systemd && mkosi -t none -f --distribution=fedora --release=43'

.PHONY: sysupdate
sysupdate:
	mkosi sysupdate -- update
	mkdir -p versions
	cat mkosi.output/ParticleOS_$(LATEST_VERSION)_x86-64.changelog | gzip > versions/$(LATEST_VERSION).changelog.gz

.PHONY: diff_changelog
diff_changelog:
	sh -c 'diff --color=always -u <(gzip --decompress --to-stdout versions/$(INSTALLED_VERSION).changelog.gz) mkosi.output/ParticleOS_$(LATEST_VERSION)_x86-64.changelog; test $$? -le 1'

.PHONY: diff_manifest
diff_manifest:
	sh -c 'diff --color=always -u /etc/mkosi-manifest mkosi.output/ParticleOS_$(LATEST_VERSION)_x86-64.manifest; test $$? -le 1'
