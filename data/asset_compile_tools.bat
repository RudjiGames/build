@echo off
echo RTM Asset pipeline 
echo Compiling asset build script generator...

genie vs2015 -f %~dp0../../rtm/src/tools/cmdline/asset_script/genie.lua 

if not defined DevEnvDir (
    call "%VS140COMNTOOLS%\..\..\VC\vcvarsall.bat" x86_amd64
)

devenv %~dp0../../.build/windows/vs2015/projects/asset_script/asset_script.sln /build retail 

copy %~dp0..\..\.build\windows\vs2015\x64\retail\asset_script\bin\asset_script_retail.exe %~dp0..\..\tools\rtm\asset_script.exe

echo Compiling asset build script generator...

