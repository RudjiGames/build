--
-- Copyright 2025 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/netsurf-plan9/libdom.git

local params		= { ... }
local LIBPU_ROOT	= params[1]

local LIBPU_FILES = {
	LIBPU_ROOT .. "src/**.c",
	LIBPU_ROOT .. "src/**.h",
}

function projectExtraConfig_libparserutils()
	defines { "WITHOUT_ICONV_FILTER" }
	includedirs { LIBPU_ROOT .. "Include" }
	includedirs { LIBPU_ROOT .. "src" }
end

function projectAdd_libparserutils()
	local cwd = _WORKING_DIR
	os.chdir(LIBPU_ROOT)
	os.execute("perl build/make-aliases.pl")
	os.chdir(cwd)

	addProject_3rdParty_lib("libparserutils", LIBPU_FILES)
end
