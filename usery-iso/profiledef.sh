#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="usery"
iso_label="USERY_$(date +%Y%m)"
iso_publisher="Usery Project"
iso_application="Usery OS Live/Rescue System"
iso_version="$(date +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito' 'uefi-ia32.grub.esp' 'uefi-x64.grub.esp' 'uefi-ia32.grub.eltorito' 'uefi-x64.grub.eltorito')
arch="x86_64"
pacman_conf="pacman.conf"

file_permissions=(
  ["/etc/shadow"]="0:0:0400"
  ["/etc/gshadow"]="0:0:0400"
  ["/etc/passwd"]="0:0:0644"
  ["/etc/group"]="0:0:0644"
  ["/root"]="0:0:0750"
  ["/root/.automated_script.sh"]="0:0:0755"
  ["/root/.gnupg"]="0:0:0700"
  ["/usr/local/bin/choose-mirror"]="0:0:0755"
)
