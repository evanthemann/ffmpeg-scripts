# Prompt the user for the first video file.
echo "This concatenates two video files that have the same properties. Enter the path to first video file or drag-and-drop here:"
read video1  

# Prompt the user for the second video file.
echo "Enter the path to second video file or drag-and-drop here:"
read video2 

# Build the output file path
concatenated_video="${video1%.*}_concatenated.mp4"

ffmpeg -hide_banner -loglevel warning -i $video1 -i $video2 -filter_complex "[0:v][0:a][1:v][1:a]concat=n=2:v=1:a=1[v][a]" -map "[v]" -map "[a]" $concatenated_video
