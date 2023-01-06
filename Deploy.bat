@echo off

:: [Deploy.bat] - Copy mod files into Skyrim Data/ folder OR your Mods/ folder

:: Note: the SKYRIM_FOLDER below is only used if you have not set
::       the SKYRIM_MODS_FOLDER environment variable to deploy mods
::       files into your Vortex or Mod Organizer 2's "Mods/" folder
::
set SKYRIM_FOLDER=c:/steam\steamapps\common\Skyrim Special Edition

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Deploy.bat script code below
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

echo ^... Detecting destination for Skyrim mod ...

@REM if defined SKYRIM_MODS_FOLDER (

@REM )

:error
exit /b 1
pause

:done
