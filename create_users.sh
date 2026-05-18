#!/bin/bash

# Kontrollera root
if [ "$EUID" -ne 0 ]; then
    echo "Du måste vara root för att köra scriptet."
    exit 1
fi

# Kontrollera argument
if [ $# -eq 0 ]; then
    echo "Användning: $0 användare"
    exit 1
fi

# Loopa genom användare
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

    echo "Välkommen $user" > "$HOME_DIR/welcome.txt"
    echo "Alla användare:" >> "$HOME_DIR/welcome.txt"
    cat /etc/passwd >> "$HOME_DIR/welcome.txt"

    chmod 600 "$HOME_DIR/welcome.txt"
    chown -R "$user:$user" "$HOME_DIR"
done
