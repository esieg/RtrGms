mkdir Icon.iconset
sips -z 16 16     Icon.png --out Icon.iconset/icon_16x16.png
sips -z 32 32     Icon.png --out Icon.iconset/icon_16x16@2x.png
sips -z 32 32     Icon.png --out Icon.iconset/icon_32x32.png
sips -z 64 64     Icon.png --out Icon.iconset/icon_32x32@2x.png
sips -z 128 128   Icon.png --out Icon.iconset/icon_128x128.png
sips -z 256 256   Icon.png --out Icon.iconset/icon_128x128@2x.png
sips -z 256 256   Icon.png --out Icon.iconset/icon_256x256.png
sips -z 512 512   Icon.png --out Icon.iconset/icon_256x256@2x.png
sips -z 512 512   Icon.png --out Icon.iconset/icon_512x512.png
cp Icon.png Icon.iconset/icon_512x512@2x.png
iconutil -c icns Icon.iconset
rm -R Icon.iconset
