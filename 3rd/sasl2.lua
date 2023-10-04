--
-- Copyright 2023 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/cyrusimap/cyrus-sasl.git

local params		= { ... }
local SASL2_ROOT	= params[1]

local SASL2_FILES = {
	SASL2_ROOT .. "lib/auxprop.c",
	SASL2_ROOT .. "lib/canonusr.c",
	SASL2_ROOT .. "lib/checkpw.c",
	SASL2_ROOT .. "lib/client.c",
	--SASL2_ROOT .. "lib/common.c",
	SASL2_ROOT .. "lib/config.c",
	SASL2_ROOT .. "lib/external.c",
	SASL2_ROOT .. "lib/saslutil.c",
	SASL2_ROOT .. "lib/server.c",
	SASL2_ROOT .. "lib/seterror.c",
}

function projectDependencies_sasl2()
	return { "openssl" }
end

function projectExtraConfig_sasl2()
	includedirs {	SASL2_ROOT .. "include",
					SASL2_ROOT .. "lib" }

	defines { "SASL2_STATICLIB", "BUILDING_LIBSASL2", "sasl2x_dynbuf=dynbuf" }

	configuration { "vs*", "windows" }
		-- 4047 - : '=': 'int' differs in levels of indirection from 'TCHAR *'
		-- 4133 - 'function': incompatible types - from 'TCHAR *' to 'WCHAR *'
		buildoptions { "/wd4047 /wd4133"}
		includedirs { SASL2_ROOT .. "win32/include" }
		defines { "LIBSASL_EXPORTS", "HAVE_NT_THREADS" }
	configuration {}
end

function projectExtraConfigExecutable_sasl2()
	configuration { "linux" }
		links { "libsasl2" }
	configuration { "vs*", "windows" }
		links { "Crypt32" }
	configuration {}
end

function copyHeaderSASL(name)
	if not os.isfile(SASL2_ROOT .. "include/sasl/"	.. name) then
		os.copyfile( SASL2_ROOT .. "include/"		.. name,
					 SASL2_ROOT .. "include/sasl/"	.. name)
	end
end

function projectAdd_sasl2()
	if getTargetOS() == "windows" then
		SASL2_FILES = mergeTables(SASL2_FILES, {
			--SASL2_ROOT .. "lib/getaddrinfo.c",
			--SASL2_ROOT .. "lib/getnameinfo.c",
			--SASL2_ROOT .. "lib/getsubopt.c",
			--SASL2_ROOT .. "lib/snprintf.c"
			SASL2_ROOT .. "lib/windlopen.c"
		})
	else
		SASL2_FILES = mergeTables(SASL2_FILES, {
			--SASL2_ROOT .. "lib/getaddrinfo.c",
			--SASL2_ROOT .. "lib/getnameinfo.c",
			--SASL2_ROOT .. "lib/getsubopt.c",
			--SASL2_ROOT .. "lib/snprintf.c"
			SASL2_ROOT .. "lib/dlopen.c"
		})
	end

	os.mkdir(SASL2_ROOT .. "include/sasl")

	os.copyfile(SASL2_ROOT .. "include/sasl/exits.h", SASL2_ROOT .. "include/sasl/exits.h")
	copyHeaderSASL("gai.h")
	copyHeaderSASL("prop.h")
	copyHeaderSASL("sasl.h")
	copyHeaderSASL("saslplug.h")
	copyHeaderSASL("saslutil.h")

	if getTargetOS() ~= "linux" and getTargetOS() ~= "osx" then
		addProject_3rdParty_lib("sasl2", SASL2_FILES)
	end
end
