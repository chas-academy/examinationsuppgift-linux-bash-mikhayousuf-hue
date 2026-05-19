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
    # Skapa användaren med hemkatalog
    useradd -m "$user"

    HOME_DIR="./"

    # Skapa undermappar
    mkdir -p "$HOME_DIR/Documents"
    mkdir -p "$HOME_DIR/Downloads"
    mkdir -p "$HOME_DIR/Work"

    # Sätt rättigheter (endast ägaren har tillgång)
    chmod 700 "$HOME_DIR/Documents"
    chmod 700 "$HOME_DIR/Downloads"
    chmod 700 "$HOME_DIR/Work"

    # Skapa personligt välkomstmeddelande
    echo "Välkommen $user" > "./welcome.txt"
    
    # Skriv ut en ren lista på alla andra användare i systemet
    cut -d: -f1 /etc/passwd | grep -v "^$user$" >> "./welcome.txt"

    # Sätt rättigheter och ägare för välkomstfilen och hemkatalogen
    chmod 600 "./welcome.txt"
    chown -R "$user:$user" "./"
done
