FROM ubuntu:22.04

ENV TERM=xterm-256color
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true
ENV LANG=ko_KR.UTF-8
ENV LC_MESSAGES=POSIX

RUN apt update -y && \
apt install -y curl wget ack locales language-pack-ko tzdata zsh vim neovim tmux git \
rsync exuberant-ctags black python3-venv && \
echo "Asia/Seoul" > /etc/timezone; \
ln -fs /usr/share/zoneinfo/`cat /etc/timezone` /etc/localtime && \
git config --global pull.rebase false && \
cd && git clone https://github.com/sangheonhan/dotfiles.git && \
cd ~/dotfiles/ && ./bootstrap.sh -f && \
locale-gen ko_KR.UTF-8 && \
update-locale LANG=ko_KR.UTF-8 && \
dpkg-reconfigure --frontend noninteractive locales && \
echo "export LC_MESSAGES=POSIX" >> ~/.extra; \
chsh -s /bin/zsh root && \
apt clean autoclean -y && \
apt autoremove -y && \ 
rm -rf /var/lib/{apt,dpkg,cache,log}/ ~/dotfiles/

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
