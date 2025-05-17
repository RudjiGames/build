--
-- Copyright 2025 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/xiph/vorbis

local params		= { ... }
local VORBIS_ROOT	= params[1]

local VORBIS_FILES = {
	VORBIS_ROOT .. "lib/**.c",
	VORBIS_ROOT .. "lib/**.h"
}

function projectDependencies_vorbis()
	return { "ogg" }
end

function projectExtraConfig_vorbis()
	defines { "M_PI=(3.1415926536f)" }
	excludes {	VORBIS_ROOT .. "lib/misc.c",
				VORBIS_ROOT .. "lib/tone.c",
				VORBIS_ROOT .. "lib/psytune.c"
	}
	includedirs { VORBIS_ROOT .. "include" }
end

function projectExtraConfigExecutable_vorbis()
	includedirs { VORBIS_ROOT .. "include" }
end

function projectAdd_vorbis()
	addProject_3rdParty_lib("vorbis", VORBIS_FILES)
end
