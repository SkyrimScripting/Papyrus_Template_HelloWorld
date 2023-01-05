@echo off

:: (Optional)
:: Uncomment the following line to set the full path to your Skyrim installation
:: set SKYRIM_FOLDER="C:\Program Files (x86)\Steam\steamapps\common\Skyrim Special Edition"
@REM set SKYRIM_FOLDER=C:\Steam\steamapps\common\Skyrim Special Edition

:: ( If not provided, the SKYRIM_FOLDER is detected automatically )
:: ( Note: if you set this value, you do NOT use 'single' or "double" quotes )

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: [Init.bat] - Initialize Papyrus project@
::
:: Gets the path to your Skyrim folder and updates it in:
:: - <project root>/Compile.bat
:: - <project root>/Scripts.ppj
:: - <project root>/.vscode/tasks.json
::
:: Compile.bat offers a simple way to compile Papyrus scripts without an editor
::
:: Scripts.ppj is the "Papyrus project file" used for building
:: the project using Visual Studio Code or directly using `pyro`
::
:: .vscode/tasks.json configures the path to the Skyrim Papyrus compiler
:: used by `pyro`, when run via Visual Studio Code build task
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set PPJ=Scripts.ppj
set COMPILE_BAT=Compile.bat
set TASKS_JSON=.vscode/tasks.json

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Init.bat script code below
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Just while testing:
cls
::::::::::::::::::::::

if not "%SKYRIM_FOLDER%" == "" (
    if not exist "%SKYRIM_FOLDER%/Papyrus Compiler/PapyrusCompiler.exe" (
        echo ^[ERROR] Provided SKYRIM_FOLDER is missing Creation Kit
        echo ^SKYRIM_FOLDER: "%SKYRIM_FOLDER%"
        echo ^Searched for: "%SKYRIM_FOLDER%/Papyrus Compiler/PapyrusCompiler.exe"
        GOTO :error
    ) else (
        echo ^[FOUND] Skyrim with Creation Kit: "%SKYRIM_FOLDER%"
    )
)

:: If SKYRIM_FOLDER isn't manually configured above, this discovers
:: your Steam installation folder from the Windows registry
set STEAM_FOLDER=
if "%SKYRIM_FOLDER%" == "" (
    echo ^... Searching for SKYRIM_FOLDER ...
    echo ^... Checking Registry item SteamPath at HKCU\SOFTWARE\Valve\Steam ...
    for /F "tokens=2* skip=2" %%a in ('reg query "HKCU\SOFTWARE\Valve\Steam" /v "SteamPath"') do set STEAM_FOLDER=%%b
)
if "%SKYRIM_FOLDER%" == "" (
    if [%STEAM_FOLDER%] == [] (
        echo ^[ERROR] STEAM_FOLDER not found from registry
        echo ^Please open Init.bat and set the SKYRIM_FOLDER variable
        echo ^Then you can run this script again
        GOTO :error
    ) else (
        if exist "%STEAM_FOLDER%/steamapps/common/Skyrim Special Edition/Papyrus Compiler/PapyrusCompiler.exe" (
            set SKYRIM_FOLDER=%STEAM_FOLDER%/steamapps/common/Skyrim Special Edition
            echo ^[FOUND] Skyrim SE with Creation Kit: %STEAM_FOLDER%/steamapps/common/Skyrim Special Edition
        ) else (
            if exist "%STEAM_FOLDER%/steamapps/common/Skyrim/Papyrus Compiler/PapyrusCompiler.exe" (
                set SKYRIM_FOLDER=%STEAM_FOLDER%/steamapps/common/Skyrim
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

echo Updating "%PPJ%"
powershell -Command "$content = Get-Content -Raw '%PPJ%'; $content = $content -replace '<Variable Name=\"SkyrimFolder\" Value=\"(.*)\" />', '<Variable Name=\"SkyrimFolder\" Value=\"%SKYRIM_FOLDER%\" />'; Set-Content '%PPJ%' $content"

echo Updating "%COMPILE_BAT%"
powershell -Command "$content = Get-Content -Raw '%COMPILE_BAT%'; $content = $content -replace 'set SKYRIM_FOLDER=.*', 'set SKYRIM_FOLDER=%SKYRIM_FOLDER%'; Set-Content '%COMPILE_BAT%' $content"

echo Updating "%TASKS_JSON%"
powershell -Command "$path = '%SKYRIM_FOLDER%'; $path = $path -replace '/', '//'; $content = Get-Content -Raw '%TASKS_JSON%'; $content = $content -replace '\"gamePath\": \".*\",', ('\"gamePath\": \"' + $path + '\",'); Set-Content '%TASKS_JSON%' $content"

echo ^Done!
GOTO :done

:error
exit /b 1
pause

:done
