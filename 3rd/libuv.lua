--
-- Copyright 2025 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/libuv/libuv.git

local params		= { ... }
local LIBUV_ROOT	= params[1]

local LIBUV_FILES = {
	LIBUV_ROOT .. "src/*.c",
	LIBUV_ROOT .. "src/*.h",
}

local LIBUV_FILES_WIN = {
	LIBUV_ROOT .. "src/win/*.c",
	LIBUV_ROOT .. "src/win/*.h",
}

local LIBUV_FILES_UNIX = {
	LIBUV_ROOT .. "src/unix/*.c",
	LIBUV_ROOT .. "src/unix/*.h",
}

if getTargetOS() == "windows" then
	LIBUV_FILES = mergeTables(LIBUV_FILES, LIBUV_FILES_WIN)
else
	LIBUV_FILES = mergeTables(LIBUV_FILES, LIBUV_FILES_UNIX)
end

local LIBUV_DEFINES = {}

function projectExtraConfig_libuv()
	defines { LIBUV_DEFINES }
	includedirs { LIBUV_ROOT .. "include" }
	includedirs { LIBUV_ROOT .. "src" }
end

function projectAdd_libuv()
	addProject_3rdParty_lib("libuv", LIBUV_FILES)
end
