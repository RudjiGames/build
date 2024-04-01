--
-- Copyright 2023 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/uNetworking/uWebSockets

local params		= { ... }
local UWS_ROOT		= params[1]

local UWS_FILES = {
	UWS_ROOT .. "src/**.cpp",
	UWS_ROOT .. "src/**.h"
}

function projectDependencies_uwebsockets()
	return { "wolfssl", "libuv", "zlib" }
end 

function projectExtraConfigExecutable_uwebsockets()
	flags   { "Cpp17" }
end

function projectHeaderOnlyLib_uwebsockets()
end

function projectExtraConfig_uwebsockets()
	defines {  "WITH_WOLFSSL=1", "WITH_LIBUV=1"  }
	flags   { "Cpp17" }
end
function projectAdd_uwebsockets()
	addProject_3rdParty_lib("uwebsockets", UWS_FILES)
end
