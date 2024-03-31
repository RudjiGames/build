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
	if os.is("windows") then
		return { "libuv", "zlib" }
	else
		return { "openssl", "libuv", "zlib" }
	end
end 

function projectExtraConfigExecutable_uwebsockets()
	flags   { "Cpp17" }
end

function projectExtraConfig_uwebsockets()
	defines { "WITH_OPENSSL=1" }
	flags   { "Cpp17" }
end

function projectNoBuild_uwebsockets()
end

function projectAdd_uwebsockets()
--	addProject_3rdParty_lib("uwebsockets", UWS_FILES)
end
