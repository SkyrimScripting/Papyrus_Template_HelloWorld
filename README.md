> 📜 other templates available at https://github.com/SkyrimScripting/Papyrus_Templates

# Papyrus "Hello, world!"

The simplest possible Papyrus plugin for Skyrim.

- [Papyrus "Hello, world!"](#papyrus-hello-world)
- [What does it do?](#what-does-it-do)
- [Requirements](#requirements)
  - [Skyrim (from Steam)](#skyrim-from-steam)
  - [Skyrim Creation Kit (from Steam)](#skyrim-creation-kit-from-steam)
    - [Installing Creation Kit](#installing-creation-kit)
  - [Visual Studio Code (_optional_)](#visual-studio-code-optional)
- [Download the template](#download-the-template)
  - [Put this folder into your "Mods" folder (_Optional_)](#put-this-folder-into-your-mods-folder-optional)
    - [MO2](#mo2)
    - [Vortex](#vortex)
- [Project setup](#project-setup)
  - [`Setup.bat` Setup Script](#setupbat-setup-script)
- [Updating Docs Below Here Still :)](#updating-docs-below-here-still-)
    - [Doing it manually](#doing-it-manually)
  - [Compiling the project](#compiling-the-project)
    - [Visual Studio Code (_Recommended_)](#visual-studio-code-recommended)
    - [`Compile.bat`](#compilebat)
- [Customize the `.esp` Plugin File](#customize-the-esp-plugin-file)
  - [Creation Kit](#creation-kit)
  - [`GeneratePlugin.ps1`](#generatepluginps1)
- [Setup your own repository](#setup-your-own-repository)
- [Clean This Stuff Up](#clean-this-stuff-up)
  - [(_Alternate_) Automatically copy files into your "Mods" folder](#alternate-automatically-copy-files-into-your-mods-folder)
    - [`Scripts.ppj`](#scriptsppj)
    - [Copying Files](#copying-files)
      - [Visual Studio Code](#visual-studio-code)
      - [Pyro](#pyro)


# What does it do?

As soon as you begin a game or load an existing game, it pops up a "Hello, world!" message.

<img title="Hello, Papyrus!" alt="Hello, Papyrus!" src="https://raw.githubusercontent.com/SkyrimScripting/Resources/main/Screenshots/Papyrus/HelloPapyrus.png" height=200 />

# Requirements

## Skyrim (from Steam)

[The Elder Scrolls V: Skyrim Special Edition](https://store.steampowered.com/app/489830/The_Elder_Scrolls_V_Skyrim_Special_Edition/) from **Steam**.

_\-or-_

[The Elder Scrolls V: Skyrim](https://store.steampowered.com/app/72850/The_Elder_Scrolls_V_Skyrim/) from **Steam**.

## Skyrim Creation Kit (from Steam)

You need to install the [Bethesda Skyrim Creation Kit](https://store.steampowered.com/app/1946180/Skyrim_Special_Edition_Creation_Kit/) to author Papyrus scripts.

### Installing Creation Kit

The Creation Kit comes with the **Papyrus compiler** and _required_ [game scripts](#install-creation-kit-papyrus-scripts).

If you have either Skyrim, Skyrim Special Edition, or Skyrim Anniversary Edition, then the **Creation Kit** will be available in **Steam**.

[Skyrim Special Edition: Creation Kit](https://store.steampowered.com/app/1946180/Skyrim_Special_Edition_Creation_Kit/) appears under **`Software`** if you have [Skyrim Special Edition](https://store.steampowered.com/app/489830/The_Elder_Scrolls_V_Skyrim_Special_Edition/) (_or "[Skyrim Anniverary Edition](https://store.steampowered.com/sub/626153/)"_)  :

> <img title="Skyrim Special Edition: Creation Kit" alt="Skyrim Special Edition: Creation Kit" src="https://raw.githubusercontent.com/SkyrimScripting/Resources/main/Screenshots/Stream/SkyrimCreationKitSE.png" height=150 />

If you have the old [The Elder Scrolls V: Skyrim](https://store.steampowered.com/app/72850/The_Elder_Scrolls_V_Skyrim/) (_"Legendary Edition"_) of Skyrim on Steam, Creation Kit appears under **`Tools`**:

<img title="Skyrim Creation Kit" alt="Skyrim Creation Kit" src="https://raw.githubusercontent.com/SkyrimScripting/Resources/main/Screenshots/Stream/SkyrimCreationKitLE.png" height=120 />

## Visual Studio Code (_optional_)

Optional but *Highly Recommended*
- [Visual Studio Code](https://code.visualstudio.com/) with the [Papyrus extension](https://marketplace.visualstudio.com/items?itemName=joelday.papyrus-lang-vscode) installed

# Download the template

- (**Recommended**) Download this repository using [`git`](https://git-scm.com/)
  - If you are new to `git`, please use [GitHub Desktop](https://desktop.github.com/). It's very easy.
    > Under the "**Code**" button, choose "**Open with GitHub Desktop**"  
    > ![Code](https://raw.githubusercontent.com/SkyrimScripting/Resources/main/Screenshots/GitHub/CodeButton.png)  
    > ![Open with GitHub Desktop](https://raw.githubusercontent.com/SkyrimScripting/Resources/main/Screenshots/GitHub/OpenWithGitHubDesktop.png)
- (**Alternate**) Download this repository as a `.zip`
  > Under the "**Code**" button, choose "**Download Zip**"  
  > ![Code](https://raw.githubusercontent.com/SkyrimScripting/Resources/main/Screenshots/GitHub/CodeButton.png)  
  > ![Download Zip](https://raw.githubusercontent.com/SkyrimScripting/Resources/main/Screenshots/GitHub/DownloadZip.png)

## Put this folder into your "Mods" folder (_Optional_)

> **Required:** [Mod Organizer 2](https://www.nexusmods.com/skyrimspecialedition/mods/6194?tab=files) or [Vortex](https://www.nexusmods.com/about/vortex/)

If you are using a mod manager, it's easiest if you put this folder directly inside
of your `mods` folder.

> When you edit your `.esp` or other files, you won't have to copy those files into
> your `mods` folder manually!

In your mod manager, find the location of your `mods` folder.

### MO2

<img title="MO2 Mods folder" alt="MO2 Mods folder" src="https://raw.githubusercontent.com/SkyrimScripting/Resources/main/Screenshots/MO2/MO2SettingsModsFolder.png" height=150 />

### Vortex

<img title="Vortex Mods folder" alt="Vortex Mods folder" src="https://raw.githubusercontent.com/SkyrimScripting/Resources/main/Screenshots/Vortex/VortexSettingsModsFolder.png" height=150 />

Take this template and place it inside of the `mods` folder.

Refresh (_or close and re-open_) your mod manager and this template should now show up as a "mod"!

> _Note: Vortex users may still need to Disable and then Enable the mod after making changes_
> _for them to become visible to the game._




# Project setup

The project is configured, by default, for users who have Skyrim installed at:

```
C:\Program Files (x86)\Steam\steamapps\common\Skyrim
or
C:\Program Files (x86)\Steam\steamapps\common\Skyrim Special Edition
```

## `Setup.bat` Setup Script

After installing ...

---

# Updating Docs Below Here Still :)

---

`Init.ps1` finds your Steam installation automatically  and updates all files with the correct Skyrim folder path.

### Doing it manually

`Init.ps1` simply:
- Updates `set SKYRIM_FOLDER=[Skyrim path]` in `Compile.bat`
- Updates `<Import>[Skyrim Path]/Data/Source/Scripts</Import>`

> Note: `Init.ps1` also determines whether your Creation Kit game scripts were extracted from `Scripts.zip` or `scripts.rar` into either the `Data\Source\Scripts` or `Data\Scripts\Source` folders and chooses the correct one automatically.

## Compiling the project

There are two supported ways to compile this Papyrus project:

- Visual Studio Code (_Recommended_)
- `Compile.bat`

### Visual Studio Code (_Recommended_)

In [Visual Studio Code](https://code.visualstudio.com/) with the [Papyrus extension](https://marketplace.visualstudio.com/items?itemName=joelday.papyrus-lang-vscode) installed:
   > Run `Terminal` > `Run Build Task` (or `Ctrl+Shift+B`).

### `Compile.bat`

Double-click on the file from Explorer and files will compile.

> This script will automatically detect `Scripts.zip` and extract it, if found.  
> It also finds your Steam installation automatically), like `Init.ps1`.

# Customize the `.esp` Plugin File

Each template comes with an `.esp` "Elder Scrolls Plugin" file.

This file is loaded by Skyrim and used to run your scripts.

If you want to customize the `.esp` file:

Open it in **Creation Kit**

_\-or-_

Customize it with **`GeneratePlugin.ps1`**

## Creation Kit

- Open Creation Kit
- Select the `.esp`

## `GeneratePlugin.ps1`

# Setup your own repository

If you clone this template on GitHub, please:

- Go into `LICENSE` and change the year and change `<YOUR NAME HERE>` to your name.
- Go into `CODE_OF_CONDUCT.md` and change `<YOUR CONTACT INFO HERE>` to your contact information.

It's good to have a `Code of Conduct` and GitHub will show your project's `CODE_OF_CONDUCT.md` in the project sidebar.

If you'd like to know more about open source licenses, see:
- [Licensing a repository](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository)
- [Choose an open source license](https://choosealicense.com/)

**If you use this template, PLEASE release your project as a public open source project.** 💖

**PLEASE DO NOT RELEASE YOUR SKSE PLUGIN ON NEXUS/ETC WITHOUT MAKING THE SOURCE CODE AVAILABLE**

# Clean This Stuff Up

## (_Alternate_) Automatically copy files into your "Mods" folder

> **Required:**  
> [Visual Studio Code](https://code.visualstudio.com/) with the [Papyrus extension](https://marketplace.visualstudio.com/items?itemName=joelday.papyrus-lang-vscode) installed  
> or  
> [`pyro`](https://github.com/fireundubh/pyro/releases) installed and added to your `PATH`

If you **do not** want to place the template folder directly into your `mods` folder, that's okay too.

This template is configured with an option to copy all of the scripts and other important files (_e.g. `.esp` or `.bsa` for templates containing those file types_).

The option must be enabled in the `Scripts.ppj` file:

### `Scripts.ppj`

By default, the option to copy files is disabled (by `UseInBuild="false"`)

```xml
<Variables>
    <Variable Name="ModName" Value="HelloPapyrus" />
    <Variable Name="OutputFolder" Value="%SKYRIM_MODS_FOLDER%/@ModName" />
</Variables>
<PostBuildEvent Description="Copy the mod files into a folder" UseInBuild="false">
```

To enable copying files to your Mods folder, set `UseInBuild="true"`

### Copying Files

To "run" the `Scripts.ppj` file and deploy these scripts, you need either:

 - [Visual Studio Code](https://code.visualstudio.com/) with the [Papyrus extension](https://marketplace.visualstudio.com/items?itemName=joelday.papyrus-lang-vscode) installed  
or  
 - [`pyro`](https://github.com/fireundubh/pyro/releases) installed and added to your `PATH`

#### Visual Studio Code

With Visual Studio Code, run `Terminal` > `Run Build Task` (or `Ctrl+Shift+B`).

#### Pyro

With `pyro` installed (_and in your `PATH`_), run `Compile.bat`
