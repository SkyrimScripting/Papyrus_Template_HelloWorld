> 📜 other templates available at https://github.com/SkyrimScripting/Papyrus_Templates

# Papyrus "Hello, world!"

- [Papyrus "Hello, world!"](#papyrus-hello-world)
- [What does it do?](#what-does-it-do)
- [Requirements](#requirements)
  - [Optional but *Highly Recommended*](#optional-but-highly-recommended)
- [Creation Kit](#creation-kit)
  - [Install Creation Kit Papyrus Scripts](#install-creation-kit-papyrus-scripts)
- [Project setup](#project-setup)
    - [Doing it manually](#doing-it-manually)
- [Compiling the project](#compiling-the-project)
  - [Setup your own repository](#setup-your-own-repository)


---

The simplest possible Papyrus plugin for Skyrim.

# What does it do?

As soon as you begin a game or load an existing game, it pops up a "Hello, world!" message.

<img title="Hello, Papyrus!" alt="Hello, Papyrus!" src="https://raw.githubusercontent.com/SkyrimScripting/Resources/main/Screenshots/Papyrus/HelloPapyrus.png" height=200 />

# Requirements

- [Skyrim Special Edition: Creation Kit](https://store.steampowered.com/app/1946180/Skyrim_Special_Edition_Creation_Kit/) from Steam  

## Optional but *Highly Recommended*
- [Visual Studio Code](https://code.visualstudio.com/) with the [Papyrus extension](https://marketplace.visualstudio.com/items?itemName=joelday.papyrus-lang-vscode) installed

# Creation Kit

You need to install the Bethesda Skyrim Creation Kit to write Papyrus scripts.

The Creation Kit comes with the Papyrus compiler and required [game scripts](#install-creation-kit-papyrus-scripts).

> **Creation Kit** requires [Skyrim Special Edition](https://store.steampowered.com/app/489830/The_Elder_Scrolls_V_Skyrim_Special_Edition/) (_or "[Skyrim Anniverary Edition](https://store.steampowered.com/sub/626153/)"_)  
> It is currently (2022) only distributed via Steam (_e.g. not available via GOG_)
> It can be found in your Steam library under "**Software**"

<img title="Skyrim Special Edition: Creation Kit" alt="Skyrim Special Edition: Creation Kit" src="https://raw.githubusercontent.com/SkyrimScripting/Resources/main/Screenshots/Stream/SkyrimCreationKitSE.png" height=100 />

> If you have the old [The Elder Scrolls V: Skyrim](https://store.steampowered.com/app/72850/The_Elder_Scrolls_V_Skyrim/) "Legendary Edition" of Skyrim on Steam,  
> you should have access to the classic edition of Creation Kit under "**Tools**"

<img title="Skyrim Creation Kit" alt="Skyrim Creation Kit" src="https://raw.githubusercontent.com/SkyrimScripting/Resources/main/Screenshots/Stream/SkyrimCreationKitLE.png" height=100 />

## Install Creation Kit Papyrus Scripts

After you have installed Creation Kit, launch it _once_.

It will prompt you to unpack a `Scripts.zip` file. Say "Yes" to unpack the zip.

<img title="Unpack Scripts.zip" alt="Unpack Scripts.zip" src="https://raw.githubusercontent.com/SkyrimScripting/Resources/main/Screenshots/CreationKit/CreationKitUnpackScriptsZip.png" height=150 />

> Note: "Legendary Edition" Creation Kit will not prompt you.  
> To unpack, manually extract `<Skyrim folder>\Data\scripts.rar`  
> (_you can extract .rar files using [7-zip](https://www.7-zip.org/)_)

...

# Project setup

The project is configured, by default, for users who have Skyrim installed at:

```
C:\Program Files (x86)\Steam\steamapps\common\Skyrim
or
C:\Program Files (x86)\Steam\steamapps\common\Skyrim Special Edition
```

If you have Skyrim installed to a different location, run the `Init.ps1` script.

<img title="Run Init.ps1 with Powershell" alt="Run Init.ps1 with PowerShell" src="https://raw.githubusercontent.com/SkyrimScripting/Resources/main/Screenshots/Papyrus/InitPs1.png" height=200>

`Init.ps1` finds your Steam installation automatically and updates all files with the correct Skyrim folder path.

### Doing it manually

`Init.ps1` simply:
- Updates `set SKYRIM_FOLDER=[Skyrim path]` in `Compile.bat`
- Updates `<Import>[Skyrim Path]/Data/Source/Scripts</Import>`

> Note: `Init.ps1` also determines whether your Creation Kit game scripts were extracted from `Scripts.zip` or `scripts.rar` into either the `Data\Source\Scripts` or `Data\Scripts\Source` folders and chooses the correct one automatically.

# Compiling the project

There are two supported ways to compile this Papyrus project:

1. (**Recommended**) In [Visual Studio Code](https://code.visualstudio.com/) with the [Papyrus extension](https://marketplace.visualstudio.com/items?itemName=joelday.papyrus-lang-vscode) installed:
   > Run `Terminal` > `Run Build Task` (or `Ctrl+Shift+B`). You're done, it "just works".
2. Run the `Compile.bat`
   > Simply double-click on the file from Explorer and files will compile.

## Setup your own repository

If you clone this template on GitHub, please:

- Go into `LICENSE` and change the year and change `<YOUR NAME HERE>` to your name.
- Go into `CODE_OF_CONDUCT.md` and change `<YOUR CONTACT INFO HERE>` to your contact information.

It's good to have a `Code of Conduct` and GitHub will show your project's `CODE_OF_CONDUCT.md` in the project sidebar.

If you'd like to know more about open source licenses, see:
- [Licensing a repository](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository)
- [Choose an open source license](https://choosealicense.com/)

**If you use this template, PLEASE release your project as a public open source project.** 💖

**PLEASE DO NOT RELEASE YOUR SKSE PLUGIN ON NEXUS/ETC WITHOUT MAKING THE SOURCE CODE AVAILABLE**
