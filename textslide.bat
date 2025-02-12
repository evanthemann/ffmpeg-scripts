@echo off
setlocal enabledelayedexpansion

echo .
:: Prompt for title text
set /p text=. Enter the text you'd like on the title: 
echo .

:: Check if the user left it blank and set default text
if not defined text set "text=Hello, world"
timeout /t 2 /nobreak >nul

:: Confirm the text
echo . Thanks, your text is: %text%.
echo .

:: Pause for 2 seconds
timeout /t 2 /nobreak >nul

:: Prompt for duration 
set /p "durationSeconds=. Duration of entire clip (seconds): "
timeout /t 2 /nobreak >nul

:: Check and cleanup durationSeconds
if "%durationSeconds%"=="" (
	set "durationSeconds=8"
	echo .
) else (
	echo .
)
timeout /t 2 /nobreak >nul

:: echo Thanks, clip will be %durationSeconds% seconds.
:: echo .
:: timeout /t 2 /nobreak >nul
set /a durationFrames=durationSeconds * 30
:: echo Translated to %durationFrames% frames.
:: echo .
:: timeout /t 2 /nobreak >nul

:: Prompt for fade times 
set /p "fadeOnStart=. Fade ON starts when? (seconds): "

:: Check and cleanup fadeOnStart
if "%fadeOnStart%"=="" (
	set "fadeOnStart=1"
	echo .
) else (
	echo .
)

set /p "fadeOnStop=. Fade ON stops when? (seconds): "

:: Check and cleanup fadeOnStop
if "%fadeOnStop%"=="" (
	set "fadeOnStop=3"
	echo .
) else (
	echo .
)

set /p "fadeOffStart=. Fade OFF starts when? (seconds): "

:: Check and cleanup fadeOffStart
if "%fadeOffStart%"=="" (
	set "fadeOffStart=5"
	echo .
) else (
	echo .
)

set /p "fadeOffStop=. Fade OFF stops when? (seconds): "

:: Check and cleanup fadeOffStop
if "%fadeOffStop%"=="" (
	set "fadeOffStop=7"
	echo .
) else (
	echo .
)

timeout /t 2 /nobreak >nul
set /a fadeOnDuration=fadeOnStop-fadeOnStart
set /a fadeOffDuration=fadeOffStop-fadeOffStart
echo . Thanks, video will look like this: 
echo .
timeout /t 2 /nobreak >nul
echo . Total duration: %durationSeconds% seconds.
timeout /t 1 /nobreak >nul
echo . Fade on %fadeOnStart% seconds to %fadeOnStop% seconds. (%fadeOnDuration% second fade)
timeout /t 1 /nobreak >nul
echo . Fade off %fadeOffStart% seconds to %fadeOffStop% seconds. (%fadeOffDuration% second fade)
echo .
timeout /t 5 /nobreak >nul

:: Prompt for bgcolor
set /p "bgcolor=. What color background? (leave blank for black) "
echo .
timeout /t 2 /nobreak >nul

:: Check and cleanup bgcolor
if "%bgcolor%"=="" (
	echo . Thanks, background color will be black.
	set "bgcolor=black"
) else (
	echo . Thanks, background color will be %bgcolor%.
)
echo .
timeout /t 2 /nobreak >nul

:: Prompt for fontcolor
set /p "fontcolor=. What color font? (leave blank for white) "
echo .
timeout /t 2 /nobreak >nul

:: Check and cleanup fontcolor
if "%fontcolor%"=="" (
	echo . Thanks, font color will be white.
	set "fontcolor=white"
) else (
	echo . Thanks, font color will be %fontcolor%.
)
echo .
timeout /t 2 /nobreak >nul

:: Prompt for fontsize
set /p "fontsize=. What size font? (leave blank default 80) "
echo .
timeout /t 2 /nobreak >nul

:: Check and cleanup fontcolor
if "%fontsize%"=="" (
	echo . Thanks, font size will be 80.
	set "fontsize=80"
) else (
	echo . Thanks, font size will be %fontsize%.
)
echo .
timeout /t 2 /nobreak >nul

:: Set variables
set "ffmpeg=ffmpeg"
set "fontfile=baskvill.ttf" & :: ttf file needs to be in same folder as this script

:: Create filename
set "filename=%text%.mp4"
set "filename=%filename:,=%" & :: remove comma

:: Output final sanitized filename
echo . Safe filename: %filename%
echo .

:: Escape bad characters
set "text=%text:,=\,%" & :: Escape comma
set "text=%text:!=\!%" & :: Escape exclamation point
set "text=%text:"=\"%" & :: Escape double quote
set "text=%text:'=\'%" & :: Escape single quote


:: Summarize text clip properties

%ffmpeg% -hide_banner -loglevel error -stats ^
-f lavfi ^
-i "color=c=%bgcolor%:s=1920x1080" ^
-vf "drawtext=alpha=if(lt(t\,%fadeOnStart%)\,0\,if(lt(t\,%fadeOnStop%)\,(t-%fadeOnStart%)/(%fadeOnStop%-%fadeOnStart%)\,if(lt(t\,%fadeOffStart%)\,1\,if(lt(t\,%fadeOffStop%)\,(1-(t-%fadeOffStart%)/(%fadeOffStop%-%fadeOffStart%))\,0)))):fontfile=%fontfile%:fontcolor=%fontcolor%:fontsize=%fontsize%:text=%text%:x=(w-text_w)/2:y=(h-text_h)/2" ^
-c:v libx264 ^
-r 30 ^
-frames:v %durationFrames% ^
-y "%filename%"

echo .
echo Done. Closing in 10 seconds.
timeout /t 10 /nobreak >nul
echo .
