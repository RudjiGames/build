--
-- Copyright 2024 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/sheredom/subprocess.h

local params	= { ... }
local SUBP_ROOT	= params[1]

local SUBP_FILES = {
	SUBP_ROOT .. "subprocess.h",
}

function projectExtraConfig_subprocess_h()
	includedirs { SUBP_ROOT .. "include/" }
end

function projectHeaderOnlyLib_subprocess_h()
end

function projectAdd_subprocess_h()
	addProject_3rdParty_lib("subprocess_h", SUBP_FILES)
end
