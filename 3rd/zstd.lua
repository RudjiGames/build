--
-- Copyright 2023 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/cyrusimap/cyrus-sasl.git

local params		= { ... }
local SASL_ROOT		= params[1]

local SASL_FILES = {
	SASL_ROOT .. "lib/**.c",
	SASL_ROOT .. "lib/**.h",
	SASL_ROOT .. "include/**.h"
}

function projectExtraConfig_sasl()
	includedirs { SASL_ROOT .. "include" }
end

function projectAdd_sasl()
	addProject_3rdParty_lib("sasl", SASL_FILES)
end
