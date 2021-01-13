--
-- Copyright (c) 2018 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/dougbinks/enkiTS

local params		= { ... }
local ENKITS_ROOT	= params[1]

local ENKITS_FILES = {
	ENKITS_ROOT .. "**h",
	ENKITS_ROOT .. "src/**.*"
}

function projectExtraConfig_enkits()
	includedirs { ENKITS_ROOT .. "include/" }
end

function projectAdd_enkits()
	addProject_3rdParty_lib("enkits", ENKITS_FILES)
end
