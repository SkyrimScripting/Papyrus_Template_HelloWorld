########################################################
# Needs to be set to the root of your Steam installation
$steamFolder = "C:\Program Files (x86)\Steam"
########################################################
$bat_compile_script = "Compile.bat"
$ppj_pyro_script    = "Scripts.ppj"
########################################################

$exists = Test-Path -Path $steamFolder
if (-Not $exists) {
    # Check the Registry for an alternate Steam install location
    $steamFolder = Get-ItemProperty -Path "HKCU:\SOFTWARE\Valve\Steam" -Name SteamPath -ErrorAction SilentlyContinue
    if ($steamFolder) {
        echo "STEAM PATH" $steamPath.SteamPath
    }
}

if (-Not $steamFolder) {
    echo "[ERROR] Could not find Steam folder (with Skyrim installation)"
    echo "Searched: ${steamFolder}"
    return
}

$compilerPath = "Papyrus Compiler/PapyrusCompiler.exe"

$skyrimPath = ""
$skyrimPath_SE = "${steamFolder}/steamapps/common/Skyrim Special Edition"
$skyrimPath_LE = "${steamFolder}/steamapps/common/Skyrim"

$creationKitExists_SE = Test-Path -Path "${skyrimPath_SE}/${compilerPath}"
$creationKitExists_LE = Test-Path -Path "${skyrimPath_LE}/${compilerPath}"

if ($creationKitExists_SE) {
    $skyrimPath = $skyrimPath_SE
} elseif ($creationKitExists_LE) {
    $skyrimPath= $skyrimPath_LE
} else {
    echo "[ERROR] Could not find a Skyrim installation including Creation Kit"
    echo "Searched: ${skyrimPath_SE}/${compilerPath}"
    echo "Searched: ${skyrimPath_LE}/${compilerPath}"
    return
}

# Update the compiler .bat with the correct path
echo "Updating SKYRIM_FOLDER path in ${bat_compile_script}"
$bat_content = Get-Content $bat_compile_script -Raw
$updated_bat = $bat_content -replace "set SKYRIM_FOLDER=.*", "set SKYRIM_FOLDER=${skyrimPath}"
Set-Content -Path $bat_compile_script -Value $updated_bat
echo "Updated."

# Update the .ppj Papyrus Project file with the correct path
$useScriptsSource = Test-Path -Path "${skyrimPath}\Data\Scripts\Source"
$useSourceScripts = Test-Path -Path "${skyrimPath}\Data\Source\Scripts"
echo "Updating <Import> for Skyrim Creation Kit scripts in ${ppj_pyro_script}"
$pyro_content = Get-Content $ppj_pyro_script -Raw
if ($useScriptsSource) {
    $updated_ppj = $pyro_content -replace "<Import>.*Steam.*steamapps.*common.*Data.*Scripts.*</Import>", "<Import>${skyrimPath}\Data\Scripts\Source</Import>"
} else {
    $updated_ppj = $pyro_content -replace "<Import>.*Steam.*steamapps.*common.*Data.*Scripts.*</Import>", "<Import>${skyrimPath}\Data\Source\Scripts</Import>"
}
Set-Content -Path $ppj_pyro_script -Value $updated_ppj
echo "Updated."

echo "Complete"
