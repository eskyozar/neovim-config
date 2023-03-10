#!/bin/bash

# Config created by eskyozar https://github.com/eskyozar/neovim-config.git

config_directory="$HOME/.config/nvim"

green='\033[0;32m'
no_color='\033[0m'
date=$(date +%s)

system_update(){

    echo -e "${green}=> Doing a system update, just keeping your system updated just in case....${no_color}'"
    sudo pacman --noconfirm -Syu
}


install_aur_helper(){

    if ! command -v &> /dev/null
    then 
    echo -e "${green}=> It looks like you don't have a $aurhelper insattled, I am going to install that for you.${no_color}'"
    git clone https://aur.archlinux.org/"$aurhelper".git $HOME/.srcs/"$aurhelper"
    
    (cd $HOME/.srcs/"$aurhelper"/ && makepkg -si)
    else
    echo -e "${green}=> It looks like you have an $aurhelper installed, skipping...${no_color}"
    fi

}

install_neovim(){

    echo -e "${green}=> Installing neovim.${no_color}"
    $aurhelper -Syu neovim
    $aurhelper -Syu neovim-nvim-treesitter

}

create_default_directories(){

    echo -e "${green}=> Copying configs to $config_directory.${no_color}"
    mkdir -p "$HOME"/.config/nvim

}

create_backup(){

    echo -e "${green}=> Createing backups of your existing configs.${no_color}"
    [ -d "$config_directory"/lua ] && mv "$config_directory" "$config_directory"_$date && echo "nvim configs detected, backing up.${no_color}"
    [ -d "$config_directory"/init.lua ] && mv "$config_directory"/init.lua "$config_directory"_$date && echo "nvim configs detected, backing up.${no_color}"



}

copy_configs(){

    echo -e "${green}=> Copying scripts to $config_directory.${no_color}"
    cp -r ./lua/ "$config_directory"
    cp init.lua "$config_directory"

}


echo -e "Install the desired aur helper which you want 1) yay 2) paru.${no_color}"
read choice

if [[ $choice -eq 1 ]] 
then	
	aurhelper="yay"
elif [[ $choice -eq 2 ]]
then
	aurhelper="paru"
else 
    echo -e "${green}=> Please enter a valid choice.${no_color}"
    exit
fi

system_update;
install_aur_helper;
install_neovim;
create_default_directories;
create_backup;
copy_configs;
