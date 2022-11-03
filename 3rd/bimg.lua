--
-- Copyright (c) 2018 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/bkaradzic/bimg

local params	    	= { ... }
local BIMG_ROOT	    	= params[1]
local ASTC_CODEC_DIR    = BIMG_ROOT .. "3rdparty/astc-codec/" 

local BIMG_INCLUDE	= {
	BIMG_ROOT .. "include",
	BIMG_ROOT .. "3rdparty",
	BIMG_ROOT .. "3rdparty/iqa/include",
	BIMG_ROOT .. "3rdparty/tinyexr/deps/miniz",
	BIMG_ROOT .. "3rdparty/astc-encoder",
	BIMG_ROOT .. "3rdparty/astc-encoder/include",
	find3rdPartyProject("bx") .. "include"
}

local BIMG_FILES = {
	BIMG_ROOT .. "include/**.h",
	BIMG_ROOT .. "src/**.h",
    BIMG_ROOT .. "src/**.cpp",
	BIMG_ROOT .. "3rdparty/tinyexr/deps/miniz/**.c",

    ASTC_CODEC_DIR .. "src/decoder/astc_file.*",
	ASTC_CODEC_DIR .. "src/decoder/codec.*",
	ASTC_CODEC_DIR .. "src/decoder/endpoint_codec.*",
	ASTC_CODEC_DIR .. "src/decoder/footprint.*",
	ASTC_CODEC_DIR .. "src/decoder/integer_sequence_codec.*",
	ASTC_CODEC_DIR .. "src/decoder/intermediate_astc_block.*",
	ASTC_CODEC_DIR .. "src/decoder/logical_astc_block.*",
	ASTC_CODEC_DIR .. "src/decoder/partition.*",
	ASTC_CODEC_DIR .. "src/decoder/physical_astc_block.*",
	ASTC_CODEC_DIR .. "src/decoder/quantization.*",
	ASTC_CODEC_DIR .. "src/decoder/weight_infill.*",
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
	configuration {}
end

function projectAdd_bimg()
	addProject_3rdParty_lib("bimg", BIMG_FILES)
end

