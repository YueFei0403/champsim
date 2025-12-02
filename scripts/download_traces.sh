#!/bin/bash

TRACE_URL="https://dpc3.compas.cs.stonybrook.edu/champsim-traces/speccpu/"
OUTPUT_DIR="$PWD/traces"

mkdir -p "$OUTPUT_DIR"

echo "🔍 Fetching trace list from server…"

# Crawl the directory and extract filenames ending in .xz
TRACE_LIST=$(curl -s "$TRACE_URL" | grep -oP '(?<=href=")[^"]+\.xz')

# Check if we actually got any trace names
if [[ -z "$TRACE_LIST" ]]; then
    echo "❌ ERROR: Could not retrieve trace list from server."
    exit 1
fi

echo "✅ Retrieved trace list from server."
echo "🔀 Selecting 5 random traces…"

# Pick n random traces
SELECTED=$(echo "$TRACE_LIST" | shuf | head -n 1)

echo "📦 Selected traces:"
echo "$SELECTED"
echo

# Download selected traces
echo "$SELECTED" | while read FNAME; do
    echo "⬇️  Downloading: $FNAME"
    wget -c "$TRACE_URL/$FNAME" -P "$OUTPUT_DIR"
done

echo
echo "🎉 Done! Traces saved to: $OUTPUT_DIR"
