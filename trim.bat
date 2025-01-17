@echo off
setlocal enabledelayedexpansion

:: Define the full paths to ffmpeg and ffprobe
set "ffmpeg=C:\Path\to\ffmpeg.exe"
set "ffprobe=C:\Path\to\ffprobe.exe"


echo .
echo .
:: Prompt for input file
set /p "inputFile=Enter the full path to the file (include quotes if needed): "
echo .
timeout /t 2 /nobreak >nul
echo Thanks, got your file: %inputFile%.
echo .
timeout /t 2 /nobreak >nul

:: Find duration of video file
set "tempFile=duration_temp.txt"
%ffprobe% -i %inputFile% -show_entries format=duration -v quiet -of csv="p=0" -sexagesimal > %tempFile%

:: Read duration into a variable
set /p videoDuration=<%tempFile%

:: Delete temporary file
del %tempFile%

:: Display duration
echo Video duration: %videoDuration%
echo .
timeout /t 2 /nobreak >nul

:: Prompt for start
set /p "startTime=Trim how much from start? (write as HH:MM:SS or leave blank): "
echo .
timeout /t 2 /nobreak >nul

:: Check and cleanup startTime input
if "%startTime%"=="" (
	echo Thanks, I'll trim nothing from the start.
	set "startTime=00:00:00"
) else (
	echo Thanks, I'll trim %startTime% from the start.
)

echo .
timeout /t 2 /nobreak >nul

:: Prompt for end
set /p "endTime=What time should the video end? (write as HH:MM:SS or leave blank): "
echo .
timeout /t 2 /nobreak >nul

:: Check and cleanup endTime input
if "%endTime%"=="" (
	echo Thanks, I'll trim nothing from the end.
) else (
	echo Thanks, I'll end the video at %endTime%.
)

echo .
timeout /t 2 /nobreak >nul

:: Validate input
if not exist %inputFile% (
    echo File not found: %inputFile%
    pause
    exit /b
)

:: Extract directory, filename, and extension
for %%F in (%inputFile%) do (
    set "fileDir=%%~dpF"
    set "fileName=%%~nF"
)

:: Create new file path
set "outputFile=%fileDir%%fileName%_processed.mp4"
echo Your output file will be: %outputFile%
echo .
timeout /t 2 /nobreak >nul

:: Check and assign endTime
if "%endTime%"=="" (
    set "endTime=%videoDuration%"
)

:: echo video variables
echo Start time: %startTime%
echo .
timeout /t 2 /nobreak >nul

echo End time: %endTime%
echo .
timeout /t 2 /nobreak >nul


:: Run FFmpeg command
echo Processing with FFmpeg...
echo .
timeout /t 2 /nobreak >nul
%ffmpeg% -hide_banner -loglevel quiet -nostats -t %endTime% -i %inputFile% -ss %startTime% -async 1 -c:v libx264 -c:a aac "%outputFile%"

:: Check if FFmpeg succeeded
if %ERRORLEVEL% equ 0 (
    echo Processing complete! Output saved to: %outputFile%
) else (
    echo FFmpeg encountered an error. Please check the input file and try again.
)

timeout /t 5 /nobreak >nul
