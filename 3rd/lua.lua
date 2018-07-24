--
-- Copyright (c) 2017 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/lua/lua

local params	= { ... }
local LUA_ROOT	= params[1]

local LUA_FILES = {
	LUA_ROOT .. "src/**.c",
	LUA_ROOT .. "src/**.h"
}

local LUA_DEFINES = {}
if getTargetOS() == "android" then
	lua_defines = { "l_getlocaledecpoint()='.'" }
end

function projectExtraConfig_lua()
	defines { LUA_DEFINES }
end

function projectAdd_lua()
	addProject_3rdParty_lib("lua", LUA_FILES)
end

