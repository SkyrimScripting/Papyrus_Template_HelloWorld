@echo off
setlocal EnableDelayedExpansion

set MOD_NAME=
set MOD_PREFIX=

:: [Personalize.bat] - Create your own .esp (from existing template .esp)

:: Requires bethkit.exe to be extracted to you computer and added to your PATH
:: https://www.nexusmods.com/skyrim/mods/101736/

set TEMPLATE_NAME=HelloPapyrus
set TEMPLATE_ESX=%TEMPLATE_NAME%.esx
set TEMPLATE_ESP=%TEMPLATE_NAME%.esp

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Replacements for this template's .esp plugin
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set variable_desc[0]="Quest Name"
set variable_name[0]=EXAMPLEMOD_Quest

set variable_desc[1]="Quest Script Name"
set variable_name[1]=HelloPapyrus

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Personalize.bat code below
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set MSGBOX_TITLE=Generate .esp Plugin

:: For newlines in PowerShell commands
(set \n=^
%=Do not remove this line=%
)

if "%MOD_NAME%" == "" (
    set ERROR_MSG=^[ERROR] Mod name not configured.
    set ERROR_MSG=^!ERROR_MSG!`n`nPlease run Setup.bat
    goto :error_msg
)
if "%MOD_PREFIX%" == "" (
    set ERROR_MSG=^[ERROR] Mod prefix not configured.
    set ERROR_MSG=^!ERROR_MSG!`n`nPlease run Setup.bat
    goto :error_msg
)

echo ^[SEARCH] bethkit.exe
where /q bethkit
if not %ERRORLEVEL% == 0 (
    set MSGBOX_MSG=^[ERROR] bethkit was not found
    set MSGBOX_MSG=^!MSGBOX_MSG!`n`nPlease download from https://www.nexusmods.com/skyrim/mods/101736
    set MSGBOX_MSG=^!MSGBOX_MSG!`n`nAfter downloading:
    set MSGBOX_MSG=^!MSGBOX_MSG!`n- extract the downloaded archive somewhere
    set MSGBOX_MSG=^!MSGBOX_MSG!`n- copy the full path to the FOLDER where you extracted [folder should contain bethkit.exe]
    set MSGBOX_MSG=^!MSGBOX_MSG!`n- then open the start menu and type 'Edit environment variables for your account'
    set MSGBOX_MSG=^!MSGBOX_MSG!`n- then double-click the Path variable under 'User variables for [your account]'
    set MSGBOX_MSG=^!MSGBOX_MSG!`n- then click New
    set MSGBOX_MSG=^!MSGBOX_MSG!`n- then paste the full path to the FOLDER where bethkit.exe was extracted
    set MSGBOX_MSG=^!MSGBOX_MSG!`n- then run this command again
    set MSGBOX_MSG=^!MSGBOX_MSG!`n`nIf you ran this command from a command prompt or terminal, you
    set MSGBOX_MSG=^!MSGBOX_MSG!`nneed toclose it and open a new one before bethkit.exe will be found.
    set MSGBOX_MSG=^!MSGBOX_MSG!`n`nSelect 'Yes' to open the Bethesda Toolkit page on Nexus
    for /f "usebackq delims=" %%i in (`
        powershell -c "Add-Type -Assembly System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show(\"!MSGBOX_MSG!\", '%MSGBOX_TITLE%', 'YesNo').ToString()"
    `) do set MSGBOX_RESULT=%%i
    if "!MSGBOX_RESULT!" == "Yes" (
        echo ^[OPEN URL] https://www.nexusmods.com/skyrim/mods/101736?tab=files
        START https://www.nexusmods.com/skyrim/mods/101736?tab=files
    )
    goto :done
)

echo ^[PROMPT] Mod Prefix
for /f "usebackq delims=" %%i in (`
  powershell -Command "Add-Type -AssemblyName Microsoft.VisualBasic; [Microsoft.VisualBasic.Interaction]::InputBox(\"Enter a short prefix for Quest/Script names etc`n`n[no spaces]`n[must start with a letter]`n[only a-z A-Z 0-9 characters allowed]`n`ne.g. If your mod is called 'Cool Amazing Things', maybe your would use 'COOL' or 'CLMAZ' or 'CoolAmazing'.`n`nSome modders use their initials, e.g. 'MPCool'.`n`nThis prefix is used to help keep your Quest/Script/etc names distinct from other mods [they must have unique names]`n`n[please enter nothing to cancel]\", '%MSGBOX_TITLE%', '%MOD_PREFIX%')"
`) do set MOD_PREFIX=%%i
if [%MOD_PREFIX%] == [] (
    echo ^[CANCEL] No mod prefix provided.
    goto :cancel
) else (
    echo ^[INFO] Mod Prefix: "%MOD_PREFIX%"
)

set ESX=%MOD_PREFIX%.%TEMPLATE_NAME%.esx
set ESP=%MOD_PREFIX%.%TEMPLATE_NAME%.esp

if exist "%ESP%" (
    set MSGBOX_MSG=^.esp already exists for this mod: %ESP%
    set MSGBOX_MSG=^!MSGBOX_MSG!`n`nWould you like to overwrite this file?
    for /f "usebackq delims=" %%i in (`
        powershell -c "Add-Type -Assembly System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show(\"!MSGBOX_MSG!\", '%MSGBOX_TITLE%', 'YesNo').ToString()"
    `) do set MSGBOX_RESULT=%%i
    if "!MSGBOX_RESULT!" == "Yes" (
        echo ^[DELETE] %ESP%
    ) else (
        echo ^[CANCEL]
        goto :cancel
    )
)
if exist "%ESX%" (
    set MSGBOX_MSG=^.esx already exists for this mod: %ESX%
    set MSGBOX_MSG=^!MSGBOX_MSG!`n`nWould you like to overwrite this file?
    for /f "usebackq delims=" %%i in (`
        powershell -c "Add-Type -Assembly System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show(\"!MSGBOX_MSG!\", '%MSGBOX_TITLE%', 'YesNo').ToString()"
    `) do set MSGBOX_RESULT=%%i
    if "!MSGBOX_RESULT!" == "Yes" (
        echo ^[DELETE] %ESX%
    ) else (
        echo ^[CANCEL]
        goto :cancel
    )
)

if not exist "%ESX%" (
    if exist "%TEMPLATE_ESX%" (
        echo ^[COPY] "%TEMPLATE_ESX%" "%ESX%"
        xcopy "%TEMPLATE_ESX%" "%ESX%*"
    ) else (
        if not exist "%TEMPLATE_ESP%" (
            set ERROR_MSG=^[ERROR] No .esp file found to generate an .esx from "%TEMPLATE_ESP%"
            goto :error_msg
        )
        echo ^[CONVERT] "%TEMPLATE_ESP%" to "%ESX"
        bethkit convert "%TEMPLATE_ESP%" "%ESX%"
        if not exist "%ESX%" (
            set ERROR_MSG=^[ERROR] There was a problem generating .esx from .esp "%TEMPLATE_ESP%"
            goto :error_msg
        )
    )
)

set length=0
:variable_size_loop
if defined variable_desc[%length%] ( 
   set /a "length+=1"
   goto :variable_size_loop 
)
set /a "length-=1"

echo ^[REPLACE] Performing replacements in .esx "%ESX%"
for /L %%i in (0,1,%length%) do (
    for /L %%i in (0,1,%length%) do (
        if "!variable_value[%%i]!" == "$CANCEL$" (
            echo ^[CANCEL]
            echo ^[DELETE] "%ESX%"
            del "%ESX%"
            goto :cancel
        )
    )
    for /f "usebackq delims=" %%x in (`
        powershell -Command "$varname = '%%variable_name[%%i]%%' -replace 'EXAMPLEMOD_', ''; Add-Type -AssemblyName Microsoft.VisualBasic; $result = [Microsoft.VisualBasic.Interaction]::InputBox('Set name for %%variable_desc[%%i]%%', '%%variable_desc[%%i]%%', \"%MOD_PREFIX%_${varname}\"); if (-Not $result) { $result = '$CANCEL$'; }; $result"
    `) do set variable_value[%%i]=%%x
)
for /L %%i in (0,1,%length%) do (
    if "!variable_value[%%i]!" == "$CANCEL$" (
        echo ^[CANCEL]
        echo ^[DELETE] "%ESX%"
        del "%ESX%"
        goto :cancel
    )
)

for /L %%i in (0,1,%length%) do (
    call echo %%variable_desc[%%i]%%
    call echo %%variable_name[%%i]%%
    call echo %%variable_value[%%i]%%
    call echo ^[UPDATE] "%ESX%" "%%variable_desc[%%i]%%" Replacing "%%variable_name[%%i]%%" with "%%variable_value[%%i]%%"
    call powershell -Command "$content = Get-Content -Raw '%ESX%'; $content = $content -replace '%%variable_name[%%i]%%', '%%variable_value[%%i]%%'; $content = $content.Trim(); Set-Content '%ESX%' $content"
)

echo ^[CONVERT] "%ESX%" into an "%ESP"
echo ^bethkit convert "%ESX%" "%ESP%"
bethkit convert "%ESX%" "%ESP%"
if not exist "%ESP%" (
    echo ^[ERROR] There was a problem generating .esp from .esx "%ESX%"
    goto :error
)

echo ^[DELETE] "%ESX%"
del "%ESX%"

echo ^[PROMPT] Overwrite Template
set MSGBOX_MSG=^Generated %ESP%!
set MSGBOX_MSG=^!MSGBOX_MSG!`n`nWould you like to overwrite the original %TEMPLATE_ESP%?
for /f "usebackq delims=" %%i in (`
    powershell -c "Add-Type -Assembly System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show(\"!MSGBOX_MSG!\", '%MSGBOX_TITLE%', 'YesNo').ToString()"
`) do set MSGBOX_RESULT=%%i
if "!MSGBOX_RESULT!" == "Yes" (
    echo ^[DELETE] %TEMPLATE_ESP%
    del "%TEMPLATE_ESP%"
    echo ^[COPY] %ESP% to %TEMPLATE_ESP%
    xcopy "%ESP%" "%TEMPLATE_ESP%"*
    echo ^[DELETE] %ESP%
    del "%ESP%"
)

echo ^Done!
goto :done

:error_msg
    powershell -c "Add-Type -Assembly System.Windows.Forms; $result = [System.Windows.Forms.MessageBox]::Show(@\"!\n!!ERROR_MSG!!\n!\"@).ToString(); ''"

:error
    echo ^[ERROR] Exiting...
    exit /b 1

:cancel
    exit /b 1

:done
