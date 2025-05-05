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
		echo "[*] Installing curl (required for Brave Browser)"
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
	if [ ! -d "$directory"]; then
		mkdir -p "$directory"
	fi	
}

# function -> create a link between .config directory and repo directory
set_themes_files(){
	theme_name=$1
	src_dir="$(pwd)/themes/$theme_name"
	config_dir="$HOME/.config"

	echo "[+] Creating symlinks from theme '$theme_name' into ~/.config"

	# Create necessary directories if they don't exist
	is_directory_created "$config_dir/bspwm"
	is_directory_created "$config_dir/sxhkd"
	is_directory_created "$config_dir/kitty"

	# Create symlinks (overwrite if already exist with -sf)
	ln -sf "$src_dir/bspwmrc" "$config_dir/bspwm/bspwmrc"
	ln -sf "$src_dir/sxhkdrc" "$config_dir/sxhkd/sxhkdrc"
	ln -sf "$src_dir/kitty.conf" "$config_dir/kitty/kitty.conf"

	# Set wallpaper using feh
	feh --bg-scale "$src_dir/naruto_wallpaper.png"

	echo "[+] Symlinks for theme '$theme_name' applied successfully."	
}

# Main menu
main(){
	while true; do
		clear
		echo "==============================="
		echo "         setup-themes          "
		echo "==============================="
		echo "1) Install packages"
		echo "2) Select theme"
		echo "3) Exit"
		echo "==============================="
		read -p "[1-3] >> " opcion
	
		case $opcion in
		1)
			echo "[+] Installing packages..."
			install_packages "${windows_requirements[@]}"
			install_packages "${terminal_requirements[@]}"
			install_browser
			read -p "Press ENTER to continue..."
			;;
		2)
			# Submenú de temas
			while true; do
				clear
				echo "==============================="
				echo "        Choose a Theme         "
				echo "==============================="
				echo "1) naruto-theme"
				echo "2) return"
				echo "==============================="
				read -p "[1-2] >> " tema_opcion

				case $tema_opcion in
					1)
						echo "[+] naruto-theme..."
						set_themes_files naruto-theme
						read -p "Press ENTER to continue..."
						;;
					2)
						break
						;;
					*)
						echo "[!] Choose a correct option..."
						read -p "Press ENTER to continue..."
						;;
				esac
			done
			;;
	       	3)
			clear
			echo "[+] Good bye..."
			exit 0
			;;
		*)
			echo "[!] Choose a correct option..."
			read -p "Press ENTER to continue..."
			;;
		esac
	done
}

main
