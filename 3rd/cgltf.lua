--
-- Copyright 2024 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/jkuhlmann/cgltf.git

local params		= { ... }
local CGLTF_ROOT	= params[1]

local CGLTF_INCLUDE	= {
	CGLTF_ROOT
}

local CGLTF_FILES = {
	CGLTF_ROOT .. "*.h"
}

function projectHeaderOnlyLib_cgltf()
end

function projectExtraConfig_cgltf()
	includedirs { CGLTF_INCLUDE }
	projectDependencyConfig_bx()
end

function projectAdd_cgltf()
	addProject_3rdParty_lib("cgltf", CGLTF_FILES)
end

