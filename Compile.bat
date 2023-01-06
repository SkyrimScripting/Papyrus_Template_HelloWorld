@echo off
setlocal EnableDelayedExpansion

:: TODO update to use UI

:: [Compile.bat] - Compile Papyrus scripts!
 
:: > You must have Creation Kit installed

:: Note: Unless you have pyro* installed and in your PATH,
::       this script *completely ignores* your Scripts.ppj file
::       and uses the Skyrim Papyrus Compiler *directly*.
::
::       Only use this script if you are not using
::       Visual Studio Code (or the pyro command-line application)
::
:: * pyro: https://github.com/fireundubh/pyro/releases

:: Note: the SKYRIM_FOLDER below is only used if you have
::       neither `pyro` nor `PapyrusCompiler.exe` in your PATH
::
set SKYRIM_FOLDER=c:/steam\steamapps\common\Skyrim Special Edition

set SCRIPTS_FOLDER=Scripts\Source\
set OUTPUT_FOLDER=Scripts

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Compile.bat script code below
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Check for pyro.exe
where /q pyro
if %ERRORLEVEL% == 0 (
    echo ^[FOUND] pyro
    echo ^Searching for .ppj Papyrus Project Files
    if exist *.ppj (
        echo ^Compiling project using pyro
        for /r %%a in (*.ppj) do echo^ [FOUND] "%%a"
        for /r %%a in (*.ppj) do pyro -i "%%a"
        goto :done
    ) else (
        echo ^No .ppj Papuyrus Project Files found
        echo ^Falling back to PapyrusCompiler.exe...
    )
) else (
    echo ^[NOT FOUND] pyro
    echo ^Falling back to PapyrusCompiler.exe...
)

goto :done

:: Check for PapyrusCompiler.exe
where /q PapyrusCompiler
if %ERRORLEVEL% == 0 (
    echo ^[FOUND] PapyrusCompiler.exe
) else (
    echo ^[NOT FOUND] PapyrusCompiler.exe
    echo ^Searching for PapyrusCompiler.exe...
)

if not exist "%SKYRIM_FOLDER%" (
    echo ^Could not find Skyrim Folder "%SKYRIM_FOLDER%"
    goto :error
)

echo here
set PAPYRUS_COMPILER=%SKYRIM_FOLDER%\Papyrus Compiler\PapyrusCompiler.exe
echo there
if exist "%PAPYRUS_COMPILER%" (
    echo ^[FOUND] PapyrusCompiler.exe
    echo "%PAPYRUS_COMPILER%"
) else (
    echo ^Could not find Papyrus compiler "%PAPYRUS_COMPILER%"
    goto :error
)

if not exist "%SKYRIM_FOLDER%\Data\Scripts\Source\TESV_Papyrus_Flags.flg" (
    if not exist "%SKYRIM_FOLDER%\Data\Source\Scripts\TESV_Papyrus_Flags.flg" (
        if exist "%SKYRIM_FOLDER%\Data\Scripts.zip" (
            echo ^Could not find Papyrus scripts in your "%SKYRIM_FOLDER%\Data" directory
            echo ^[FOUND] Scripts.zip
            echo ^Extracting to Data folder: "%SKYRIM_FOLDER%\Data\"
            echo ^powershell Expand-Archive %SKYRIM_FOLDER%\Data\Scripts.zip -DestinationPath %SKYRIM_FOLDER%\Data
            powershell -Command "& Expand-Archive -Force '%SKYRIM_FOLDER%\Data\Scripts.zip' -DestinationPath '%SKYRIM_FOLDER%\Data'"
        )
    )
)

if not exist "%SKYRIM_FOLDER%\Data\Scripts\Source\TESV_Papyrus_Flags.flg" (
    if not exist "%SKYRIM_FOLDER%\Data\Source\Scripts\TESV_Papyrus_Flags.flg" (
        echo ^Could not find Papyrus scripts in your "%SKYRIM_FOLDER%\Data" directory
        echo ^Please follow README instructions to unzip the Scripts.zip or scripts.rar
        echo ^[NOT FOUND] Searched "%SKYRIM_FOLDER%\Data\Scripts\Source"
        echo ^[NOT FOUND] Searched "%SKYRIM_FOLDER%\Data\Source\Scripts"
        goto :error
    )
)

echo ^Compiling project using PapyrusCompiler.exe

set COMPILER_INCLUDES=Scripts\Source
if exist "%SKYRIM_FOLDER%\Data\Scripts\Source" (
    set COMPILER_INCLUDES=%COMPILER_INCLUDES%;%SKYRIM_FOLDER%\Data\Scripts\Source
)
if exist "%SKYRIM_FOLDER%\Data\Source\Scripts" (
    set COMPILER_INCLUDES=%COMPILER_INCLUDES%;%SKYRIM_FOLDER%\Data\Source\Scripts
)

"%PAPYRUS_COMPILER%" %SCRIPTS_FOLDER% -all -f=TESV_Papyrus_Flags.flg -o=%OUTPUT_FOLDER% -i="%COMPILER_INCLUDES%"

:error_msg
    powershell -c "Add-Type -Assembly System.Windows.Forms; $result = [System.Windows.Forms.MessageBox]::Show(@\"!\n!!ERROR_MSG!!\n!\"@).ToString(); ''"

:error
    echo ^[ERROR] Exiting...
    exit /b 1

:done
