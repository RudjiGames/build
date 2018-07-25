--
-- Copyright (c) 2018 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/libuv/libuv

local params		= { ... }
local LUV_ROOT		= params[1]

local LUV_FILES = {
	LUV_ROOT .. "src/*.c",
	LUV_ROOT .. "src/**.h"
}

local LUV_FILES_WIN = {
	LUV_ROOT .. "src/win/**.c",
	LUV_ROOT .. "src/win/**.h"
}

local LUV_FILES_UNIX = {
	LUV_ROOT .. "src/unix/**.c",
	LUV_ROOT .. "src/unix/**.h"
}

if os.is("windows") then
	LUV_FILES = mergeTables(LUV_FILES, LUV_FILES_WIN)
else
	LUV_FILES = mergeTables(LUV_FILES, LUV_FILES_UNIX)
end

local LUV_INCLUDES	= {
	LUV_ROOT .. "include/",
	LUV_ROOT .. "src/"
}

function projectExtraConfig_libuv()
	includedirs { LUV_INCLUDES }
end

function projectAdd_libuv()
	addProject_3rdParty_lib("libuv", LUV_FILES)
end

