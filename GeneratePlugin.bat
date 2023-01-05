@echo off

setlocal EnableDelayedExpansion

:: [GeneratePlugin.bat] - Create your own .esp (from existing template .esp)
::
:: Requires bethkit.exe to be extracted to you computer and added to your PATH
:: https://www.nexusmods.com/skyrim/mods/101736/
::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: HelloPapyrus.esp Replacements
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set TEMPLATE_NAME=HelloPapyrus
set TEMPLATE_ESX=%TEMPLATE_NAME%.esx
set TEMPLATE_ESP=%TEMPLATE_NAME%.esp

set variable_desc[0]="Quest Name"
set variable_name[0]=EXAMPLEMOD_Quest

set variable_desc[1]="Quest Script Name"
set variable_name[1]=HelloPapyrus

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: for testing... TODO remove cls
cls

where /q bethkit
if not %ERRORLEVEL% == 0 (
    echo ^[ERROR] bethkit was not found
    echo.
    echo ^Please download from https://www.nexusmods.com/skyrim/mods/101736
    echo.
    echo ^After downloading:
    echo ^- extract the downloaded archive somewhere
    echo ^- copy the full path to the FOLDER where you extracted [folder should contain bethkit.exe]
    echo ^- then open the start menu and type 'Edit environment variables for your account'
    echo ^- then double-click the Path variable under 'User variables for [your account]'
    echo ^- then click New
    echo ^- then paste the full path to the FOLDER where bethkit.exe was extracted
    echo ^- then run this command again
    echo.
    echo ^If you ran this command from a command prompt or terminal, you need to
    echo ^close it and open a new one before bethkit.exe will be found.
    GOTO :error
)

echo ^Generating new Skyrim plugin...

for /f "usebackq delims=" %%i in (`
  powershell -Command "Add-Type -AssemblyName Microsoft.VisualBasic; [Microsoft.VisualBasic.Interaction]::InputBox('Enter your mod name (no spaces, must start with a letter, only a-z A-Z 0-9 characters allowed)', 'Create Skyrim Mod', 'MYMOD')"
`) do set MOD_NAME=%%i
if [%MOD_NAME%] == [] (
    echo ^No mod name provided.
    GOTO :error
) else (
    echo ^Mod name: "%MOD_NAME%"
)

set ESX=%MOD_NAME%.%TEMPLATE_NAME%.esx
set ESP=%MOD_NAME%.%TEMPLATE_NAME%.esp

if exist "%ESP%" (
    echo ^.esp already exists for this mod: "%ESP%"
    echo ^Please delete this file or choose a new mod name.
    echo ^We don't override files here, sorry!
    GOTO :error
)
if exist "%ESX%" (
    echo ^.esx already exists for this mod: "%ESX%"
    echo ^Please delete this file or choose a new mod name.
    echo ^We don't override files here, sorry!
    GOTO :error
)

if not exist "%ESX%" (
    if exist "%TEMPLATE_ESX%" (
        echo ^Template .esx exists "%TEMPLATE_ESX%"
        echo ^Creating a copy "%ESX%"
        xcopy "%TEMPLATE_ESX%" "%ESX%*"
    ) else (
        echo "Creating %ESX% from %TEMPLATE_ESP%"
        if not exist "%TEMPLATE_ESP%" (
            echo ^[ERROR] No .esp file found to generate an .esx from "%TEMPLATE_ESP%"
            GOTO :error
        )
        echo ^bethkit convert "%TEMPLATE_ESP%" "%ESX%"
        bethkit convert "%TEMPLATE_ESP%" "%ESX%"
        if not exist "%ESX%" (
            echo ^[ERROR] There was a problem generating .esx from .esp "%TEMPLATE_ESP%"
            GOTO :error
        )
    )
)

set length=0
:variable_size_loop
if defined variable_desc[%length%] ( 
   set /a "length+=1"
   GOTO :variable_size_loop 
)
set /a "length-=1"

echo ^Performing replacements in .esx "%ESX%"
for /L %%i in (0,1,%length%) do (
    for /L %%i in (0,1,%length%) do (
        if "!variable_value[%%i]!" == "$CANCEL$" (
            echo ^Canceled
            del "%ESX%"
            GOTO :error
        )
    )
    @REM for /F "tokens=2 delims==" %%x in ('set variable_value[') do (
    @REM     if "%%x" == "$CANCEL$" (
    @REM         echo ^Canceled
    @REM         del "%ESX%"
    @REM         GOTO :error
    @REM     )
    @REM )
    for /f "usebackq delims=" %%x in (`
        powershell -Command "$varname = '%%variable_name[%%i]%%' -replace 'EXAMPLEMOD_', ''; Add-Type -AssemblyName Microsoft.VisualBasic; $result = [Microsoft.VisualBasic.Interaction]::InputBox('Set name for %%variable_desc[%%i]%%', '%%variable_desc[%%i]%%', \"%MOD_NAME%_${varname}\"); if (-Not $result) { $result = '$CANCEL$'; }; $result"
    `) do set variable_value[%%i]=%%x
)
for /L %%i in (0,1,%length%) do (
    if "!variable_value[%%i]!" == "$CANCEL$" (
        echo ^Canceled
        del "%ESX%"
        GOTO :error
    )
)

for /L %%i in (0,1,%length%) do (
    call echo %%variable_desc[%%i]%%
    call echo %%variable_name[%%i]%%
    call echo %%variable_value[%%i]%%
    call echo Updating "%ESX%" "%%variable_desc[%%i]%%" Replacing "%%variable_name[%%i]%%" with "%%variable_value[%%i]%%"
    call powershell -Command "$content = Get-Content -Raw '%ESX%'; $content = $content -replace '%%variable_name[%%i]%%', '%%variable_value[%%i]%%'; $content = $content.Trim(); Set-Content '%ESX%' $content"
)

echo ^Converting "%ESX%" into an "%ESP"
echo ^bethkit convert "%ESX%" "%ESP%"
bethkit convert "%ESX%" "%ESP%"
if not exist "%ESP%" (
    echo ^[ERROR] There was a problem generating .esp from .esx "%ESX%"
    GOTO :error
)

echo ^Cleaning up. Deleting .esx "%ESX%"
del "%ESX%"

echo ^Done!
GOTO :done

:error
exit /b 1
pause

:done
