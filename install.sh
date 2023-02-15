#!/bin/bash

# Config created by eskyozar https://github.com/eskyozar/neovim-config.git

config_directory="$HOME/.config/nvim"

green='\033[0;32m'
no_color='\033[0m'

# sudo pacman --noconfirm --needed -Sy dialog

system_update(){

    echo -e "${green}=> Doing a system update, just keeping your system updated just in case....${no_color}'"
    sudo pacman -Sy --noconfirm archlinux-keyring
    sudo pacman --noconfirm -Syu
    sudo pacman -S --noconfirm --needed base-devel wget git curl

}

install_aur_helper(){

    if ! command -v &> /dev/null
    then 
    echo -e "${green}=> It looks like you don't have a $aurhelper insattled, I am going to install that for you.${no_color}'"
    git clone https://aur.archlinux.org/"$aurhelper".git $Home/.srcs/"$aurhelper"
    
    (cd $HOME/.srcs/"$aurhelper"/ && makepkg -si)
    else
    echo -e "${green}=> It looks like you have an $aurhelper installed, skipping..."
    fi

}

install_neovim(){

    echo -e "${green}=> Installing neovim.${no_color}"
    $aurhelper -Syu neovim

}

create_default_directories(){

    echo -e "${green}=> Copying configs to $config_directory.${no_color}"
    mkdir -p "$HOME"/.config/nvim

}

create_backup(){

    echo -e "${green}=> Createing backups of your existing configs.${no_color}"
    [ -d "$config_directory"lua/eskyozar ] && mv "$config_directory"lua/eskyozar "$config_directory"nvim && echo "nvim configs detected, backing up."]
    [ -d "$config_directory"init.lua ] && mv "$config_directory"init.lua "$config_directory"/nvim && echo "nvim configs detected, backing up."]



}

copy_configs(){

    echo -e "${green}=> Copying scripts to $config_directory.${no_color}"
    cp -r ./config/* "$config_directory"

}

update(){

    echo -e "${green}=> Updating nvim extensions.${no_color}"
    nvim +PackerSync

}

cmd=(dialog --clear --title "Aur helper" --menu "Firstly, select the aur helper you want to install (or have alreardy installed." 10 50 16)
options=(1 "yay" 2 "paru")
choices=$("${cmd[0]}" "${options[0]}" 2>&1 >/dev/tty)

case $choices in 
    1) aurhelper="yay";;
    2) aurhelper="paru";;
esac

cmd=(dialog --clear --separate-output --checklist "Select (with space) what script should do.\\nChecked optitons are required for proper installtion, do not uncheck them if you do not know what you are doing." 26 86 16)
options=(1 "System update" on
         2 "Install aur helper" on
         3 "Install neovim" on
         4 "Create default directories" on
         5 "Create backups of existing configs" on
         6 "Copy configs" on
         7 "Update nvim extensions" on)

choices=$("${cmd[0]}" "${options[0]}" 2>&1 >/dev/tty)

clear

for choice in $choices
do 
    case $choice in
        1) system_update;;
        2) install_aur_helper;;
        3) install_neovim;;
        4) create_default_directories;;
        5) create_backup;;
        6) copy_configs;;
        7) update;;
    esac
done
