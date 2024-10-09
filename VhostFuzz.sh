cat > ffuf_new.sh << 'EOF'
#!/bin/bash

# Create directory if it doesn't exist
mkdir -p localhost-vhost

# Loop through each line in the file not_resolved
while IFS= read -r domain; do
    # Run ffuf and save the output to a temporary CSV file
    ffuf -u "http://$domain" -w localhost -H "Host: FUZZ" -of csv -o "localhost-vhost/$domain.csv"

    # Check the size of the CSV file
    filesize=$(stat -c%s "localhost-vhost/$domain.csv")

    # If the size is greater than 123 bytes, keep the file, otherwise delete it
    if [ "$filesize" -le 123 ]; then
        rm "localhost-vhost/$domain.csv"
    fi
done < not_resolved
EOF