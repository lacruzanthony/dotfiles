#!/usr/bin/env bash
# Preferencias de macOS: Dock y Finder. En un Mac gestionado por MDM algunas pueden ignorarse.
set -euo pipefail
source "$(dirname "$0")/lib.sh"

info "Dock"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock tilesize -int 48
defaults write com.apple.dock mineffect -string scale
defaults write com.apple.dock mru-spaces -bool false   # no reordenar escritorios por uso
killall Dock 2>/dev/null || true
ok "Dock"

info "Finder"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string Nlsv        # vista lista
defaults write com.apple.finder FXDefaultSearchScope -string SCcf        # buscar en la carpeta actual
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder NewWindowTarget -string PfHm             # ventanas nuevas en ~
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
killall Finder 2>/dev/null || true
ok "Finder"
