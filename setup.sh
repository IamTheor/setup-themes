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

# function -> install brave-browser
install_browser(){

	# Verify if curl package is already installed
	if ! is_package_installed "curl"; then
		sudo apt install curl -y
	fi	

	sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

	echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

	sudo apt update # Update the system

	# Verify and try to install brave-browser
	if ! is_package_installed "brave-browser"; then
		if sudo apt install brave-browser -y; then
			echo "[+] Brave installed successfully"
		else
			echo "[!] Error installing Brave"
		fi
	else
		echo "[!] Brave is already installed"
	fi
}

# function -> check if a directory exists
is_directory_created(){
	directory=$1
	
	# If the directory does not exists, make the directory
	if ! [-d "$directory"]; then
		mkdir "$directory"
	fi	
}


