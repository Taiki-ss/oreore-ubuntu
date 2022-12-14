#!/bin/bash

# Capslock => ctrl
sudo sed -i 's/XKBOPTIONS=""/XKBOPTIONS="ctrl:nocaps"/g' /etc/default/keyboard

# .bash_aliases
echo "#!/bin/bash
alias s='systemctl suspend -i'
alias vi='vim'
alias rl='cd \`readlink -f .\`'
alias gs='git status'
alias ga='git add'
alias gcm='git commit -m'
alias gl='git log'
alias gb='git branch'
alias gc='git checkout'
alias gd='git diff HEAD'

# docker関連
function dc(){
	case \$1 in
		# コンテナ一覧
		\"ps\")
			docker ps;;
		# 現在のディレクトリ名のサービスのbashに潜る
		\"bash\")
			docker compose exec \$(basename \$(pwd)) bash;;
		# コンテナ停止
		\"down\")
			docker compose down;;
		# 全停止
		\"stop\")
			docker stop \$(docker ps -q);;
		# ミキプルーン
		\"prune\")
			docker system prune -a;;
		\"build\")
			docker compose up -d --build;;
		# 起動
		*)
			docker compose up -d
	esac
}" > ~/.bash_aliases

# git
sudo apt update
sudo apt install -y git
echo "githubのユーザー名を入力してください"
read github_user
git config --global user.name $github_user
echo "githubのEmailを入力してください"
read github_email
git config --global user.email $github_email

# .netrc
echo "githubのアクセストークンを入力してください
ここで発行  ====>  https://github.com/settings/tokens"
read github_token
echo "machine github.com
login $github_user
password $github_token" > ~/.netrc

# vim
sudo apt install vim neovim -y

# vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# termiantor
sudo apt install terminator

# keychain
sudo apt install keychain -y
echo "
# keychain 
source \$HOME/.keychain/\`hostname\`-sh" >> .bashrc

# ssh-server
sudo apt install -y openssh-server

# return English
LANG=C xdg-user-dirs-gtk-update

# docker
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
cat /etc/apt/sources.list.d/docker.list
sudo apt update
sudo apt info docker-ce
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo docker version
docker version
echo "このUbuntuのユーザー名を入力してください"
read ubuntu_user
sudo usermod -aG docker $ubuntu_user
sudo docker run hello-world

# mkcert
sudo apt -y install mkcert
sudo apt -y install libnss3-tools
mkcert -install

# google chrome 
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
sudo wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo apt update
sudo apt install -y google-chrome-stable

# vscode
sudo apt install software-properties-common apt-transport-https wget
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt install -y code

# slack
sudo snap install slack --classic

# Qlipper
sudo apt install -y qlipper

# Brave
sudo apt install apt-transport-https curl
curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser

# CapsLock to Ctrl
gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:nocaps']"

gsettings set org.gnome.desktop.interface gtk-key-theme Emacs

echo "設定完了！すべてを反映するには再起動してください。"
