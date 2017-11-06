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
		if  not (getTargetOS() == "durango")	and 
			not (getTargetOS() == "orbis")		and
			not (getTargetOS() == "winphone8")	and
			not (getTargetOS() == "winphone81")	
--			not (getTargetOS() == "winstore81")	and
--			not (getTargetOS() == "winstore82") 
			then -- these platforms set their own platform config
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
	local mergedTable = {}
	local hash = {}
	for _,v1 in ipairs(_table1) do 
		if (not hash[v1]) then
			table.insert(mergedTable, v1)
			hash[v1] = true
		end
	end
	for _,v2 in ipairs(_table2) do 
		if (not hash[v2]) then
			table.insert(mergedTable, v2)
			hash[v2] = true
		end
	end
	return mergedTable
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
		shortname			= _name,
		longname			= _name,
		description			= _name .. " description",
		logo_square			= RTM_SCRIPTS_DIR .. "deploy/res/logo_square.png",
		logo_wide			= RTM_SCRIPTS_DIR .. "deploy/res/logo_wide.png"
	}
end

ProjectPath = {
	Dir		= {},
	Root	= {}
}

function istable(_var)
	return type(_var) == "table"
end

function isGENieProject(_projectName)
	local basename = getProjectBaseName(_projectName)
	local projectParentDir = getProjectPath(_projectName, ProjectPath.Root)
	if os.isfile(projectParentDir .. basename .. ".lua") then return true end
	if os.isfile(projectParentDir .. basename .. "/genie/genie.lua") then return true end
	return false
end

function getProjectBaseName(_projectName)
	if istable(_projectName) then
		for _,name in ipairs(_projectName) do
			return name
		end
	end
	return _projectName
end

function getProjectFullName(_projectName)
	if istable(_projectName) then
		local ret = ""
		for _,name in ipairs(_projectName) do
			if ret == "" then ret = name else ret = ret .. "_" .. name end
		end
		return ret
	else
		return _projectName
	end
end

function find3rdPartyProject(_name)
	local name = getProjectBaseName(_name)
	for _,dir in ipairs(RTM_PROJECT_DIRS) do
		local libDir = dir .. name
		if os.isdir(libDir) then 
			return libDir
		end
	end
	return nil	
end

function getProjectPath(_name, _pathType)
	local name = getProjectBaseName(_name)
	_pathType = _pathType or ProjectPath.Dir
	for _,dir in ipairs(RTM_PROJECT_DIRS) do
		local libDir = dir .. name
		if os.isdir(libDir) then 
			if _pathType == ProjectPath.Dir then
				return libDir .. "/" 
			else
				return dir
			end
		end
	end

	local projectPath = find3rdPartyProject(_name)
	if projectPath == nil then return "" end

	if _pathType == ProjectPath.Root then
		return path.getabsolute(projectPath .. "../") .. "/"
	else
		return projectPath
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
	assert(_path ~= nil)
	if string.len(_path) == 0 then return end
	if os.isdir(_path) then includedirs { _path } end
end

function addInclude(_baseDir, _projectName)
	local basename = getProjectBaseName(_projectName)
	local fullname = getProjectFullName(_projectName)

	local projectParentDir = getProjectPath(_projectName, ProjectPath.Root)
	if projectParentDir == nil then return false end

	addIncludePath(projectParentDir)
	addIncludePath(projectParentDir .. basename .. "/include")
	addIncludePath(projectParentDir .. basename .. "/inc")

	local linkFn = _G["projectLink_" .. fullname]
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

	local name = getProjectFullName(_name)
	
	if g_projectIsLoaded[name] == nil then
		g_projectIsLoaded[name] = true
		if _G["projectAdd_" .. name] ~= nil then -- prebuilt libs have no projects
			_G["projectAdd_" .. name]()
		end
	end
end

function configDependency(_name, dependency)
	local name = getProjectFullName(_name)
	if _G["projectDependencyConfig_" .. name] ~= nil then -- prebuilt libs have no projects
		return _G["projectDependencyConfig_" .. name](dependency)
	end
	return dependency
end

function loadProject(_projectName, _load)
	local name = getProjectBaseName(_projectName)

	local prjFile = ""
	for _,path in ipairs(RTM_PROJECT_DIRS) do
		prjFile = path .. name .. ".lua"
		if os.isfile(prjFile) then assert(loadfile(prjFile))(find3rdPartyProject(name)) break end
		prjFile = path .. name .. "/genie/" .. name .. ".lua"
		if os.isfile(prjFile) then dofile(prjFile) break end
	end

	_load = _load or ProjectLoad.LoadAndAdd
	if _load == ProjectLoad.LoadAndAdd then
		addProject(_projectName)
	end
end

function getProjectDependencies(_name, _additionalDeps)
	local fullName = getProjectFullName(_name)

	local dep = {}
	if _G["projectDependencies_" .. fullName] then
		dep = _G["projectDependencies_" .. fullName]()
	end
	
	_additionalDeps = _additionalDeps or {}
	dep = mergeTables(dep, _additionalDeps)

	local finalDep = {}
	for _,dependency in ipairs(dep) do
		table.insert(finalDep, configDependency(_name, dependency))
	end

	for _,dependency in ipairs(finalDep) do
		loadProject(dependency, ProjectLoad.LoadOnly)
	end

	local depNest = {}
	for _,d in ipairs(finalDep) do
		depNest = mergeTables(depNest, getProjectDependencies(d))
	end

	finalDep = mergeTables(finalDep, depNest)

	return finalDep
end

-- can be called only ONCE from one project, merge dependencies before calling!!!
function addDependencies(_name, _additionalDeps)
	_dependencies = getProjectDependencies(_name, _additionalDeps)
	
	if _dependencies ~= nil then
		for _,dependency in ipairs(_dependencies) do
			local shouldLink = true

			for _,dir in ipairs(RTM_PROJECT_DIRS) do
				shouldLink = shouldLink and addInclude(dir, dependency)
			end

			if shouldLink == true and isGENieProject(dependency) then
				links { getProjectFullName(dependency) }
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

	if istable(_name) then return end	-- TODO: samples to link against the right library version

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

