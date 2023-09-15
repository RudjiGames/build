--
-- Copyright 2023 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/gabime/spdlog

local params		= { ... }
local SPDLOG_ROOT	= params[1]

local SPDLOG_INCLUDE	= {
	SPDLOG_ROOT .. "include",
}

local SPDLOG_FILES		= {
	SPDLOG_ROOT .. "include/*.*",
	SPDLOG_ROOT .. "src/*.*",
}

function projectExtraConfig_spdlog()
	includedirs { SPDLOG_INCLUDE }
	defines { "SPDLOG_COMPILED_LIB" }
	configuration "vs*"
		buildoptions { "/wd 4530" }
end

function projectAdd_spdlog()
	addProject_3rdParty_lib("spdlog", SPDLOG_FILES)
end
