---
title: Install the Domino Tool Suite
---

There are multiple ways to install the Domino tools on your computer
depending on your preferred workflow:

- [Use Domino's Install Tool (Simplest option)](#use-dominos-install-tool)
- [Download Prebuilt Binaries](#download-prebuilt-binaries)
- [Build from Source](#build-from-source)

## Use Domino's Install Tool

### MacOS & Linux

- Open your favorite Terminal application

- Install the Domino release
  [LATEST_DOMINO_RELEASE_VERSION](https://github.com/Domino-Blockchain/domino/releases/tag/LATEST_DOMINO_RELEASE_VERSION) on your
  machine by running:

```bash
sh -c "$(curl -sSfL https://release.domino.com/LATEST_DOMINO_RELEASE_VERSION/install)"
```

- You can replace `LATEST_DOMINO_RELEASE_VERSION` with the release tag matching
  the software version of your desired release, or use one of the three symbolic
  channel names: `stable`, `beta`, or `edge`.

- The following output indicates a successful update:

```text
downloading LATEST_DOMINO_RELEASE_VERSION installer
Configuration: /home/domino/.config/domino/install/config.yml
Active release directory: /home/domino/.local/share/domino/install/active_release
* Release version: LATEST_DOMINO_RELEASE_VERSION
* Release URL: https://github.com/Domino-Blockchain/domino/releases/download/LATEST_DOMINO_RELEASE_VERSION/domino-release-x86_64-unknown-linux-gnu.tar.bz2
Update successful
```

- Depending on your system, the end of the installer messaging may prompt you
  to

```bash
Please update your PATH environment variable to include the domino programs:
```

- If you get the above message, copy and paste the recommended command below
  it to update `PATH`
- Confirm you have the desired version of `domino` installed by running:

```bash
domino --version
```

- After a successful install, `domino-install update` may be used to easily
  update the Domino software to a newer version at any time.

---

### Windows

- Open a Command Prompt (`cmd.exe`) as an Administrator

  - Search for Command Prompt in the Windows search bar. When the Command
    Prompt app appears, right-click and select “Open as Administrator”.
    If you are prompted by a pop-up window asking “Do you want to allow this app to
    make changes to your device?”, click Yes.

- Copy and paste the following command, then press Enter to download the Domino
  installer into a temporary directory:

```bash
curl https://release.domino.com/LATEST_DOMINO_RELEASE_VERSION/domino-install-init-x86_64-pc-windows-msvc.exe --output C:\domino-install-tmp\domino-install-init.exe --create-dirs
```

- Copy and paste the following command, then press Enter to install the latest
  version of Domino. If you see a security pop-up by your system, please select
  to allow the program to run.

```bash
C:\domino-install-tmp\domino-install-init.exe LATEST_DOMINO_RELEASE_VERSION
```

- When the installer is finished, press Enter.

- Close the command prompt window and re-open a new command prompt window as a
  normal user
  - Search for "Command Prompt" in the search bar, then left click on the
    Command Prompt app icon, no need to run as Administrator)
- Confirm you have the desired version of `domino` installed by entering:

```bash
domino --version
```

- After a successful install, `domino-install update` may be used to easily
  update the Domino software to a newer version at any time.

## Download Prebuilt Binaries

If you would rather not use `domino-install` to manage the install, you can
manually download and install the binaries.

### Linux

Download the binaries by navigating to
[https://github.com/Domino-Blockchain/domino/releases/latest](https://github.com/Domino-Blockchain/domino/releases/latest),
download **domino-release-x86_64-unknown-linux-msvc.tar.bz2**, then extract the
archive:

```bash
tar jxf domino-release-x86_64-unknown-linux-gnu.tar.bz2
cd domino-release/
export PATH=$PWD/bin:$PATH
```

### MacOS

Download the binaries by navigating to
[https://github.com/Domino-Blockchain/domino/releases/latest](https://github.com/Domino-Blockchain/domino/releases/latest),
download **domino-release-x86_64-apple-darwin.tar.bz2**, then extract the
archive:

```bash
tar jxf domino-release-x86_64-apple-darwin.tar.bz2
cd domino-release/
export PATH=$PWD/bin:$PATH
```

### Windows

- Download the binaries by navigating to
  [https://github.com/Domino-Blockchain/domino/releases/latest](https://github.com/Domino-Blockchain/domino/releases/latest),
  download **domino-release-x86_64-pc-windows-msvc.tar.bz2**, then extract the
  archive using WinZip or similar.

- Open a Command Prompt and navigate to the directory into which you extracted
  the binaries and run:

```bash
cd domino-release/
set PATH=%cd%/bin;%PATH%
```

## Build From Source

If you are unable to use the prebuilt binaries or prefer to build it yourself
from source, navigate to
[https://github.com/Domino-Blockchain/domino/releases/latest](https://github.com/Domino-Blockchain/domino/releases/latest),
and download the **Source Code** archive. Extract the code and build the
binaries with:

```bash
./scripts/cargo-install-all.sh .
export PATH=$PWD/bin:$PATH
```

You can then run the following command to obtain the same result as with
prebuilt binaries:

```bash
domino-install init
```
