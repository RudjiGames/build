--
-- Copyright 2023 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/ARMmbed/mbedtls

local params		= { ... }
local MBEDTLS_ROOT	= params[1]

local MBEDTLS_INCLUDE	= {
	MBEDTLS_ROOT .. "include",
}

local MBEDTLS_FILES = {
	MBEDTLS_ROOT .. "library/**.c",
}

function projectExtraConfig_mbedtls()
	includedirs { MBEDTLS_INCLUDE }
end

function projectAdd_mbedtls()
	addProject_3rdParty_lib("mbedtls", MBEDTLS_FILES)
end

