--
-- Copyright 2024 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/Chlumsky/msdf-atlas-gen.git

local params			= { ... }
local MSDFATLASGEN_ROOT	= params[1]

local MSDFATLASGEN_FILES = {
	MSDFATLASGEN_ROOT .. "msdf-atlas-gen/**.*",
}

function projectExtraConfig_msdf_atlas_gen()
	includedirs {
		MSDFATLASGEN_ROOT,
		MSDFATLASGEN_ROOT .. "msdfgen",
		MSDFATLASGEN_ROOT .. "artery-font-format"		
	}
	defines { "MSDFGEN_PUBLIC= " } -- static link
end

function projectDependencies_msdf_atlas_gen()
	return { "freetype2", "tinyxml2" }
end 

function projectAdd_msdf_atlas_gen()
	addProject_3rdParty_lib("msdf_atlas_gen", MSDFATLASGEN_FILES)
end
