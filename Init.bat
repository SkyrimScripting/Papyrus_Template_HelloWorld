@echo off

:: [Init.bat] - Initialize Papyrus project@
::
:: Gets the path to your Skyrim folder and updates it in:
:: - <project root>/Scripts.ppj
:: - <project root>/.vscode/tasks.json
::
:: Scripts.ppj is the "Papyrus project file" used for building
:: the project using Visual Studio Code or directly using `pyro`
::
:: .vscode/tasks.json configures the path to the Skyrim Papyrus compiler
:: used by `pyro`, when run via Visual Studio Code build task

:: (Optional) set this to the full path to your Skyrim installation
set SKYRIM_FOLDER=

:: Example:
:: set SKYRIM_FOLDER=C:\Program Files (x86)\Steam\steamapps\common\Skyrim Special Edition

:: If not provided, the SKYRIM_FOLDER is detected automatically.

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Init.bat script code below
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: This reads your Steam installation folder from the Windows registry into a variable
set STEAM_FOLDER=
if [%SKYRIM_FOLDER%] == [] (
    echo ^... Searching for SKYRIM_FOLDER ...
    echo ^... Checking Registry item SteamPath at HKCU\SOFTWARE\Valve\Steam ...
    for /F "tokens=2* skip=2" %%a in ('reg query "HKCU\SOFTWARE\Valve\Steam" /v "SteamPath"') do set STEAM_FOLDER=%%b
)
if [%SKYRIM_FOLDER%] == [] (
    if [%STEAM_FOLDER%] == [] (
        echo ^[ERROR] STEAM_FOLDER not found from registry
        echo ^Please open Init.bat and set the SKYRIM_FOLDER variable
        echo ^Then you can run this script again
        GOTO :error
    ) else (
        if exist "%STEAM_FOLDER%/steamapps/common/Skyrim Special Edition/Papyrus Compiler/PapyrusCompiler.exe" (
            set SKYRIM_FOLDER=%STEAM_FOLDER%/steamapps/common/Skyrim Special Edition/Papyrus Compiler/PapyrusCompiler.exe
            echo ^[FOUND] Skyrim SE with Creation Kit: %STEAM_FOLDER%/steamapps/common/Skyrim Special Edition
        ) else (
            if exist "%STEAM_FOLDER%/steamapps/common/Skyrim/Papyrus Compiler/PapyrusCompiler.exe" (
                set SKYRIM_FOLDER=%STEAM_FOLDER%/steamapps/common/Skyrim/Papyrus Compiler/PapyrusCompiler.exe
                echo ^[FOUND] Skyrim LE with Creation Kit: %STEAM_FOLDER%/steamapps/common/Skyrim
            ) else (
                echo ^[ERROR] No Skyrim installation containing Creation Kit found
                echo ^Searched for: %STEAM_FOLDER%/steamapps/common/Skyrim Special Edition/Papyrus Compiler/PapyrusCompiler.exe
                echo ^Searched for: %STEAM_FOLDER%/steamapps/common/Skyrim/Papyrus Compiler/PapyrusCompiler.exe
                goto :error
            )
        )
    )
)


GOTO :done

        @REM set SKYRIM_FOLDER=
@REM set SKYRIM_FOLDER=%STEAM_FOLDER%/steamapps/common/Skyrim Special Edition

:error
exit /b 1
pause

:done
