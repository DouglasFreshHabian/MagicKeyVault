#!/bin/bash

# Regular Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
WHITE='\033[0;37m'
RESET='\033[0m'

# Array of color names
allcolors=("RED" "GREEN" "YELLOW" "BLUE" "CYAN" "PURPLE" "WHITE")

# Function to print banner with a random color
ascii_banner() {

	# Pick a random color from the allcolors array
	random_color="${allcolors[$((RANDOM % ${#allcolors[@]}))]}"

	# Convert the color name to the actual escape code
	case $random_color in
	"RED") color_code=$RED ;;
	"GREEN") color_code=$GREEN ;;
	"YELLOW") color_code=$YELLOW ;;
	"BLUE") color_code=$BLUE ;;
	"CYAN") color_code=$CYAN ;;
	"PURPLE") color_code=$PURPLE ;;
	"WHITE") color_code=$WHITE ;;
	esac

	#--------) Display ASCII banner (--------#

	# Print the banner in the chosen color
	echo -e "${color_code}"
	cat <<"EOF"
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢤⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⣀⡀⠀⠀⠀⠀⣰⡤⠀⠀⡀⠀⠀⠀⢀⠀⠀
⠀⠀⠀⠀⣀⣤⠶⠛⠛⠉⠉⠉⠉⠉⠙⠛⠻⠶⣤⡀⠁⠀⠤⢷⠂⠀⢀⡠⣷⠖
⠀⢀⡴⠛⠉⠀⢀⡠⠤⠒⢒⣉⠉⠩⣭⣒⣦⠀⠀⠙⣦⠀⠀⠀⠁⢠⣄⠀⠘⠀
⣰⢏⢀⡀⡴⠊⢁⠤⡂⠍⠒⢈⣩⠴⠒⠋⠁⠀⠀⢀⣿⠀⠀⠀⣰⣿⠋⠀⠀⠀
⣿⢸⢸⠗⣇⠰⡡⠊⣀⠴⠚⠉⠀⠀⣀⣤⡴⡶⠞⠛⠁⠀⠀⡰⢫⠃⠀⠀⠀⠀
⠹⣆⠁⠀⠈⠉⠉⠉⠁⠀⠀⣀⣴⡾⠟⢁⠔⣷⠀⠀⠀⠀⡴⣱⠃⢈⣦⠄⠀⠀
⠀⠙⠳⣤⣄⣀⣀⣀⣠⣴⠞⠋⣁⠠⢒⠡⣪⠸⡆⠀⠀⡼⣱⠃⠀⠀⠙⠀⠀⠀
⠀⠀⠀⠀⠀⢹⠭⠽⠧⠬⠭⠅⠒⠈⠑⡪⢔⠅⢻⡀⡜⡴⠁⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢸⡄⠀⠀⠀⠀⠀⠀⠀⠀⢈⠥⡪⠀⡟⡼⠁⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠫⢒⡟⡜⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢸⣇⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⠞⡜⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠈⠙⠒⠲⠶⠶⠒⠒⠋⢉⣮⡞⠀⠠⢾⠒⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⠟⠀⠀⠀⠀⠁⠀⠀⠀

EOF
	echo -e "${RESET}" # Reset color
}

ascii_banner

# Function to check the kernel version
check_kernel_version() {
	echo -e "${GREEN}Checking kernel version...${RESET}"
	kernel_version=$(uname -r)
	echo -e "${BLUE}Kernel Version: $kernel_version${RESET}"
}

# Function to check if CONFIG_MAGIC_SYSRQ is enabled
check_config_magic_sysrq() {
	echo -e "${GREEN}Checking for CONFIG_MAGIC_SYSRQ in the kernel config...${RESET}"
	kernel_config="/boot/config-$(uname -r)"

	if [ -f "$kernel_config" ]; then
		config_sysrq=$(grep -i CONFIG_MAGIC_SYSRQ "$kernel_config")
		if [ -n "$config_sysrq" ]; then
			echo -e "${CYAN}Found CONFIG_MAGIC_SYSRQ Settings:${RESET}"
			echo -e "$config_sysrq"
		else
			echo -e "${RED}No CONFIG_MAGIC_SYSRQ settings found in the config.${RESET}"
		fi
	else
		echo -e "${RED}Kernel config file not found for the current version.${RESET}"
	fi
}

# Function to check the current SysRq value
check_sysrq_value() {
	echo -e "${GREEN}Checking the current SysRq value...${RESET}"
	sysrq_value=$(cat /proc/sys/kernel/sysrq)
	echo -e "${BLUE}Current SysRq value: $sysrq_value${RESET}"

	if [ "$sysrq_value" -ge 0 ]; then
		echo -e "${CYAN}Breaking down the SysRq value: $sysrq_value${RESET}"

		# Use awk to break down the SysRq value into its component flags
		echo -e "${YELLOW}SysRq Value Breakdown:${RESET}"

		# Iterate through all the bits from 0-31 for a 32-bit mask
		for i in {0..31}; do
			bit_value=$((2 ** i))
			if ((sysrq_value & bit_value)); then
				case $bit_value in
				1) echo -e "${PURPLE}Control of console logging level enabled${RESET}" ;;
				2) echo -e "${PURPLE}Control of keyboard (SAK, etc.) enabled${RESET}" ;;
				4) echo -e "${PURPLE}Debugging dumps of processes enabled${RESET}" ;;
				8) echo -e "${PURPLE}Syncing of filesystems enabled${RESET}" ;;
				16) echo -e "${PURPLE}Remount read-only enabled${RESET}" ;;
				32) echo -e "${PURPLE}Send signals to processes (kill, term, etc.) enabled${RESET}" ;;
				64) echo -e "${PURPLE}Allow reboot/poweroff enabled${RESET}" ;;
				128) echo -e "${PURPLE}Catch-all (anything not listed above) enabled${RESET}" ;;
				256) echo -e "${PURPLE}Reserved for extended or custom functions${RESET}" ;;
				512) echo -e "${PURPLE}Reserved for extended or custom functions${RESET}" ;;
				1024) echo -e "${PURPLE}Reserved for extended or custom functions${RESET}" ;;
				2048) echo -e "${PURPLE}Reserved for extended or custom functions${RESET}" ;;
				4096) echo -e "${PURPLE}Reserved for extended or custom functions${RESET}" ;;
				8192) echo -e "${PURPLE}Reserved for extended or custom functions${RESET}" ;;
				16384) echo -e "${PURPLE}Reserved for extended or custom functions${RESET}" ;;
				32768) echo -e "${PURPLE}Reserved for extended or custom functions${RESET}" ;;
				65536) echo -e "${PURPLE}Reserved for extended or custom functions${RESET}" ;;
				131072) echo -e "${PURPLE}Reserved for extended or custom functions${RESET}" ;;
				262144) echo -e "${PURPLE}Reserved for extended or custom functions${RESET}" ;;
				524288) echo -e "${PURPLE}Reserved for extended or custom functions${RESET}" ;;
				1048576) echo -e "${PURPLE}Reserved for extended or custom functions${RESET}" ;;
				2097152) echo -e "${PURPLE}Reserved for extended or custom functions${RESET}" ;;
				4194304) echo -e "${PURPLE}Reserved for extended or custom functions${RESET}" ;;
				8388608) echo -e "${PURPLE}Reserved for extended or custom functions${RESET}" ;;
				16777216) echo -e "${PURPLE}Reserved for extended or custom functions${RESET}" ;;
				33554432) echo -e "${PURPLE}Reserved for extended or custom functions${RESET}" ;;
				67108864) echo -e "${PURPLE}Reserved for extended or custom functions${RESET}" ;;
				134217728) echo -e "${PURPLE}Reserved for extended or custom functions${RESET}" ;;
				268435456) echo -e "${PURPLE}Reserved for extended or custom functions${RESET}" ;;
				536870912) echo -e "${PURPLE}Reserved for extended or custom functions${RESET}" ;;
				1073741824) echo -e "${PURPLE}Reserved for extended or custom functions${RESET}" ;;
				2147483648) echo -e "${PURPLE}Reserved for extended or custom functions${RESET}" ;;
				*) echo -e "${RED}Unknown value: $bit_value${RESET}" ;;
				esac
			fi
		done
	else
		echo -e "${RED}Invalid SysRq value: $sysrq_value${RESET}"
	fi
}

# Function to check all the settings
check_all_settings() {
	check_kernel_version
	check_config_magic_sysrq
	check_sysrq_value
}

# Run the script
check_all_settings
