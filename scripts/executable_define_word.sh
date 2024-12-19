#!/usr/bin/env bash

# Ensure necessary tools are installed
if ! command -v xclip &> /dev/null; then
    echo "xclip could not be found, please install it."
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo "jq could not be found, please install it."
    exit 1
fi

# Get the word from the first argument or clipboard
word=${1:-$(xclip -o -selection primary)}

# Check if a word is provided
if [ -z "$word" ]; then
    echo "No word provided or found in clipboard."
    exit 1
fi

# Query the dictionary API
query=$(curl -s "https://api.dictionaryapi.dev/api/v2/entries/en_US/$word")

# Check if the query was successful
if [ $? -ne 0 ]; then
    echo "Failed to fetch data from the dictionary API."
    notify-send "Error" "Failed to fetch data from the dictionary API."
    exit 1
fi

# Check if the response is valid (i.e., not an empty string or an error message)
if [ -z "$query" ] || echo "$query" | jq -e '.[0].message? == "No Definitions Found"' > /dev/null; then
    echo "Invalid word."
    notify-send "Invalid word" "No definitions found for \"$word\"."
    exit 0
fi

# Show only the first 3 definitions
def=$(echo "$query" | jq -r '[.[].meanings[] | {pos: .partOfSpeech, def: .definitions[].definition}] | .[:3].[] | "\n\(.pos): \(.def)"')

# Send a notification with the definitions
notify-send "$word" "$def"

echo "Definitions for \"$word\":"
echo "$def"
