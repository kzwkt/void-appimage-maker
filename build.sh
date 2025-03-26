sudo apt install wget tar xz-utils 
wget https://repo-default.voidlinux.org/static/xbps-static-latest.x86_64-musl.tar.xz
wget https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage
chmod +x appimagetool-x86_64.AppImage
tar xf xbps-static-latest.x86_64-musl.tar.xz

export XBPS_ARCH=x86_64  
export ARCH=x86_64
APP="mpv"
mkdir -p $APP.AppDir/var/db/xbps/keys
cp var/db/xbps/keys/* $APP.AppDir/var/db/xbps/keys
./usr/bin/xbps-install -Sy -r $APP.AppDir -R "https://repo-default.voidlinux.org/current" $APP
./usr/bin/xbps-remove -RFfy -r $APP.AppDir -R "https://repo-default.voidlinux.org/current" gtk+3 glibc icu-libs

 cat >> ./$APP.AppDir/AppRun << 'EOF'
#!/bin/sh
HERE="$(dirname "$(readlink -f "${0}")")"
export PATH="${HERE}"/usr/bin/:"${HERE}"/usr/sbin/:"${HERE}"/usr/games/:"${PATH}"
export LD_LIBRARY_PATH=/lib/:/lib64/:/usr/lib/:/usr/lib/x86_64-linux-gnu/:"${HERE}"/usr/lib/:"${HERE}"/usr/lib/x86_64-linux-gnu/:"${HERE}"/lib/:"${HERE}"/lib/x86_64-linux-gnu/:"${LD_LIBRARY_PATH}"
export PYTHONPATH="${HERE}"/usr/share/python3/:"${PYTHONPATH}"
export XDG_DATA_DIRS="${HERE}"/usr/share/:"${XDG_DATA_DIRS}"
export MPV_CONFIG_PATH=$HERE/etc/mpv/:$MPV_CONFIG_PATH
exec ${HERE}/usr/bin/mpv "$@"
EOF
chmod a+x ./$APP.AppDir/AppRun


ARCH=x86_64 ./appimagetool-x86_64.AppImage $APP.AppDir

rm appimagetool-x86_64.AppImage
file=$(realpath *.AppImage)
echo $file > file
