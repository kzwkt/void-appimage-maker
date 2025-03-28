sudo apt install wget tar xz-utils zstd zsync
wget https://repo-default.voidlinux.org/static/xbps-static-latest.x86_64-musl.tar.xz
wget https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage
chmod +x appimagetool-x86_64.AppImage
tar xf xbps-static-latest.x86_64-musl.tar.xz

export XBPS_ARCH=x86_64  
export ARCH=x86_64
export SSL_NO_VERIFY_PEER=true   
UPINFO="gh-releases-zsync|$GITHUB_REPOSITORY_OWNER|$REPO|TAG|*x86_64.AppImage.zsync"
APP="mpv"
mkdir -p $APP.AppDir/var/db/xbps/keys
cp var/db/xbps/keys/* $APP.AppDir/var/db/xbps/keys
./usr/bin/xbps-install -Sy -r $APP.AppDir -R "https://repo-default.voidlinux.org/current" $APP
./usr/bin/xbps-remove -RFfy -r $APP.AppDir -R "https://repo-default.voidlinux.org/current" gtk+3 libxcrypt-compat glibc libpcre2 libffi zlib util-linux-common libblkid libmount libzstd liblzma bzip2 libelf glib fribidi brotli libpng freetype expat fontconfig  libXau libXdmcp libxcb libX11 libXext libXrender lzo pixman cairo libgcc libstdc++ icu-libs graphite libharfbuzz  libpciaccess libdrm libXfixes wayland libva ncurses-libs libreadline8 libxml2 libtasn1 p11-kit libunistring libidn2 gmp nettle libcrypto3 libssl3 libsodium  libevent libunbound gnutls alsa-lib  vulkan-loader lcms2 libgomp libsamplerate dbus-libs avahi-libs eudev-libudev libuuid libXtst libcap libelogind libfftw libglvnd libXcursor libXi libXrandr libxkbfile xkbcomp xkeyboard-config libxkbcommon libdatrie libthai pango libjpeg-turbo shared-mime-info jbigkit-libs tiff gdk-pixbuf gtk-update-icon-cache librsvg adwaita-icon-theme  dbus-x11 libepoxy libXdamage libXcomposite libXinerama atk at-spi2-core  at-spi2-atk  libxcrypt libcups libusb json-glib libgusb libcolord  libgbm acl liblz4 libarchive  

 cat >> ./$APP.AppDir/AppRun << 'EOF'
#!/bin/sh
HERE="$(dirname "$(readlink -f "${0}")")"
export PATH="${HERE}"/usr/bin/:"${HERE}"/usr/sbin/:"${HERE}"/usr/games/:"${PATH}"
export LD_LIBRARY_PATH=/lib/:/lib64/:/usr/lib/:/usr/lib/x86_64-linux-gnu/:"${HERE}"/usr/lib/:"${HERE}"/usr/lib/x86_64-linux-gnu/:"${HERE}"/usr/lib/pulseaudio/:"${HERE}"/lib/:"${HERE}"/lib/x86_64-linux-gnu/:"${LD_LIBRARY_PATH}"
export PYTHONPATH="${HERE}"/usr/share/python3/:"${PYTHONPATH}"
export XDG_DATA_DIRS="${HERE}"/usr/share/:"${XDG_DATA_DIRS}"
export MPV_CONFIG_PATH=$HERE/etc/mpv/:$MPV_CONFIG_PATH
exec ${HERE}/usr/bin/mpv "$@"
EOF
chmod a+x ./$APP.AppDir/AppRun


cp ./$APP.AppDir/usr/share/applications/mpv.desktop ./$APP.AppDir
sed -i 's|^Exec=.*|Exec=mpv|' $APP.AppDir/mpv.desktop
cp mpv.AppDir/usr/share/icons/hicolor/scalable/apps/mpv.svg mpv.AppDir/
rm -rf $APP.AppDir/var/

ARCH=x86_64 ./appimagetool-x86_64.AppImage --comp zstd --mksquashfs-opt -Xcompression-level --mksquashfs-opt 20  $APP.AppDir -u "$UPINFO"

rm appimagetool-x86_64.AppImage
