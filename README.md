# IntelliJ Apple Silicon Patch

![](https://i.imgur.com/mCEuGqk.png)

IntelliJ IDEA is written in Java so it is a cross-platform IDE - meaning that you can use it on any platforms that Java works.

This patch helps you to transform your **Intel** IntelliJ application to Apple Silicon native by replacing its Intel-only files with the files built for Apple Silicon.

NOTE: Some functions, plugins, and native bindings wouldn't work with this way. This is just a temporary workaround.

## NOTE: Prebuilt binaries

I've created the following prebuilt binaries because compiling these files require hard work:

- Launcher (`idea`) from [intellij-community](https://github.com/JetBrains/intellij-community)
- Libjnidispatch (`libjnidispatch.jnilib`) from [JNA](https://github.com/java-native-access/jna)

## Guide

I'll assume you have already installed XCode command line tools.

First of all you need to download [the lastest version of IntelliJ](https://www.jetbrains.com/idea/download/)

1. Clone this repository.
2. Put "IntelliJ IDEA.app" to the cloned directory.
3. Run `./make.bash`.
   - It will ask password several times during the work.
4. Check IntelliJ works properly.
