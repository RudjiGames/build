--
-- Copyright 2025 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/netsurf-plan9/libdom.git

local params		= { ... }
local LIBDOM_ROOT	= params[1]

local LIBDOM_FILES = {
	LIBDOM_ROOT .. "bindings/xml/libxml_xmlparser.c",
	LIBDOM_ROOT .. "src/**.c",
	LIBDOM_ROOT .. "src/**.h",
}

function projectDependencies_libdom()
	return { "libwapcaplet", "libparserutils", "libxml2" }
end 

function projectDependencyConfig_libdom()
	if getTargetOS() == "windows" then
		links { "Bcrypt" }
	end
	includedirs { LIBDOM_ROOT .. "include",
				  LIBDOM_ROOT .. "include/dom" }
end

function projectExtraConfig_libdom()
	defines {"PRIu32="}
	includedirs { LIBDOM_ROOT .. "src",
				  LIBDOM_ROOT .. "include",
				  LIBDOM_ROOT .. "include/dom" }
end

function projectAdd_libdom()
	addProject_3rdParty_lib("libdom", LIBDOM_FILES)
end
