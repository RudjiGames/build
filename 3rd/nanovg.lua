--
-- Copyright 2023 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/memononen/nanovg

local params		= { ... }
local NANOVG_ROOT	= params[1]

local NANOVG_INCLUDE = {
	NANOVG_ROOT .. "src"
}

local NANOVG_FILES = {
	NANOVG_ROOT .. "src/**.*"
}

function projectExtraConfig_nanovg()
	includedirs { NANOVG_ROOT .. "src/" }

 	configuration { "vs*", "windows" }	
		buildoptions { "/wd4244" } -- 4324 - '=': conversion from 'int' to 'stbi_uc', possible loss of data
 	configuration {}	
end

function projectAdd_nanovg()
	addProject_3rdParty_lib("nanovg", NANOVG_FILES)
end
