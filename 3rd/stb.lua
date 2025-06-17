--
-- Copyright 2025 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/nothings/stb.git

local params	= { ... }
local STB_ROOT	= params[1]

local STB_FILES = {
	STB_ROOT .. "stb_vorbis.c",
	STB_ROOT .. "*.h"
}

function projectExtraConfig_stb()
	includedirs { STB_ROOT }

 	configuration { "vs*", "windows" }
		-- : '=': conversion from '' to '', possible loss of data
		-- : declaration of '' hides previous local declaration
		-- : declaration of '' hides function parameter
		-- : '=': conversion from '' to '', signed/unsigned mismatch
		-- : potentially uninitialized local variable '' used
		buildoptions { "/wd4244 /wd4456 /wd4457 /wd4245 /wd4701" }
	configuration { "linux-* or *clang*" }
		buildoptions_c { "-Wno-shadow" }
	configuration {}
end

function projectAdd_stb()
	addProject_3rdParty_lib("stb", STB_FILES)
end
