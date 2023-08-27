--
-- Copyright (c) 2023 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/MolecularMatters/raw_pdb

local params		= { ... }
local RAWPDB_ROOT	= params[1]

local RAWPDB_FILES = {
	RAWPDB_ROOT .. "src/**.h",
	RAWPDB_ROOT .. "src/**.cpp",
}

function projectExtraConfig_raw_pdb()
	includedirs { RAWPDB_ROOT .. "src/" }
end

function projectAdd_raw_pdb()
	addProject_3rdParty_lib("raw_pdb", RAWPDB_FILES)
end
