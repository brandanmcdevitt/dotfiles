#!/usr/bin/env bash
current_directory=$(pwd)

echo "Installing Packages..."

# Install Homebrew if it's not already installed
if test ! $(which brew); then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew update

# Brew packages to install
PACKAGES=(
    fortune
    mas
    wget
    zsh
)

echo "Installing packages..."
brew install ${PACKAGES[@]}

echo "Cleaning up..."
brew cleanup

# Brew casks to install
CASKS=(
    bitwarden
    charles
    google-chrome
    iterm2
    notion
    pdf-expert
    postman
    simsims
    slack
    spotify
    the-unarchiver
    visual-studio-code
    whatsapp
)

read -p "Is this a work environment? (Y/N): " environment

if [[ $environment == [nN] || $environment == [nN][oO] ]]; then
    # Additional casks to install if running on a home environment
    CASKS+=(
        discord
        dropbox
        google-drive
        mamp
        plex-media-server
        qbittorrent
    )

    # Install Sketch@55.2-78181
    cd "$(brew --repo homebrew/cask)" && git checkout 908eea010dc48fb01643fb92c96cd160ef005cfb
    HOMEBREW_NO_AUTO_UPDATE=1 brew install --cask sketch
    git checkout master
    cd $current_directory
fi

# Install Spotmenu@1.8
cd "$(brew --repo homebrew/cask)" && git checkout 295ffc11c10e1f8297bf70192d45155d90cfbeaa
HOMEBREW_NO_AUTO_UPDATE=1 brew install --cask spotmenu
brew pin spotmenu
git checkout master
cd $current_directory

echo "Installing cask apps..."
brew install --cask ${CASKS[@]}

echo "Installing fonts..."
brew tap homebrew/cask-fonts

# Array of fonts to install
FONTS=(
    font-hack-nerd-font
    font-droid-sans-mono-for-powerline
    font-droid-sans-mono-nerd-font
    font-roboto
)

brew install --cask ${FONTS[@]}

echo "Installing Ruby gems..."
RUBY_GEMS=(
    cocoapods
    colorls
    lolcat
)

sudo gem install ${RUBY_GEMS[@]}

echo "Installing App Store applications.."

# Install Amphetamine
mas install 937984704
# Install Wipr
mas install 1320666476
# Install DevCleaner
mas install 1388020431

echo "Configuring OSX System Settings..."

# Require password as soon as screensaver or sleep mode starts
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Enable tap-to-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# set ZSH as default shell
sudo sh -c "echo $(which zsh) >> /etc/shells" && chsh -s $(which zsh)

# install zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo "Packages installed"

echo "Updating dotfiles..."

cp zsh/custom/aliases.zsh ~/.oh-my-zsh/custom/aliases.zsh
cp zsh/custom/functions.zsh ~/.oh-my-zsh/custom/functions.zsh
cp zsh/.zshrc ~/

cp colorls/dark_colors.yaml ~/.config/colorls/dark_colors.yaml

echo "Dotfiles updated"
