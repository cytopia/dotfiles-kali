#!/usr/bin/env bash

set -e
set -u
set -o pipefail

ROOT_PATH="$(cd -P -- "$(dirname -- "${0}")" && pwd -P)"


# -------------------------------------------------------------------------------------------------
# Packages
# -------------------------------------------------------------------------------------------------
APT_PACKAGES="\
  chromium \
  compton \
  dunst \
  feh \
  git \
  i3 \
  libnotify-bin \
  maim \
  python-neovim \
  python3-neovim \
  python3-pip \
  qalc \
  rofi \
  rxvt-unicode-256color \
  tmux \
  x11-utils \
  xsel \
  silversearcher-ag \
"

PIP_PACKAGES="\
  pynvim \
"
PIP3_PACKAGES="\
  pynvim \
"

URL_PACKAGES="\
  https://raw.githubusercontent.com/K-Phoen/Config/master/bin/diff-highlight \
  https://raw.githubusercontent.com/cdown/clipmenu/master/clipdel \
  https://raw.githubusercontent.com/cdown/clipmenu/master/clipmenu \
  https://raw.githubusercontent.com/cdown/clipmenu/master/clipmenud \
  https://raw.githubusercontent.com/cytopia/autorunner/master/autorunner \
  https://raw.githubusercontent.com/cytopia/i3-utils-bin/master/bin/rcalc \
  https://raw.githubusercontent.com/cytopia/i3-utils-bin/master/bin/xscreenshot \
"

URL_FONTS=" \
  https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Terminus/terminus-ttf-4.40.1/Bold/complete/Terminess%20(TTF)%20Bold%20Nerd%20Font%20Complete%20Mono%20Windows%20Compatible.ttf \
  https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Terminus/terminus-ttf-4.40.1/Bold/complete/Terminess%20(TTF)%20Bold%20Nerd%20Font%20Complete%20Mono.ttf \
  https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Terminus/terminus-ttf-4.40.1/Bold/complete/Terminess%20(TTF)%20Bold%20Nerd%20Font%20Complete%20Windows%20Compatible.ttf \
  https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Terminus/terminus-ttf-4.40.1/Bold/complete/Terminess%20(TTF)%20Bold%20Nerd%20Font%20Complete.ttf \
  https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Terminus/terminus-ttf-4.40.1/BoldItalic/complete/Terminess%20(TTF)%20Bold%20Italic%20Nerd%20Font%20Complete%20Mono%20Windows%20Compatible.ttf \
  https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Terminus/terminus-ttf-4.40.1/BoldItalic/complete/Terminess%20(TTF)%20Bold%20Italic%20Nerd%20Font%20Complete%20Mono.ttf \
  https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Terminus/terminus-ttf-4.40.1/BoldItalic/complete/Terminess%20(TTF)%20Bold%20Italic%20Nerd%20Font%20Complete%20Windows%20Compatible.ttf \
  https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Terminus/terminus-ttf-4.40.1/BoldItalic/complete/Terminess%20(TTF)%20Bold%20Italic%20Nerd%20Font%20Complete.ttf \
  https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Terminus/terminus-ttf-4.40.1/Italic/complete/Terminess%20(TTF)%20Italic%20Nerd%20Font%20Complete%20Mono%20Windows%20Compatible.ttf \
  https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Terminus/terminus-ttf-4.40.1/Italic/complete/Terminess%20(TTF)%20Italic%20Nerd%20Font%20Complete%20Mono.ttf \
  https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Terminus/terminus-ttf-4.40.1/Italic/complete/Terminess%20(TTF)%20Italic%20Nerd%20Font%20Complete%20Windows%20Compatible.ttf \
  https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Terminus/terminus-ttf-4.40.1/Italic/complete/Terminess%20(TTF)%20Italic%20Nerd%20Font%20Complete.ttf \
  https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Terminus/terminus-ttf-4.40.1/Regular/complete/Terminess%20(TTF)%20Nerd%20Font%20Complete%20Mono%20Windows%20Compatible.ttf \
  https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Terminus/terminus-ttf-4.40.1/Regular/complete/Terminess%20(TTF)%20Nerd%20Font%20Complete%20Mono.ttf \
  https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Terminus/terminus-ttf-4.40.1/Regular/complete/Terminess%20(TTF)%20Nerd%20Font%20Complete%20Windows%20Compatible.ttf \
  https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Terminus/terminus-ttf-4.40.1/Regular/complete/Terminess%20(TTF)%20Nerd%20Font%20Complete.ttf \
"

# -------------------------------------------------------------------------------------------------
# Install Packages
# -------------------------------------------------------------------------------------------------

# Apt
apt update && apt install -y ${APT_PACKAGES}

# Python
pip install ${PIP_PACKAGES}
pip3 install ${PIP3_PACKAGES}

# Tools from URL
for url in ${URL_PACKAGES}; do
	name="$( echo "${url}" | sed 's/.*\///g' )"
	curl -sS "${url}" -o "/usr/local/bin/${name}"
	chmod +x "/usr/local/bin/${name}"
done

# Fonts from URL
mkdir -p "/usr/share/fonts/truetype/terminus/"
for url in ${URL_FONTS}; do
	name="$( echo "${url}" | sed -e 's/.*\///g' -e 's/%20/ /g' )"
	curl -sS -L "${url}" -o "/usr/share/fonts/truetype/terminus/${name}"
done
fc-cache -fv


# -------------------------------------------------------------------------------------------------
# Symlink config
# -------------------------------------------------------------------------------------------------

mkdir -p "${HOME}/.config"

###
### Autorunner
###
ln -sf "${ROOT_PATH}/autorunner" "${HOME}/.config/autorunner"


###
### Bash
###
if ! grep -E '^\. ~/\.config/bash/bashrc' "${HOME}/.bashrc" >/dev/null; then
	echo ". ~/.config/bash/bashrc" >> "${HOME}/.bashrc"
fi
ln -sf "${ROOT_PATH}/bash" "${HOME}/.config/bash"


###
### Binaries
###
cp -f "${ROOT_PATH}/bin/tmux-attach" "/usr/local/bin/tmux-attach"


###
### Git
###
ln -sf "${ROOT_PATH}/git/gitconfig" "${HOME}/.gitconfig"


###
### I3
###
ln -sf "${ROOT_PATH}/i3" "${HOME}/.config/i3"


###
### I3status
###
ln -sf "${ROOT_PATH}/i3status" "${HOME}/.config/i3status"


###
### Tmux
###
ln -sf "${ROOT_PATH}/tmux/tmux.conf" "${HOME}/.tmux.conf"
ln -sf "${ROOT_PATH}/tmux/config" "${HOME}/.config/tmux"


###
### Neovim
###
TMP_SCRIPT="$( mktemp )"
mkdir -p "${HOME}/.config/nvim"
curl -sS https://raw.githubusercontent.com/cytopia/dotfiles/master/neovim/init.vim -o "${HOME}/.config/nvim/init.vim"
curl -sS https://raw.githubusercontent.com/cytopia/dotfiles/master/neovim/coc-settings.json -o "${HOME}/.config/nvim/coc-settings.json"
curl -sS https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh -o "${TMP_SCRIPT}"
sh "${TMP_SCRIPT}" "${HOME}/.local/share/nvim/bundles" || true
rm -f "${TMP_SCRIPT}"
nvim +'call dein#install()' +qall || true
nvim +'call dein#update()' +qall
{
	echo "set termguicolors";
	echo "set colorcolumn=0";
	echo "hi Normal guibg=None ctermbg=None";
	echo "hi LineNr guibg=None ctermbg=None";
	echo "hi SignColumn guibg=None ctermbg=None";
	echo "hi SignifySignAdd guibg=None";
	echo "hi SignifySignDelete guibg=None";
	echo "hi SignifySignChange guibg=None";
} >> "${HOME}/.config/nvim/init.vim"


###
### Xresources
###
mkdir -p "${HOME}/.config/Xresources.d"
curl -sS https://raw.githubusercontent.com/cytopia/dotfiles/master/X11/Xresources -o "${HOME}/.Xresources"
curl -sS https://raw.githubusercontent.com/cytopia/dotfiles/master/X11/Xresources.d/colors.xresources -o "${HOME}/.config/Xresources.d/colors.xresources"
curl -sS https://raw.githubusercontent.com/cytopia/dotfiles/master/X11/Xresources.d/rofi.xresources -o "${HOME}/.config/Xresources.d/rofi.xresources"
curl -sS https://raw.githubusercontent.com/cytopia/dotfiles/master/X11/Xresources.d/urxvt.xresources -o "${HOME}/.config/Xresources.d/urxvt.xresources"
curl -sS https://raw.githubusercontent.com/cytopia/dotfiles/master/X11/Xresources.d/xft.xresources -o "${HOME}/.config/Xresources.d/xft.xresources"
curl -sS https://raw.githubusercontent.com/cytopia/dotfiles/master/X11/Xresources.d/fonts.xresources -o "${HOME}/.config/Xresources.d/fonts.xresources"
xrdb ~/.Xresources


###
### Application defines
###
cp -f "${ROOT_PATH}/applications/chromium.desktop" "/usr/share/applications/chromium.desktop"


###
### Wallpaper
###
cp "${ROOT_PATH}/wallpaper/wallpaper1.png" "${HOME}/Pictures/wallpaper1.png"
cp "${ROOT_PATH}/wallpaper/wallpaper2.png" "${HOME}/Pictures/wallpaper2.png"
