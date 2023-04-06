--
-- Copyright (c) 2018 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/bkaradzic/bgfx

local params		= { ... }
local BGFX_ROOT		= params[1]

local BX_ROOT		= find3rdPartyProject("bx") .. "include"

local BGFX_INCLUDE	= {
	BGFX_ROOT .. "include",
	BGFX_ROOT .. "3rdparty",
	BGFX_ROOT .. "3rdparty/khronos",
	BGFX_ROOT .. "3rdparty/directx-headers/include/directx",
	BX_ROOT,
	find3rdPartyProject("bimg") .. "include" 
}

local BGFX_FILES = {
	BGFX_ROOT .. "src/amalgamated.cpp",
	BGFX_ROOT .. "include/**.h"
}

function projectDependencies_bgfx()
	local dependencies = { "bx", "bimg" }
	if (getTargetOS() == "linux" or getTargetOS() == "freebsd") then
		table.insert(dependencies, "X11")
		table.insert(dependencies, "GL")
	end
	if _OPTIONS["with-glfw"] then
		table.insert(dependencies, "GL")
	end
	return dependencies
end 

function projectExtraConfigExecutable_bgfx()
	if _OPTIONS["with-glfw"] then
		links   {
			"glfw3"
		}

		configuration { "linux or freebsd" }
			links {
				"Xrandr",
				"Xinerama",
				"Xi",
				"Xxf86vm",
				"Xcursor",
			}

		configuration { "osx" }
			linkoptions {
				"-framework CoreVideo",
				"-framework IOKit",
			}

		configuration {}
	end
	
	configuration { "vs20* or mingw*", "not orbis", "not durango", "not winphone*", "not winstore*" }
		links {
			"gdi32",
			"psapi",
		}

	configuration { "winphone8* or winstore8*" }
		removelinks {
			"DelayImp",
			"gdi32",
			"psapi"
		}
		links {
			"d3d11",
			"dxgi"
		}
		linkoptions {
			"/ignore:4264" -- LNK4264: archiving object file compiled with /ZW into a static library; note that when authoring Windows Runtime types it is not recommended to link with a static library that contains Windows Runtime metadata
		}

	configuration { "android*" }
		linkoptions {
			"-Wl,--fix-cortex-a8",
		}
		links {
			"EGL",
			"GLESv2",
		}

	configuration { "linux-* or freebsd" }
		configuration { "linux-*" }
		buildoptions {
			"-fPIC",
		}
		links {
			"X11",
			"GL",
			"pthread",
		}

	configuration { "rpi" }
		links {
--			"EGL",
			"bcm_host",
			"vcos",
			"vchiq_arm",
			"pthread",
		}

	configuration { "osx" }
		buildoptions { "-x objective-c++" }  -- additional build option for osx
		linkoptions {
			"-framework Cocoa",
			"-framework IOKit",
			"-framework OpenGL",
			"-framework QuartzCore",
			"-weak_framework Metal",
			"-weak_framework MetalKit",
		}

			
	configuration { "ios*" }
		kind "ConsoleApp"
		linkoptions {
			"-framework CoreFoundation",
			"-framework Foundation",
			"-framework OpenGLES",
			"-framework UIKit",
			"-framework QuartzCore",
		}

	configuration {}

	if getTargetOS() == "ios" then
		configuration { "xcode4", "ios" }
			kind "WindowedApp"
	end

	configuration {}
 end

function projectExtraConfig_bgfx()
 	includedirs { BGFX_INCLUDE }
	defines { BGFX_DEFINES }

	local BGFX_DEFINES = {}
	if _OPTIONS["with-glfw"] then
		BGFX_DEFINES = { "BGFX_CONFIG_MULTITHREADED=0" }		
	end

	configuration { "*clang*" }
		buildoptions {
			"-Wno-microsoft-enum-value", -- enumerator value is not representable in the underlying type 'int'
			"-Wno-microsoft-const-init", -- default initialization of an object of const type '' without a user-provided default constructor is a Microsoft extension
		}														

	configuration { "debug or release" }
		defines { "BX_CONFIG_DEBUG=1" }
	configuration { "retail" }
		defines { "BX_CONFIG_DEBUG=0" }

	configuration { "linux*" }
		includedirs {	BX_ROOT .. "/compat/linux",
						BGFX_ROOT .. "/3rdparty/directx-headers/include/directx",
						BGFX_ROOT .. "/3rdparty/directx-headers/include",
						BGFX_ROOT .. "/3rdparty/directx-headers/include/wsl/stubs" }

	configuration { "vs* or mingw*", "not durango" }
		includedirs {	BGFX_ROOT .. "/3rdparty/directx-headers/include/directx"	}
	
	configuration {}
end

function projectAdd_bgfx()
	if isAppleTarget() then
		table.insert(BGFX_FILES, BGFX_ROOT .. "src/amalgamated.mm")
	end
	
	addProject_3rdParty_lib("bgfx", BGFX_FILES)
end

