--
-- Copyright (c) 2023 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/MolecularMatters/raw_pdb

local params		= { ... }
local RAWPDB_ROOT	= params[1]

local RAWPDB_FILES = {
	RAWPDB_ROOT .. "src/Examples/ExampleMemoryMappedFile.cpp",
	RAWPDB_ROOT .. "src/Examples/ExampleMemoryMappedFile.h",
	RAWPDB_ROOT .. "src/Examples/ExampleMain.cpp",
	RAWPDB_ROOT .. "src/Foundstion/PDB**.cpp",
	RAWPDB_ROOT .. "src/Foundstion/PDB**.h",
	RAWPDB_ROOT .. "src/PDB**.h",
	RAWPDB_ROOT .. "src/PDB**.cpp"
}

function projectExtraConfig_raw_pdb()
	includedirs { RAWPDB_ROOT .. "src/" }
	forcedincludes {"cstdlib"}
end

function projectAdd_raw_pdb()
	addProject_3rdParty_lib("raw_pdb", RAWPDB_FILES)
end
