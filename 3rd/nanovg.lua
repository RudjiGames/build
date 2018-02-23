--
-- Copyright (c) 2017 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/memononen/nanovg

local params		= { ... }
local NANOVG_ROOT	= params[1]
local NANOVG_INC	= NANOVG_ROOT .. "src/"

local NANOVG_FILES = {
	NANOVG_INC .. "**.*"
}

function projectAdd_nanovg()
	addProject_3rdParty_lib("nanovg", NANOVG_FILES, false, NANOVG_INC)
end

