--
-- Copyright 2025 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/RudjiGames/nanosvg2

local params		= { ... }
local NANOSVG2_ROOT	= params[1]

local NANOSVG2_INCLUDE = {
	NANOSVG2_ROOT .. "src"
}

local NANOSVG2_FILES = {
	NANOSVG2_ROOT .. "src/**.*"
}

function projectExtraConfig_nanosvg2()
	includedirs { NANOSVG2_ROOT .. "src/" }
end

function projectHeaderOnlyLib_nanosvg2()
end

function projectAdd_nanosvg2()
	addProject_3rdParty_lib("nanosvg2", NANOSVG2_FILES)
end
