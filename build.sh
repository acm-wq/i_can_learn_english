#!/bin/bash

input_file="base_english_words.txt"
output_file="base_english_words.json"

declare -A words_dict
current_theme=""

while IFS= read -r line; do
    if [[ "$line" =~ ^##### ]]; then
        current_theme=$(echo "$line" | sed 's/^##### *//')
        words_dict["$current_theme"]=""
    elif [[ -n "$line" ]]; then
        words_dict["$current_theme"]+="$line,"  
    fi
done < "$input_file"

{
    echo -n "{"
    first=1
    for theme in "${!words_dict[@]}"; do
        [[ $first -eq 0 ]] && echo -n ","
        first=0
        words="${words_dict[$theme]}"
        words=${words%,}  # Убираем последнюю запятую
        echo -n "\"$theme\":[\"${words//,/\",\"}\"]"
    done
    echo -n "}"
} > "$output_file"

echo "JSON save in $output_file"