--
-- Copyright 2024 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/LLNL/zfp.git

local params		= { ... }
local ZFP_ROOT	= params[1]

local ZFP_INCLUDE	= {
	ZFP_ROOT .. "include",
	ZFP_ROOT .. "src"
}

local ZFP_FILES = {
	ZFP_ROOT .. "include/**.h",
	ZFP_ROOT .. "src/*.c",
	ZFP_ROOT .. "src/*.h"
}

function projectExtraConfig_zfp()
	includedirs { ZFP_INCLUDE }
end

function projectAdd_zfp()
	addProject_3rdParty_lib("zfp", ZFP_FILES)
end
