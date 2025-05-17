--
-- Copyright 2025 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/memononen/libtess2.git

local params		= { ... }
local LIBTESS2_ROOT	= params[1]

local LIBTESS2_FILES = {
	LIBTESS2_ROOT .. "Source/*.c",
	LIBTESS2_ROOT .. "Source/*.h",
}

function projectExtraConfig_libtess2()
	includedirs { LIBTESS2_ROOT .. "Include" }
end

function projectAdd_libtess2()
	addProject_3rdParty_lib("libtess2", LIBTESS2_FILES)
end
