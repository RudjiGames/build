@echo off

set RTM_PROJECT=all

IF [%1]==[] GOTO NO_PROJECT_NAME
set RTM_PROJECT=%1
:NO_PROJECT_NAME

%~dp0..\..\tools\rtm\asset_script.exe -r %~dp0..\..\data -p %RTM_PROJECT%  %1 %2 %3

