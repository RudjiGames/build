--
-- Copyright 2025 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/SpartanJ/efsw

local params		= { ... }
local EFSW_ROOT		= params[1]

local EFSW_INCLUDE	= {
	EFSW_ROOT .. "include",
	EFSW_ROOT .. "src",
}

local EFSW_FILES = {
	EFSW_ROOT .. "include/**.h",
	EFSW_ROOT .. "src/efsw/**.h",
	EFSW_ROOT .. "src/efsw/**.cpp"
}

function projectExtraConfig_efsw()
	includedirs { EFSW_INCLUDE }
end

function projectAdd_efsw()
	addProject_3rdParty_lib("efsw", EFSW_FILES)
end
