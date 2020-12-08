# IntelliJ Apple Silicon Patch

![](https://i.imgur.com/mCEuGqk.png)

IntelliJ IDEA is written in Java so it is a cross-platform IDE - meaning that you can use it on any platforms that Java works.

This patch helps you to transform your **Intel** IntelliJ application to Apple Silicon native by replacing its Intel-only files with the files built for Apple Silicon.

NOTE: Some functions, plugins, and native bindings wouldn't work with this way. This is just a temporary workaround.

## NOTE: Prebuilt binaries

I've created the following prebuilt binaries because compiling these files require hard work:

- Launcher (`idea`) from [intellij-community](https://github.com/JetBrains/intellij-community)
- Libjnidispatch (`libjnidispatch.jnilib`) from [JNA](https://github.com/java-native-access/jna)

### How to build (if you want)

You can build the binaries above if you suspect the prebuilt binaries that I've built are such malformed or dangerous:

#### JNA

You may have to do this on Intel-based Macs, and have the following packages installed:

- automake
- autoconf
- ant

Then,

1. Clone https://github.com/fkistner/jna, and checkout the `darwin_arm64` branch
2. Replace all the `"ffi.h"` with `<ffi/ffi.h>`
3. Run `ant native -Ddynlink.native=true -Dbuild.os.arch=aarch64` to build native libs
4. Open `jna/build` and extract `darwin.jar` to get `libjnidispatch.dylib`

#### Launcher

1. Clone https://github.com/JetBrains/intellij-community
2. Build `native/MacLauncher`

## Guide

I'll assume you have already installed XCode command line tools.

First of all you need to download [the lastest version of IntelliJ](https://www.jetbrains.com/idea/download/).

1. Clone this repository.
2. Put "IntelliJ IDEA.app" to the cloned directory. The directory should look like: ![](https://i.imgur.com/2VuPtRk.png)
3. Run `./make.bash "./IntelliJ Idea.app"`.
   - It will ask password several times during the work.
4. Check IntelliJ works properly.

![](https://i.imgur.com/fYvO0qu.png)

### TIP: Scrolling performance

If you feel like the scrolling is too slow you should simply turn off Antialiasing for Code Editor.

![](https://i.imgur.com/gYE1jzA.png)
