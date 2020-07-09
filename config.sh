#!/bin/sh
: ${DIALOG:=dialog}
case "$DIALOG" in
*dialog*)
        OPTS="$OPTS --cr-wrap"
        high=10
        ;;
*whiptail*)
        high=12
        ;;
esac
# rows=$(stty size | cut -d' ' -f1)
# [ -z "$rows" ] && rows=$high
# [ $rows -gt $high ] && rows=$high
# cols=$(stty size | cut -d' ' -f2)
# $DIALOG --backtitle "Setup of basic configuration" \
#        --title "System installation" \
#        $OPTS \
#        --yesno '\nIn order to install this package, you must accept the license terms, the "Operating System Distributor License for Java" (DLJ), v1.1. Not accepting will cancel the installation.\n\nDo you accept the DLJ license terms?' $rows $((cols - 5))
# # 0=ja; 1=nein
# clear
# echo "$?"


# # Demonstriert dialog --inputbox
# # Name : dialog4
# name=`dialog --inputbox "Wie heißen Sie?" 0 0 "" \
#  3>&1 1>&2 2>&3`
# # Dialog-Bildschirm löschen
# dialog --clear
# dialog --msgbox "Hallo $name, Willkommen bei $HOST!" 5 50
# # Bildschirm löschen
# clear

# # Demonstriert dialog --inputbox
# # Name : dialog4
# email=`dialog --inputbox "Wie ist Ihre E-Mailadresse?" 0 0 "" \
#  3>&1 1>&2 2>&3`
# # Dialog-Bildschirm löschen
# dialog --clear
# dialog --msgbox "Hallo $email, Willkommen bei $HOST!" 5 50
# # Bildschirm löschen
# clear

