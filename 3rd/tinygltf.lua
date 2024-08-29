--
-- Copyright 2024 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/syoyo/tinygltf.git

local params		= { ... }
local TINYGLTF_ROOT	= params[1]

local TINYGLTF_INCLUDE = {
	TINYGLTF_ROOT
}

local TINYGLTF_FILES = {
	TINYGLTF_ROOT .. "tiny_gltf.h",
	TINYGLTF_ROOT .. "tiny_gltf.cc"
}

function projectExtraConfig_tinygltf()
	includedirs { TINYGLTF_ROOT .. "src/" }
	defines { "TINYGLTF_ALL_COLOR_KEYWORDS" }
end

function projectHeaderOnlyLib_tinygltf()
end

function projectAdd_tinygltf()
	addProject_3rdParty_lib("tinygltf", TINYGLTF_FILES)
end
