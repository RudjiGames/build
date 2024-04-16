--
-- Copyright 2023 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/Chlumsky/msdfgen

local params		= { ... }
local MSDFGEN_ROOT	= params[1]

local MSDFGEN_FILES = {
	MSDFGEN_ROOT .. "core/**.*",
	MSDFGEN_ROOT .. "ext/**.*",
}

function projectExtraConfig_msdfgen()
	defines { "MSDFGEN_PUBLIC= " } -- static link
end

function projectDependencies_msdfgen()
	return { "freetype2", "tinyxml2" }
end 

function projectAdd_msdfgen()
	addProject_3rdParty_lib("msdfgen", MSDFGEN_FILES)
end

