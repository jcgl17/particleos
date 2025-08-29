DISTRIBUTION := fedora
DISTRIBUTION_RELEASE := 44

BIN_DIR := mkosi.profiles/custom/mkosi.extra/usr/local/bin
PACKAGES_DIR := mkosi.profiles/custom/mkosi.packages
btdu := $(BIN_DIR)/btdu
fish-lsp := $(BIN_DIR)/fish-lsp
jj := $(BIN_DIR)/jj
trash := $(BIN_DIR)/trash
tkey_verification := $(PACKAGES_DIR)/tkey_verification.rpm
tkey_ssh_agent := $(PACKAGES_DIR)/tkey_ssh_agent.rpm
tkey_sign := $(PACKAGES_DIR)/tkey_sign.rpm
opensnitch := $(PACKAGES_DIR)/opensnitch.rpm
opensnitch_ui := $(PACKAGES_DIR)/opensnitch_ui.rpm
stripe := $(PACKAGES_DIR)/stripe.rpm
tux-manager := $(PACKAGES_DIR)/tux-manager.rpm
ALL := $(btdu) $(fish-lsp) $(jj) $(tkey_verification) $(tkey_ssh_agent) $(tkey_sign) $(opensnitch) $(opensnitch_ui) $(tux-manager) $(stripe) $(trash)
LATEST_VERSION = $(shell mkosi summary --json | jq -r '.Images[] | select(.Image == "main") | .ImageVersion')
INSTALLED_VERSION = $(shell grep IMAGE_VERSION /etc/os-release | cut -d= -f2 | tr -d \")

.PHONY: build
build: deps
	mkosi build \
		--auto-bump \
		--cache-only never \
		--incremental no \
		--force \
		--distribution $(DISTRIBUTION) \
		--release $(DISTRIBUTION_RELEASE) \
		--extra-search-path ./systemd/build/mkosi.builddir/$(DISTRIBUTION)~$(DISTRIBUTION_RELEASE)~x86-64/ \
		--volatile-package-directory ./systemd/build/mkosi.builddir/$(DISTRIBUTION)~$(DISTRIBUTION_RELEASE)~x86-64/

.PHONY: deps
deps: $(PACKAGES_DIR) $(BIN_DIR) $(ALL)

.PHONY: clean
clean:
	rm -fv $(ALL)

$(BIN_DIR) $(PACKAGES_DIR):
	mkdir -p $@

$(btdu): $(MAKE_TMPDIR)/btdu
	echo 35b9bb752e6aa902b8281e92a5411b2f1cfb9fa251089adf909dc95efc011c48 $(MAKE_TMPDIR)/btdu | sha256sum --check
	cp $(MAKE_TMPDIR)/btdu $@
	chmod +x $@

$(MAKE_TMPDIR)/fish-lsp:
	wget https://github.com/ndonfris/fish-lsp/releases/download/v1.1.2/fish-lsp.standalone -O $(MAKE_TMPDIR)/fish-lsp

$(fish-lsp): $(MAKE_TMPDIR)/fish-lsp
	echo 948cd962a77cac437307e56be5f9b70737207949b623d470c3ffaefeb125f1fd $(MAKE_TMPDIR)/fish-lsp | sha256sum --check
	cp $(MAKE_TMPDIR)/fish-lsp $@
	chmod +x $@

$(MAKE_TMPDIR)/btdu:
	wget https://github.com/CyberShadow/btdu/releases/download/v0.6.0/btdu-static-x86_64 -O $(MAKE_TMPDIR)/btdu

$(jj): $(MAKE_TMPDIR)/jj.tar.gz
	echo 9967a240e3294a0bce4444c55d40a35b70af44c69b558689aced95e4e497cef2 $(MAKE_TMPDIR)/jj.tar.gz | sha256sum --check
	tar -xzf $(MAKE_TMPDIR)/jj.tar.gz -C $(MAKE_TMPDIR) --one-top-level=jj_out --overwrite
	cp $(MAKE_TMPDIR)/jj_out/jj $@

$(MAKE_TMPDIR)/jj.tar.gz:
	wget https://github.com/jj-vcs/jj/releases/download/v0.35.0/jj-v0.35.0-x86_64-unknown-linux-musl.tar.gz -O $(MAKE_TMPDIR)/jj.tar.gz

$(tkey_verification): $(MAKE_TMPDIR)/tkey_verification.rpm
	echo ec4fbee3c7e893f2223678a13f865325c303cb8d28d172884e166c5709bca7d1 $(MAKE_TMPDIR)/tkey_verification.rpm | sha256sum --check
	cp $(MAKE_TMPDIR)/tkey_verification.rpm $@

$(MAKE_TMPDIR)/tkey_verification.rpm:
		wget https://github.com/tillitis/tkey-verification/releases/download/v1.0.0/tkey-verification_1.0.0_linux_amd64.rpm -O $(MAKE_TMPDIR)/tkey_verification.rpm

$(tkey_ssh_agent): $(MAKE_TMPDIR)/tkey_ssh_agent.rpm
	echo d7f03ff9f4510ef870a115103baff3d9fed31b9212ec5a9e1c1567a4bdf5f917 $(MAKE_TMPDIR)/tkey_ssh_agent.rpm | sha256sum --check
	cp $(MAKE_TMPDIR)/tkey_ssh_agent.rpm $@

$(MAKE_TMPDIR)/tkey_ssh_agent.rpm:
		wget https://github.com/tillitis/tkey-ssh-agent/releases/download/v1.0.0/tkey-ssh-agent_1.0.0_linux_amd64.rpm -O $(MAKE_TMPDIR)/tkey_ssh_agent.rpm

$(tkey_sign): $(MAKE_TMPDIR)/tkey_sign.rpm
	echo ee141ed35e0ebf455e01757bb04782ab9e56ce5069410be016643f77273aceb6 $(MAKE_TMPDIR)/tkey_sign.rpm | sha256sum --check
	cp $(MAKE_TMPDIR)/tkey_sign.rpm $@

$(MAKE_TMPDIR)/tkey_sign.rpm:
		wget https://github.com/tillitis/tkey-sign/releases/download/v1.0.1/tkey-sign_1.0.1_linux_amd64.rpm -O $(MAKE_TMPDIR)/tkey_sign.rpm

$(opensnitch): $(MAKE_TMPDIR)/opensnitch.rpm
	echo e06e9119daf764e56455b61c319e496274c0274bb53bb94a0ff1ab72967fea7d $(MAKE_TMPDIR)/opensnitch.rpm | sha256sum --check
	cp $(MAKE_TMPDIR)/opensnitch.rpm $@

$(MAKE_TMPDIR)/opensnitch.rpm:
		wget https://github.com/evilsocket/opensnitch/releases/download/v1.8.0/opensnitch-1.8.0-1.x86_64.rpm -O $(MAKE_TMPDIR)/opensnitch.rpm

$(opensnitch_ui): $(MAKE_TMPDIR)/opensnitch_ui.rpm
	echo e5527b6b0040f771cd5345d4917269f0fe98b6d06064bae15f4ab937e45b4a08 $(MAKE_TMPDIR)/opensnitch_ui.rpm | sha256sum --check
	cp $(MAKE_TMPDIR)/opensnitch_ui.rpm $@

$(MAKE_TMPDIR)/opensnitch_ui.rpm:
	wget https://github.com/evilsocket/opensnitch/releases/download/v1.8.0/opensnitch-ui-1.8.0-1.noarch.rpm -O $(MAKE_TMPDIR)/opensnitch_ui.rpm

$(tux-manager): $(MAKE_TMPDIR)/tux-manager.rpm
	echo 274f5af019cdc328561bf9a5ed76c7df34a56ec8d2f2b02fab5b7bdd6a989814 $(MAKE_TMPDIR)/tux-manager.rpm | sha256sum --check
	cp $(MAKE_TMPDIR)/tux-manager.rpm $@

$(MAKE_TMPDIR)/tux-manager.rpm:
	wget https://github.com/benapetr/TuxManager/releases/download/v1.0.4/tux-manager-1.0.4-1.fc43.x86_64.rpm -O $(MAKE_TMPDIR)/tux-manager.rpm

$(stripe): $(MAKE_TMPDIR)/stripe.rpm
	echo d79e6e151ba71aa7e12eaf1375a6a6c365300e8e59455275b1f9ac820e818641 $(MAKE_TMPDIR)/stripe.rpm | sha256sum --check
	cp $(MAKE_TMPDIR)/stripe.rpm $@

$(MAKE_TMPDIR)/stripe.rpm:
	wget https://github.com/stripe/stripe-cli/releases/download/v1.35.1/stripe_1.35.1_linux_amd64.rpm -O $(MAKE_TMPDIR)/stripe.rpm

$(trash): $(MAKE_TMPDIR)/trashy.tar.gz
	echo a122c8994c6884629c0157fe9d375c9a156a14b236ccbb1aee28b08c3fa59a13 $(MAKE_TMPDIR)/trashy.tar.gz | sha256sum --check
	tar -xzf $(MAKE_TMPDIR)/trashy.tar.gz -C $(MAKE_TMPDIR) --one-top-level=trashy_out --overwrite
	cp $(MAKE_TMPDIR)/trashy_out/trash $@

$(MAKE_TMPDIR)/trashy.tar.gz:
	wget https://github.com/oberblastmeister/trashy/releases/download/v2.0.0/trash-x86_64-unknown-linux-gnu.tar.gz -O $(MAKE_TMPDIR)/trashy.tar.gz

mkosi.crt:
	ln -s ~/Vaults/particleos_keys/sbctl/var/keys/db/db.pem mkosi.crt

mkosi.key:
	ln -s ~/Vaults/particleos_keys/sbctl/var/keys/db/db.key mkosi.key

.PHONY: systemd
systemd:
	sh -c 'cd systemd && mkosi -t none -f --distribution $(DISTRIBUTION) --release $(DISTRIBUTION_RELEASE)'

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
