@echo off
setlocal EnableDelayedExpansion

set MOD_NAME=

:: [Package.bat] - .Zip up mod files for sharing and distribution

set FILES_TO_COPY=HelloPapyrus.esp
set FOLDERS_TO_COPY=Scripts

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Package.bat script code below
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: For newlines in PowerShell commands
(set \n=^
%=Do not remove this line=%
)

if "%MOD_NAME%" == "" (
    set ERROR_MSG=^[ERROR] Mod name not configured.
    set ERROR_MSG=^!ERROR_MSG!`n`nPlease run Setup.bat
    goto :error_msg
)


set COMPRESS_ARCHIVE_ARG=

(for %%f in (%FILES_TO_COPY%) do (
    if "!COMPRESS_ARCHIVE_ARG!" == "" (
        set COMPRESS_ARCHIVE_ARG="%%f"
    ) else (
        set COMPRESS_ARCHIVE_ARG=!COMPRESS_ARCHIVE_ARG!,"%%f"
    )
)
(for %%f in (%FOLDERS_TO_COPY%) do ( 
    if "!COMPRESS_ARCHIVE_ARG!" == "" (
        set COMPRESS_ARCHIVE_ARG="%%f"
    ) else (
        set COMPRESS_ARCHIVE_ARG=!COMPRESS_ARCHIVE_ARG!,"%%f"
    )
)))

echo ^powershell -c "Compress-Archive -LiteralPath %COMPRESS_ARCHIVE_ARG% -DestinationPath \"%MOD_NAME%.zip\""
powershell -c "Compress-Archive -LiteralPath %COMPRESS_ARCHIVE_ARG% -DestinationPath \"%MOD_NAME%.zip\""

echo ^Done!
goto :done

:error_msg
    powershell -c "Add-Type -Assembly System.Windows.Forms; $result = [System.Windows.Forms.MessageBox]::Show(@\"!\n!!ERROR_MSG!!\n!\"@).ToString(); ''"

:error
    echo ^[ERROR] Exiting...
    exit /b 1

:done
