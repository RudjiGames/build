--
-- Copyright 2024 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/edubart/tomlplusplus.git

local params		= { ... }
local TOMLPP_ROOT	= params[1]

local TOMLPP_INCLUDE	= {
	TOMLPP_ROOT .. "include"
}

local TOMLPP_FILES = {
	TOMLPP_ROOT .. "include/**.h",
	TOMLPP_ROOT .. "src/**.cpp"
}

function projectExtraConfig_tomlplusplus()
	includedirs { TOMLPP_INCLUDE }
end

function projectAdd_tomlplusplus()
	addProject_3rdParty_lib("tomlplusplus", TOMLPP_FILES)
end
