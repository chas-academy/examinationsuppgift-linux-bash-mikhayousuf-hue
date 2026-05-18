#!/bin/bash

# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "Du måste vara root för att köra scriptet."
    exit 1
fi

# Kontrollera att användare skickas in
if [ $# -eq 0 ]; then
    echo "Användning: $0 användare"
    exit 1
fi

# Loopa igenom alla användare
for user in "$@"
do
    # Skapa användare och hemkatalog
    useradd -m "$user"

    # Hemkatalog
    HOME_DIR="/home/$user"

    # Skapa undermappar
    mkdir -p "$HOME_DIR/Documents"
    mkdir -p "$HOME_DIR/Downloads"
    mkdir -p "$HOME_DIR/Work"

    # Endast ägaren får åtkomst
    chmod 700 "$HOME_DIR/Documents"
    chmod 700 "$HOME_DIR/Downloads"
    chmod 700 "$HOME_DIR/Work"

    # Skapa välkomstfil
    echo "Välkommen $user" > "$HOME_DIR/welcome.txt"

    # Lista alla användare i systemet
    cut -d: -f1 /etc/passwd >> "$HOME_DIR/welcome.txt"

    # Rättigheter för välkomstfil
    chmod 600 "$HOME_DIR/welcome.txt"

    # Gör användaren till ägare
    chown -R "$user:$user" "$HOME_DIR"

done
