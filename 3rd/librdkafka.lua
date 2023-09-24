--
-- Copyright 2023 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/confluentinc/librdkafka/

local params		= { ... }
local KAFKA_ROOT	= params[1]

local KAFKA_FILES = {
	KAFKA_ROOT .. "src/**.c",
	KAFKA_ROOT .. "src/**.h"
}

function projectDependencies_librdkafka()
	return { "openssl", "curl", "zlib", "zstd", "sasl2" }
end 

function projectExtraConfig_librdkafka()
	defines {	"_CRT_SECURE_NO_WARNINGS",
				"LIBRDKAFKA_EXPORTS",
				"STRUCT_IOVEC_DEFINED"
	}
	includedirs {
		KAFKA_ROOT .. "include",
		KAFKA_ROOT .. "include",
		ZLIB_ROOT
	}

 	configuration { "vs*", "windows" }
		-- 4133 -  incompatible types - from 'wchar_t [512]' to 'SEC_CHAR *'
		buildoptions { "/wd4133"}
	configuration {}
end

function projectAdd_librdkafka()
	addProject_3rdParty_lib("librdkafka", KAFKA_FILES)
end
