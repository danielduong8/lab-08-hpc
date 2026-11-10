#!/bin/bash
set -euo pipefail

# Usage check: need a bucket name and a book directory
if [ $# -ne 2 ]; then
    echo "Usage: bash get_books.sh BUCKET_NAME BOOK_DIR" >&2
    exit 1
fi

BUCKET="$1"
BOOK_DIR="$2"

# Create the book directory if it doesn't exist yet
mkdir -p "$BOOK_DIR"

# Copy only .txt files from the bucket (exclude everything first, then include .txt)
aws s3 cp "s3://$BUCKET/" "$BOOK_DIR/" --recursive --exclude "*" --include "*.txt"

# Turn the book directory into an absolute path
ABS_DIR=$(realpath "$BOOK_DIR")

# Write the header (single > starts a fresh file)
echo "File path" > book_list.txt

# Append the sorted absolute path of every book (>> adds to the file)
find "$ABS_DIR" -type f -name "*.txt" | sort >> book_list.txt

# Count the books (total lines minus the header)
COUNT=$(( $(wc -l < book_list.txt) - 1 ))
echo "Wrote $COUNT book files to book_list.txt"
