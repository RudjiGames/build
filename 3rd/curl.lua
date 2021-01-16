--
-- Copyright (c) 2018 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/curl/curl.git

local params		= { ... }
local CURL_ROOT		= params[1]

local CURL_FILES = {
	CURL_ROOT .. "lib/**.c",
	CURL_ROOT .. "lib/**.h",
	CURL_ROOT .. "src/*.c",
	CURL_ROOT .. "src/*.h"
}

local CURL_DEFINES = { "CURL_STATICLIB", "CURL_STRICTER", "CURL_DISABLE_LDAP" }

function projectExtraConfig_curl()
	includedirs {	CURL_ROOT .. "include",
					CURL_ROOT .. "lib" }

	defines { CURL_DEFINES }
	configuration { "vs20*", "windows" }
		buildoptions { '/wd"4005"' }
		defines {"USE_SSL", "USE_SCHANNEL", "USE_WINDOWS_SSPI"}
	configuration { 'linux' }
		defines {"HAVE_CONFIG_H", "CURL_HIDDEN_SYMBOLS"}
end

function projectExtraConfigExecutable_curl()
	configuration { "vs20*", "windows" }
		links { "Crypt32" }
end

function projectAdd_curl()
	addProject_3rdParty_lib("curl", CURL_FILES)
end

