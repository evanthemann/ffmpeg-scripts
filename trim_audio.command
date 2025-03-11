#!/bin/bash

# Define the paths to ffmpeg and ffprobe
ffmpeg="ffmpeg"
ffprobe="ffprobe"

echo
echo
# Prompt for input file
read -p "Enter the full path to the file (include quotes if needed): " inputFile
echo
echo "Thanks, got your file: $inputFile"
echo
sleep 2

# Find duration of video file
tempFile="duration_temp.txt"
$ffprobe -i "$inputFile" -show_entries format=duration -v quiet -of csv="p=0" -sexagesimal > "$tempFile"

# Read duration into a variable
videoDuration=$(<"$tempFile")

# Delete temporary file
rm "$tempFile"

# Display duration
echo "Video duration: $videoDuration"
echo
sleep 2

# Prompt for start
read -p "Trim how much from start? (write as HH:MM:SS or leave blank): " startTime
echo
sleep 2

# Check and cleanup startTime input
if [[ -z "$startTime" ]]; then
    echo "Thanks, I'll trim nothing from the start."
    startTime="00:00:00"
else
    echo "Thanks, I'll trim $startTime from the start."
fi

echo
sleep 2

# Prompt for end
read -p "What time should the video end? (write as HH:MM:SS or leave blank): " endTime
echo
sleep 2

# Check and cleanup endTime input
if [[ -z "$endTime" ]]; then
    echo "Thanks, I'll trim nothing from the end."
    endTime="$videoDuration"
else
    echo "Thanks, I'll end the video at $endTime."
fi

echo
sleep 2

# Validate input file
if [[ ! -f "$inputFile" ]]; then
    echo "File not found: $inputFile"
    exit 1
fi

# Extract directory, filename, and extension
fileDir=$(dirname "$inputFile")
fileName=$(basename "$inputFile" | cut -d. -f1)

# Create new file path
fileExt="${inputFile##*.}"  # Extracts the file extension from inputFile
# outputFile="$fileDir/${fileName}_processed.mp4"
outputFile="$fileDir/${fileName}_processed.$fileExt"
echo "Your output file will be: $outputFile"
echo
sleep 2

# Echo video variables
echo "Start time: $startTime"
echo
sleep 2

echo "End time: $endTime"
echo
sleep 2

# Run FFmpeg command
echo "Processing with FFmpeg..."
echo
sleep 2
$ffmpeg -hide_banner -loglevel quiet -nostats -t "$endTime" -i "$inputFile" -ss "$startTime" -c:a copy "$outputFile" -y

# Check if FFmpeg succeeded
if [[ $? -eq 0 ]]; then
    echo "Processing complete! Output saved to: $outputFile"
else
    echo "FFmpeg encountered an error. Please check the input file and try again."
fi

sleep 5
