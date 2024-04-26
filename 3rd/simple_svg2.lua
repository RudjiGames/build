--
-- Copyright 2024 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/jdryg/simple-svg.git

local params		= { ... }
local SIMPSVG2_ROOT	= params[1]

local SIMPSVG2_INCLUDE	= {
	SIMPSVG2_ROOT .. "include",
}

local SIMPSVG2_FILES		= {
	SIMPSVG2_ROOT .. "include/*.*",
	SIMPSVG2_ROOT .. "src/*.*",
}

function projectDependencies_simple_svg2()
	return { "bx" }
end

function projectExtraConfig_simple_svg2()
	includedirs { SIMPSVG2_INCLUDE }
	configuration { "debug or release" }
		defines { "BX_CONFIG_DEBUG=1" }
	configuration { "retail" }
		defines { "BX_CONFIG_DEBUG=0" }
	configuration {}
end

function projectAdd_simple_svg2()
	addProject_3rdParty_lib("simple_svg2", SIMPSVG2_FILES)
end
