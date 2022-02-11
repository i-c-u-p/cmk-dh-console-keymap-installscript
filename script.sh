#!/bin/sh
CapsBackspace=1 # change this to 0 to avoid changing caps lock to backspace
SwapEscape=0 # if this is set to 1 and CapsBackspace to 0, caps lock and escape will be swapped
InstallDir=/usr/share/kbd/keymaps/i386/colemak-dh
WD="$(mktemp -d)"
cd $WD
git clone --depth 1 https://github.com/ColemakMods/mod-dh.git
cd mod-dh/console
mkdir $InstallDir
chmod 755 $InstallDir
[ $CapsBackspace = 0 ] && sed -i '/! Remove this line if you want caps lock unmodified/,+2d' *.map # Delete comment and the 2 lines below it
[ $CapsBackspace = 0 ] && [ $SwapEscape = 1 ] && sed -i "s/keycode   1 = Escape/keycode   1 = Caps_Lock/" *.map && echo "keycode  58 = Escape" | tee -a *.map >/dev/null
for file in *.map; do gzip $file; done
mv *.map.gz $InstallDir/
rm -rf $WD
