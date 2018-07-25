--
-- Copyright (c) 2018 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/turbulenz/NvTriStrip

local params			= { ... }
local NVTRISTRIP_ROOT	= params[1]

local NVTRISTRIP_FILES = {
	NVTRISTRIP_ROOT .. "NvTriStrip/src/NvTriStrip.cpp",
	NVTRISTRIP_ROOT .. "NvTriStrip/src/NvTriStripObjects.cpp",
	NVTRISTRIP_ROOT .. "NvTriStrip/src/NvTriStripObjects.h",
	NVTRISTRIP_ROOT .. "NvTriStrip/src/VertexCache.h"
}

function projectExtraConfig_NvTriStrip()
	includedirs { NVTRISTRIP_ROOT .. "NvTriStrip/include" }
end

function projectAdd_NvTriStrip()
	addProject_3rdParty_lib("NvTriStrip", NVTRISTRIP_FILES)
end

