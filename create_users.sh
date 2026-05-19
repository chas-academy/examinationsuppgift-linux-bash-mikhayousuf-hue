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

# Hämta alla användare som redan finns
OLD_USERS=$(cut -d: -f1 /etc/passwd)

# Loopa igenom alla användare
for user in "$@"
do
    # Skapa användare med hemkatalog och bash-shell
    useradd -m -s /bin/bash "$user"

    # Sätt hemkatalog
    HOME_DIR=$(eval echo "~$user")

    # Skapa undermappar
    mkdir -p "$HOME_DIR/Documents"
    mkdir -p "$HOME_DIR/Downloads"
    mkdir -p "$HOME_DIR/Work"

    # Sätt rättigheter
    chmod 700 "$HOME_DIR/Documents"
    chmod 700 "$HOME_DIR/Downloads"
    chmod 700 "$HOME_DIR/Work"

    # Skapa welcome.txt
    echo "Välkommen $user" > "$HOME_DIR/welcome.txt"

    # Lägg till andra användare
    echo "$OLD_USERS" >> "$HOME_DIR/welcome.txt"

    # Sätt ägare och rättigheter
    chown -R "$user:$user" "$HOME_DIR"
    chmod 600 "$HOME_DIR/welcome.txt"
done
