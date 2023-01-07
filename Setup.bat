@echo off
setlocal EnableDelayedExpansion

:: just for testing:
cls

:: Setup.bat - setup your Papyrus template!

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Template-Specific Variables
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set TEMPLATE_NAME=Hello World

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Invoke main() method for each supported action
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if "%1" == ""            call :setup
if "%1" == "compile"     call :compile
if "%1" == "deploy"      call :deploy
if "%1" == "package"     call :package
if "%1" == "personalize" call :personalize
goto :end

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Misc: required variable for creating UI messages with line breaks
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

(set \n=^
%=DO NOT REMOVE THIS LINE - This creates a variable with a newline character=%
)

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Skyrim Folder (containing Creation Kit)
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:verify_skyrim_folder
    call :find_skyrim_folder
    echo verify
    goto :end

:find_skyrim_folder
    if not "%SKYRIM_FOLDER%" == "" goto :end
    echo lookup
    goto :end

:find_steam_folder
    goto :end

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Skyrim Creation Kit game scripts (Data\Source\Scripts or Data\Scripts\Source)
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Setup
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:setup
    call :verify_skyrim_folder
    goto :end

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Compile
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:compile
    echo hi from compile
    goto :end

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Deploy
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:deploy
    echo hi from deploy
    goto :end

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Package
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:package
    echo hi from package
    goto :end

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Personalize
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:personalize
    echo hi from personalize
    goto :end

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: User Interface
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:msgbox_ok
    powershell -c "Add-Type -Assembly System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show(\"${env:MSGBOX_TEXT}\", \"${env:MSGBOX_TITLE}\")"
    goto :end

:msgbox_yes_no
    set MSGBOX_RESULT=
    for /f "usebackq delims=" %%i in (`
        powershell -c "Add-Type -Assembly System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show(\"${env:MSGBOX_TEXT}\", \"${env:MSGBOX_TITLE}\", \"${env:MSGBOX_TYPE}\")"
    `) do set MSGBOX_RESULT=%%i
    goto :end

:msgbox_input
    set MSGBOX_RESULT=
    for /f "usebackq delims=" %%i in (`
        powershell -c "Add-Type -AssemblyName Microsoft.VisualBasic; [Microsoft.VisualBasic.Interaction]::InputBox(\"${env:MSGBOX_TEXT}\", \"${env:MSGBOX_TITLE}\", \"${env:MSGBOX_VALUE}\")"
    `) do set MSGBOX_RESULT=%%i
    goto :end

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Errors
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:end
