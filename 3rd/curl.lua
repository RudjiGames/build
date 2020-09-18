--
-- Copyright (c) 2018 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/curl/curl.git

local params		= { ... }
local CURL_ROOT		= params[1]
print(CURL_ROOT)
local CURL_FILES = {
	CURL_ROOT .. "lib/*.c",
	CURL_ROOT .. "lib/*.h",
	CURL_ROOT .. "src/*.c",
	CURL_ROOT .. "src/*.h"
}

local CURL_DEFINES = { "CURL_STATICLIB", "CURL_STRICTER" }

function projectExtraConfig_curl()
	includedirs {	CURL_ROOT .. "include",
					CURL_ROOT .. "lib" }

	defines { CURL_DEFINES }
	configuration { "vs20*", "windows" }
		buildoptions { '/wd"4005"' }
end

function projectAdd_curl()
	addProject_3rdParty_lib("curl", CURL_FILES)
end

