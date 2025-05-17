--
-- Copyright 2025 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/nothings/stb.git

local params	= { ... }
local STB_ROOT	= params[1]

local STB_FILES = {
	STB_ROOT .. "stb_vorbis.c",
	STB_ROOT .. "*.h"
}

function projectExtraConfig_stb()
	includedirs { STB_ROOT }
end

function projectAdd_stb()
	addProject_3rdParty_lib("stb", STB_FILES)
end
