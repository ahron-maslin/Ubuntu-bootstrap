#!/bin/bash


# Define colors...
RED=`tput bold && tput setaf 1`
GREEN=`tput bold && tput setaf 2`
YELLOW=`tput bold && tput setaf 3`
BLUE=`tput bold && tput setaf 4`
NC=`tput sgr0`

function RED(){
	echo -e "\n${RED}${1}${NC}"
}
function GREEN(){
	echo -e "\n${GREEN}${1}${NC}"
}
function YELLOW(){
	echo -e "\n${YELLOW}${1}${NC}"
}
function BLUE(){
	echo -e "\n${BLUE}${1}${NC}"
}

# Testing if root...
if [ $UID -ne 0 ]
then
	RED "You must run this script as root!" && echo
	exit
fi


#general update
BLUE "Updating and upgrading everything..."
sudo apt update -y && sudo apt upgrade -y

#set init to 3
YELLOW "Should I set init to multi-user.target? (Yy/Nn)"
read init_set
case $init_set in 
    y|Y)
        BLUE "Setting default target to command line"
        sudo systemctl set-default multi-user.target
        GREEN "Checking init status...(should be multi-user.target)"
        systemctl get-default;;
    n|N|*)
        BLUE "Not changing any defaults";;

esac
#create ros script and chmod it
touch ~/ros.sh
cat > ~/ros.sh << EOF
#!/bin/bash
sudo apt update -y
sudo apt upgrade -y 
sudo apt autoremove -y
EOF
chmod 700 ros.sh

BLUE "Removing boilerplate home directories..."
rmdir ~/Documents ~/Downloads ~/Music ~/Pictures ~/Public ~/Templates ~/Videos

#verify or download git, python3, pip, genact, tmux, ltrace, strace, ifconfig
BLUE "Installing packages..."
sudo apt-get install --no-upgrade git python3 tmux ltrace strace net-tools mplayer ranger guake terminator -y


BLUE "Configuring Gnome Dock"
gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop']"

BLUE "Done!"
exit

