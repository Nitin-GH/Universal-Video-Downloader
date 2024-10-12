@echo off
REM Batch file to install Brotli, yt-dlp, and ffmpeg using pip

echo Installing Brotli...
pip install brotli
if %errorlevel% neq 0 (
    echo Failed to install Brotli.
) else (
    echo Brotli installed successfully.
)

echo Installing yt-dlp...
pip install yt-dlp
if %errorlevel% neq 0 (
    echo Failed to install yt-dlp.
) else (
    echo yt-dlp installed successfully.
)

echo Installing ffmpeg...
pip install ffmpeg-python
if %errorlevel% neq 0 (
    echo Failed to install ffmpeg.
) else (
    echo ffmpeg installed successfully.
)

echo.
echo All installations completed. Press any key to exit...
pause >nul
