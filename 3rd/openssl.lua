--
-- Copyright 2025 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/openssl/openssl.git

local params		= { ... }
local OSSL_ROOT		= params[1]

function projectExtraConfigExecutable_openssl()
	if getTargetOS() == "windows" then
		configuration {"x64"}
			includedirs { OSSL_ROOT .. "x64/include" }
			libdirs { OSSL_ROOT .. "x64/lib" }
			links   {
				"libcrypto",
				"libssl"
			}
		configuration {"x32"}
			includedirs { OSSL_ROOT .. "x86/include" }
			libdirs { OSSL_ROOT .. "x86/lib" }
			links   {
				"libcrypto",
				"libssl"
			}
	end
end
