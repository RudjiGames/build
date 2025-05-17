--
-- Copyright 2025 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/BinomialLLC/basis_universal

local params	    	= { ... }
local BASIS_ROOT    	= params[1]

local BASIS_INCLUDE	= {
	BASIS_ROOT .. "encoder",
	BASIS_ROOT .. "transcoder",
}

local BASIS_FILES = {
	BASIS_ROOT .. "encoder/**.h",
	BASIS_ROOT .. "encoder/**.cpp",
	BASIS_ROOT .. "transcoder/**.h",
    BASIS_ROOT .. "transcoder/**.cpp",
    BASIS_ROOT .. "transcoder/**.inc"
} 

function projectDependencies_basis_universal()
	return {}
end 

function projectExtraConfig_basis_universal()
	includedirs { BASIS_INCLUDE }
end

function projectAdd_basis_universal()
	addProject_3rdParty_lib("basis_universal", BASIS_FILES)
end
