--
-- Copyright 2023 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/bkaradzic/bx

local params		= { ... }
local BX_ROOT		= params[1]

local BX_INCLUDE	= {
	BX_ROOT .. "include",
	BX_ROOT .. "3rdparty"
}

local BX_FILES = {
	BX_ROOT .. "include/bx/*.*",
	BX_ROOT .. "src/amalgamated.cpp",
}

function projectDependencyConfig_bx()
	configuration { "debug or release" }
		defines { "BX_CONFIG_DEBUG=1", "__STDC_FORMAT_MACROS" }
	configuration { "retail" }
		defines { "BX_CONFIG_DEBUG=0", "__STDC_FORMAT_MACROS" }
	configuration {}
end

function projectExtraConfig_bx()
 	configuration { "vs*", "windows" }
		buildoptions { "/wd4324" } -- 4324 -  structure was padded due to alignment specifier
	configuration {}
	includedirs { BX_INCLUDE }
	projectDependencyConfig_bx()
end

function projectAdd_bx()
	addProject_3rdParty_lib("bx", BX_FILES)
end

