@echo off
echo RTM Asset pipeline compiler

pushd %~dp0
"../tools/windows/ninja.exe" -f "../../data/build.ninja"
popd

