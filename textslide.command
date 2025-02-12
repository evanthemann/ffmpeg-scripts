#!/bin/bash

# Define the paths to ffmpeg and font
ffmpeg="ffmpeg"
fontfile="baskvill.ttf" # needs to be in same folder as script

echo
echo
# Prompt for title text
read -p "Enter the text you'd like on the title: " text

# Check if the user left it blank and set default text
if [ -z "$text" ]; then
  text="Hello, world"
fi

echo
echo "Thanks, your text is: $text"
echo

# Prompt for duration
read -p "Duration of entire clip (seconds): " durationSeconds
echo 

# Check if the user left it blank and set default 
if [ -z "$durationSeconds" ]; then
  durationSeconds=8
fi

durationFrames=$((durationSeconds * 30))

#Prompt for fade times
read -p "Fade ON starts when? (seconds) " fadeOnStart
echo

# Check if the user left it blank and set default 
if [ -z "$fadeOnStart" ]; then
  fadeOnStart=1
fi

read -p "Fade ON stops when? (seconds) " fadeOnStop
echo

# Check if the user left it blank and set default 
if [ -z "$fadeOnStop" ]; then
  fadeOnStop=3
fi

read -p "Fade OFF starts when? (seconds) " fadeOffStart
echo

# Check if the user left it blank and set default 
if [ -z "$fadeOffStart" ]; then
  fadeOffStart=5
fi

read -p "Fade OFF stops when? (seconds) " fadeOffStop
echo

# Check if the user left it blank and set default 
if [ -z "$fadeOffStop" ]; then
  fadeOffStop=7
fi

fadeOffDuration=$((fadeOffStop - fadeOffStart))
fadeOnDuration=$((fadeOnStop - fadeOnStart))

echo "Thanks, video will look like this: "
echo 
echo "Total duration: $durationSeconds seconds."
echo "Fade on $fadeOnStart seconds to $fadeOnStop seconds. ($fadeOnDuration second fade)"
echo "Fade off $fadeOffStart seconds to $fadeOffStop seconds. ($fadeOffDuration second fade)"
echo 

# Prompt for bgcolor
read -p "What color background? (leave blank for black) " bgcolor
echo

# Check if the user left it blank and set default 
if [ -z "$bgcolor" ]; then
  bgcolor="black"
fi

echo "Thanks, background color will be $bgcolor."
echo

# Prompt for fontcolor
read -p "What color font? (leave blank for white) " fontcolor
echo

# Check if the user left it blank and set default 
if [ -z "$fontcolor" ]; then
  fontcolor="white"
fi

echo "Thanks, font color will be $fontcolor."
echo

# Prompt for fontsize
read -p "What size font? (leave blank for default 80) " fontsize
echo

# Check if the user left it blank and set default 
if [ -z "$fontsize" ]; then
  fontsize=80
fi

echo "Thanks, font size will be $fontsize."
echo

# Create filename
filename="${text}.mp4"

# Remove commas from filename
filename="${filename//,/}"

# Output final sanitized filename
echo "Safe filename: $filename"
echo

# Escape bad characters in text
text="${text//,/\\,}"   # Escape comma
text="${text//!/\\!}"   # Escape exclamation point
text="${text//\"/\\\"}" # Escape double quote
text="${text//\'/\\\'}" # Escape single quote

# command="ffmpeg -hide_banner -loglevel error -stats -f lavfi -i 'color=c=$bgcolor:s=1920x1080' -vf 'drawtext=alpha=if(lt(t\,$fadeOnStart)\,0\,if(lt(t\,$fadeOnStop)\,(t-$fadeOnStart)/($fadeOnStop-$fadeOnStart)\,if(lt(t\,$fadeOffStart)\,1\,if(lt(t\,$fadeOffStop)\,(1-(t-$fadeOffStart)/($fadeOffStop-$fadeOffStart))\,0)))):fontfile=$fontfile:fontcolor=$fontcolor:fontsize=$fontsize:text=\'$text\':x=(w-text_w)/2:y=(h-text_h)/2' -c:v libx264 -r 30 -frames:v '$durationFrames' -y '$filename'"

# echo $command

# Run FFmpeg command
"$ffmpeg" -hide_banner -loglevel error -stats \
  -f lavfi \
  -i "color=c=$bgcolor:s=1920x1080" \
  -vf "drawtext=alpha=if(lt(t\,$fadeOnStart)\,0\,if(lt(t\,$fadeOnStop)\,(t-$fadeOnStart)/($fadeOnStop-$fadeOnStart)\,if(lt(t\,$fadeOffStart)\,1\,if(lt(t\,$fadeOffStop)\,(1-(t-$fadeOffStart)/($fadeOffStop-$fadeOffStart))\,0)))):fontfile=$fontfile:fontcolor=$fontcolor:fontsize=$fontsize:text='$text':x=(w-text_w)/2:y=(h-text_h)/2" \
  -c:v libx264 \
  -r 30 \
  -frames:v "$durationFrames" \
  -y "$filename"

echo 
echo "Done. Closing in 10 seconds." 
echo 

sleep 10
