call clean.bat
call android update project -p . --target @@ANDROID_VER@@
call d:\android-ndk-r10d\ndk-build.cmd NDK_DEBUG=1
call ant debug
call adb install -r bin/@@SHORT_NAME@@-debug.apk

