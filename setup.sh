#!/bin/bash

# requirements -> windows management programs
windows_requirements=('xorg', 'bspwm', 'xrandr', 'sxhkd', 'feh', 'rofi')

# requirements -> terminal management programs
terminal_requirements=('kitty', 'nano', 'vim', 'picom')

# function -> check if a requirement has been installed
is_package_installed(){
	package_name=$1

	dpkg -s "$package_name" &> /dev/null # Verify if the package is installed
}

# function -> install the requirements
install_packages(){
	
	package_list=("$@") # Take an array as argument

	for package in "${package_list[@]}"; do
		if ! is_package_installed "$package"; then
			if sudo apt install "$package" -y; then
				echo "[+] $package installed successfully"
			else
				echo "[!] Error installing $package"
			fi
		else
			echo "[!] $package already installed"
		fi
	done
}



