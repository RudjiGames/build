--
-- Copyright (c) 2017 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

--------------------------------------------------------
-- directories
--------------------------------------------------------

function script_dir()
	return path.getdirectory(debug.getinfo(2, "S").source:sub(2)) .. "/"
end

RTM_SCRIPTS_DIR			= script_dir()
RTM_ROOT_DIR			= path.getabsolute(RTM_SCRIPTS_DIR .. "../") .. "/"		-- project root
RTM_BUILD_DIR			= RTM_ROOT_DIR .. ".build/"								-- temp build files
RTM_LOCATION_PATH		= ""													-- solution/makefile/etc.

local RTM_PROJECT_DIRS_LIST = {
	"",
	"3rd/",
	"src/libs/",
	"src/game/games/",
	"src/game/libs/",
	"src/tools/libs/",
	"src/tools/cmdline/",
	"src/tools/qt/"
}

RTM_PROJECT_DIRS = {}

for _,path in ipairs(RTM_PROJECT_DIRS_LIST) do
	if os.isdir(RTM_ROOT_DIR .. path) then
		table.insert(RTM_PROJECT_DIRS, RTM_ROOT_DIR .. path) 
	end
end

dofile (RTM_SCRIPTS_DIR .. "toolchain.lua")

if _ACTION == nil then
	print ("No action specified!")
	os.exit()
	return
end

if _ACTION == "clean" then
	rmdir(RTM_BUILD_DIR)
	os.exit()
	return
end

--------------------------------------------------------
-- compiler flags
--------------------------------------------------------

Flags_ThirdParty	= { "StaticRuntime", "NoEditAndContinue", "NoPCH" }
Flags_Libraries		= { "StaticRuntime", "NoEditAndContinue", "NoRTTI", "ExtraWarnings", "NoExceptions" }
Flags_Tests			= { "StaticRuntime", "NoEditAndContinue", "NoRTTI", "ExtraWarnings" }
Flags_Cmd			= { "StaticRuntime", "NoEditAndContinue", "NoRTTI", "ExtraWarnings", "NoExceptions" }
Flags_QtTool		= { "StaticRuntime", "NoEditAndContinue", "NoRTTI", "ExtraWarnings" }

ExtraFlags_Debug	= { "Symbols" }
ExtraFlags_Release	= { "NoFramePointer", "OptimizeSpeed", "NoBufferSecurityCheck", "Symbols" }
ExtraFlags_Retail	= { "NoFramePointer", "OptimizeSpeed", "NoBufferSecurityCheck" }

--------------------------------------------------------
-- utility functions to check for target compiler
--------------------------------------------------------

function actionUsesGCC()
	return ("gmake" == _ACTION or "codelite" == _ACTION or "codeblocks" == _ACTION or "xcode3" == _ACTION)
end

function actionUsesMSVC()
	return (_ACTION ~= nil and _ACTION:find("vs"))
end

function actionUsesXcode()
	return (_ACTION ~= nil and _ACTION:find("xcode"))
end

-- has to be called from an active solution
function setPlatforms()
	if actionUsesXcode() then
		platforms { "Universal" }
	elseif actionUsesMSVC() then
		if not getTargetOS() == "durango" and not getTargetOS() == "orbis" then -- durango and orbis add their own platforms
			platforms { "x32", "x64" }
		end
	else
		platforms { "x32", "x64", "native" }
	end

	configuration {}

	if not toolchain() then
		return -- no action specified
	end 

end

--------------------------------------------------------
-- fixup for precompiled header path
--------------------------------------------------------

function getPCHPath(_path, _projectName, _projType)
	local fullPath = _path .. _projectName .. "_pch.h"
	if os.isfile(fullPath) == false then
		return nil
	end
	local retPath = _projectName .. "_pch.h"
	if actionUsesGCC() then
		retPath = _path .. retPath
	end
	return retPath
end

function addPCH(_path, _name)
	local PCH = getPCHPath(_path, _name)
	if PCH ~= nil then
		pchheader (PCH)
		pchsource (_path .. _name .. "_pch.cpp")
	end
end

--------------------------------------------------------
-- Library types
--------------------------------------------------------

Lib = {
	Runtime	= {},
	Tool	= {},
	Game	= {}
}

--------------------------------------------------------
-- configuration specific defines
--------------------------------------------------------

Defines_Debug   = { "RTM_DEBUG_BUILD", "_DEBUG", "DEBUG" }
Defines_Release = { "RTM_RELEASE_BUILD", "NDEBUG" }
Defines_Retail  = { "RTM_RETAIL_BUILD", "NDEBUG", "RETAIL" }

dofile (RTM_SCRIPTS_DIR .. "project_3rd.lua")
dofile (RTM_SCRIPTS_DIR .. "project_cmdtool.lua")
dofile (RTM_SCRIPTS_DIR .. "project_game.lua")
dofile (RTM_SCRIPTS_DIR .. "project_lib.lua")
dofile (RTM_SCRIPTS_DIR .. "project_lib_sample.lua")
dofile (RTM_SCRIPTS_DIR .. "project_lib_test.lua")
dofile (RTM_SCRIPTS_DIR .. "project_lib_tool.lua")
dofile (RTM_SCRIPTS_DIR .. "project_qt.lua")

--------------------------------------------------------
-- helper functions
--------------------------------------------------------
function mergeTwoTables(_table1, _table2)
	table1 = table1 or {}
	table2 = table2 or {}
	local retTable = {}
	for _,v1 in ipairs(_table1) do table.insert(retTable, v1) end
	for _,v2 in ipairs(_table2) do table.insert(retTable, v2) end
	return retTable
end

function mergeTables(_table1, _table2, _table3, _table4, _table5, _table6)
	_table1 = _table1 or {}		_table2 = _table2 or {}
	_table3 = _table3 or {}		_table4 = _table4 or {}
	_table5 = _table5 or {}		_table6 = _table6 or {}
	local t1 = mergeTwoTables(_table1, _table2)
	local t2 = mergeTwoTables(_table3, _table4)
	local t3 = mergeTwoTables(_table5, _table6)	
	return mergeTwoTables(t1, mergeTwoTables(t2, t3))
end

ProjectLoad = {
	LoadOnly	= {},
	LoadAndAdd	= {}
}

g_projectIsLoaded		= {}
g_projectDependencies	= {}

function getProjectDesc(_name)
	local descFn = _G["projectDescription_" .. _name]
	if descFn then
		return descFn()
	end
	-- no project desc (sample, test, etc.); return default
	return {
		version		= "1.0.0.0",	-- quad format for durango support
		publisher	= {
			company			= "RTM",
			organization	= "RTM",
			location		= "Belgrade",
			state			= "Serbia",
			country			= "Serbia",
		},
		shortname	= _name,
		longname	= _name,
		description	= _name .. " description",
		logosquare	= RTM_SCRIPTS_DIR .. "deploy/res/logo_square.png",	-- should be no less than 480x480 (xb1)
		logowide	= RTM_SCRIPTS_DIR .. "deploy/res/logo_wide.png"		-- should be no less than 1920x1080
	}
end

ProjectPath = {
	Dir		= {},
	Root	= {}
}

function getProjectPath(_name, _pathType)
	_pathType = _pathType or ProjectPath.Dir
	for _,dir in ipairs(RTM_PROJECT_DIRS) do
		libDir = dir .. _name
		if os.isdir(libDir) then 
			if _pathType == ProjectPath.Dir then
				return libDir .. "/" 
			else
				return dir
			end
		end
	end
	return ""
end

function getProjectGenieScriptPath(_name)
	for _,dir in ipairs(RTM_PROJECT_DIRS) do
		libScript = dir .. _name .. "/genie/" .. _name .. ".lua"
		if os.isfile(libScript) then return libScript end
	end
	return ""
end

function addIncludePath(_path)
	if string.len(_path) == 0 then return end
	if os.isdir(_path) then includedirs { _path } end
end

function isGENieProject(_projectName)
	local projectParentDir = getProjectPath(_projectName, ProjectPath.Root)
	if os.isfile(projectParentDir .. _projectName .. ".lua") then return true end
	if os.isfile(projectParentDir .. _projectName .. "/genie/genie.lua") then return true end
	return false
end

function addInclude(_projectName)

	local projectParentDir = getProjectPath(_projectName, ProjectPath.Root)

	addIncludePath(projectParentDir)
	addIncludePath(projectParentDir .. _projectName .. "/include")
	addIncludePath(projectParentDir .. _projectName .. "/inc")

	local linkFn = _G["projectLink_" .. _projectName]
	if linkFn then
		linkFn()
		return false
	end	
	return true
end

function addProject(_name)
	local deps = getProjectDependencies(_name)
	for _,dep in ipairs(deps) do
		addProject(dep)
	end
	if g_projectIsLoaded[_name] == nil then
		g_projectIsLoaded[_name] = true
		if _G["projectAdd_" .. _name] ~= nil then -- prebuilt libs have no projects
			_G["projectAdd_" .. _name]()
		end
	end
end

function loadProject(_projectName, _load)
	local prjFile = ""
	for _,path in ipairs(RTM_PROJECT_DIRS) do
		prjFile = path .. _projectName .. ".lua"
		if os.isfile(prjFile) then dofile(prjFile) break end
		prjFile = path .. _projectName .. "/genie/" .. _projectName .. ".lua"
		if os.isfile(prjFile) then dofile(prjFile) break end
	end

	_load = _load or ProjectLoad.LoadAndAdd
	if _load == ProjectLoad.LoadAndAdd then
		addProject(path.getbasename(prjFile))
	end
end

function getProjectDependencies(_name, _additionalDeps)
	local dep = {}
	if _G["projectDependencies_" .. _name] then
		dep = _G["projectDependencies_" .. _name]()
	end
	
	_additionalDeps = _additionalDeps or {}
	dep = mergeTables(dep, _additionalDeps)

	for _,dependency in ipairs(dep) do
		loadProject(dependency, ProjectLoad.LoadOnly)
	end

	local depNest = {}
	for _,d in ipairs(dep) do
		depNest = mergeTables(depNest, getProjectDependencies(d))
	end

	return mergeTables(dep, depNest)
end

-- can be called only ONCE from one project, merge dependencies before calling!!!
function addDependencies(_name, _additionalDeps)
	_dependencies = getProjectDependencies(_name, _additionalDeps)

	for _,dependency in ipairs(_dependencies) do
		addInclude(dependency)
	end
	
	if _dependencies ~= nil then
		for _,dependency in ipairs(_dependencies) do
			local shouldLink = true

			for _,dir in ipairs(RTM_PROJECT_DIRS) do
				shouldLink = shouldLink and addInclude(dir, dependency)
			end

			if shouldLink == true and isGENieProject(dependency) then
				links { dependency }
			end
		end
	end
	
	if _dependencies ~= nil then
		for _,dependency in ipairs(_dependencies) do
			loadProject(dependency)
		end
	end
end

function addLibProjects(_name)
	loadProject(_name)

	local projectDir = getProjectPath(_name)

	local sampleDirs = os.matchdirs(projectDir .. "/samples/*") 
	for _,dir in ipairs(sampleDirs) do
		local dirName = path.getbasename(dir)
		addProject_lib_sample(_name, dirName, _toolLib)
	end

	local testDir = projectDir .. "/test/"
	if os.isdir(testDir) then
		addProject_lib_test(_name)
 	end

	local toolsDirs = os.matchdirs(projectDir .. "/tools/*") 
	for _,dir in ipairs(toolsDirs) do
		local dirName = path.getbasename(dir)
		addProject_lib_tool(_name, dirName)
	end
end

function stripExtension( _path )
	local pathFS = _path:gsub("\\","/")
	return path.getdirectory(pathFS) .. "/" .. path.getbasename(pathFS)
end

function flatten(t)
	t = t or {}
	local tmp = {}
	for si,sv in ipairs(t) do
			if type( sv ) == "table" then
		for _,v in ipairs(sv) do
			table.insert(tmp, v)
		end
			elseif type( sv ) == "string" then
				table.insert( tmp, sv )
			end
		t[si] = nil
	end
	for _,v in ipairs(tmp) do
		table.insert(t, v)
	end
end

function readFile(_file)
    local f = io.open(_file, "r")
	if f == nil then return "" end
    local content = f:read("*all")
    f:close()
    return content
end

function recreateDir(_path)
	rmdir(_path)
	mkdir(_path)
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

