@echo off
:: Check if the script is running as admin
net session >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Requesting administrative privileges...
    :: Relaunch the script with admin privileges
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /B
)

:: Administrative privileges granted from this point

:: Set installation directories
SET "YT_DLP_DIR=%ProgramFiles%\yt-dlp"
SET "FFMPEG_DIR=%ProgramFiles%\ffmpeg"
SET "SEVEN_ZIP_DIR=%ProgramFiles%\7-Zip"

:: Create directories for yt-dlp and ffmpeg
mkdir "%YT_DLP_DIR%" 2>nul
mkdir "%FFMPEG_DIR%" 2>nul

:: Check if 7-Zip is installed
if not exist "%SEVEN_ZIP_DIR%\7z.exe" (
    echo 7-Zip is not installed. Downloading and installing 7-Zip...
    curl -L -o "%TEMP%\7z.exe" "https://www.7-zip.org/a/7z1900-x64.exe"
    if not exist "%TEMP%\7z.exe" (
        echo Failed to download 7-Zip. Please check your internet connection.
        pause
        exit /B
    )
    "%TEMP%\7z.exe" /S /D="%SEVEN_ZIP_DIR%"
    if %ERRORLEVEL% NEQ 0 (
        echo Failed to install 7-Zip. Please check the installation file.
        pause
        exit /B
    )
) else (
    echo 7-Zip is already installed.
)

:: Download and install yt-dlp
echo Downloading yt-dlp...
curl -L -o "%YT_DLP_DIR%\yt-dlp.exe" "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe"
if %ERRORLEVEL% NEQ 0 (
    echo Failed to download yt-dlp. Please check your internet connection.
    pause
    exit /B
)

:: Download and install ffmpeg
echo Downloading ffmpeg...
curl -L -o "%TEMP%\ffmpeg.7z" "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-full.7z"
if %ERRORLEVEL% NEQ 0 (
    echo Failed to download ffmpeg. Please check your internet connection.
    pause
    exit /B
)

:: Extract ffmpeg using 7-Zip
echo Extracting ffmpeg...
"%SEVEN_ZIP_DIR%\7z.exe" x "%TEMP%\ffmpeg.7z" -o"%FFMPEG_DIR%" -y
if %ERRORLEVEL% NEQ 0 (
    echo Failed to extract ffmpeg. Please check the 7-Zip installation and paths.
    pause
    exit /B
)

:: Check extracted FFmpeg folder
for /d %%i in ("%FFMPEG_DIR%\ffmpeg-*") do set "FFMPEG_EXTRACTED_DIR=%%i"
if not defined FFMPEG_EXTRACTED_DIR (
    echo FFmpeg extraction failed. Could not find extracted folder.
    pause
    exit /B
)

:: Move ffmpeg files to a bin folder
mkdir "%FFMPEG_DIR%\bin" 2>nul
move "%FFMPEG_EXTRACTED_DIR%\bin\*" "%FFMPEG_DIR%\bin" 2>nul
rmdir /s /q "%FFMPEG_EXTRACTED_DIR%"

:: Add yt-dlp and ffmpeg to PATH
echo Adding yt-dlp and ffmpeg to PATH...
setx PATH "%PATH%;%YT_DLP_DIR%;%FFMPEG_DIR%\bin"
if %ERRORLEVEL% NEQ 0 (
    echo Failed to set PATH. Please check the system permissions.
    pause
    exit /B
)

:: Check if yt-dlp is working
echo Verifying yt-dlp installation...
yt-dlp --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo yt-dlp is not working correctly. Please check the installation.
    pause
    exit /B
) else (
    echo yt-dlp is installed and working!
)

:: Check if ffmpeg is working
echo Verifying ffmpeg installation...
ffmpeg -version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ffmpeg is not working correctly. Please check the installation.
    pause
    exit /B
) else (
    echo ffmpeg is installed and working!
)

:: Wait for user input or close in 5 seconds
echo Installation complete. Press any key to exit, or the window will close in 5 seconds.
timeout /t 5 /nobreak
exit
