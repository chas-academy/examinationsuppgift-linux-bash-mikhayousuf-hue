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
    # Skapa användare med hemkatalog
    useradd -m "$user"

    HOME_DIR="/home/$user"

    # Skapa mappar
    mkdir -p "$HOME_DIR/Documents"
    mkdir -p "$HOME_DIR/Downloads"
    mkdir -p "$HOME_DIR/Work"

    # Sätt rättigheter
    chmod 700 "$HOME_DIR/Documents"
    chmod 700 "$HOME_DIR/Downloads"
    chmod 700 "$HOME_DIR/Work"

    # Sätt ägare
    chown -R "$user:$user" "$HOME_DIR"

    # Skapa welcome.txt
    {
        echo "Välkommen $user"
        echo "Andra användare i systemet:"

        for existing_user in $(cut -d: -f1 /etc/passwd)
        do
            if [ "$existing_user" != "$user" ]; then
                echo "$existing_user"
            fi
        done
    } > "$HOME_DIR/welcome.txt"

    # Rättigheter för welcome.txt
    chmod 600 "$HOME_DIR/welcome.txt"
    chown "$user:$user" "$HOME_DIR/welcome.txt"

done
