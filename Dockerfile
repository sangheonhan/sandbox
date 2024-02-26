FROM ubuntu:24.04

ENV TERM=xterm-256color
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true
ENV LANG=ko_KR.UTF-8
ENV LC_MESSAGES=POSIX

WORKDIR /app/

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list && \
apt update -y && \
apt install -y curl wget ack locales language-pack-ko tzdata zsh vim tmux git \
rsync exuberant-ctags black python3-venv gpg sudo gosu && \
echo "Asia/Seoul" > /etc/timezone; \
ln -fs /usr/share/zoneinfo/`cat /etc/timezone` /etc/localtime && \
git config --global pull.rebase false && \
locale-gen ko_KR.UTF-8 && \
update-locale LANG=ko_KR.UTF-8 && \
dpkg-reconfigure --frontend noninteractive locales && \
echo "export LC_MESSAGES=POSIX" >> ~/.extra; \
chsh -s /bin/zsh root && \
usermod -l app ubuntu && \
groupmod -n app ubuntu && \
usermod -d /home/app -m app && \
chown -R app:app /home/app && \
passwd -d app && \
usermod -c "Application" app && \
chsh -s /bin/zsh app && \
echo "app ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/app && \
chmod 0440 /etc/sudoers.d/app && \
sudo -u app bash -c "cd /home/app/ && git clone https://github.com/sangheonhan/dotfiles.git && cd ./dotfiles && ./bootstrap.sh -f && echo 'export LC_MESSAGES=POSIX' >> ~/.extra" && \
apt clean autoclean -y && \
apt autoremove -y && \ 
chmod +x /usr/local/bin/entrypoint.sh && \
rm -rf ~/dotfiles/ /var/lib/apt/lists /var/lib/apt/ /var/lib/cache/ /var/lib/log/

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
