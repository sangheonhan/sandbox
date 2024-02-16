#! /bin/bash

DEFAULT_UID=1000
DEFAULT_GID=1000
DEFAULT_USERNAME=app

if [ ! -z "$HOST_UID" ] && [ ! -z "$HOST_GID" ]; then
    # If $HOST_UID and $HOST_GID is less than 1000, force to 1000
    # Because the user with UID less than 1000 is a system user
    if [ $HOST_UID -lt $DEFAULT_UID ]; then
        HOST_UID=$DEFAULT_UID
    fi
    if [ $HOST_GID -lt $DEFAULT_GID ]; then
        HOST_GID=$DEFAULT_GID
    fi

    EXISTING_USER=$(getent passwd "$HOST_UID" | cut -d: -f1)
    if [ ! -z "$EXISTING_USER" ]; then
        USERNAME=$EXISTING_USER
    else
        USERNAME=$DEFAULT_USERNAME
        if getent group $HOST_GID >/dev/null 2>&1; then
            useradd --uid $HOST_UID --gid $HOST_GID --create-home --shell /bin/zsh --no-user-group $USERNAME
        else
            groupadd --gid $HOST_GID $USERNAME
            useradd --uid $HOST_UID --gid $HOST_GID --create-home --shell /bin/zsh --no-user-group $USERNAME
        fi
        passwd -d $USERNAME
    fi

    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME
    chmod 0440 /etc/sudoers.d/$USERNAME

    USER_HOME=/home/$USERNAME
    if [ ! -d $USER_HOME/.vim ] || [ ! -d $USER_HOME/.oh-my-zsh ] || [ ! -d $USER_HOME/.fzf ]; then
        TEMP_DIR=$(sudo -u $USERNAME mktemp -d)
        sudo -u $USERNAME bash -c "cd $TEMP_DIR && git clone https://github.com/sangheonhan/dotfiles.git && cd $TEMP_DIR/dotfiles && ./bootstrap.sh -f && rm -rf $TEMP_DIR"
    fi

    chown $HOST_UID:$HOST_GID /app/
    chmod 0755 /app/

    exec gosu $USERNAME "$@"
else
    echo "HOST_UID and HOST_GID must be set"
    exit 1
fi
