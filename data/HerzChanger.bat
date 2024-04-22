@echo off
setlocal enabledelayedexpansion

::Copyright (c) MKritskiy.
echo Copyright (c) MKritskiy.
:: Устанавливаем кодировку консоли на UTF-8
chcp 65001 > nul

:: Переходим в директорию со скриптом
cd /d "%~dp0"
set /a count=0
for /f "tokens=2 delims==" %%i in ('wmic path Win32_VideoController get CurrentRefreshRate^,MinRefreshRate^,MaxRefreshRate /value ^| findstr /r "[0-9]"') do (
    set /a count+=1
    set "line!count!=%%i"
)

set "current_refresh_rate=%line1%"
set "max_refresh_rate=%line2%"
set "min_refresh_rate=%line3%"

echo Текущая частота обновления экрана: %current_refresh_rate% Гц
echo Минимальная частота обновления экрана: %min_refresh_rate% Гц
echo Максимальная частота обновления экрана: %max_refresh_rate% Гц

:: Спрашиваем пользователя, хочет ли он изменить частоту
set /p "change_refresh_rate=Изменить текущую частоту? (y/n): "

:: Проверяем ответ пользователя
if /i "!change_refresh_rate!"=="y" (
    if "%current_refresh_rate%"=="%max_refresh_rate%" (
        set "new_refresh_rate=%min_refresh_rate%"
    ) else if "%current_refresh_rate%"=="%min_refresh_rate%"  (
        set "new_refresh_rate=%max_refresh_rate%"
    ) else (
        echo Не удалось определить текущую частоту обновления экрана.
	set "new_refresh_rate=%current_refresh_rate%"
    )
    .\qres.exe /r:!new_refresh_rate!
    echo Частота обновления изменена на !new_refresh_rate! Гц.
) else (
    echo Изменение частоты отменено.
)

:: Добавляем команду pause для ожидания нажатия клавиши Enter
pause

endlocal
