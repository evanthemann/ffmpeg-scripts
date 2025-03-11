#!/bin/bash

# Ask for input file
read -p "Enter the input audio file: " inputFile

# Ensure the file exists
if [[ ! -f "$inputFile" ]]; then
    echo "Error: File not found!"
    exit 1
fi

# Extract filename and extension
fileDir=$(dirname "$inputFile")
fileName=$(basename "$inputFile" .${inputFile##*.})
fileExt="${inputFile##*.}"

# Temporary file to store duration
tempFile=$(mktemp)

# Get audio duration in HH:MM:SS format
ffprobe -i "$inputFile" -show_entries format=duration -v quiet -of csv="p=0" -sexagesimal > "$tempFile"

# Read duration from the temp file
audioLength=$(cat "$tempFile")
rm "$tempFile"  # Clean up temp file

echo "Audio length: $audioLength"

# Ask for fade-in and fade-out duration
read -p "Enter fade-in duration (seconds): " fadeIn
read -p "Enter fade-out duration (seconds): " fadeOut

# Convert duration to seconds (in case it's in HH:MM:SS format)
durationInSeconds=$(ffprobe -i "$inputFile" -show_entries format=duration -v quiet -of csv="p=0")

# Calculate fade-out start time
fadeOutStart=$(echo "$durationInSeconds - $fadeOut" | bc)

# Define output file
outputFile="$fileDir/${fileName}_faded.$fileExt"

# Apply fades with FFmpeg
ffmpeg -i "$inputFile" -af "afade=t=in:ss=0:d=$fadeIn, afade=t=out:st=$fadeOutStart:d=$fadeOut" -c:a aac "$outputFile"

echo "Faded audio saved as: $outputFile"

