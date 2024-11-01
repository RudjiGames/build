--
-- Copyright 2023 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/bkaradzic/bimg

local params	    	= { ... }
local BIMG_ROOT	    	= params[1]
local ASTC_CODEC_DIR    = BIMG_ROOT .. "3rdparty/astc-encoder/" 

local BIMG_INCLUDE	= {
	BIMG_ROOT .. "include",
	BIMG_ROOT .. "3rdparty",
	BIMG_ROOT .. "3rdparty/iqa/include",
	BIMG_ROOT .. "3rdparty/tinyexr/deps/miniz",
	ASTC_CODEC_DIR,
	ASTC_CODEC_DIR .. "include",
	find3rdPartyProject("bx") .. "include"
}

local BIMG_FILES = {
	BIMG_ROOT .. "include/**.h",
	BIMG_ROOT .. "src/**.h",
	BIMG_ROOT .. "src/**.cpp",
	BIMG_ROOT .. "3rdparty/tinyexr/deps/miniz/**.c",
	ASTC_CODEC_DIR,
	ASTC_CODEC_DIR .. "source/**.cpp"
} 

function projectDependencies_bimg()
	return { "bx" }
end 

function projectExtraConfig_bimg()
	includedirs { BIMG_INCLUDE }
	configuration { "debug or release" }
		defines { "BX_CONFIG_DEBUG=1" }
	configuration { "retail" }
		defines { "BX_CONFIG_DEBUG=0" }
 	configuration { "vs*", "windows" }
		buildoptions { "/wd4324" } -- 4324 - structure was padded due to alignment specifier
		buildoptions { "/wd4127" } -- 4127 - conditional expression is constant
		buildoptions { "/wd4505" } -- 4505 - unreferenced function with internal linkage has been removed
		buildoptions { "/wd4244" } -- 4244 - '=': conversion from 'unsigned int' to 'uint16_t', possible loss of data
		buildoptions { "/wd4706" } -- 4706 - assignment within conditional expression
	configuration {}
end

function projectAdd_bimg()
	addProject_3rdParty_lib("bimg", BIMG_FILES)
end

