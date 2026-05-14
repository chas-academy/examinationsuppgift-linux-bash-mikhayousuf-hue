#!/bin/bash

# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "Du måste vara root för att köra scriptet."
    exit 1
fi

# Kontrollera att användare skickats in
if [ $# -eq 0 ]; then
    echo "Användning: $0 användare1 användare2"
    exit 1
fi

# Loop genom alla användare
for user in "$@"
do
    # Skapa användare och hemkatalog
    useradd -m "$user"

    # Sökväg till hemkatalog
    HOME_DIR="/home/$user"

    # Skapa mappar
    mkdir -p "$HOME_DIR/Documents"
    mkdir -p "$HOME_DIR/Downloads"
    mkdir -p "$HOME_DIR/Work"

    # Ägare
    chown -R "$user:$user" "$HOME_DIR"

    # Rättigheter
    chmod 700 "$HOME_DIR/Documents"
    chmod 700 "$HOME_DIR/Downloads"
    chmod 700 "$HOME_DIR/Work"

    # Skapa welcome.txt
    echo "Välkommen $user" > "$HOME_DIR/welcome.txt"

    # Lista andra användare
    cut -d: -f1 /etc/passwd >> "$HOME_DIR/welcome.txt"

    # Rättigheter för fil
    chmod 600 "$HOME_DIR/welcome.txt"
    chown "$user:$user" "$HOME_DIR/welcome.txt"

done
