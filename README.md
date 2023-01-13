# 🚧 Under Development 🚧

---

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
- [Project `Setup.bat`](#project-setupbat)
- [Compiling the project](#compiling-the-project)
  - [Visual Studio Code](#visual-studio-code)
  - [`Compile.bat`](#compilebat)
- [Copy mod files (_into Skyrim or mods folder_)](#copy-mod-files-into-skyrim-or-mods-folder)
  - [Visual Studio Code](#visual-studio-code-1)
  - [`Deploy.bat`](#deploybat)
- [Personalize the `.esp` Plugin File](#personalize-the-esp-plugin-file)
  - [`Personalize.bat`](#personalizebat)
- [Setup your own repository](#setup-your-own-repository)


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

The Creation Kit comes with the **Papyrus compiler** and _required_ game scripts.

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

If you are using a mod manager, it's easiest if you put this folder directly inside
of your `mods` folder.

> When you edit your `.esp` or other files, you won't have to copy those files into
> your `mods` folder manually!

In your mod manager, find the location of your `mods` folder.

### MO2

<img title="MO2 Mods folder" alt="MO2 Mods folder" src="https://raw.githubusercontent.com/SkyrimScripting/Resources/main/Screenshots/MO2/MO2SettingsModsFolder.png" height=150 />

### Vortex

<img title="Vortex Mods folder" alt="Vortex Mods folder" src="https://raw.githubusercontent.com/SkyrimScripting/Resources/main/Screenshots/Vortex/VortexSettingsModsFolder.png" height=150 />

Take this template folder and place it inside of the `mods` folder.

> For example:
> ```
> C:\<your mods folder>\Papyrus_Template_Something
> ```

Refresh (_or close and re-open_) your mod manager and this template should now show up as a "mod"!

> _Note: **Vortex** users may still need to Disable and then Enable the mod after making changes_
> _for them to become visible to the game._

# Project `Setup.bat`

To get started, run `Setup.bat` (_e.g. double-click on it from File Explorer_)

This does a few things to configure your project:
- _finds your Skyrim installation (containing Creation Kit)_
- _detects your Skyrim Creation Kit game scrtips (will prompt to extract them if necessary)_
- _configures a location to copy your mods files to, if desires (Skyrim Data folder or a mods folder)_
- _asks you for a custom name for your mod, if desired_
- _updates all required scripts with these required pieces of information_

**Nothing will work if you skip this step.**

# Compiling the project

There are two supported ways to compile this Papyrus project:

- Visual Studio Code
- `Compile.bat`

## Visual Studio Code

In [Visual Studio Code](https://code.visualstudio.com/) with the [Papyrus extension](https://marketplace.visualstudio.com/items?itemName=joelday.papyrus-lang-vscode) installed:
   > Run `Terminal` > `Run Build Task` (or `Ctrl+Shift+B`).

## `Compile.bat`

Double-click on the `Compile.bat` file in File Explorer and files will compile.

> Note: if you have [`pyro`](https://github.com/fireundubh/pyro/releases) downloaded and the containing folder added to your `PATH` environment variable, then `Compile.bat` will run your `.ppj` file(s) using `pyro`. Otherwise `Compile.bat` will run the native `PapyrusCompiler.exe`.

# Copy mod files (_into Skyrim or mods folder_)

If you did not place this template folder inside of your mods folder (_see: [Put this folder into your "Mods" folder (_Optional_)](#put-this-folder-into-your-mods-folder-optional)_), then you will need to copy mod files and compiled scripts every time that you make changes to them.

There are two supported ways to copy mods files for this Papyrus project:

- Visual Studio Code
- `Deploy.bat`

## Visual Studio Code

In [Visual Studio Code](https://code.visualstudio.com/) with the [Papyrus extension](https://marketplace.visualstudio.com/items?itemName=joelday.papyrus-lang-vscode) installed:
   > Run `Terminal` > `Run Build Task` (or `Ctrl+Shift+B`).

The `Deploy.bat` script is automatically run by Visual Studio Code after each build.

## `Deploy.bat`

Double-click on the `Deploy.bat` file in File Explorer and mod files will be copied to the destination configured by `Setup.bat`

# Personalize the `.esp` Plugin File

Most templates come with an `.esp` "_Elder Scrolls Plugin_" file.

If provided, this file defines things including:

- Editor IDs and names of any Quests (_and names of attached scripts_)
- Editor IDs and names of any Spells (_and names of attached scripts_)
- _and more_

It is **not recommended** to share the template `.esp` on sites like Nexus:

- The Editor IDs may not be unique!
- The script names may not be unique!

With Skyrim, it is _very important_ for each mod to use **unique script names**.

You can customize your `.esp` using Creation Kit, SSEEdit, or by running `Personalize.bat`.

## `Personalize.bat`

Every template with an .esp is configured so it's easy for you to personalize the `.esp` and make it your own.

Double-click on the `Personalize.bat` file in File Explorer and you will be prompted with a series of questions for what to name certain things in your mod.

Once complete, the `.esp` will be updated with your _own names_ for Quests, Spells, scripts, etc.

> Note: `Personalize.bat` uses [`bethkit`](https://www.nexusmods.com/skyrim/mods/101736?tab=files) (_also known as [Bethesda Toolkit](https://www.nexusmods.com/skyrim/mods/101736?tab=files)_) to make changes to the template `.esp`.  
> Running `Personalize.bat` will provide you with instructions on how to install `bethkit` properly.

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
