--
-- Copyright 2025 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/edubart/minilua.git

local params		= { ... }
local MINILUA_ROOT	= params[1]

local MINILUA_INCLUDE	= {
	MINILUA_ROOT
}

local MINILUA_FILES = {
	MINILUA_ROOT .. "src/**.h"
}

function projectExtraConfig_minilua()
	includedirs { MINILUA_INCLUDE }
end

function projectHeaderOnlyLib_minilua()
end

function projectAdd_minilua()
	addProject_3rdParty_lib("minilua", MINILUA_FILES)
end
