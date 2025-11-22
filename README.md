# Tools

git clone --depth=1 https://github.com/junegunn/fzf ~/.fzf
~/.fzf/install --key-bindings --completion --no-update-rc

curl -o ~/.LS_COLORS https://raw.githubusercontent.com/trapd00r/LS_COLORS/master/LS_COLORS

fdfind: https://github.com/sharkdp/fd/releases

bat: https://github.com/sharkdp/bat/releases

lsd: https://github.com/lsd-rs/lsd/releases

sudo apt install chafa btop

mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts

# fonts
wget 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf'
wget 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf'
wget 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf'
wget 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf'

fc-cache -fv

or system wide
sudo mkdir -p /usr/local/share/fonts/meslo-nerd
cd /usr/local/share/fonts/meslo-nerd

sudo wget 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf'
sudo wget 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf'
sudo wget 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf'
sudo wget 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf'

sudo fc-cache -fv

https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg
https://vitormv.github.io/fzf-themes/