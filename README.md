# ⸭ ParticleOS

[ParticleOS](https://github.com/systemd/particleos) is an extremely cool
meta-distribution from the systemd project. It's my favorite thing in software
since getting into IPv6. Concretely, it's a configuration for systemd's [`mkosi`
tool](https://mkosi.systemd.io/) that you use to build your own ParticleOS
images. As described in the readme:

> ParticleOS is a fully customizable immutable distribution implementing the
concepts described in [Fitting Everything
Together](https://0pointer.net/blog/fitting-everything-together.html).

Among other things, it has the following characteristics:

- OS versions are delivered as immutable `/usr` partitions
  - A/B partitions for worry-free upgrades and rollbacks
  - Block-level integrity provided by
    [dm-verity](https://wiki.archlinux.org/title/Dm-verity)
  - Authenticity provided by a signature on the dm-verity data, with signing
    done by your own keys
- Is easily hacked on, just like traditional mutable OSes
  - Essentially *is* a traditional OS (one of Arch, Debian, or Fedora), built
    from regular distro packages
  - Hacking on `/usr` is done at image build-time, rather than during OS runtime
- Is signed with your own SecureBoot keys
- LUKS-encrypted root partition with TPM-bound key for automatic unlocking
- LUKS-encrypted home directory managed by
  [`systemd-homed`](https://systemd.io/HOME_DIRECTORY/)

This here is my own customized version/soft fork of ParticleOS. It's the Fedora
variant.

See [here](https://www.cgl.sh/blog/posts/particleos.html) for my blog post on
ParticleOS and mkosi.

## Notable files/directories

- [makefile](makefile)—contains most important commands. `build` and
  `sysupdate` targets are the main ones. is also responsible for downloading
  miscellaneous unpackaged binaries.
- [mkosi.local.conf](mkosi.local.conf)—the linchpin that holds the custom
  configuration together.
- [mkosi.profiles/custom](mkosi.profiles/custom)—the custom `mkosi` profile
  where most of my customizations live.
  - [mkosi.conf](mkosi.profiles/custom/mkosi.conf)—contains the
    packages I want installed.
  - [mkosi.extra](mkosi.profiles/custom/mkosi.extra)—additional files that
    get included in the built images.

## Other changes

In addition to the above customizations, there are a number of other small
tweaks I've made, mostly to get Fedora+KDE Plasma working together. Some of them
should probably be upstreamed to the ParticleOS project. The overall patchset
can be seen [here on Gitpatch](https://gitpatch.com/jcgl/particleos/patch/5).
