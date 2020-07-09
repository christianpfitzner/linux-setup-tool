#!/bin/bash

# -- Settings --
NAME='Max Mustermann'
E_MAIL='max.mustermann@muster.de'

dialog --backtitle "$(echo abc)" --title "$(cat file)" ...


wait

# Print welcome screen

echo "************************************************************"
echo "Martins Linux Setup and Environment Congfiguration tool"
echo "------------------------------------------------------------"
echo "Author: Martin Bauernschmitt"
echo "************************************************************"
echo ""
echo "************************************************************"
echo "This script will install and config the following components:"
echo "------------------------------------------------------------"
echo "General: Zsh (with oh-my-zsh), curl, wget, nano"
echo "Security: scdaemon, pcscd, pcsc-tools"
echo "Build: build-essential, git, cmake, libsocketcan-dev, "
echo "       can-utils, clang-10, clang-format-10, clang-tidy-10, "
echo "       clangd-10"
echo "IDEs: VSCode"
echo "************************************************************"
echo ""
echo "************************************************************"
# Check for SUDO
if [ "$EUID" -ne 0 ]
  then echo "Please run program with sudo!"
  echo "Exiting..."
  echo "************************************************************"
  exit
fi

echo ""
echo "------------------------------------------------------------"
echo "Configuration is done with the following credentials:"
echo "------------------------------------------------------------"
echo ""
echo  -e "Name:  \033[4m$NAME\033[0m"
echo  -e "E-Mail:\033[4m$E_MAIL\033[0m"
echo "------------------------------------------------------------"

# Final question
while true; do
    read -p "Do you wish to install this program?" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) echo "Exiting..."; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
echo "************************************************************"
echo ""
echo ""

echo "************************************************************"
echo "Installing fancy stuff..."
echo ""

echo "------------------------------------------------------------"
echo "Update & Upgrade"
echo "------------------------------------------------------------"
apt update && apt upgrade -y
echo ""
echo ""

echo "------------------------------------------------------------"
echo "General Tools"
echo "------------------------------------------------------------"
echo "--> zsh"
echo "--> curl"
echo "--> wget"
echo "--> apt-transport-https"
echo "--> nano"
echo "--> tmux"
echo "--> p7zip-full"

apt install -y zsh curl wget apt-transport-https nano tmux p7zip-full
echo ""
echo ""

echo "------------------------------------------------------------"
echo "Security Tools"
echo "------------------------------------------------------------"
echo "--> scdaemon"
echo "--> pcscd"
echo "--> pcsc-tools"

apt install -y scdaemon pcscd pcsc-tools
echo ""
echo ""

echo "------------------------------------------------------------"
echo "Build Tools"
echo "------------------------------------------------------------"
echo "--> build-essential"
echo "--> gdb"
echo "--> cmake"
echo "--> git"
echo "--> libsocketcan-dev"
echo "--> can-utils"
echo "--> clang-10"
echo "--> clang-format-10"
echo "--> clang-tidy-10"
echo "--> clangd-10"

apt install -y build-essential gdb cmake git libsocketcan-dev can-utils \
               clang-10 clang-format-10 clang-tidy-10 clangd-10
echo ""
echo ""
echo "--> Updating clangd"
update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-10 10

echo "------------------------------------------------------------"
echo "IDEs"
echo "------------------------------------------------------------"

if grep -q Microsoft /proc/version; then
  echo "--> Skipped VSCode installation due to WSL"
else
  echo "--> Configuring VSCode Repository"
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
  sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
  echo ""
  echo ""
  echo "--> Updating sources"
  apt update
  echo ""
  echo ""
  echo "--> Installing VSCode"
  apt install -y code
fi
echo ""
echo ""
echo "************************************************************"
echo ""
echo ""

echo "************************************************************"
echo "Setup environment.."
echo ""
echo "------------------------------------------------------------"
echo "Installing & Config oh-my-zsh"
echo "------------------------------------------------------------"

echo "--> Installing oh-my-zsh"
runuser $SUDO_USER -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended"

echo "--> Config oh-my-zsh"
echo "---> Changing default shell"
chsh -s /bin/zsh $SUDO_USER

echo "---> Copying zsh config"
cp data/my_zshrc /home/$SUDO_USER/.zshrc

echo ""
echo ""

echo "------------------------------------------------------------"
echo "Installing VSCode extensions"
echo "------------------------------------------------------------"

if grep -q Microsoft /proc/version; then
  echo "--> Skipped for WSL version"
else
  echo "--> Bracket Pair Colorizer 2"
  runuser $SUDO_USER -c 'code --install-extension coenraads.bracket-pair-colorizer-2'
  echo ""

  echo "--> C/C++"
  runuser $SUDO_USER -c 'code --install-extension ms-vscode.cpptools'
  echo ""

  echo "--> CMake Language Support"
  runuser $SUDO_USER -c 'code --install-extension twxs.cmake'
  echo ""

  echo "--> Doxygen Language Support"
  runuser $SUDO_USER -c 'code --install-extension bbenoist.doxygen'
  echo ""

  echo "--> Doxygen Documentation Generator"
  runuser $SUDO_USER -c 'code --install-extension cschlosser.doxdocgen'
  echo ""

  echo "--> Git Lens "
  runuser $SUDO_USER -c 'code --install-extension eamodio.gitlens'
  echo ""

  echo "--> Markdown Preview Enhanced"
  runuser $SUDO_USER -c 'code --install-extension shd101wyy.markdown-preview-enhanced'
  echo ""

  echo "--> Project Manager"
  runuser $SUDO_USER -c 'code --install-extension alefragnani.project-manager'
  echo ""

  echo "--> Python"
  runuser $SUDO_USER -c 'code --install-extension ms-python.python'
  echo ""

  echo "--> Clangd"
  runuser $SUDO_USER -c 'code --install-extension llvm-vs-code-extensions.vscode-clangd'
  echo ""

  #echo "--> "
  #runuser $SUDO_USER -c 'code --install-extension '
fi
echo ""

echo ""
echo "------------------------------------------------------------"
echo "Config git"
echo "------------------------------------------------------------"
echo ""
echo "--> Set GIT global name to   $NAME"
runuser $SUDO_USER -c "git config --global user.name '$NAME'"
echo "--> Set GIT global e-mail to $E_MAIL"
runuser $SUDO_USER -c "git config --global user.email '$E_MAIL'"
echo ""

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

echo ""
echo "------------------------------------------------------------"
echo "Creating project folder structure"
echo "------------------------------------------------------------"
echo "--> Creating project folder: /home/$SUDO_USER/Projekte"
runuser $SUDO_USER -c 'mkdir ~/Projekte'

echo "--> Creating project folder for Evocortex: Projekte/evocortex"
runuser $SUDO_USER -c 'mkdir ~/Projekte/evocortex'

echo "--> Creating project folder for FRANCOR e.V.: Projekte/francor"
runuser $SUDO_USER -c 'mkdir ~/Projekte/francor'

echo "--> Creating project folder for own projects: Projekte/feesmrt"
runuser $SUDO_USER -c 'mkdir ~/Projekte/feesmrt'

echo "--> Downloading eclipse formatter of google code style"
runuser $SUDO_USER -c 'wget -O eclipse-cpp-google-style.xml https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-cpp-google-style.xml'
runuser $SUDO_USER -c "mv eclipse-cpp-google-style.xml ~/Projekte/"
echo ""

echo "************************************************************"
echo ""
echo ""

echo ""
echo ""
echo "************************************************************"
echo "Cleanup "
echo "************************************************************"

echo "--> Deleting packages.microsoft.gpg"
rm packages.microsoft.gpg

echo "--> Deleting gnpug folder"
rm -r data/gnupg

echo ""
echo ""

echo ""
echo ""
echo "************************************************************"
echo "Finished -> Have fun you lazy software stuff programming guy "
echo "************************************************************"
echo ""
echo ""
