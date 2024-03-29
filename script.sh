#!/bin/bash
CapsBackspace=1 # Change this to 0 to avoid changing caps lock to backspace.
SwapEscape=0 # If this is set to 1 and CapsBackspace to 0, caps lock and escape will be swapped.
SwapLAltLShift=0 # If set to 1, swaps left alt with left shift.
InstallDir=/usr/share/kbd/keymaps/i386/colemak-dh # Directory that the gunzipped keymaps will be moved to.
WD="$(mktemp -d)"
# Colors/formatting for echo: {
RED='\e[31m'
YELLOW='\e[33m'
BOLD='\e[1m'
RESET='\e[0m' # Reset text to default appearance
# }
cd $WD
git clone --depth 1 https://github.com/ColemakMods/mod-dh.git
cd mod-dh/console
mkdir -p "$InstallDir"
chmod 755 "$InstallDir"
for file in *.map; do
	if [ -f "$InstallDir/$file.gz" ]; then
		echo -en "${RED}The file \"$InstallDir/$file.gz\" exists. Overwrite it? (y/N): ${RESET}"
		read -n 1 -r
		while [[ ! $REPLY =~ [YyNn]|^$ ]]; do
			echo -en "\n${YELLOW}${BOLD}Bad answer. Type \"y\" for yes, or \"n\" (or leave blank) for no. ${RESET}"
			read -n 1 -r
		done
		if [[ $REPLY =~ Y|y ]]; then
			if [ $CapsBackspace = 0 ]; then
				if [ $SwapEscape = 1 ]; then
					sed -i "/^keycode *1 /s/=.*/= Caps_Lock/;/^keycode *58/s/=.*/= Escape/" "$file"
				else
					sed -i 's/^keycode *58/! &/' "$file"
				fi
			fi
			[ $SwapLAltLShift = 1 ] && sed -i '/^keycode *42/s/=.*/= Alt/;/^keycode *56/s/=.*/= Shift/' "$file"
			gzip "$file"
			mv "$file.gz" "$InstallDir/"
			echo
		fi
	fi
done
rm -rf $WD