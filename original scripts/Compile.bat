@echo off
setlocal EnableDelayedExpansion

set SKYRIM_FOLDER=

:: [Compile.bat] - Compile Papyrus scripts!

:: Requires Creation Kit to be installed
 
set SCRIPTS_FOLDER=Scripts\Source\
set OUTPUT_FOLDER=Scripts

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Compile.bat script code below
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: For newlines in PowerShell commands
(set \n=^
%=Do not remove this line=%
)

if "%SKYRIM_FOLDER%" == "" (
    set ERROR_MSG=^[ERROR] Skyim Folder not configured.
    set ERROR_MSG=^!ERROR_MSG!`n`nPlease run Setup.bat
    goto :error_msg
)

:: Check for pyro.exe
where /q pyro
if %ERRORLEVEL% == 0 (
    echo ^[FOUND] pyro
    echo ^[SEARCH] .ppj Papyrus Project Files
    if exist *.ppj (
        echo ^[COMPILE] Compiling project using pyro
        for /r %%a in (*.ppj) do echo^ [FOUND] "%%a"
        for /r %%a in (*.ppj) do pyro -i "%%a"
        goto :done
    ) else (
        echo ^[NOT FOUND] No .ppj Papuyrus Project Files found
        echo ^[INFO] Falling back to PapyrusCompiler.exe...
    )
) else (
    echo ^[NOT FOUND] pyro
    echo ^[INFO] Falling back to PapyrusCompiler.exe...
)

:: Check for PapyrusCompiler.exe
where /q PapyrusCompiler
if %ERRORLEVEL% == 0 (
    echo ^[FOUND] PapyrusCompiler.exe
)

if not exist "%SKYRIM_FOLDER%" (
    echo ^[NOT FOUND] Skyrim Folder "%SKYRIM_FOLDER%"
    set ERROR_MSG=^[ERROR] Could not find Skyrim folder
    set ERROR_MSG=^!ERROR_MSG!`n`nExpected path:
    set ERROR_MSG=^!ERROR_MSG!`n"%SKYRIM_FOLDER%"
    goto :error_msg
)

echo ^[SEARCH] PapyrusCompiler.exe
set PAPYRUS_COMPILER=%SKYRIM_FOLDER%\Papyrus Compiler\PapyrusCompiler.exe
if exist "%PAPYRUS_COMPILER%" (
    echo ^[FOUND] PapyrusCompiler.exe "%PAPYRUS_COMPILER%"
) else (
    echo ^[NOT FOUND] PapyrusCompiler.exe
    set ERROR_MSG=^[ERROR] Could not find Papyrus compiler
    set ERROR_MSG=^!ERROR_MSG!`n`nExpected path:
    set ERROR_MSG=^!ERROR_MSG!`n"%PAPYRUS_COMPILER%"
    goto :error_msg
)

set COMPILER_INCLUDES=Scripts\Source
if exist "%SKYRIM_FOLDER%\Data\Scripts\Source" (
    set COMPILER_INCLUDES=%COMPILER_INCLUDES%;%SKYRIM_FOLDER%\Data\Scripts\Source
)
if exist "%SKYRIM_FOLDER%\Data\Source\Scripts" (
    set COMPILER_INCLUDES=%COMPILER_INCLUDES%;%SKYRIM_FOLDER%\Data\Source\Scripts
)

echo.
echo ^[COMPILE] Compiling project using PapyrusCompiler.exe
echo ^"%PAPYRUS_COMPILER%" %SCRIPTS_FOLDER% -all -f=TESV_Papyrus_Flags.flg -o=%OUTPUT_FOLDER% -i="%COMPILER_INCLUDES%"
echo.
"%PAPYRUS_COMPILER%" %SCRIPTS_FOLDER% -all -f=TESV_Papyrus_Flags.flg -o=%OUTPUT_FOLDER% -i="%COMPILER_INCLUDES%"

echo ^Done!
goto :done

:error_msg
    powershell -c "Add-Type -Assembly System.Windows.Forms; $result = [System.Windows.Forms.MessageBox]::Show(@\"!\n!!ERROR_MSG!!\n!\"@).ToString(); ''"

:error
    echo ^[ERROR] Exiting...
    exit /b 1

:done
