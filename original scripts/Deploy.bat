@echo off
setlocal EnableDelayedExpansion

set MOD_OUTPUT_FOLDER=
set ALWAYS_DELETE_FIRST=true

:: [Deploy.bat] - Copy mod files into Skyrim Data/ folder OR your Mods/ folder

set FILES_TO_COPY=HelloPapyrus.esp
set FOLDERS_TO_COPY=Scripts

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Deploy.bat script code below
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: For newlines in PowerShell commands
(set \n=^
%=Do not remove this line=%
)

if "%MOD_OUTPUT_FOLDER%" == "" (
    echo ^No deploy location configured
    goto :done
)

echo ^[DEPLOY TO] "%MOD_OUTPUT_FOLDER%"

if "%ALWAYS_DELETE_FIRST%" == "true" (
    if exist "%MOD_OUTPUT_FOLDER%" (
        echo ^[DELETE FOLDER] "%MOD_OUTPUT_FOLDER%"
        echo ^[NOTE] To disable deleting folder on deploy, change ALWAYS_DELETE_FIRST setting in Deploy.bat to "false"
        echo ^rmdir /s /q "%MOD_OUTPUT_FOLDER%"
        rmdir /s /q "%MOD_OUTPUT_FOLDER%"
    )
)

mkdir "%MOD_OUTPUT_FOLDER%"

(for %%f in (%FILES_TO_COPY%) do ( 
   echo ^[COPY] %%f
   echo ^xcopy "%%f" "%MOD_OUTPUT_FOLDER%/%%f"*
   ^xcopy "%%f" "%MOD_OUTPUT_FOLDER%/%%f"*
)
(for %%f in (%FOLDERS_TO_COPY%) do ( 
   echo ^[COPY] %%f
   echo ^xcopy "%%f" "%MOD_OUTPUT_FOLDER%/%%f"\
   ^xcopy "%%f" "%MOD_OUTPUT_FOLDER%/%%f"\
)))

echo ^Done!
goto :done

:error_msg
    powershell -c "Add-Type -Assembly System.Windows.Forms; $result = [System.Windows.Forms.MessageBox]::Show(@\"!\n!!ERROR_MSG!!\n!\"@).ToString(); ''"

:error
    echo ^[ERROR] Exiting...
    exit /b 1

:done
