#!/bin/bash
CapsBackspace=1 # Change this to 0 to avoid changing caps lock to backspace.
SwapEscape=0 # If this is set to 1 and CapsBackspace to 0, caps lock and escape will be swapped.
SwapLAltLShift=0 # If set to 1, swaps left alt with left shift.
InstallDir=/usr/share/kbd/keymaps/i386/colemak-dh # Directory that the gunzipped keymaps will be moved to.
WD="$(mktemp -d)"
# Colors/formatting for echo: {
RED='\e[31m'
YELLOW='\e[33m'
COLOROFF='\e[0m'
BOLD=$(tput bold)
NORM=$(tput sgr0)
# }
cd $WD
git clone --depth 1 https://github.com/ColemakMods/mod-dh.git
cd mod-dh/console
mkdir -p "$InstallDir"
chmod 755 "$InstallDir"
[ $CapsBackspace = 0 ] && sed -i '/! Remove this line if you want caps lock unmodified/,+2d' *.map # Delete comment and the 2 lines below it
[ $CapsBackspace = 0 ] && [ $SwapEscape = 1 ] && sed -i "s/keycode   1 = Escape/keycode   1 = Caps_Lock/" *.map && echo "keycode  58 = Escape" | tee -a *.map >/dev/null
[ $SwapLAltLShift = 1 ] && sed -i -e 's/^keycode  42 = Shift/keycode  42 = Alt/g;s/^keycode  56 = Alt/keycode  56 = Shift/g' *.map
for file in *.map; do gzip "$file"; done
for file in *.map.gz; do
	if [ -f "$InstallDir/$file" ]; then
		echo -en "${RED}The file \"$InstallDir/$file\" exists. Overwrite it? (Y/n): ${COLOROFF}"
		read -n 1 -r
			while [[ ! $REPLY =~ [YyNn]|^$ ]]; do
				echo -en "\n${YELLOW}${BOLD}Bad answer. Type a \"y\" or \"n\": ${NORM}${COLOROFF}"
				read -n 1 -r
			done
			case $REPLY in
				Y|y|'' ) mv "$file" "$InstallDir/"; echo;;
				N|n ) echo;;
			esac
	else
		mv "$file" "$InstallDir/"
	fi
done
rm -rf $WD