--
-- Copyright 2023 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/milostosic/freetype2

local params			= { ... }
local FREETYPE2_ROOT	= params[1]

local FREETYPE2_FILES = {
	FREETYPE2_ROOT .. "src/**.c",
	FREETYPE2_ROOT .. "src/**.h"
}



function projectExtraConfig_freetype2()
	defines {"FT2_BUILD_LIBRARY" }
	includedirs { FREETYPE2_ROOT .. "include"}
	excludes { FREETYPE2_ROOT .. "src/tools/**.*" }
	excludes { FREETYPE2_ROOT .. "src/gzip/**.*" }
	excludes { FREETYPE2_ROOT .. "src/lzw/**.*" }
end

function projectAdd_freetype2()
	addProject_3rdParty_lib("freetype2", FREETYPE2_FILES)
end

