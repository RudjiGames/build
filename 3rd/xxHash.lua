--
-- Copyright 2025 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/Cyan4973/xxHash.git

local params		= { ... }
local XXHASH_ROOT	= params[1]

local XXHASH_INCLUDE	= {
	XXHASH_ROOT
}

local XXHASH_FILES = {
	XXHASH_ROOT .. "xxh3.h",
	XXHASH_ROOT .. "xxhash*.c",
	XXHASH_ROOT .. "xxhash*.h"
}

function projectExtraConfig_xxHash()
	includedirs { XXHASH_INCLUDE }

	configuration { "vs*", "windows" }
			-- 4113 -  incompatible function pointer cast
			buildoptions { "/wd4113"}
	configuration {}
end

function projectAdd_xxHash()
	addProject_3rdParty_lib("xxHash", XXHASH_FILES)
end
