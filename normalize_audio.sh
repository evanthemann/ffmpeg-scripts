#!/bin/bash

# Ensure ffmpeg is installed
if ! command -v ffmpeg &> /dev/null; then
  echo "ffmpeg is not installed. Please install it and try again."
  exit 1
fi

# Introduction message
echo "I will help you edit your audio from a video file."

# Ask for the video file
read -p "Please enter the full path to your video file: " video_file

# Check if the file exists
if [ ! -f "$video_file" ]; then
  echo "The file '$video_file' does not exist. Please try again."
  exit 1
fi

# Extract the filename and directory
file_dir=$(dirname "$video_file")
file_name=$(basename "$video_file")
file_base_name="${file_name%.*}"

# Extract audio as WAV
output_audio_file="$file_dir/${file_base_name}_audioonly.wav"
echo "Extracting audio from the video..."
ffmpeg -i "$video_file" -q:a 0 -map a "$output_audio_file" -y

if [ $? -ne 0 ]; then
  echo "Failed to extract audio. Please check your video file and try again."
  exit 1
fi

echo "Audio extracted successfully: $output_audio_file"
echo "Use this file to adjust the volume levels."
read -p "Press any key to continue once you have made your adjustments..." -n 1 -s

echo "\n"

# Ask for the new audio file
read -p "Please enter the full path to your adjusted audio file (AIFF format): " new_audio_file

# Check if the new audio file exists
if [ ! -f "$new_audio_file" ]; then
  echo "The file '$new_audio_file' does not exist. Please try again."
  exit 1
fi

# Generate the new video file
output_video_file="$file_dir/${file_base_name}_enhanceaudio.mp4"
echo "Replacing the original audio with the new audio..."
ffmpeg -i "$video_file" -i "$new_audio_file" -c:v copy -map 0:v:0 -map 1:a:0 -shortest "$output_video_file" -y

if [ $? -ne 0 ]; then
  echo "Failed to replace audio. Please check your input files and try again."
  exit 1
fi

echo "New video file created successfully: $output_video_file"
echo "All done!"
