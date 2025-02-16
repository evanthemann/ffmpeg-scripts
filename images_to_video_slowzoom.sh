#!/bin/bash

# Prompt the user for the  file.
echo "Enter the path to the file or drag-and-drop the file here:"
read -e input_file  # -e option enables tab completion for file paths

# Build the output file path by replacing the extension with .mp4.
output_file="${input_file%.*}.mp4"

convert "$input_file" -auto-orient -resize "3840x2160" -size "3840x2160" xc:black +swap -gravity center -composite output.jpg

ffmpeg -loop 1 -i output.jpg -c:v libx264 -pix_fmt yuv420p -vf "scale=1920:1080" -r 30 -t 1 output.mp4
ffmpeg -loop 1 -i output.jpg -c:v libx264 -pix_fmt yuv420p -vf "zoompan=
z='min(zoom+0.001,1.1)':
d=400:
x='iw/2-(iw/zoom/2)':
y='ih/2-(ih/zoom/2)':
s=1920x1080" -r 30 -t 5 output2.mp4

ffmpeg -i output.mp4 -i output2.mp4 -filter_complex "[0:v:0][1:v:0]concat=n=2:v=1[v]" -map "[v]" -c:v libx264 "$output_file"

rm output.jpg
rm output.mp4
rm output2.mp4

#  -vf "zoompan=
#    z='min(zoom+0.005,1.2)':      # Zoom factor: gradually increase zoom by 0.005, capped at 1.2
#    d=400:                        # Duration: 400 frames
#    x='iw/2-(iw/zoom/2)':          # X-coordinate: center of the frame adjusted based on zoom
#    y='ih/2-(ih/zoom/2)':          # Y-coordinate: center of the frame adjusted based on zoom
#    s=1920x1080"                   # Output resolution: 1920x1080
