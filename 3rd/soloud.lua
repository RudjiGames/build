--
-- Copyright (c) 2022 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/jarikomppa/soloud

local params		= { ... }
local SOLOUD_ROOT = params[1]

local SOLOUD_FILES = {
	SOLOUD_ROOT .. "src/core/**.cpp",
	SOLOUD_ROOT .. "src/audiosource/**.cpp",
	SOLOUD_ROOT .. "*.h"
}

function projectExtraConfig_soloud()
	includedirs { SOLOUD_ROOT .. "include" }
	configuration { "vs*" }
		defines { "WITH_XAUDIO2" }
	configuration { "asmjs" }
		defines { "WITH_MINIAUDIO" }
	configuration {}
end

function projectAdd_soloud()

	if getTargetOS() == "windows" then
		table.insert(SOLOUD_FILES, SOLOUD_ROOT .. "src/backend/xaudio2/**.*")
	end

	if getTargetOS() == "asmjs" then
		table.insert(SOLOUD_FILES, SOLOUD_ROOT .. "src/backend/miniaudio/**.*")
	end

	addProject_3rdParty_lib("soloud", SOLOUD_FILES)
end
