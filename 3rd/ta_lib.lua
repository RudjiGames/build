--
-- Copyright (c) 2017 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- TA-Lib : Technical Analysis Library
-- https://github.com/milostosic/ta-lib

local params		= { ... }
local TA_LIB_ROOT	= params[1]

local TA_LIB_FILES = {
	TA_LIB_ROOT .. "src/ta_common/**h",
	TA_LIB_ROOT .. "src/ta_common/**.c",
	TA_LIB_ROOT .. "src/ta_func/**h",
	TA_LIB_ROOT .. "src/ta_func/**.c",
}

local TA_LIB_INCLUDES = { 
	TA_LIB_ROOT .. "include/",
	TA_LIB_ROOT .. "src/ta_common/" 
}

function projectExtraConfig_ta_lib()
	includedirs { TA_LIB_INCLUDES }
end

function projectAdd_ta_lib()
	addProject_3rdParty_lib("ta_lib", TA_LIB_FILES)
end

