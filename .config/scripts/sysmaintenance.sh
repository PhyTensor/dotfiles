#!/usr/bin/env bash

echo "[ + ] Updating system"
sudo pacman -Syu

echo "[ + ] Clearing pacman cache"
pacman_cache_space_used="$(du -sh /var/cache/pacman/pkg/)"
paccache -ruk 1
paccache -rvk 1
paccache -rvk 0
echo "[ + ] Space saved: $pacman_cache_space_used"

echo "[ + ] Removing orphan packages"
sudo pacman -Qdtq | sudo pacman -Rns $(pacman -Qtdq) --noconfirm

echo "[ + ] Clearing ~/.cache"
home_cache_used="$(du -sh ~/.cache)"
sudo rm -rf ~/.cache/
echo "[ + ] Spaced saved: $home_cache_used"

echo "[ + ] Clearing system logs"
sudo journalctl --vacuum-time=7d

echo "[ + ] Done!!"
