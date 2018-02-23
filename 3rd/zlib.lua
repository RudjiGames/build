--
-- Copyright (c) 2017 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/madler/zlib

local params		= { ... }
local ZLIB_ROOT		= params[1]

local ZLIB_FILES = {
	ZLIB_ROOT .. "*.c",
	ZLIB_ROOT .. "*.h"
}

local ZLIB_DEFINES = {}
if getTargetOS() == "android" then
	ZLIB_DEFINES = {
		"fopen64=fopen",
		"ftello64=ftell",
		"fseeko64=fseek",
	}
end

function projectAdd_zlib()
	addProject_3rdParty_lib("zlib", ZLIB_FILES, false, {}, ZLIB_DEFINES)
end

