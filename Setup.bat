@echo off
setlocal EnableDelayedExpansion

:: [Setup.bat] - Initialize Papyrus project template

:: (Optional)
:: Uncomment the following line to set the full path to your Skyrim installation
:: set SKYRIM_FOLDER=C:\Program Files (x86)\Steam\steamapps\common\Skyrim Special Edition

set TEMPLATE_NAME=Hello World

set PPJ=Scripts.ppj
set COMPILE_BAT=Compile.bat
set DEPLOY_BAT=Deploy.bat
set TASKS_JSON=.vscode/tasks.json

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Gets the path to your Skyrim folder and updates it in:
:: - <project root>/Compile.bat
:: - <project root>/Deploy.bat
:: - <project root>/Scripts.ppj
:: - <project root>/.vscode/tasks.json
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Setup.bat script code below
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set PAPYRUS_COMPILER_PATH=Papyrus Compiler/PapyrusCompiler.exe

:: For newline support
(set \n=^
%=Do not remove this line=%
)

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Find path to Skyrim folder (containing valid Creation Kit installation)
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if not "%SKYRIM_FOLDER%" == "" (
    if not exist "%SKYRIM_FOLDER%/%PAPYRUS_COMPILER_PATH%" (
        set ERROR_MSG=^[ERROR] Provided SKYRIM_FOLDER is missing Creation Kit
        set ERROR_MSG=^!ERROR_MSG!!\n!!\n!SKYRIM_FOLDER: "%SKYRIM_FOLDER%"
        set ERROR_MSG=^!ERROR_MSG!!\n!!\n!Searched for: "%SKYRIM_FOLDER%/%PAPYRUS_COMPILER_PATH%"
        goto :error
    ) else (
        echo ^[FOUND] Skyrim with Creation Kit: "%SKYRIM_FOLDER%"
    )
)

:: If SKYRIM_FOLDER isn't manually configured above, this discovers
:: your Steam installation folder from the Windows registry
set STEAM_FOLDER=
if "%SKYRIM_FOLDER%" == "" (
    echo ^... Searching for SKYRIM_FOLDER ...
    echo ^... Checking Registry item SteamPath at HKCU\SOFTWARE\Valve\Steam ...
    for /F "tokens=2* skip=2" %%a in ('reg query "HKCU\SOFTWARE\Valve\Steam" /v "SteamPath"') do set STEAM_FOLDER=%%b
)

set SE_FOLDER_NAME=Skyrim Special Edition
set SE_GAME_PATH=%STEAM_FOLDER%/steamapps/common/%SE_FOLDER_NAME%
set SE_COMPILER_PATH=%SE_GAME_PATH%/%PAPYRUS_COMPILER_PATH%
set LE_FOLDER_NAME=Skyrim
set LE_GAME_PATH=%STEAM_FOLDER%/steamapps/common/%LE_FOLDER_NAME%
set LE_COMPILER_PATH=%LE_GAME_PATH%/%PAPYRUS_COMPILER_PATH%

if "%SKYRIM_FOLDER%" == "" (
    if [%STEAM_FOLDER%] == [] (
        set ERROR_MSG=^[ERROR] STEAM_FOLDER not found from registry
        set ERROR_MSG=^!ERROR_MSG!!\n!!\n!Please open Setup.bat and set the SKYRIM_FOLDER variable
        set ERROR_MSG=^!ERROR_MSG!!\n!or set the SKYRIM_FOLDER environment variable.
        set ERROR_MSG=^!ERROR_MSG!!\n!!\n!Then you can run this script again!
        set ERROR_MSG=^!ERROR_MSG!!\n!!\n!Read this template README for more information.
        goto :error
    ) else (
        if exist "%SE_COMPILER_PATH%" (
            set SKYRIM_FOLDER=%SE_GAME_PATH%
            echo ^[FOUND] Skyrim SE with Creation Kit: %SE_GAME_PATH%
        ) else (
            if exist "%LE_COMPILER_PATH%" (
                set SKYRIM_FOLDER=%LE_GAME_PATH%
                echo ^[FOUND] Skyrim LE with Creation Kit: %LE_GAME_PATH%
            ) else (
                set ERROR_MSG=^[ERROR] No Skyrim installation containing Creation Kit found
                set ERROR_MSG=^!ERROR_MSG!!\n!!\n!Searched paths:
                set ERROR_MSG=^!ERROR_MSG!!\n!- "%SE_COMPILER_PATH%"
                set ERROR_MSG=^!ERROR_MSG!!\n!- "%LE_COMPILER_PATH%"
                goto :error
            )
        )
    )
)

:: Get a name for this mod!
echo ^... Getting mod name from user input ...
for /f "usebackq delims=" %%i in (`
    powershell -c "Add-Type -AssemblyName Microsoft.VisualBasic; $result = [Microsoft.VisualBasic.Interaction]::InputBox(\"Enter a name for your mod!`n`nThis is used to name the folder your mod is output to.\", 'Name of mod', '%TEMPLATE_NAME%'); $result"
`) do set MOD_NAME=%%i

if "%MOD_NAME%" == "" (
    echo ^Setup canceled...
    goto :error
) else (
    echo ^Mod name: %MOD_NAME%
)

echo Updating "%PPJ%"
powershell -Command "$content = Get-Content -Raw '%PPJ%'; $content = $content -replace '<Variable Name=\"SkyrimFolder\" Value=\"(.*)\" />', '<Variable Name=\"SkyrimFolder\" Value=\"%SKYRIM_FOLDER%\" />'; $content = $content.Trim(); Set-Content '%PPJ%' $content"
powershell -Command "$content = Get-Content -Raw '%PPJ%'; $content = $content -replace '<Variable Name=\"ModName\" Value=\"(.*)\" />', '<Variable Name=\"ModName\" Value=\"%MOD_NAME%\" />'; $content = $content.Trim(); Set-Content '%PPJ%' $content"

echo Updating "%COMPILE_BAT%"
powershell -Command "$content = Get-Content -Raw '%COMPILE_BAT%'; $content = $content -replace 'set SKYRIM_FOLDER=.*', 'set SKYRIM_FOLDER=%SKYRIM_FOLDER%'; $content = $content.Trim(); Set-Content '%COMPILE_BAT%' $content"

echo Updating "%DEPLOY_BAT%"
powershell -Command "$content = Get-Content -Raw '%DEPLOY_BAT%'; $content = $content -replace 'set SKYRIM_FOLDER=.*', 'set SKYRIM_FOLDER=%SKYRIM_FOLDER%'; $content = $content.Trim(); Set-Content '%DEPLOY_BAT%' $content"

echo Updating "%TASKS_JSON%"
powershell -Command "$path = '%SKYRIM_FOLDER%'; $path = $path -replace '/', '//'; $content = Get-Content -Raw '%TASKS_JSON%'; $content = $content -replace '\"gamePath\": \".*\",', ('\"gamePath\": \"' + $path + '\",'); $content = $content.Trim(); Set-Content '%TASKS_JSON%' $content"

echo ^Done!
goto :done

:error
if not "%ERROR_MSG%" == "" (
    powershell -c "Add-Type -Assembly System.Windows.Forms; $result = [System.Windows.Forms.MessageBox]::Show('!ERROR_MSG!').ToString(); ''"
)
echo Exiting...
exit /b 1

:done
