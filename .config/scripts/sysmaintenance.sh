#!/usr/bin/env bash

echo "[ + ] Updating mirrorlist"
sudo reflector --protocol https --country Kenya,Germany,Bahrain,Netherlands --latest 20 --sort rate --threads $(nproc) --save /etc/pacman.d/mirrorlist

echo "[ + ] Updating system"
sudo pacman -Syu --noconfirm

echo "[ + ] Clearing pacman cache"
pacman_cache_space_used="$(du -sh /var/cache/pacman/pkg/)"
paccache -rk1
paccache -ruk0
echo "[ + ] Space saved: $pacman_cache_space_used"

echo "[ + ] Clear Trash"
rm -rf ~/.local/share/Trash/*

echo "[ + ] Removing orphan packages"
sudo pacman -Rns $(pacman -Qtdq) --noconfirm

echo "[ + ] Clearing ~/.cache"
home_cache_used="$(du -sh ~/.cache)"
rm -rf ~/.cache/
echo "[ + ] Spaced saved: $home_cache_used"

echo "[ + ] Clearing system logs"
sudo journalctl --vacuum-time=7d

echo "[ + ] Done!!"
