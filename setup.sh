#Setup tmux
sudo apt install tmux
cd 
git clone https://github.com/gpakosz/.tmux.git .config/tmux
ln -s -f .config/tmux/.tmux.conf
cp .config/tmux/.tmux.conf.local .
sudo apt-get install fonts-powerline

#Setup nvim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
sudo mv ./nvim.appimage /usr/bin/nvim

#Setup conda
wget "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
sha256sum Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
rm Miniconda3-latest-Linux-x86_64.sh
#Install python neovim
conda install -c conda-forge neovim

#Setup yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install yarn
#Install yarn neovim
yarn global add neovim

#FZF
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
sudo apt install ripgrep
sudo apt install universal-ctags
sudo apt install silversearcher-ag
sudo apt install fd-find

#ZSH
sudo apt install zsh
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

#Font Iosevka
mkdir -p ~/fonts/
cd ~/fonts/ && wget -O Iosevka.zip "https://github.com/be5invis/Iosevka/releases/download/v3.6.2/pkg-iosevka-3.6.2.zip"
sudo apt install unzip
unzip ~/fonts/Iosevka.zip -d ~/fonts/Iosevka
mkdir -p ~/.local/share/fonts/Iosevka
cp ~/fonts/Iosevka/ttf/*.ttf ~/.local/share/fonts/Iosevka
fc-cache -f -v 
rm -rf ~/fonts/Iosevka

#Watchmen (required for coc-tsserver)
cd ~
git clone https://github.com/facebook/watchman.git -b v4.9.0 --depth 1
cd watchman
sudo apt-get install -y autoconf automake build-essential python2-dev
./autogen.sh 
./configure --enable-lenient 
make
sudo make install
watchman --version

#Haskell
cd ~
curl -sSL https://get.haskellstack.org/ | sh #Stack install
stack path --local-bin
##hie
sudo apt install libicu-dev libncurses-dev libgmp-dev zlib1g-dev
git clone https://github.com/haskell/haskell-language-server --recurse-submodules
cd haskell-language-server
stack ./install.hs hls
##hlint
stack install hlint
##apply-refact
stack install apply-refact
##stylish-haskell
stack install stylish-haskell
### NIX SETUP
# curl -L https://nixos.org/nix/install | sh
# nix-env --install cabal2nix
# nix-env --install nix-prefetch-git
# nix-env --install cabal-install
# nix-env -iA nixpkgs.zlib.dev
# nix-env -iA nixpkgs.zlib
# nix-env -i -f '<nixpkgs>' -E 'pkgs: (pkgs {}).ghc.withPackages (hp: with hp; [ zlib ])'
# INSTALL HLS WITH CABAL
