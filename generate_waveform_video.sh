#!/bin/sh
# Prompt the user for the input MP3 file
echo "Enter the path to the MP3 file:"
read -r ifn
ifn=$(echo "$ifn" | xargs)  # Trim spaces and newlines

# Debugging: Print the path entered
echo "Path entered: $ifn"

# Check if the file exists
if [ ! -f "$ifn" ]; then
  echo "Error: File not found at the specified path."
  exit 1
fi

# Proceed with processing if the file exists
echo "File found. Proceeding with waveform generation..."


# Extract the directory and base name of the input file
input_dir="$(dirname "$ifn")"
ifnb="$(basename "$ifn" .mp3)"

# Extract the base name of the script without the .sh extension
pref="$(basename "$0" .sh)"

# Define the output file path in the same directory as the input file
output_file="${input_dir}/${pref}_${ifnb}.mp4"

# Use ffmpeg to process the MP3 file and create a video with an audio waveform visualization
ffmpeg -y -i "$ifn" -filter_complex "
[0:a]showwaves=mode=cline:s=1920x1080[v]
" \
-map "[v]" -map "0:a" -c:v libx264 -c:a aac -pix_fmt yuv420p -profile:v high -level:v 4.0 \
"$output_file"

# Notify the user of success
echo "Waveform video created: $output_file"
