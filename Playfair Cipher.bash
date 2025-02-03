#!/bin/bash

# Function to prepare the key table
prepare_key_table() {
    local key=$1
    key=$(echo "$key" | tr '[:lower:]' '[:upper:]' | tr 'J' 'I')
    local alphabet="ABCDEFGHIKLMNOPQRSTUVWXYZ"
    local table=""
    local seen=""

    # Add unique characters from the key
    for ((i = 0; i < ${#key}; i++)); do
        char=${key:i:1}
        if [[ ! $seen =~ $char ]]; then
            table+=$char
            seen+=$char
        fi
    done

    # Add remaining letters of the alphabet
    for ((i = 0; i < ${#alphabet}; i++)); do
        char=${alphabet:i:1}
        if [[ ! $seen =~ $char ]]; then
            table+=$char
            seen+=$char
        fi
    done

    echo "$table"
}

# Function to find the position of a character in the table
find_position() {
    local table=$1
    local char=$2
    for ((i = 0; i < ${#table}; i++)); do
        if [[ ${table:i:1} == "$char" ]]; then
            echo $((i / 5)) $((i % 5))
            return
        fi
    done
}

# Function to encrypt a pair of characters
encrypt_pair() {
    local table=$1
    local char1=$2
    local char2=$3

    read row1 col1 <<<$(find_position "$table" "$char1")
    read row2 col2 <<<$(find_position "$table" "$char2")

    if [[ $row1 -eq $row2 ]]; then
        # Same row
        col1=$(( (col1 + 1) % 5 ))
        col2=$(( (col2 + 1) % 5 ))
    elif [[ $col1 -eq $col2 ]]; then
        # Same column
        row1=$(( (row1 + 1) % 5 ))
        row2=$(( (row2 + 1) % 5 ))
    else
        # Rectangle
        temp=$col1
        col1=$col2
        col2=$temp
    fi

    echo -n "${table:row1*5+col1:1}${table:row2*5+col2:1}"
}

# Function to prepare the plaintext
prepare_text() {
    local text=$1
    text=$(echo "$text" | tr '[:lower:]' '[:upper:]' | tr 'J' 'I' | tr -d ' ')
    local prepared_text=""
    local i=0

    while [[ $i -lt ${#text} ]]; do
        char1=${text:i:1}
        if [[ $((i + 1)) -lt ${#text} && ${text:i+1:1} != "$char1" ]]; then
            char2=${text:i+1:1}
            i=$((i + 2))
        else
            char2="X"
            i=$((i + 1))
        fi
        prepared_text+="$char1$char2"
    done

    echo "$prepared_text"
}

# Main encryption function
playfair_encrypt() {
    local plaintext=$1
    local key=$2

    local table=$(prepare_key_table "$key")
    local prepared_text=$(prepare_text "$plaintext")
    local encrypted_text=""

    for ((i = 0; i < ${#prepared_text}; i += 2)); do
        char1=${prepared_text:i:1}
        char2=${prepared_text:i+1:1}
        encrypted_text+=$(encrypt_pair "$table" "$char1" "$char2")
    done

    echo "$encrypted_text"
}

# Example usage
key="CIPHER"
plaintext="EXAMPLE TEXT"
ciphertext=$(playfair_encrypt "$plaintext" "$key")
echo "Encrypted text: $ciphertext"