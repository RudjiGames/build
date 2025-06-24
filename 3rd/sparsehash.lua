--
-- Copyright 2025 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/sparsehash/sparsehash.git

local params		= { ... }
local SPARSEH_ROOT	= params[1]

local SPARSEH_FILES = {
	SPARSEH_ROOT .. "src/sparsehash/*.*"
}

function projectExtraConfig_sparsehash()
	includedirs { SPARSEH_ROOT .. "src" }
	if getTargetOS() == "windows" then
		includedirs { SPARSEH_ROOT .. "src/windows" }	
	end
end

function projectExtraConfigExecutable_sparsehash()
	projectExtraConfig_sparsehash()
end

function projectHeaderOnlyLib_sparsehash()
end

function projectAdd_sparsehash()
	if getTargetOS() ~= "windows" then
		os.execute(SPARSEH_ROOT .. "configure")
		os.execute("cp " .. SPARSEH_ROOT .. "src/config.h " .. SPARSEH_ROOT .. "src/sparsehash/internal/sparseconfig.h")
	end

	addProject_3rdParty_lib("sparsehash", SPARSEH_FILES)
end
