--
-- Copyright (c) 2017 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/bkaradzic/bgfx

local params		= { ... }
local BGFX_ROOT		= params[1]

local BGFX_INCLUDE	= {
	BGFX_ROOT .. "include",
	BGFX_ROOT .. "3rdparty",
	BGFX_ROOT .. "3rdparty/khronos",
	BGFX_ROOT .. "3rdparty/dxsdk/include",
	find3rdPartyProject("bx") .. "include",
	find3rdPartyProject("bimg") .. "include" 
}

local BFGX_FILES = {
	BGFX_ROOT .. "src/amalgamated.cpp",
	BGFX_ROOT .. "include/**.h"
}

function projectDependencies_bgfx()
	local dependencies = { "bx", "bimg" }
	if (getTargetOS() == "linux" or getTargetOS() == "freebsd") and _OPTIONS["with-glfw"] then
		table.insert(dependencies, "GL")
	end
	return dependencies
end 

function projectAdd_bgfx()
	local BGFX_DEFINES = {}
	if _OPTIONS["with-glfw"] then
		BGFX_DEFINES = { "BGFX_CONFIG_MULTITHREADED=0" }		
	end	
	addProject_3rdParty_lib("bgfx", BFGX_FILES, false, BGFX_INCLUDE, BGFX_DEFINES)
end

