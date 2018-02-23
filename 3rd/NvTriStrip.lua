--
-- Copyright (c) 2017 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/turbulenz/NvTriStrip

local params			= { ... }
local NVTRISTRIP_ROOT	= params[1]
local NVTRISTRIP_INC	= { NVTRISTRIP_ROOT .. "NvTriStrip/include" }

local NVTRISTRIP_FILES = {
	NVTRISTRIP_ROOT .. "NvTriStrip/src/NvTriStrip.cpp",
	NVTRISTRIP_ROOT .. "NvTriStrip/src/NvTriStripObjects.cpp",
	NVTRISTRIP_ROOT .. "NvTriStrip/src/NvTriStripObjects.h",
	NVTRISTRIP_ROOT .. "NvTriStrip/src/VertexCache.h"
}

function projectAdd_NvTriStrip()
	addProject_3rdParty_lib("NvTriStrip", NVTRISTRIP_FILES, false, NVTRISTRIP_INC)
end

