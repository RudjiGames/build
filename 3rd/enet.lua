--
-- Copyright 2023 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/lsalzman/enet

local params	= { ... }
local ENET_ROOT	= params[1]

local ENET_FILES = {
	ENET_ROOT .. "**h",
	ENET_ROOT .. "**.c"
}

function projectExtraConfig_enet()
	includedirs { ENET_ROOT .. "include/" }
end

function projectAdd_enet()
	addProject_3rdParty_lib("enet", ENET_FILES)
end

