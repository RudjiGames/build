--
-- Copyright (c) 2017 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/lsalzman/enet

local params	= { ... }
local ENET_ROOT	= params[1]
local ENET_INC	= ENET_ROOT .. "include/"

local ENET_FILES = {
	ENET_ROOT .. "**h",
	ENET_ROOT .. "**.c"
}

function projectAdd_enet()
	addProject_3rdParty_lib("enet", ENET_FILES, false, ENET_INC)
end

