--
-- Copyright (c) 2018 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/Cavewhere/squish.git

local params		= { ... }
local SQUISH_ROOT = params[1]

local SQUISH_FILES = {
	SQUISH_ROOT .. "*.cpp",
	SQUISH_ROOT .. "*.h"
}

function projectExtraConfig_squish()
	includedirs { SQUISH_ROOT }
end

function projectAdd_squish()
	addProject_3rdParty_lib("squish", SQUISH_FILES)
end

