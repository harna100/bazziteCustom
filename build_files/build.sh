#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y tmux

dnf install -y fedpkg
fedpkg clone --anonymous kernel
cd kernel
fedpkg switch-branch f43
usermod -a -G mock root
newgrp -
wget -O linux-kernel-test.patch https://github.com/torvalds/linux/commit/1fb710793ce2619223adffaf981b1ff13cd48f17.patch
fedpkg mockbuild
ls -R results_kernel
ls results_kernel/6.17.7
cd results_kernel/6.17.7/ba14.fc43
rm *.src.rpm
dnf install ./*.rpm


# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
