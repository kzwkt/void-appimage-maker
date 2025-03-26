sudo apt install tar xz-utils arch-install-scripts
wget https://repo-default.voidlinux.org/static/xbps-static-latest.x86_64-musl.tar.xz
wget https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage
chmod +x appimagetool-x86_64.AppImage
tar xf xbps-static-latest.x86_64-musl.tar.xz

export XBPS_ARCH=x86_64  
export ARCH=x86_64
APP="mpv"

./usr/bin/xbps-install -Sy -r $APP.AppDir -R "https://repo-default.voidlinux.org/current" $APP
./usr/bin/xbps-remove -RFf -r $APP.AppDir -R "https://repo-default.voidlinux.org/current" gtk+3 glibc icu-libs

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
