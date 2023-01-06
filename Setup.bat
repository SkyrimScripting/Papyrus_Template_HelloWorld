@echo off
setlocal EnableDelayedExpansion

set CONFIGURED_MOD_NAME=
set CONFIGURED_DEPLOY_TO=

:: [Setup.bat] - Initialize Papyrus project template

:: (Optional)
:: Uncomment the following line to set the full path to your Skyrim installation
:: set SKYRIM_FOLDER=C:\Program Files (x86)\Steam\steamapps\common\Skyrim Special Edition

set TEMPLATE_NAME=Hello World

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Setup.bat script code below
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set PPJ=Scripts.ppj
set COMPILE_BAT=Compile.bat
set DEPLOY_BAT=Deploy.bat
set PERSONALIZE_BAT=Personalize.bat
set PACKAGE_BAT=Package.bat
set SETUP_BAT=Setup.bat
set TASKS_JSON=.vscode/tasks.json

set MOD_NAME=%CONFIGURED_MOD_NAME%
set DEPLOY_TO=%CONFIGURED_DEPLOY_TO%
set PAPYRUS_COMPILER_PATH=Papyrus Compiler/PapyrusCompiler.exe

:: For newlines in PowerShell commands
(set \n=^
%=Do not remove this line=%
)

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Find path to Skyrim folder (containing valid Creation Kit installation)
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if not "%SKYRIM_FOLDER%" == "" (
    if not exist "%SKYRIM_FOLDER%/%PAPYRUS_COMPILER_PATH%" (
        echo "ERROR MSG"
        set ERROR_MSG=^[ERROR] Provided SKYRIM_FOLDER is missing Creation Kit
        set ERROR_MSG=^!ERROR_MSG!`n`nSKYRIM_FOLDER: "%SKYRIM_FOLDER%"
        set ERROR_MSG=^!ERROR_MSG!!\n!!\n!Searched for: "%SKYRIM_FOLDER%/%PAPYRUS_COMPILER_PATH%"
        goto :error_msg
    ) else (
        echo ^[FOUND] Skyrim with Creation Kit: "%SKYRIM_FOLDER%"
    )
)

:: Find your Steam installation folder (from the Windows registry for your user)
set STEAM_FOLDER=
if "%SKYRIM_FOLDER%" == "" (
    echo ^[SEARCH] Searching for SKYRIM_FOLDER
    echo ^[REGISTRY] Checking Registry item SteamPath at HKCU\SOFTWARE\Valve\Steam
    for /F "tokens=2* skip=2" %%a in ('reg query "HKCU\SOFTWARE\Valve\Steam" /v "SteamPath"') do set STEAM_FOLDER=%%b
)

set SE_FOLDER_NAME=Skyrim Special Edition
set SE_GAME_PATH=%STEAM_FOLDER%\steamapps\common\%SE_FOLDER_NAME%
set SE_COMPILER_PATH=%SE_GAME_PATH%\%PAPYRUS_COMPILER_PATH%
set LE_FOLDER_NAME=Skyrim
set LE_GAME_PATH=%STEAM_FOLDER%\steamapps\common\%LE_FOLDER_NAME%
set LE_COMPILER_PATH=%LE_GAME_PATH%\%PAPYRUS_COMPILER_PATH%
set VALIDATE_SCRIPTS_FOLDER_FILE=TESV_Papyrus_Flags.flg

:: Find Skyrim installation (containing Creation Kit)
if "%SKYRIM_FOLDER%" == "" (
    if "%STEAM_FOLDER%" == "" (
        set ERROR_MSG=^[ERROR] STEAM_FOLDER not found from registry
        set ERROR_MSG=^!ERROR_MSG!`n`nPlease open Setup.bat and set the SKYRIM_FOLDER variable
        set ERROR_MSG=^!ERROR_MSG!`nor set the SKYRIM_FOLDER environment variable.
        set ERROR_MSG=^!ERROR_MSG!`n`nThen you can run this script again!
        set ERROR_MSG=^!ERROR_MSG!`n`nRead this template README for more information.
        goto :error_msg
    ) else (
        echo HELLO
        echo ^[REGISTRY] SteamPath: "%STEAM_FOLDER%"
        if exist "%SE_COMPILER_PATH%" (
            set SKYRIM_FOLDER="%SE_GAME_PATH%"
            echo ^[FOUND] Skyrim SE with Creation Kit: "%SE_GAME_PATH%"
        ) else (
            if exist "%LE_COMPILER_PATH%" (
                set SKYRIM_FOLDER="%LE_GAME_PATH%"
                echo ^[FOUND] Skyrim LE with Creation Kit: "%LE_GAME_PATH%""
            ) else (
                set ERROR_MSG=^[ERROR] No Skyrim installation containing Creation Kit found
                set ERROR_MSG=^!ERROR_MSG!`n!\n!Searched paths:
                set ERROR_MSG=^!ERROR_MSG!`n- "%SE_COMPILER_PATH%"
                set ERROR_MSG=^!ERROR_MSG!`n- "%LE_COMPILER_PATH%"
                goto :error_msg
            )
        )
    )
)

:: Remove double quotes
set SKYRIM_FOLDER=%SKYRIM_FOLDER:"=%

:: Find out if your Creation Kit setup uses Data/Scripts/Source or Data/Source/Scripts for main game .psc script files
echo ^[SEARCH] Searching for Skryim game scripts
:: Check Source\Scripts
echo ^[CHECK] "%SKYRIM_FOLDER%\Data\Source\Scripts\%VALIDATE_SCRIPTS_FOLDER_FILE%"
if exist "%SKYRIM_FOLDER%\Data\Source\Scripts\%VALIDATE_SCRIPTS_FOLDER_FILE%" (
    echo ^[FOUND] Skyrim game scripts in "%SKYRIM_FOLDER%\Data\Source\Scripts"
    set DATA_SCRIPTS_FOLDER=Data\Source\Scripts
) else (
    echo ^[NOT FOUND] Skyrim game scripts in "%SKYRIM_FOLDER%\Data\Source\Scripts"
    :: Check Scripts\Source
    echo ^[CHECK] "%SKYRIM_FOLDER%\Data\Scripts\Source\%VALIDATE_SCRIPTS_FOLDER_FILE%"
    if exist "%SKYRIM_FOLDER%\Data\Scripts\Source\%VALIDATE_SCRIPTS_FOLDER_FILE%" (
        echo ^[FOUND] Skyrim game scripts in "%SKYRIM_FOLDER%\Data\Scripts\Source"
        set DATA_SCRIPTS_FOLDER=Data\Scripts\Source
    ) else (
        :: Check for Scripts.zip
        echo ^[NOT FOUND] Skyrim game scripts in "%SKYRIM_FOLDER%\Data\Scripts\Source"
        if exist "%SKYRIM_FOLDER%\Data\Scripts.zip" (
            echo ^[FOUND] Compressed Skyrim game scripts at "%SKYRIM_FOLDER%\Data\Scripts.zip"
            :: Do you want to extract Scripts.zip?
            for /f "usebackq delims=" %%i in (`
                powershell -c "Add-Type -Assembly System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show(\"It appears that your Skyrim Creation Kit game scripts have not been extracted into your Skyrim folder.`n`nWould you like to extract the Skyrim game scripts`ninto your Skyrim Data/ folder?`n`nThese scripts are required for this template to run.`n`nRecommended: Yes\", 'Extract Creation Kit Scripts.zip', 'YesNo').ToString()"
            `) do set MSGBOX_RESULT=%%i
            if "!MSGBOX_RESULT!" == "Yes" (
                :: Let's extract Scripts.zip!
                echo ^[EXTRACT] Extracting Scripts.zip
                echo ^[RUN] powershell Expand-Archive "%SKYRIM_FOLDER%\Data\Scripts.zip" -DestinationPath "%SKYRIM_FOLDER%\Data"
                powershell -Command "& Expand-Archive -Force '%SKYRIM_FOLDER%\Data\Scripts.zip' -DestinationPath '%SKYRIM_FOLDER%\Data'"
                if exist "%SKYRIM_FOLDER%\Data\Source\Scripts\%VALIDATE_SCRIPTS_FOLDER_FILE%" (
                    echo ^[FOUND] Skyrim game scripts in "%SKYRIM_FOLDER%\Data\Source\Scripts"
                    set DATA_SCRIPTS_FOLDER=Data\Source\Scripts
                    :: Now, do you want to move Source\Scripts to Scripts\Source?
                    for /f "usebackq delims=" %%i in (`
                        powershell -c "Add-Type -Assembly System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show(\"Scripts.zip game file extraction complete.`n`nWould you like to rename?`n`nData\Source\Scripts -----^^^> Data\Scripts\Source`n`nIt is more common for Skyrim modders to use Data\Scripts\Source`n`nIf you are unsure, it is recommended to select: Yes\", 'Rename Data\Source\Scripts to Data\Scripts\Source', 'YesNo').ToString()"
                    `) do set MSGBOX_RESULT=%%i
                    if "!MSGBOX_RESULT!" == "Yes" (
                        echo ^... Moving Data\Source\Scripts to Data\Scripts\Source ...
                        if not exist "%SKYRIM_FOLDER%\Data\Scripts\Source" (
                            echo ^... Create folder "%SKYRIM_FOLDER%\Data\Scripts\Source"
                            mkdir "%SKYRIM_FOLDER%\Data\Scripts\Source"
                        )
                        move "%SKYRIM_FOLDER%\Data\Source\Scripts\*" "%SKYRIM_FOLDER%\Data\Scripts\Source\"
                        if exist "%SKYRIM_FOLDER%\Data\Scripts\Source\%VALIDATE_SCRIPTS_FOLDER_FILE%" (
                            echo ^[DONE] Successfully moved game scripts to Data\Scripts\Source
                            set DATA_SCRIPTS_FOLDER=Data\Scripts\Source
                        ) else (
                            set ERROR_MSG=^[ERROR] Failed to move scripts from Data\Source\Scripts to Data\Scripts\Source
                            goto :error_msg
                        )
                    )
                ) else (
                    set ERROR_MSG=^[ERROR] Extracting Scripts.zip failed
                    set ERROR_MSG=^!ERROR_MSG!`n`nDid not find Skyrim game scripts in:
                    set ERROR_MSG=^!ERROR_MSG!`n"%SKYRIM_FOLDER%\Data\Source\Scripts"
                    goto :error_msg
                )
            ) else (
                echo ^[CANCEL] Game script extraction canceled
                goto :error
            )
        ) else (
            echo ^[NOT FOUND] Compressed Skyrim game scripts at "%SKYRIM_FOLDER%\Data\Scripts.zip"
            if exist "%SKYRIM_FOLDER%\Data\scripts.rar" (
                echo ^[FOUND] Compressed Skyrim game scripts at "%SKYRIM_FOLDER%\Data\scripts.rar"
                set ERROR_MSG=^[ERROR] Skyrim game scripts not extracted into Data\ folder
                set ERROR_MSG=^!ERROR_MSG!`n`nPlease open your Skyrim Data\ folder
                set ERROR_MSG=^!ERROR_MSG!`n`nThen extract the scripts.rar file
                set ERROR_MSG=^!ERROR_MSG!`n`nNote: to extract the scripts.rar file, you can use 7-zip which can be downloaded at https://7-zip.org/
                goto :error_msg
            ) else (
                echo ^[NOT FOUND] Compressed Skyrim game scripts at "%SKYRIM_FOLDER%\Data\scripts.rar"
                set ERROR_MSG=^[ERROR] Your Creation Kit installation may be corrupt.
                set ERROR_MSG=^!ERROR_MSG!`n`nPlease reinstall Creation Kit.
                set ERROR_MSG=^!ERROR_MSG!`n`nWe could not find required file TESV_Papyrus_Flags.flg
                set ERROR_MSG=^!ERROR_MSG!`nin Data\Source\Scripts or Data\Scripts\Source
                goto :error_msg
            )
        )
    )
)

:: Get a name for this mod!
if "%MOD_NAME%" == "" (
    echo ^[INPUT] Getting mod name from user input ...
    for /f "usebackq delims=" %%i in (`
        powershell -c "Add-Type -AssemblyName Microsoft.VisualBasic; $result = [Microsoft.VisualBasic.Interaction]::InputBox(\"Enter a name for your mod!`n`nThis is used to name the folder your mod is output to.\", 'Name of mod', '%TEMPLATE_NAME%'); $result"
    `) do set MOD_NAME=%%i
    if "!MOD_NAME!" == "" (
        echo ^Setup canceled...
        goto :error
    ) else (
        echo ^Mod name: !MOD_NAME!
    )
) else (
    echo ^Mod name: %MOD_NAME%
    echo ^[NOTE] Change CONFIGURED_MOD_NAME in Setup.bat to clear the currently configured MOD_NAME
)

if "%DEPLOY_TO%" == "" (
    :: How would they like to 'Deploy' this mod's .esp, scripts, etc?
    set MSGBOX_MSG=^Would you like to automatically copy this mod into your Skyrim folder [or MO2/Vortex mods folder] whenever you compile the mod?
    set MSGBOX_MSG=^!MSGBOX_MSG!`n`nSelect 'Yes' for additional options
    for /f "usebackq delims=" %%i in (`
        powershell -c "Add-Type -Assembly System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show(\"!MSGBOX_MSG!\", '%MSGBOX_TITLE%', 'YesNo').ToString()"
    `) do set MSGBOX_RESULT=%%i
    if "!MSGBOX_RESULT!" == "Yes" (
        set CONFIGURING_DEPLOY=true
        if not "%SKYRIM_MODS_FOLDER%" == "" (
            if exist "%SKYRIM_MODS_FOLDER%" (
                set MSGBOX_MSG=^Detected configured SKYRIM_MODS_FOLDER
                set MSGBOX_MSG=^!MSGBOX_MSG!`n`n%SKYRIM_MODS_FOLDER%\%MOD_NAME%
                set MSGBOX_MSG=^!MSGBOX_MSG!`n`nWould you like to copy mod files here automatically?
                for /f "usebackq delims=" %%i in (`
                    powershell -c "Add-Type -Assembly System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show(\"!MSGBOX_MSG!\", '%MSGBOX_TITLE%', 'YesNo').ToString()"
                `) do set MSGBOX_RESULT=%%i
                if "!MSGBOX_RESULT!" == "Yes" (
                    echo ^[CONFIG] Deploy to "%SKYRIM_MODS_FOLDER%\%MOD_NAME%"
                    set DEPLOY_TO=%SKYRIM_MODS_FOLDER%\%MOD_NAME%
                )
            )
        )
    )
    if "!CONFIGURING_DEPLOY!" == "true" (
        if "!DEPLOY_TO!" == "" (
            set MSGBOX_MSG=^Would you like to automatically copy mod files into your Skyrim Data folder?
            set MSGBOX_MSG=^!MSGBOX_MSG!`n`n%SKYRIM_FOLDER%
            for /f "usebackq delims=" %%i in (`
                powershell -c "Add-Type -Assembly System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show(\"!MSGBOX_MSG!\", '%MSGBOX_TITLE%', 'YesNo').ToString()"
            `) do set MSGBOX_RESULT=%%i
            if "!MSGBOX_RESULT!" == "Yes" (
                echo ^[CONFIG] Deploy to "%SKYRIM_FOLDER%\Data"
                set DEPLOY_TO=%SKYRIM_FOLDER%\Data
            )
        )
    )
    if "!CONFIGURING_DEPLOY!" == "true" (
        if "!DEPLOY_TO!" == "" (
            set MSGBOX_MSG=^Would you like to specify a custom output location? 
            for /f "usebackq delims=" %%i in (`
                powershell -c "Add-Type -Assembly System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show(\"!MSGBOX_MSG!\", '%MSGBOX_TITLE%', 'YesNo').ToString()"
            `) do set MSGBOX_RESULT=%%i
            if "!MSGBOX_RESULT!" == "Yes" (
                for /f "usebackq delims=" %%i in (`
                    powershell -c "Add-Type -AssemblyName Microsoft.VisualBasic; $result = [Microsoft.VisualBasic.Interaction]::InputBox(\"Mod output folder\", 'Output location', ''); $result"
                `) do set OUTPUT_FOLDER=%%i
                if "!OUTPUT_FOLDER!" == "" (
                    echo ^[CANCEL] Output folder not provided
                    goto :cancel
                ) else (
                    echo ^[CONFIG] Deploy to "!OUTPUT_FOLDER!"
                    set DEPLOY_TO=!OUTPUT_FOLDER!
                )
            ) else (
                echo ^[CANCEL] No output option selected
                goto :cancel
            )
        )
    )
) else (
    echo ^[CONFIG] Deploy to "!DEPLOY_TO!"
    echo ^[NOTE] Change CONFIGURED_DEPLOY_TO in Setup.bat to clear the currently configured DEPLOY_TO
)

echo Updating "%PPJ%"
:: TODO combine these:
powershell -Command "$content = Get-Content -Raw '%PPJ%'; $content = $content -replace '<Variable Name=\"SkyrimFolder\" Value=\"(.*)\" />', '<Variable Name=\"SkyrimFolder\" Value=\"%SKYRIM_FOLDER%\" />'; $content = $content.Trim(); Set-Content '%PPJ%' $content"
powershell -Command "$content = Get-Content -Raw '%PPJ%'; $content = $content -replace '<Variable Name=\"ModName\" Value=\"(.*)\" />', '<Variable Name=\"ModName\" Value=\"%MOD_NAME%\" />'; $content = $content.Trim(); Set-Content '%PPJ%' $content"
powershell -Command "$content = Get-Content -Raw '%PPJ%'; $content = $content -replace '<Variable Name=\"DataScriptsFolder\" Value=\"(.*)\" />', '<Variable Name=\"DataScriptsFolder\" Value=\"%DATA_SCRIPTS_FOLDER%\" />'; $content = $content.Trim(); Set-Content '%PPJ%' $content"

echo Updating "%COMPILE_BAT%"
powershell -Command "$content = Get-Content -Raw '%COMPILE_BAT%'; $content = $content -replace 'set SKYRIM_FOLDER=.*', 'set SKYRIM_FOLDER=%SKYRIM_FOLDER%'; $content = $content.Trim(); Set-Content '%COMPILE_BAT%' $content"

if not "%DEPLOY_TO%" == "" (
    echo Updating "%DEPLOY_BAT%"
    powershell -Command "$content = Get-Content -Raw '%DEPLOY_BAT%'; $content = $content -replace 'set MOD_OUTPUT_FOLDER=.*', 'set MOD_OUTPUT_FOLDER=%DEPLOY_TO%'; $content = $content.Trim(); Set-Content '%DEPLOY_BAT%' $content"
)

echo Updating "%PERSONALIZE_BAT%"
powershell -Command "$content = Get-Content -Raw '%PERSONALIZE_BAT%'; $content = $content -replace 'set MOD_NAME=.*', 'set MOD_NAME=%MOD_NAME%'; $prefix = '%MOD_NAME%'; $prefix = $prefix -replace '[^a-zA-Z0-9]', ''; $content = $content -replace 'set MOD_PREFIX=.*', \"set MOD_PREFIX=${prefix}\"; $content = $content.Trim(); Set-Content '%PERSONALIZE_BAT%' $content"

echo Updating "%PACKAGE_BAT%"
powershell -Command "$content = Get-Content -Raw '%PACKAGE_BAT%'; $content = $content -replace 'set MOD_NAME=.*', 'set MOD_NAME=%MOD_NAME%'; $content = $content.Trim(); Set-Content '%PACKAGE_BAT%' $content"

echo Updating "%TASKS_JSON%"
powershell -Command "$path = '%SKYRIM_FOLDER%'; $path = $path -replace '/', '//'; $path = $path -replace '\\', '\\'; $content = Get-Content -Raw '%TASKS_JSON%'; $content = $content -replace '\"gamePath\": \".*\",', ('\"gamePath\": \"' + $path + '\",'); $content = $content.Trim(); Set-Content '%TASKS_JSON%' $content"

echo Updating "%SETUP_BAT%"
powershell -Command "$content = Get-Content -Raw '%SETUP_BAT%'; $content = $content -replace ('set ' + 'CONFIGURED_MOD_NAME=.*'), ('set ' + 'CONFIGURED_MOD_NAME=%MOD_NAME%'); $content = $content -replace ('set ' + 'CONFIGURED_DEPLOY_TO=.*'), ('set ' + 'CONFIGURED_DEPLOY_TO=%DEPLOY_TO%'); $content = $content.Trim(); Set-Content '%TEMP%/%SETUP_BAT%' $content"

echo ^Done!
goto :done

:: TODO - ask them if they wanna Generate Script
:: TODO - ask them if they wanna Compile
:: TODO - ask them if they wanna Deploy

:error_msg
    powershell -c "Add-Type -Assembly System.Windows.Forms; $result = [System.Windows.Forms.MessageBox]::Show(@\"!\n!!ERROR_MSG!!\n!\"@).ToString(); ''"

:error
    echo ^[ERROR] Exiting...

:cancel
    exit /b 1

:done

powershell -Command "Copy-Item -Path '%TEMP%/%SETUP_BAT%' -Destination %0" >nul
