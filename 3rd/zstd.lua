--
-- Copyright 2023 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/facebook/zstd.git

local params		= { ... }
local ZSTD_ROOT		= params[1]

local ZSTD_FILES = {
	ZSTD_ROOT .. "lib/**.c",
	ZSTD_ROOT .. "lib/**.h",
	ZSTD_ROOT .. "include/**.h"
}

function projectExtraConfig_zstd()
	includedirs { ZSTD_ROOT .. "lib" }
end

function projectAdd_zstd()
	addProject_3rdParty_lib("zstd", ZSTD_FILES)
end
