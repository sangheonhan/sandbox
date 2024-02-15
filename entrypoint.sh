#! /bin/bash

USERNAME=app

if [ ! -z "$HOST_UID" ] && [ ! -z "$HOST_GID" ]; then
    # If $HOST_UID is less than 1000, force to 1000
    # Because the user with UID less than 1000 is a system user
    if [ $HOST_UID -lt 1000 ]; then
	HOST_UID=1000
    fi
    if [ $HOST_GID -ne $HOST_UID ]; then
    	HOST_GID=$HOST_UID
    fi

    groupadd --gid $HOST_GID $USERNAME && \
    useradd --uid $HOST_UID --gid $HOST_GID --create-home --shell /bin/zsh $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME && \
    passwd -d $USERNAME

    USER_HOME=/home/$USERNAME

    if [ ! -d $USER_HOME/.vim ] || [ ! -d $USER_HOME/.oh-my-zsh ] || [ ! -d $USER_HOME/.fzf ]; then
	TEMP_DIR=$(sudo -u $USERNAME mktemp -d)
	sudo -u $USERNAME bash -c "cd $TEMP_DIR && git clone https://github.com/sangheonhan/dotfiles.git && cd $TEMP_DIR/dotfiles && ./bootstrap.sh -f && rm -rf $TEMP_DIR"
    fi
fi

exec gosu $USERNAME "$@"
