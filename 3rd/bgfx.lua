--
-- Copyright (c) 2017 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/bkaradzic/bgfx

local params		= { ... }
local BGFX_ROOT		= params[1]

local BGFX_INCLUDE	= {
	BGFX_ROOT .. "include",
	BGFX_ROOT .. "3rdparty",
	BGFX_ROOT .. "3rdparty/khronos",
	BGFX_ROOT .. "3rdparty/dxsdk/include",
	find3rdPartyProject("bx") .. "include",
	find3rdPartyProject("bimg") .. "include" 
}

local BFGX_FILES = {
	BGFX_ROOT .. "src/amalgamated.cpp",
	BGFX_ROOT .. "include/**.h"
}

function projectInclude_bgfx()
	return { BGFX_ROOT .. "include/",
			 BGFX_ROOT .. "3rdparty/" }
end

function projectDependencies_bgfx()
	local dependencies = { "bx", "bimg" }
	if (getTargetOS() == "linux" or getTargetOS() == "freebsd") then
		table.insert(dependencies, "X11")
	end
	if _OPTIONS["with-glfw"] then
		table.insert(dependencies, "GL")
	end
	return dependencies
end 

function projectExtraConfig_bgfx()
	if getTargetOS() == "android" then
		links {
			"EGL",
			"GLESv2",
		}
	end

	if isWinStoreTarget() then
		linkoptions {
			"/ignore:4264" -- LNK4264: archiving object file compiled with /ZW into a static library; note that when authoring Windows Runtime types it is not recommended to link with a static library that contains Windows Runtime metadata
		}
	end

	if getTargetCompiler() == "clang" then
		buildoptions {
			"-Wno-microsoft-enum-value", -- enumerator value is not representable in the underlying type 'int'
			"-Wno-microsoft-const-init", -- default initialization of an object of const type '' without a user-provided default constructor is a Microsoft extension
		}
	end

	if getTargetOS() == "osx" then
		linkoptions {
			"-framework Cocoa",
			"-framework QuartzCore",
			"-framework OpenGL",
			"-weak_framework Metal",
			"-weak_framework MetalKit",
		}
	end
 end

function projectAdd_bgfx()
	local BGFX_DEFINES = {}
	if _OPTIONS["with-glfw"] then
		BGFX_DEFINES = { "BGFX_CONFIG_MULTITHREADED=0" }		
	end

	if isAppleTarget() then
		table.insert(BFGX_FILES, BGFX_ROOT .. "src/amalgamated.mm")
	end
	
	addProject_3rdParty_lib("bgfx", BFGX_FILES, false, BGFX_INCLUDE, BGFX_DEFINES, projectExtraConfig_bgfx)
end

