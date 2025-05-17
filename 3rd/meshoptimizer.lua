--
-- Copyright 2025 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/zeux/meshoptimizer

local params		= { ... }
local MESHOPT_ROOT	= params[1]

local MESHOPT_INCLUDE	= {
	MESHOPT_ROOT .. "src",
}

local MESHOPT_FILES = {
	MESHOPT_ROOT .. "src/**.cpp",
	MESHOPT_ROOT .. "src/**.h"
}

function projectExtraConfig_meshoptimizer()
	includedirs { MESHOPT_INCLUDE }
end

function projectAdd_meshoptimizer()
	addProject_3rdParty_lib("meshoptimizer", MESHOPT_FILES)
end
