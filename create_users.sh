#!/bin/bash

# Script som skapar användare med hemkataloger
# och lägger till mappar samt välkomstfil.

# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "Fel: Scriptet måste köras som root."
    exit 1
fi

# Kontrollera att minst ett användarnamn skickas in
if [ "$#" -eq 0 ]; then
    echo "Användning: $0 användare1 användare2 användare3"
    exit 1
fi

# Loopar igenom alla användarnamn som skickats in
for username in "$@"; do

    # Skapa användaren om den inte redan finns
    if id "$username" &>/dev/null; then
        echo "Användaren $username finns redan."
    else
        useradd -m "$username"
        echo "Användaren $username har skapats."
    fi

    home_dir="/home/$username"

    # Skapa mappar i användarens hemkatalog
    mkdir -p "$home_dir/Documents" "$home_dir/Downloads" "$home_dir/Work"

    # Skapa välkomstfil
    echo "Välkommen $username" > "$home_dir/welcome.txt"
    echo "Andra användare i systemet:" >> "$home_dir/welcome.txt"
    cut -d: -f1 /etc/passwd >> "$home_dir/welcome.txt"

    # Sätt rätt ägare
    chown -R "$username:$username" "$home_dir"

    # Endast ägaren får läsa och skriva
    chmod 700 "$home_dir/Documents" "$home_dir/Downloads" "$home_dir/Work"
    chmod 600 "$home_dir/welcome.txt"

done
