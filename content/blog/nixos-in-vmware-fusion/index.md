+++
title = "Setting up NixOS in VMware Fusion Public Tech Preview 22H2"
date = 2022-08-05

[taxonomies]
tags = ["nixos"]
+++

On the macOS host:

1. Install and start [Docker Desktop for Mac](https://docs.docker.com/desktop/install/mac-install)
1. `git clone https://github.com/normful/nixos-config.git`
1. `cd nixos-config && make iso/nixos.iso`
1. Install [VMware Fusion Public Tech Preview 22H2](https://customerconnect.vmware.com/downloads/get-download?downloadGroup=FUS-PUBTP-22H2)

In VMware Fusion:
1. Install from disc or image
1. Choose `nixos.iso`
1. Select **Linux** -> **Other Linux 5.x kernel 64-bit Arm**
1. Click **Customize Settings**
1. Type a better name into the **Save As** field.
1. **Display**:
    {{ img(path="./display-settings.png", alt="") }}
1. **Network Adapter** -> **Connect Network Adapter** -> **Share with my Mac** (default)
1. **Hard Disk**:
    {{ img(path="./hard-disk-settings-nvme.png", alt="") }}
1. **Sound Card** -> **Remove Sound Card**
1. **Camera** -> **Remove Camera**
1. Start VM

On the VM:
1. Press enter to start the installer (default selection). This will run https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/system/boot/stage-1-init.sh
    - For some strange reason, at one point, it was running into an error trying to mount `/mnt-root` even though `/mnt-root` was not even mounted in latter attempts that succeeded.
1. `setfont ter-v32n` to use a larger font.
1. Switch into into the `root` user: `sudo su`
1. Set the `root` user password to `root`: `passwd`
1. Write down IP address from `ip a` output.

On the host:
1. Fill in `NIXADDR` in the `Makefile` using the IP address.
1. `make vm/boostrap0` and wait it to finish and reboot.
1. `docker run -it --rm alpine mkpasswd -m sha-512` and copy the password hash to `nixos-config/users/norman/nixos.nix` in `users.users.norman.hashedPassword`.
1. Copy `~/.ssh/id_ed25519.pub` to `nixos-config/users/norman/nixos.nix` in `users.users.norman.openssh.authorizedKeys.keys`.
1. `make vm/boostrap` and wait it to finish and reboot.
