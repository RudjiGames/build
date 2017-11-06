--
-- Copyright (c) 2017 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

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
	return { "bx", "bimg" }
end 

function projectAdd_bgfx()
	addProject_3rdParty_lib("bgfx", BFGX_FILES, false, BGFX_INCLUDE)
end

