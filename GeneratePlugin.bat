@echo off

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
set variable_name[0]=HelloPapyrusQuest

set variable_desc[1]="Quest Script Name"
set variable_name[1]=HelloPapyrus

@REM set variable_desc[0]="Quest Name"
@REM set variable_name[0]=EXAMPLEMOD_MainQuest

@REM set variable_desc[1]="Quest Script Name"
@REM set variable_name[1]=EXAMPLEMOD_QuestScript

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
            GOTO :rrror
        )
    )
) else (
    echo ^Mod .esx already exists "%ESX%"
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
    call echo %%variable_desc[%%i]%%
    call echo %%variable_name[%%i]%%
    for /f "usebackq delims=" %%i in (`
        powershell -Command "Add-Type -AssemblyName Microsoft.VisualBasic; [Microsoft.VisualBasic.Interaction]::InputBox('Set name for %%variable_name[%%i]%%', '%%variable_desc[%%i]%%', '%%variable_name[%%i]%%')"
    `) do set MOD_NAME=%%i
)

:error
exit /b 1
pause

:done
