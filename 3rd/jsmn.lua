--
-- Copyright (c) 2017 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/zserge/jsmn

local params		= { ... }
local JSMN_ROOT		= params[1]

local JSMN_FILES = {
	JSMN_ROOT .. "jsmn.c",
	JSMN_ROOT .. "jsmn.h"
}

function projectAdd_jsmn()
	addProject_3rdParty_lib("jsmn", JSMN_FILES, false)
end

