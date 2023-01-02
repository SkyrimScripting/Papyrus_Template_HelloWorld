:: Set this to the root folder of your Skyrim or Skyrim Special Edition installation
:: 
:: You must have Creation Kit installed
::
:: Note: Unless you have pyro* installed and in your PATH,
::       this script *completely ignores* your Scripts.ppj file
::       and uses the Skyrim Papyrus Compiler *directly*.
::
::       Only use this script if you are not using
::       Visual Studio Code (or the pyro command-line application)
::
:: * pyro: https://github.com/fireundubh/pyro/releases
::
:: Note: the SKYRIM_FOLDER below is only required if you have
::       neither `pyro` nor `PapyrusCompiler.exe` in your PATH
::
set SKYRIM_FOLDER=C:\Program Files (x86)\Steam\steamapps\common\Skyrim Special Edition
set SCRIPTS_FOLDER=Scripts\Source\
set OUTPUT_FOLDER=Scripts
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@echo off

where /q pyroXXX
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

set PAPYRUS_COMPILER=%SKYRIM_FOLDER%\Papyrus Compiler\PapyrusCompiler.exe
if exist "%PAPYRUS_COMPILER%" (
    echo ^[FOUND] PapyrusCompiler.exe
    echo "%PAPYRUS_COMPILER%"
) else (
    echo ^Could not find Papyrus compiler "%PAPYRUS_COMPILER%"
    goto :error
)

if exist "%SKYRIM_FOLDER%\Data\Scripts\Source" (
    set SKYRIM_SCRIPTS_FOLDER="%SKYRIM_FOLDER%\Data\Scripts\Source"
) else if exist "%SKYRIM_FOLDER%\Data\Source\Scripts" (
    set SKYRIM_SCRIPTS_FOLDER="%SKYRIM_FOLDER%\Data\Source\Scripts"
) else (
    echo ^Could not find Papyrus scripts in your "%SKYRIM_FOLDER%\Data" directory
    echo ^Please follow README instructions to unzip the Scripts.zip or scripts.rar
    echo ^[NOT FOUND] Searched "%SKYRIM_FOLDER%\Data\Scripts\Source"
    echo ^[NOT FOUND] Searched "%SKYRIM_FOLDER%\Data\Source\Scripts"
    goto :error
)

echo ^[FOUND] Skyrim Scripts Folder %SKYRIM_SCRIPTS_FOLDER%
echo ^Compiling project using PapyrusCompiler.exe

set "SKYRIM_SCRIPTS_FOLDER_NO_QUOTES=%SKYRIM_SCRIPTS_FOLDER:"=%"
echo ^no quotes %SKYRIM_SCRIPTS_FOLDER_NO_QUOTES%
"%PAPYRUS_COMPILER%" %SCRIPTS_FOLDER% -all -f=TESV_Papyrus_Flags.flg -o=%OUTPUT_FOLDER% -i="%SCRIPTS_FOLDER%;%SKYRIM_SCRIPTS_FOLDER_NO_QUOTES%"

:error
exit /b 1
pause

:done
