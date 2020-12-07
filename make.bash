#!/bin/bash
set -exuo pipefail

realpath () {
  [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

function unsign () {
  codesign --remove-signature "$1"
}

function sign () {
  codesign -s - "$1"
}

if [ -z "$1" ]; then
  exit 1
fi

APPDIR=$(realpath "$1")
WORKDIR=$(pwd)/workdir
rm -rf "$WORKDIR"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

unsign "$APPDIR"

git clone --depth 1 -b xcodejdk14-release https://github.com/apple/openjdk.git
cd openjdk/apple/JavaNativeFoundation
xcodebuild -target JavaNativeFoundation -configuration Release

cd "$WORKDIR"
curl -o zulu13.35.1017-ca-jdk13.0.5.1-macos_aarch64.zip https://cdn.azul.com/zulu/bin/zulu13.35.1017-ca-jdk13.0.5.1-macos_aarch64.zip
unzip zulu13.35.1017-ca-jdk13.0.5.1-macos_aarch64.zip
mv zulu13.35.1017-ca-jdk13.0.5.1-macos_aarch64/zulu-13.jdk .
rm -rf zulu-13.jdk/lib/JavaNativeFoundation.framework
cp -r "$WORKDIR/openjdk/apple/JavaNativeFoundation/build/Release/JavaNativeFoundation.framework" zulu-13.jdk/lib/

cd "$WORKDIR"
git clone --depth 1 -b master https://github.com/JetBrains/intellij-community.git
cd intellij-community/native/fsNotifier/mac
./make.sh
cp -f build/fsnotifier "$APPDIR/Contents/bin/fsnotifier"

cd "$WORKDIR"
cp -f ../idea "$APPDIR/Contents/MacOS/idea"
rm -rf "$APPDIR/Contents/jbr"
cp -r "$WORKDIR/zulu-13.jdk" "$APPDIR/Contents/jbr"

unsign "$APPDIR/Contents/jbr"
rm -rf "$APPDIR/Contents/jbr/lib"
sign "$APPDIR/Contents/jbr"
cp "$APPDIR/Contents/lib/jna.jar" .
unzip jna.jar -d jna
cp -f "$WORKDIR/../libjnidispatch.jnilib" jna/com/sun/jna/darwin/libjnidispatch.jnilib
mv jna.jar jna.jar.bak
zip -r jna.jar jna/com jna/META-INF
cp -f "$WORKDIR/jna.jar" "$APPDIR/Contents/lib/jna.jar"
cp -f "$WORKDIR/../jni.jar" "$APPDIR/Contents/lib/jni.jar"

sed -i '' 's/x86_64/arm64/g' "$APPDIR/Contents/Info.plist"
sign "$APPDIR"
sudo xattr -dr com.apple.quarantine "$APPDIR"

open "$APPDIR"
