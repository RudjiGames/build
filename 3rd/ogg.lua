--
-- Copyright 2025 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/xiph/ogg

local params	= { ... }
local OGG_ROOT	= params[1]

local OGG_FILES = {
	OGG_ROOT .. "src/**.c",
	OGG_ROOT .. "src/**.h"
}

function projectDependencies_ogg()
	return {}
end

function projectExtraConfig_ogg()
	includedirs { OGG_ROOT .. "include" }
end

function projectExtraConfigExecutable_ogg()
	includedirs { OGG_ROOT .. "include" }
end

function projectAdd_ogg()
	addProject_3rdParty_lib("ogg", OGG_FILES)
end
