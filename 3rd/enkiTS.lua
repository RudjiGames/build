--
-- Copyright 2025 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/dougbinks/enkiTS

local params		= { ... }
local ENKITS_ROOT	= params[1]

local ENKITS_FILES = {
	ENKITS_ROOT .. "**h",
	ENKITS_ROOT .. "src/**.*"
}

function projectExtraConfig_enkiTS()
 	configuration { "vs*", "windows" }
		buildoptions { "/wd4100" } -- 4100: 'pETS_': unreferenced formal parameter
	configuration { "linux-* or *clang*" }
		buildoptions {
			"-Wunused-variable -Wunused-function"
		}
	configuration {}

	includedirs { ENKITS_ROOT .. "include/" }
end

function projectAdd_enkiTS()
	addProject_3rdParty_lib("enkiTS", ENKITS_FILES)
end
