--
-- Copyright 2025 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/dunkelstern/libsvgtiny.git

local params			= { ... }
local LIBSVGTINY_ROOT	= params[1]

local LIBSVGTINY_FILES = {
	LIBSVGTINY_ROOT .. "src/*.c",
	LIBSVGTINY_ROOT .. "src/*.h",
	LIBSVGTINY_ROOT .. "include/*.h"
}

function projectDependencies_libsvgtiny()
	return { "libxml2", "libdom" }
end 

function projectExtraConfig_libsvgtiny()
	includedirs { LIBSVGTINY_ROOT .. "include" }
end

function projectAdd_libsvgtiny()
	addProject_3rdParty_lib("libsvgtiny", LIBSVGTINY_FILES)
end
