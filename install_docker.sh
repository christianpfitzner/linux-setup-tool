#!/bin/bash

# -- Settings --

# Print welcome screen
echo "************************************************************"
echo "Martins Linux Setup and Environment Congfiguration tool"
echo "DOCKER Install Tool"
echo "------------------------------------------------------------"
echo "Author: Martin Bauernschmitt"
echo "************************************************************"
echo ""
echo "************************************************************"
echo "This script will install and config the following components:"
echo "------------------------------------------------------------"
echo "Docker: docker-ce, docker-compose"
echo "Docker-Images: Comming soon"
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
echo "Docker Installation"
echo "------------------------------------------------------------"
echo "--> Installing necessary tools"
apt install -y apt-transport-https ca-certificates curl software-properties-common

echo "--> Adding GPG Key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

echo "--> Adding repository"
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

echo "--> Updating"
apt update

echo "--> Installing docker"
apt install -y docker-ce docker-ce-cli containerd.io

echo "--> Adding user $SUDO_USER to docker group"
usermod -aG docker $SUDO_USER

echo ""
echo ""

echo "------------------------------------------------------------"
echo "Docker Images"
echo "------------------------------------------------------------"
echo "--> Coming soon"

echo ""
echo ""
echo "************************************************************"

echo ""
echo ""
echo "************************************************************"
echo "Finished -> Have fun dockering around "
echo "************************************************************"
echo ""
echo ""
