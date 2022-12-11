--
-- Copyright (c) 2022 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/jrouwe/JoltPhysics

local params		= { ... }
local JOLT_ROOT		= params[1]

local JOLT_FILES	= {
	JOLT_ROOT .. "Jolt/**.cpp",
	JOLT_ROOT .. "Jolt/**.h"
}

function projectExtraConfig_jolt()
	includedirs { JOLT_ROOT }
	defines {
		"JPH_CROSS_PLATFORM_DETERMINISTIC"
	}

--	configuration {}
end

function projectAdd_jolt()
	addProject_3rdParty_lib("jolt", JOLT_FILES)
end
