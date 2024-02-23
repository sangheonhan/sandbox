#! /bin/bash

UBUNTU_USER=ubuntu
UBUNTU_USER_UID=1000
UBUNTU_USER_GID=1000
USERNAME=app
USER_HOME=/home/$USERNAME

if getent passwd $USERNAME > /dev/null 2>&1; then
    echo "User $USERNAME already exists"
    exit 0
fi

if [ -z "$HOST_UID" ] || [ -z "$HOST_GID" ]; then
    echo "HOST_UID and HOST_GID must be set"
    exit 1
fi

# If $HOST_UID and $HOST_GID is less than 1000, force to 1000
# Because the user with UID less than 1000 is a system user
if [ $HOST_UID -lt $UBUNTU_USER_UID ]; then
    HOST_UID=$UBUNTU_USER_UID
fi
if [ $HOST_GID -lt $UBUNTU_USER_GID ]; then
    HOST_GID=$UBUNTU_USER_GID
fi

echo "Changing $UBUNTU_USER user to $USERNAME ($HOST_UID:$HOST_GID)"
usermod -l $USERNAME $UBUNTU_USER
groupmod -n $USERNAME $UBUNTU_USER
usermod -d $USER_HOME -m $USERNAME
passwd -d $USERNAME
chsh -s /bin/zsh $USERNAME
usermod -u $HOST_UID $USERNAME
groupmod -g $HOST_GID $USERNAME
chown -R $USERNAME:$USERNAME $USER_HOME

if [ ! -f /etc/sudoers.d/$USERNAME ]; then
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME
    chmod 0440 /etc/sudoers.d/$USERNAME
fi

if [ ! -d $USER_HOME/.vim ] || [ ! -d $USER_HOME/.oh-my-zsh ] || [ ! -d $USER_HOME/.fzf ]; then
    TEMP_DIR=$(sudo -u $USERNAME mktemp -d)
    sudo -u $USERNAME bash -c "cd $TEMP_DIR && git clone https://github.com/sangheonhan/dotfiles.git && cd $TEMP_DIR/dotfiles && ./bootstrap.sh -f && rm -rf $TEMP_DIR"
fi

chown $HOST_UID:$HOST_GID /app/
chmod 0755 /app/

echo "Starting with Username: $USERNAME, UID: $HOST_UID, GID: $HOST_GID"
echo "Now you can use this container."

exec gosu $USERNAME "$@"
