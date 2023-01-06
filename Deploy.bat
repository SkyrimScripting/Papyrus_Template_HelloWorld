@echo off
setlocal EnableDelayedExpansion

:: TODO - make this complain if you haven't run Setup.bat
:: and ask if you wanna run Setup.bat

:: [Deploy.bat] - Copy mod files into Skyrim Data/ folder OR your Mods/ folder

set FILES_TO_COPY=HelloPapyrus.esp
set FOLDERS_TO_COPY=Scripts

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set ALWAYS_DELETE_FIRST=true
set MOD_OUTPUT_FOLDER=

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Deploy.bat script code below
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

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
