#!/bin/bash

# requirements -> windows management programs
windows_requirements=('xorg', 'bspwm', 'xrandr', 'sxhkd', 'feh', 'rofi')

# requirements -> terminal management programs
terminal_requirements=('kitty', 'nano', 'vim')

# function -> check if a requirement has been installed
is_installed(){
	requirement=$1 # variable that contains the package name

	if dpkg -s "$requirement" &> /dev/null; then # verify if the package is already installed
		return 0 # (true value -> the requirement is already installed)
	else
		return 1 # (false value -> the requirement is not installed)	
	fi
		
}

# function -> install the requirements
install_requirements(){

	# First step -> update and upgrade the system packages
	echo "[*] Updating and upgrading packages"
	if sudo apt update && sudo apt updgrade -y; then
		echo "[*] Packages updated and upgraded"
	else
		echo "[!] Error updating and upgrading packages"
		return 1 # (false value ->  something went wrong)
	fi

	# Second step -> install the windows requirements
	echo "[*] Installing windows requirements"
	for requirement in "${windows_requirements[@]}"; do
		if ! is_installed "$requirement";  then
			if sudo apt install $requirement -y; then
				echo "[+] $requirement installed successfully"
			else
				echo "[!] Error installing $requirement"
			fi
		else
			echo "[!] $requirement already installed"
		fi
	done

	# Third step -> install terminal requirements
	echo "[*] Installing terminal requirements"
	for requirement in "${terminal_requirements[@]}"; do
		if ! is_installed "$requirement"; then
			if sudo apt install $requirement -y; then
				echo "[+] $requirement installed successfully"
			else
				echo "[!] Error installing $requirement"
			fi
		else
			echo "[!] $requirement already installed"
		fi
	done

	echo "[+] All requirements installed successfully"
	return 0 # (true value -> the requirements installed correctly)
}

install_requirements
