--
-- Copyright 2025 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

local params = { ... }

local SOURCE_FILES		= params[1] or false
local IS_LIBRARY		= params[2] or false
local IS_SHARED_LIBRARY	= params[3] or false
local COPY_QT_DLLS		= params[4] or false
local WITH_QT			= params[5] or false
local EXECUTABLE		= params[6] or false
local PROJECT_NAME		= params[7] or project().name
local IS_3RD_PARTY		= params[8] or false

dofile (RTM_SCRIPTS_DIR .. "embedded_files.lua")
dofile (RTM_SCRIPTS_DIR .. "qtpresets6.lua")
assert(loadfile(RTM_SCRIPTS_DIR .. "toolchain.lua"))( EXECUTABLE, IS_3RD_PARTY )

function setSubConfig(_platform, _configuration, _is64bit)
	commonConfig(_platform, _configuration, IS_LIBRARY, IS_SHARED_LIBRARY, EXECUTABLE)
	shaderConfigure(_platform, _configuration, PROJECT_NAME, shaderFiles)
	local prefix = ""
	if _configuration == "debug" then
		prefix = "d"
	end
	if WITH_QT then
		configuration { _configuration }
    	qtAddedFiles = qtConfigure(_platform, _configuration, PROJECT_NAME, mocFiles, qrcFiles, uiFiles, tsFiles, libsToLink, COPY_QT_DLLS, _is64bit, prefix )
	end
	if _G["projectExtraConfig_" .. project().name] then
		_G["projectExtraConfig_" .. project().name]()
	end
end

function setConfig(_configuration)
	local currPlatforms = platforms()
	for _,platform in ipairs(currPlatforms) do
		setSubConfig(platform, _configuration, "x64" == platform)
	end
end

local qtAddedFiles = {}

configuration {}
local all_configs = configurations()
for _,config in ipairs(all_configs) do
	configuration { config }
		targetsuffix ("_" .. config)
		defines { ExtraDefines[config] }
		flags   { ExtraFlags[config] }
	setConfig(config)
end
configuration {}

function vpathFilter(_string, _find)

	-- make sure we search for project folder, other folders can contain its name so adding slashes fixes it
    _find = "/" .. _find .. "/"

	-- lib samples
	local pathPos = string.find(_string, "/samples/")
	if pathPos ~= nil then
		local vpath = string.sub(_string, pathPos + string.len("/samples/"), string.findlast(_string, "/"))
		local replaceStart = string.find(vpath, "/")
		return "src" .. string.sub(vpath, replaceStart, string.len(vpath))
	end

	-- lib tests
	local pathPos = string.find(_string, "/test/")
	if pathPos ~= nil then
		local vpath = string.sub(_string, pathPos + string.len("/test/"), string.len(_string))
		local slash = string.findlast(vpath, "/")
		if slash ~= nil then
			return "src/" .. string.sub(vpath, 1, slash)
		end
		return "src"
	end

	-- lib tools
	local pathPos = string.find(_find, "_tool_")
	if pathPos ~= nil then
		local projectDirName = "/" .. string.sub(_find, pathPos + string.len("_tool_"), string.len(_find)) .. "/"
		local vpath = string.sub(_string, string.find(_string, projectDirName) + string.len(projectDirName), string.len(_string))
		local slash = string.findlast(vpath, "/")
		if slash ~= nil then
			return "src/" .. string.sub(vpath, 1, slash)
		end
		return "src"
	end

	-- 
	local pos = string.find(_string, _find)
	if pos ~= nil then
		local rem = string.sub(_string, pos + string.len(_find))
		pos = string.findlast(rem, "/")
		if pos ~= nil then
			return string.sub(rem, 1, pos-1)
		end
	end

	local lsPos = string.findlast(_string, "/") - 1
	local plPos = string.findlast(_string, "/", lsPos) + 1
	local name = string.sub(_string, plPos, lsPos)

	if name == "inc" then
		return "inc"
	end

	return "src"
end

SOURCE_FILES = mergeTables(SOURCE_FILES, qtAddedFiles)

for _,srcFilePattern in ipairs(SOURCE_FILES) do
	local srcFiles = os.matchfiles(srcFilePattern)
	if string.find(srcFilePattern, "%*%*") == nil then
		srcFiles = { srcFilePattern }
	end
	for _,srcFile in ipairs(srcFiles) do

		if string.endswith(srcFile, ".ui") then
			vpaths { ["qt/forms"]			= srcFile }
		end
		
		if string.endswith(srcFile, ".qrc") then
			vpaths { ["qt/resources"]		= srcFile }
		end
		
		local filtered = false
		if	string.endswith(srcFile, "_ui.h") then
			filtered = true
			vpaths { ["qt/generated/ui"]	= srcFile }
		end
		
		if	string.endswith(srcFile, "_moc.cpp") then
			filtered = true
			vpaths { ["qt/generated/moc"]	= srcFile }
		end
		
		if	string.endswith(srcFile, "_qrc.cpp") then
			filtered = true
			vpaths { ["qt/generated/qrc"]	= srcFile }
		end
		
		if	string.endswith(srcFile, ".ts") then
			filtered = true
			vpaths { ["qt/translation"]		= srcFile }
		end

		if	string.endswith(srcFile, ".sc") then
			filtered = true
			vpaths { ["shaders"]			= srcFile }
		end
		
		if	string.endswith(srcFile, ".h")		or
			string.endswith(srcFile, ".hpp")	or
			string.endswith(srcFile, ".hxx")	or
			string.endswith(srcFile, ".inl")	then
			if not filtered then
				filtered = true
				vpaths { [vpathFilter(srcFile, PROJECT_NAME)]	= srcFile }
			end
		end

		if	string.endswith(srcFile, ".c")		or
			string.endswith(srcFile, ".cc")		or
			string.endswith(srcFile, ".cxx")	or
			string.endswith(srcFile, ".cpp")	then
			if not filtered then
				vpaths { [vpathFilter(srcFile, PROJECT_NAME)]		= srcFile }
			end
		end
	end
end

