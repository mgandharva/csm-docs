#!/bin/bash

# Run codespell and capture output
output=$(find . -type f -name "*.md" -exec codespell --ignore-words=.github/workflows/codespell.txt --builtin clear,rare,informal,code,usage --write-changes --only-per-line --quiet-level=2 {} +)

echo "$output"

# Process the output and apply the first suggestion
echo "$output" | while read -r line; do
    if [[ $line == *"=="* ]]; then
        file=$(echo "$line" | cut -d':' -f1)
        error_line=$(echo "$line" | cut -d':' -f2)
        original=$(echo "$line" | cut -d':' -f3 | cut -d' ' -f2)
        suggestion=$(echo "$line" | grep -oP '(?<= ==>)\s\K[^,]*')

        # Apply the first suggestion
        if [ -n "$suggestion" ] && [ -f "$file" ]; then
            sed -i "${error_line}s/$original/$suggestion/" "$file"
            echo "Fixed $original to $suggestion in $file on line $error_line"
        fi
    fi
done