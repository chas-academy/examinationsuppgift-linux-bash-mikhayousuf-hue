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
    # Hämta gamla användare innan skapning
    OLD_USERS=$(cut -d: -f1 /etc/passwd)

    # Skapa användare
    useradd -m "$user"

    HOME_DIR="/home/$user"

    # Skapa mappar
    mkdir -p "$HOME_DIR/Documents"
    mkdir -p "$HOME_DIR/Downloads"
    mkdir -p "$HOME_DIR/Work"

    # Rättigheter
    chmod 700 "$HOME_DIR/Documents"
    chmod 700 "$HOME_DIR/Downloads"
    chmod 700 "$HOME_DIR/Work"

    # Welcome-fil
    echo "Välkommen $user" > "$HOME_DIR/welcome.txt"

    # Lägg till andra användare
    echo "$OLD_USERS" | grep -v "^$user$" >> "$HOME_DIR/welcome.txt"

    # Ägare och rättigheter
    chown -R "$user:$user" "$HOME_DIR"
    chmod 600 "$HOME_DIR/welcome.txt"

done
