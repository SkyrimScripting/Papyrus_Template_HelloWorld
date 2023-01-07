@echo off
setlocal EnableDelayedExpansion

:: just for testing:
cls

:: Setup.bat - setup your Papyrus template!

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Template-Specific Variables
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set TEMPLATE_NAME=Hello World
set TEMPLATE_URL=https://github.com/SkyrimScripting/Papyrus_Template_HelloWorld

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
:: Skyrim Folder (containing Creation Kit)
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:verify_skyrim_folder
    call :find_skyrim_folder
    echo verify
    goto :end

:find_skyrim_folder
    if not "%SKYRIM_FOLDER%" == "" goto :end
    call :find_steam_folder
    if "%STEAM_FOLDER%" == "" call :error_steam_not_found
    echo lookup
    goto :end

:find_steam_folder
    if not "%STEAM_FOLDER%" == "" goto :end
    @REM for /f "tokens=2* skip=2" %%a in ('reg query "HKCU\SOFTWARE\Valve\Steam" /v "SteamPath"') do set STEAM_FOLDER=%%b
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

:use_newlines
(set \n=^
%=DO NOT REMOVE THIS LINE - This creates a variable with a newline character=%
)
    goto :end

:msgbox_ok
    powershell -c "Add-Type -Assembly System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show(\"${env:MSGBOX_TEXT}\", \"${env:MSGBOX_TITLE}\")"
    goto :end

:msgbox_yes_no
    set MSGBOX_TYPE=YesNo
    set MSGBOX_RESULT=
    for /f "usebackq delims=" %%i in (`
        powershell -c "Add-Type -Assembly System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show(\"${env:MSGBOX_TEXT}\", \"${env:MSGBOX_TITLE}\", \"${env:MSGBOX_TYPE}\")"
    `) do set MSGBOX_RESULT=%%i
    if "!MSGBOX_RESULT!" == "Yes" call :open_readme_in_browser
    goto :end

:msgbox_input
    set MSGBOX_RESULT=
    for /f "usebackq delims=" %%i in (`
        powershell -c "Add-Type -AssemblyName Microsoft.VisualBasic; [Microsoft.VisualBasic.Interaction]::InputBox(\"${env:MSGBOX_TEXT}\", \"${env:MSGBOX_TITLE}\", \"${env:MSGBOX_VALUE}\")"
    `) do set MSGBOX_RESULT=%%i
    goto :end

:msgbox_redirect_readme
    set MSGBOX_TEXT=^!MSGBOX_TEXT!!\n!!\n!Would you like to view the README for this template?
    set MSGBOX_TEXT=^!MSGBOX_TEXT!!\n!!\n!Select "Yes" to open it in a browser
    call :msgbox_yes_no
    goto :end

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Errors
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:error_steam_not_found
    call :use_newlines
    set MSGBOX_TITLE=^Error
    set MSGBOX_TEXT=^Could not find find Steam directory
    set MSGBOX_TEXT=^!MSGBOX_TEXT!!\n!!\n!( Is Steam installed? )
    set MSGBOX_TEXT=^!MSGBOX_TEXT!!\n!!\n!You can fix this error by creating a new Windows environment variable called SKYRIM_FOLDER and setting the value to the full path of your Skyrim or Skyrim Special Edition game directory.
    call :msgbox_redirect_readme
    goto :exit

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Misc
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:open_readme_in_browser
    start %TEMPLATE_URL%
    goto :end

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: End of Script
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:exit
    exit /b 1

:end
