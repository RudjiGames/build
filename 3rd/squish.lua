--
-- Copyright (c) 2017 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

local params		= { ... }
local SQUISH_ROOT = params[1]

local SQUISH_FILES = {
	SQUISH_ROOT .. "*.cpp",
	SQUISH_ROOT .. "*.h"
}

function projectAdd_squish()
	addProject_3rdParty_lib("squish", SQUISH_FILES, false, SQUISH_ROOT)
end

