#!/bin/bash

# Input files
SUBDOMAIN_FILE="subs_without_302"
KEYWORDS_FILE="internaly-keyword.txt"
OUTPUT_FILE="matched_subs.txt"

# Clear the output file if it exists
> $OUTPUT_FILE

# Read keywords into an array
mapfile -t keywords < $KEYWORDS_FILE

# Function to check if a subdomain contains any of the keywords
check_keywords() {
    local sub=$1
    for keyword in "${keywords[@]}"; do
        if [[ "$sub" == *".$keyword"* ]] || [[ "$sub" == *"$keyword."* ]] || [[ "$sub" == *"-$keyword-"* ]] || [[ "$sub" == *".$keyword-"* ]] || [[ "$sub" == *"-$keyword."* ]]; then
            echo "$sub" >> $OUTPUT_FILE
            return
        fi
    done
}

# Read subdomains from the input file and check them
while IFS= read -r subdomain; do
    check_keywords "$subdomain"
done < $SUBDOMAIN_FILE

echo "Extraction completed. Results saved in $OUTPUT_FILE."