--
-- Copyright 2025 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/memononen/nanosvg

local params		= { ... }
local NANOSVG_ROOT	= params[1]

local NANOSVG_INCLUDE = {
	NANOSVG_ROOT .. "src"
}

local NANOSVG_FILES = {
	NANOSVG_ROOT .. "src/**.*"
}

function projectExtraConfig_nanosvg()
	includedirs { NANOSVG_ROOT .. "src/" }
end

function projectHeaderOnlyLib_nanosvg()
end

function projectAdd_nanosvg()
	addProject_3rdParty_lib("nanosvg", NANOSVG_FILES)
end
