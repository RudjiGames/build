--
-- Copyright 2024 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/RudjiGames/nanosvg2.git

local params		= { ... }
local NANOSVG_ROOT	= params[1]

local NANOSVG_INCLUDE = {
	NANOSVG_ROOT .. "src"
}

local NANOSVG_FILES = {
	NANOSVG_ROOT .. "src/**.*"
}

function projectExtraConfig_nanosvg2()
	includedirs { NANOSVG_ROOT .. "src/" }
	defines { "NANOSVG_ALL_COLOR_KEYWORDS" }
end

function projectHeaderOnlyLib_nanosvg2()
end

function projectAdd_nanosvg2()
	addProject_3rdParty_lib("nanosvg2", NANOSVG_FILES)
end
