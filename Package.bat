@echo off
setlocal EnableDelayedExpansion

:: [Package.bat] - .Zip up mod files for sharing and distribution

set MOD_NAME=Hello there how are you
set FILES_TO_COPY=HelloPapyrus.esp
set FOLDERS_TO_COPY=Scripts

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Package.bat script code below
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

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
