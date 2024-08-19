--
-- Copyright 2024 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/msteinbeck/tinyspline.git

local params		= { ... }
local TSPLINE_ROOT	= params[1]

local TSPLINE_FILES = {
	TSPLINE_ROOT .. "src/tinyspline.h",
	TSPLINE_ROOT .. "src/tinyspline.c"
}

function projectExtraConfig_tinyspline()
	includedirs { TSPLINE_ROOT .. "src/" }
end

function projectAdd_tinyspline()
	addProject_3rdParty_lib("tinyspline", TSPLINE_FILES)
end

