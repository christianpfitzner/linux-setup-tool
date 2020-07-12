#!/bin/sh



# Check for SUDO
if [ "$EUID" -ne 0 ]
  then echo "Please run program with sudo!"
  echo "Exiting..."
  echo "************************************************************"
  exit
fi



# install the basic dependencies for the here defined script
apt install -y dialog



radio_selection=`dialog --radiolist "Which tools should be installed?" 0 0 4  \
  General "" off\
  Programming "" off\
  Robotics "" off\
  Latex "" off 3>&1 1>&2 2>&3`
dialog --clear
clear
echo "You have selected $radio_selection".



case $radio_selection in
     General)
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
        ;;
     Programming)
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
        
        


        rows=$(stty size | cut -d' ' -f1)
        [ -z "$rows" ] && rows=$high
        [ $rows -gt $high ] && rows=$high
        cols=$(stty size | cut -d' ' -f2)
        $DIALOG --backtitle "Setup of basic configuration" \
               --title "System installation" \
               $OPTS \
               --yesno '\nIn order to install this package, you must accept the license terms, the "Operating System Distributor License for Java" (DLJ), v1.1. Not accepting will cancel the installation.\n\nDo you accept the DLJ license terms?' $rows $((cols - 5))
        # 0=ja; 1=nein
        clear
        echo "$?"



        name=`dialog --inputbox "What is your name?" 0 0 "" \
         3>&1 1>&2 2>&3`
        # Dialog-Bildschirm löschen
        dialog --clear
        dialog --msgbox "Hallo $name, Willkommen bei $HOST!" 5 50
        # Bildschirm löschen
        clear

        email=`dialog --inputbox "What is your e-Mail adress" 0 0 "" \
         3>&1 1>&2 2>&3`
        # Dialog-Bildschirm löschen
        dialog --clear
        dialog --msgbox "The e-Mail $email is used to configure git!" 5 50
        # Bildschirm löschen
        clear
        
        echo "------------------------------------------------------------"
        echo "Config git"
        echo "------------------------------------------------------------"
        echo ""
        echo "--> Set GIT global name to   $name"
        runuser $SUDO_USER -c "git config --global user.name '$name'"
        echo "--> Set GIT global e-mail to $E_MAIL"
        runuser $SUDO_USER -c "git config --global user.email '$E_MAIL'"
        echo ""
        ;;

     Robotics)
          echo "Very funny..."
          ;; 
     Latex)
          echo "Very funny..."
          ;; 
     *)
          echo "Hmm, seems i've never used it."
          ;;
esac

echo ""
echo ""

echo ""
echo ""
echo "************************************************************"
echo "Finished -> Have fun you lazy software stuff programming guy "
echo "************************************************************"
echo ""
echo "" 
