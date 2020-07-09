# linux-setup-tool

**Author:** Martin Bauernschmitt

**License:** BSD 3-clause


In this repository a simple shell script is used, which rebuilds my development environment on newly installed Linux systems. It installs and configures all basic tools I need for working and developing.

## Overview

A short overview what will be installed and configured. If you want further details look inside the `install.sh` file:

- General: Zsh (with oh-my-zsh and config from data/.zshrc), curl, wget, nano
- Security: scdaemon, pcscd, pcsc-tools
- Build: build-essential, git, cmake, libsocketcan-dev, can-utils, clang-10, clang-format-10, clang-tidy-10, clangd-10
- IDEs: VSCode + VSCode Extensions

## Usage

The script is kept very simple so that it can be easily customized. There are no complicated queries except for a yes/no query before installation.
Three things should be adjusted before use:
- In the `install.sh` file, the name and email address must be set, as this is used to configure GIT
- In the Data folder I have an encrypted 7-zip file named `gnupg.7z`. Here is my .gnupg folder, which will be decrypted and copied during the installation. Either do the same or comment out the code line.
- Check if the `install.sh` script is executable

Change your credentials in the script:

```bash
#!/bin/bash

# -- Settings --
NAME='Max Mustermann'
E_MAIL='max.mustermann@mustermail.de'
```

In the next listing you see the script installing the GPG-keys
from the encrypted directory. Deactivate this section via '#' in
front of every line if you dont want to use this feature.

```bash
echo ""
echo "------------------------------------------------------------"
echo "Config gpg"
echo "------------------------------------------------------------"
echo ""

echo "--> Execute GPG to create .gnupg folder"
runuser $SUDO_USER -c "gpg --list-keys"

echo "--> Copying gpg smartcard data"
echo "--> !! PASSWORD NEEDED to continue !!"
runuser $SUDO_USER -c "7za x data/gnupg.7z -odata/"
runuser $SUDO_USER -c "cp -r data/gnupg/* ~/.gnupg/"

echo "--> List keys: "
runuser $SUDO_USER -c "gpg --list-keys"

echo ""
```


Make script executable:
```bash
sudo chmod +x $USER install.sh
```