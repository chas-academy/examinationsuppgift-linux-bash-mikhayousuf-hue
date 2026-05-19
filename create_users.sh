#!/bin/bash

# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "Du måste vara root för att köra scriptet."
    exit 1
fi

# Kontrollera att minst ett användarnamn skickas in
if [ $# -eq 0 ]; then
    echo "Användning: $0 användare"
    exit 1
fi

# Loopa igenom alla användare
for user in "$@"
do
    # Skapa användare med hemkatalog
    useradd -m "$user"

    # Sätt hemkatalog
    HOME_DIR="/home/$user"

    # Skapa mappar i användarens hemkatalog
    mkdir -p "$HOME_DIR/Documents"
    mkdir -p "$HOME_DIR/Downloads"
    mkdir -p "$HOME_DIR/Work"

    # Endast ägaren får läsa skriva och gå in
    chmod 700 "$HOME_DIR/Documents"
    chmod 700 "$HOME_DIR/Downloads"
    chmod 700 "$HOME_DIR/Work"

    # Skapa welcome.txt i användarens hemkatalog
    echo "Välkommen $user" > "$HOME_DIR/welcome.txt"

    # Lägg till alla andra användare
    cut -d: -f1 /etc/passwd | grep -v "^$user$" >> "$HOME_DIR/welcome.txt"

    # Sätt rätt ägare och rättigheter
    chown -R "$user:$user" "$HOME_DIR"
    chmod 600 "$HOME_DIR/welcome.txt"
done
