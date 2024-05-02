--
-- Copyright 2024 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/netsurf-plan9/libdom.git

local params		= { ... }
local LIBWAP_ROOT	= params[1]

local LIBWAP_FILES = {
	LIBWAP_ROOT .. "src/**.c",
}

function projectDependencyConfig_libwapcaplet()
	includedirs { LIBWAP_ROOT .. "include" }
end

function projectExtraConfig_libwapcaplet()
	projectDependencyConfig_libwapcaplet()
end

function projectAdd_libwapcaplet()
	addProject_3rdParty_lib("libwapcaplet", LIBWAP_FILES)
end
