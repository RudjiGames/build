#!/usr/local/bin/lua5.1
--
-- Copyright (c) 2017 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--
-- Based on script from Kyle Hendricks <kyle.hendricks@gentex.com> and
-- Josh Lareau <joshua.lareau@gentex.com>
-- ----------------------------------------------------------------------------


require("lfs")

RTM_QT_FILES            = "../.qt"
RTM_QT_FILES_PATH_MOC	= "../.qt/qt_moc"
RTM_QT_FILES_PATH_UI	= "../.qt/qt_ui"
RTM_QT_FILES_PATH_QRC	= "../.qt/qt_qrc"
RTM_QT_FILES_PATH_TS	= "../.qt/qt_qm"

local qtDirectory = ""
qtDirectory = arg[3] or qtDirectory

lua_version = _VERSION:match(" (5%.[123])$") or "5.1"

windows = package.config:sub( 1, 1 ) == "\\"
windowsExe = ".exe"
del = "\\"
if not windows then
	del = "/"
	windowsExe = ""
end

findLast = function(str, what, plain)
	plain = plain or true
	local lastMatch = 1
	local result = -1
	local thisMatch

	while lastMatch ~= -1 do
		thisMatch = str:find(what, lastMatch, plain)
		if thisMatch == nil then
			lastMatch = -1
		else
			result = thisMatch
			lastMatch = result + 1
		end
	end
	return result
end

local sourceDir = ""
if arg[2] ~= nil then
	local projName = arg[4]
	sourceDir = arg[2]:sub(1, findLast(arg[2], projName .. "/") + string.len(projName))
	sourceDir = sourceDir .. "src/"
end

function BuildErrorWarningString( line, isError, message, code )
	if windows then
		return string.format( "qtprebuild.lua(%i): %s %i: %s", line, isError and "error" or "warning", code, message )
	else
		return string.format( "qtprebuild.lua:%i: %s: %s", line, isError and "error" or "warning", message )
	end
end

--Make sure there are at least 2 arguments
if not ( #arg >= 2 ) then
	print( BuildErrorWarningString( debug.getinfo(1).currentline, true, "There must be at least 2 arguments supplied", 2 ) ); io.stdout:flush()
	return
end

--Checks that the first argument is either "-moc", "-uic", or "-rcc"
if not ( arg[1] == "-moc" or arg[1] == "-uic" or arg[1] == "-rcc"  or arg[1] == "-ts" ) then
	print( BuildErrorWarningString( debug.getinfo(1).currentline, true, [[The first argument must be "-moc", "-uic", "-rcc" or "-ts"]], 3 ) ); io.stdout:flush()
	return
end

--Make sure input file exists
inputFileModTime = lfs.attributes( arg[2], "modification" )
if inputFileModTime == nil then
	print( BuildErrorWarningString( debug.getinfo(1).currentline, true, [[The supplied input file ]]..arg[2]..[[, does not exist]], 4 ) ); io.stdout:flush()
	return
end

qtOutputDirectory			= sourceDir .. RTM_QT_FILES
qtMocOutputDirectory		= sourceDir .. RTM_QT_FILES_PATH_MOC
qtUIOutputDirectory			= sourceDir .. RTM_QT_FILES_PATH_UI
qtQRCOutputDirectory		= sourceDir .. RTM_QT_FILES_PATH_QRC
qtTSOutputDirectory			= sourceDir .. RTM_QT_FILES_PATH_TS

qtMocPostfix	= "_moc"
qtQRCPostfix	= "_qrc"
qtUIPostfix		= "_ui"
qtTSPostfix		= "_ts"

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

qtMocExe = "moc" .. windowsExe
qtUICExe = "uic" .. windowsExe
qtQRCExe = "rcc" .. windowsExe
qtTSExe  = "lrelease" .. windowsExe

if file_exists(qtDirectory..del.."bin"..del..qtMocExe) then
	qtMocExe = qtDirectory..del.."bin"..del..qtMocExe
	qtUICExe = qtDirectory..del.."bin"..del..qtUICExe
	qtQRCExe = qtDirectory..del.."bin"..del..qtQRCExe
	qtTSExe  = qtDirectory..del.."bin"..del..qtTSExe
end

lfs.mkdir( qtOutputDirectory )

function checkUpToDate(outputFileName) 
	outputFileModTime = lfs.attributes( outputFileName, "modification" )
	if outputFileModTime ~= nil and ( inputFileModTime < outputFileModTime ) then
		--print( outputFileName.." is up-to-date, not regenerating" )
		io.stdout:flush()
		return true
	end
	return false
end

function getFileNameNoExtFromPath( path )
	local i = 0
	local lastSlash = 0
	local lastPeriod = 0
	local returnFilename
	while true do
		i = string.find( path, "/", i+1 )
		if i == nil then break end
		lastSlash = i
	end

	i = 0
	while true do
		i = string.find( path, "%.", i+1 )
		if i == nil then break end
		lastPeriod = i
	end

	if lastPeriod < lastSlash then
		returnFilename = path:sub( lastSlash + 1 )
	else
		returnFilename = path:sub( lastSlash + 1, lastPeriod - 1 )
	end

	return returnFilename
end

getPath=function(str,sep)
    sep=sep or'/'
    return str:match("(.*"..sep..")")
end

runProgram = function(command)
	local result = 1
	if lua_version == "5.3" then
		local value, type
		value, type, result = os.execute(command)
	else
		result = os.execute(command)
	end
	return result
end

if arg[1] == "-moc" then

	lfs.mkdir( qtMocOutputDirectory )
	outputFileName = qtMocOutputDirectory .. del .. getFileNameNoExtFromPath( arg[2] ) .. qtMocPostfix .. ".cpp"

	if checkUpToDate(outputFileName) == true then return end
	
	local fullMOCPath = qtMocExe.." \""..arg[2].. "\" -I \"" .. getPath(arg[2]) .. "\" -o \"" .. outputFileName .."\" -f\"".. arg[4] .. "_pch.h\" -f\"" .. arg[5] .. "\""
	if windows then
		fullMOCPath = '""'..qtMocExe..'" "'..arg[2].. '" -I "' .. getPath(arg[2]) .. '" -o "' .. outputFileName ..'"' .. " -f".. arg[4] .. "_pch.h -f" .. arg[5] .. '"'
	end

	if 0 ~= runProgram(fullMOCPath) then
		print( BuildErrorWarningString( debug.getinfo(1).currentline, true, [[MOC Failed to generate ]]..outputFileName, 5 ) ); io.stdout:flush()
	else
		--print( "MOC Created "..outputFileName )
		io.stdout:flush()
	end
elseif arg[1] == "-rcc" then
	lfs.mkdir( qtQRCOutputDirectory )
	outputFileName = qtQRCOutputDirectory .. del .. getFileNameNoExtFromPath( arg[2] ) .. qtQRCPostfix .. ".cpp"

	if checkUpToDate(outputFileName) == true then return end

	local fullRCCPath = qtQRCExe.." -name \""..getFileNameNoExtFromPath( arg[2] ).."\" \""..arg[2].."\" -o \""..outputFileName.."\""
	if windows then
		fullRCCPath = '""'..qtQRCExe..'" -name "'..getFileNameNoExtFromPath( arg[2] )..'" "'..arg[2]..'" -o "'..outputFileName..'""'
	end

	if 0 ~= runProgram(fullRCCPath) then
		print( BuildErrorWarningString( debug.getinfo(1).currentline, true, [[RCC Failed to generate ]]..outputFileName, 6 ) ); io.stdout:flush()
	else
		--print( "RCC Created "..outputFileName )
		io.stdout:flush()
	end
elseif arg[1] == "-uic" then
		lfs.mkdir( qtUIOutputDirectory )
		outputFileName = qtUIOutputDirectory .. del .. getFileNameNoExtFromPath( arg[2] ) .. qtUIPostfix .. ".h"

		if checkUpToDate(outputFileName) == true then return end

		local fullUICPath = qtUICExe.." \""..arg[2].."\" -o \""..outputFileName.."\""
		if windows then
			fullUICPath = '""'..qtUICExe..'" "'..arg[2]..'" -o "'..outputFileName..'""'
		end

		if 0 ~= runProgram(fullUICPath) then
			print( BuildErrorWarningString( debug.getinfo(1).currentline, true, [[UIC Failed to generate ]]..outputFileName, 7 ) ); io.stdout:flush()
		else
			--print( "UIC Created "..outputFileName )
			io.stdout:flush()
		end
elseif arg[1] == "-ts" then
		lfs.mkdir( qtTSOutputDirectory )
		outputFileName = qtTSOutputDirectory .. del .. getFileNameNoExtFromPath( arg[2] ) .. qtTSPostfix .. ".qm"

		if checkUpToDate(outputFileName) == true then return end

		local fullTSPath = qtTSExe.." \""..arg[2].."\""
		if windows then
			fullTSPath = '""'..qtTSExe..'" "'..arg[2]
		end

		if 0 ~= runProgram( fullTSPath) then
			print( BuildErrorWarningString( debug.getinfo(1).currentline, true, [[UIC Failed to generate ]]..outputFileName, 7 ) ); io.stdout:flush()
		else
			--print( "UIC Created "..outputFileName )
			io.stdout:flush()
		end		
end

