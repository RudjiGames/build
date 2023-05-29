--
-- Copyright (c) 2018 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/leethomason/tinyxml2

local params		= { ... }
local TINYXML2_ROOT	= params[1]

local TINYXML2_FILES = {
	TINYXML2_ROOT .. "tinyxml2.h",
	TINYXML2_ROOT .. "tinyxml2.cpp"
}

function projectExtraConfig_tinyxml2()
	includedirs { TINYXML2_ROOT }
end

function projectAdd_tinyxml2()
	addProject_3rdParty_lib("tinyxml2", TINYXML2_FILES)
end
