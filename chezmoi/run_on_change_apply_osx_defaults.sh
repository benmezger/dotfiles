#!/usr/bin/env bash

if [[ "$(uname)" != "Darwin" ]]; then
    exit 0
fi

# Sets sane OSX defaults

# Close System Preferences to prevent conflicts
osascript -e 'tell application "System Preferences" to quit' 2>/dev/null || true

## General

# Allow copy/paste across apps without delay (reduces clipboard latency)
defaults write org.nspasteboard.ConcealedType NSAllowsCoercion -bool true

# Disable sending diagnostic data to Apple
defaults write com.apple.SubmitDiagInfo AutoSubmit -bool false

# Disable crash reporter (no more crash dialogs)
defaults write com.apple.CrashReporter DialogType -string "none"

# Disabe UI sound system-wide
defaults write com.apple.systemsound "com.apple.sound.uiaudio.enabled" -int 0
defaults write NSGlobalDomain com.apple.sound.uiaudio.enabled -int 0

# Disable automatic capitalization
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Disable the "reopen windows when logging back in" prompt
defaults write com.apple.loginwindow TALLogoutSavesState -bool false

# Quit printer app once jobs are complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

## Keyboard

# Set key repeat rate (lower = faster; default: 6)
defaults write NSGlobalDomain KeyRepeat -int 1

# Set delay until key repeat (lower = shorter delay; default: 25)
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# Disable press-and-hold for keys (enables key repeat instead of accent picker)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

## Trackpad

# Enable tap-to-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

## Finder

# New Finder window opens in home directory instead of Recents
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME/"

# Show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Use list view in Finder by default (alternatives: icnv, clmv, Flwv)
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Show the ~/Library folder
chflags nohidden "$HOME/Library"

# Show the /Volumes folder
sudo chflags nohidden /Volumes

# Save screenshot to clipboard
defaults write com.apple.screencapture target -string "clipboard"

# Disable screenshot sound
defaults write com.apple.screencapture playHUDAnimation -bool false

## Dock

# Set Dock icon size to 30px
defaults write com.apple.dock tilesize -int 30

# Enable magnification
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 36

# Minimize windows into their application's icon
defaults write com.apple.dock minimize-to-application -bool true

# Show indicator lights for open applications
defaults write com.apple.dock show-process-indicators -bool true

## Menu

# Adjust whitespace settings in top bar so icons fit and don't go over the camera
defaults -currentHost write -globalDomain NSStatusItemSelectionPadding -int 6
defaults -currentHost write -globalDomain NSStatusItemSpacing -int 6

# Show battery percentage
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# Show date and time with seconds in menu bar
defaults write com.apple.menuextra.clock ShowSeconds -bool true
defaults write com.apple.menuextra.clock DateFormat -string "EEE MMM d  h:mm:ss a"

## Activity Monitor

# Show all processes
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

## Mac App Store

# Enable automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Check for updates daily
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

# Install system data files & security updates automatically
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

## Restart apps

for app in \
  "Activity Monitor" \
  "Dock" \
  "Finder" \
  "SystemUIServer" \
  "Terminal"; do
  killall "$app" &>/dev/null || true
done
