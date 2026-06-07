# Build Usery OS ISO locally using Docker
Write-Host "==> Preparing local build folder..." -ForegroundColor Cyan
if (Test-Path -Path "out") {
    Remove-Item -Path "out" -Recurse -Force
}
New-Item -ItemType Directory -Path "out" -Force

Write-Host "==> Running build inside Arch Linux Docker..." -ForegroundColor Cyan
docker run --privileged --rm `
  -v "${PWD}:/workspace" `
  archlinux:latest `
  bash -ec '
    set -euo pipefail
    echo "==> Updating pacman database..."
    pacman -Syu --noconfirm

    echo "==> Installing build tools..."
    pacman -S --noconfirm archiso mkinitcpio-archiso grub mtools dosfstools \
      libisoburn syslinux efibootmgr squashfs-tools erofs-utils

    echo "==> Preparing build directory..."
    mkdir -p /build
    cp -a /workspace/usery-iso/. /build/

    echo "==> Restoring symbolic links..."
    find /build/airootfs -type f | while read -r file; do
      if [ -f "$file" ] && [ ! -s "$file" ]; then continue; fi
      first_line=$(head -n 1 "$file" 2>/dev/null || true)
      if [[ "$first_line" =~ ^/(usr|etc|var|run|bin|sbin|lib|lib64|proc|sys|dev)/ ]]; then
        if [[ ! "$first_line" =~ [[:space:]] ]] && [ ${#first_line} -lt 256 ]; then
          rm -f "$file"
          ln -s "$first_line" "$file"
        fi
      fi
    done

    echo "==> Running mkarchiso..."
    mkarchiso -v -w /tmp/archiso-tmp -o /workspace/out /build
  '

Write-Host "==> Build complete! ISO is in the '\''out'\'' directory." -ForegroundColor Green
