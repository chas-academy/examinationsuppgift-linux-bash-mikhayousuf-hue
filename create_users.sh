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

# Loopa igenom användare
for user in "$@"
do
    # Skapa användare med hemkatalog
    useradd -m "$user"

    # Hemkatalog
    HOME_DIR="/home/$user"

    # Skapa undermappar
    mkdir -p "$HOME_DIR/Documents"
    mkdir -p "$HOME_DIR/Downloads"
    mkdir -p "$HOME_DIR/Work"

    # Rättigheter
    chmod 700 "$HOME_DIR/Documents"
    chmod 700 "$HOME_DIR/Downloads"
    chmod 700 "$HOME_DIR/Work"

    # Skapa welcome.txt
    echo "Välkommen $user" > "$HOME_DIR/welcome.txt"
    echo "" >> "$HOME_DIR/welcome.txt"
    echo "Andra användare i systemet:" >> "$HOME_DIR/welcome.txt"

    # Lista användare
    cut -d: -f1 /etc/passwd >> "$HOME_DIR/welcome.txt"

    # Ägare
    chown -R "$user:$user" "$HOME_DIR"

done

done
