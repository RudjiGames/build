--
-- Copyright 2025 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/ufbx/ufbx.git

local params		= { ... }
local UFBX_ROOT		= params[1]

local UFBX_FILES = {
	UFBX_ROOT .. "ufbx.c",
	UFBX_ROOT .. "ufbx.h",
}

function projectExtraConfig_ufbx()
	includedirs { UFBX_ROOT .. "Include" }
end

function projectAdd_ufbx()
	addProject_3rdParty_lib("ufbx", UFBX_FILES)
end
