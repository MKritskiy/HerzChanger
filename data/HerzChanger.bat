@echo off
setlocal enabledelayedexpansion

:: Copyright (c) MKritskiy.
echo Copyright (c) MKritskiy.
:: Set console encoding to UTF-8
chcp 65001 > nul

:: Change to the script directory
cd /d "%~dp0"
set /a count=0
for /f "tokens=2 delims==" %%i in ('wmic path Win32_VideoController get CurrentRefreshRate^,MinRefreshRate^,MaxRefreshRate /value ^| findstr /r "[0-9]"') do (
    set /a count+=1
    set "line!count!=%%i"
)

set "current_refresh_rate=%line1%"
set "max_refresh_rate=%line2%"
set "min_refresh_rate=%line3%"

echo Current screen refresh rate: %current_refresh_rate% Hz
echo Minimum screen refresh rate: %min_refresh_rate% Hz
echo Maximum screen refresh rate: %max_refresh_rate% Hz

:: Ask user if they want to change the refresh rate
set /p "change_refresh_rate=Change current refresh rate? (y/n): "

:: Check user's response
if /i "!change_refresh_rate!"=="y" (
    if "%current_refresh_rate%"=="%max_refresh_rate%" (
        set "new_refresh_rate=%min_refresh_rate%"
    ) else if "%current_refresh_rate%"=="%min_refresh_rate%"  (
        set "new_refresh_rate=%max_refresh_rate%"
    ) else (
        echo Unable to determine current screen refresh rate.
        set "new_refresh_rate=%current_refresh_rate%"
    )
    .\qres.exe /r:!new_refresh_rate!
    echo Refresh rate changed to !new_refresh_rate! Hz.
) else (
    echo Changing refresh rate cancelled.
)

:: Add pause command to wait for user input
pause

endlocal