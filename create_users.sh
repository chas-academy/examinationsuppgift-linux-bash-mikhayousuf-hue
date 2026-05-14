#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Du måste vara root för att köra scriptet."
    exit 1
fi

if [ $# -eq 0 ]; then
    echo "Användning: $0 användare1 användare2"
    exit 1
fi

for user in "$@"
do
    useradd -m "$user"

    HOME_DIR="/home/$user"

    mkdir -p "$HOME_DIR/Documents"
    mkdir -p "$HOME_DIR/Downloads"
    mkdir -p "$HOME_DIR/Work"

    chmod 700 "$HOME_DIR/Documents"
    chmod 700 "$HOME_DIR/Downloads"
    chmod 700 "$HOME_DIR/Work"

    chown -R "$user:$user" "$HOME_DIR"

    echo "Välkommen $user" > "$HOME_DIR/welcome.txt"

    cut -d: -f1 /etc/passwd | grep -v "^$user$" >> "$HOME_DIR/welcome.txt"

    chmod 600 "$HOME_DIR/welcome.txt"
    chown "$user:$user" "$HOME_DIR/welcome.txt"

done
