#!/bin/bash

# Check if ffmpeg is installed
if ! command -v ffmpeg &> /dev/null; then
    echo "Error: ffmpeg is not installed. Please install it first."
    exit 1
fi

# Enable case-insensitive matching (handles .PNG, .JPG, etc.)
shopt -s nocaseglob

echo "Starting WebP conversion..."
echo "----------------------------"

# Process JPEG files (Lossy compression)
for file in *.jpg *.jpeg; do
    # Check if files actually exist to avoid running on empty globs
    [ -e "$file" ] || continue
    
    filename="${file%.*}"
    echo "Compressing (lossy): $file -> ${filename}.webp"
    
    # -quality 80 is the sweet spot for JPEG-to-WebP conversion
    ffmpeg -i "$file" -vcodec libwebp -quality 80 "${filename}.webp" -y -loglevel error
done

# Process PNG files (Lossless compression)
for file in *.png; do
    [ -e "$file" ] || continue
    
    filename="${file%.*}"
    echo "Compressing (lossless): $file -> ${filename}.webp"
    
    # -lossless 1 preserves perfect quality and transparency
    ffmpeg -i "$file" -vcodec libwebp -lossless 1 "${filename}.webp" -y -loglevel error
done

echo "----------------------------"
echo "Conversion complete!"
