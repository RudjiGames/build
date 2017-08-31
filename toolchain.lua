--
-- Copyright (c) 2017 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--
-- Based on toolchain.lua from https://github.com/bkaradzic/bx
--

function script_dir()
	return path.getdirectory(debug.getinfo(2, "S").source:sub(2)) .. "/"
end

dofile (RTM_SCRIPTS_DIR .. "deploy.lua")

local naclToolchain = ""
local iosPlatform = ""

androidTarget		= "14"
local androidPlatform	= "android-" .. androidTarget

newoption {
	trigger = "gcc",
	value = "GCC",
	description = "Choose GCC flavor",
	allowed = {
		{ "android-arm",   "Android - ARM"          },
		{ "android-mips",  "Android - MIPS"         },
		{ "android-x86",   "Android - x86"          },
		{ "asmjs",         "Emscripten/asm.js"      },
		{ "freebsd",       "FreeBSD"                },
		{ "linux-gcc",     "Linux (GCC compiler)"   },
		{ "linux-gcc-5",   "Linux (GCC-5 compiler)" },
		{ "linux-clang",   "Linux (Clang compiler)" },
		{ "ios-arm",       "iOS - ARM"              },
		{ "ios-simulator", "iOS - Simulator"        },
		{ "mingw-gcc",     "MinGW"                  },
		{ "mingw-clang",   "MinGW (clang compiler)" },
		{ "nacl",          "Native Client"          },
		{ "nacl-arm",      "Native Client - ARM"    },
		{ "osx",           "OSX"                    },
		{ "pnacl",         "Native Client - PNaCl"  },
		{ "qnx-arm",       "QNX/Blackberry - ARM"   },
		{ "rpi",           "RaspberryPi"            },
	},
}

newoption {
	trigger = "vs",
	value = "toolset",
	description = "Choose VS toolset",
	allowed = {
		{ "vs2012-clang",  "Clang 3.6"         },
		{ "vs2013-clang",  "Clang 3.6"         },
		{ "vs2012-xp",     "Visual Studio 2012 targeting XP" },
		{ "vs2013-xp",     "Visual Studio 2013 targeting XP" },
		{ "vs2015-xp",     "Visual Studio 2015 targeting XP" },
		{ "winphone8",     "Windows Phone 8.0" },
		{ "winphone81",    "Windows Phone 8.1" },
		{ "winstore81",    "Windows Store 8.1" },
		{ "winstore82",    "Universal Windows App" }
	},
}

newoption {
	trigger = "xcode",
	value = "xcode_target",
	description = "Choose XCode target",
	allowed = {
		{ "osx", "OSX" },
		{ "ios", "iOS" },
	}
}

newoption {
	trigger = "with-android",
	value   = "#",
	description = "Set Android platform version (default: android-14).",
}

newoption {
	trigger = "with-ios",
	value   = "#",
	description = "Set iOS target version (default: 8.0).",
}

newoption {
	trigger = "with-sdl",
	description = "Enable SDL entry.",
}

newoption {
	trigger = "with-glfw",
	description = "Enable GLFW entry.",
} 

newoption {
	trigger = "no-deploy",
	description = "Disable deployment code generation and post build steps.",
}


function getTargetOS()

	-- gmake - android
	if  (_OPTIONS["gcc"] == "android-arm") or
		(_OPTIONS["gcc"] == "android-mips") or
		(_OPTIONS["gcc"] == "android-x86") then
		return "android"
	end

	-- gmake - asmjs
	if _OPTIONS["gcc"] == "asmjs" then
		return "asmjs"
	end

	-- gmake - freebsd
	if _OPTIONS["gcc"] == "freebsd" then
		return "freebsd"
	end

	-- gmake - linux
	if	(_OPTIONS["gcc"] == "linux-gcc") or
		(_OPTIONS["gcc"] == "linux-gcc-5") or
		(_OPTIONS["gcc"] == "linux-clang") then
		return "linux"
	end

	-- gmake - ios
	-- xcode - ios	
	if	(_OPTIONS["xcode"] == "ios") or
		(_OPTIONS["gcc"] == "ios-arm") or
		(_OPTIONS["gcc"] == "ios-simulator") then
		return "ios"
	end

	-- gmake - nacl
	if	(_OPTIONS["gcc"] == "nacl") or
		(_OPTIONS["gcc"] == "nacl-arm") or
		(_OPTIONS["gcc"] == "pnacl") then
		return "nacl"
	end

	-- gmake - osx
	-- xcode - osx
	if	(_OPTIONS["xcode"] == "osx") or
		(_OPTIONS["gcc"] == "osx") then
		return "osx"
	end

	if _OPTIONS["gcc"] == "qnx-arm" then
		return "qnx"
	end

	if _OPTIONS["gcc"] == "rpi" then
		return "rpi"
	end

	-- visual studio - winphone
	if	(_OPTIONS["vs"] == "winphone8") then
		return "winphone8"
	end

	if	(_OPTIONS["vs"] == "winphone81") then
		return "winphone81"
	end
	
	-- visual studio - winstore
	if	(_OPTIONS["vs"] == "winstore81") then
		return "winstore81"
	end

	if	(_OPTIONS["vs"] == "winstore82") then
		return "winstore82"
	end
	
	-- visual studio - windows
	-- gmake - mingw
	if	(_OPTIONS["gcc"] == "mingw-gcc") or
		(_OPTIONS["gcc"] == "mingw-clang") or
		(_OPTIONS["vs"] == "vs2012-clang") or
		(_OPTIONS["vs"] == "vs2013-clang") or
		(_OPTIONS["vs"] == "vs2012-xp") or
		(_OPTIONS["vs"] == "vs2013-xp") or
		(_OPTIONS["vs"] == "vs2015-xp") or
		(_ACTION ~= nil and _ACTION:find("vs")) then
		return "windows"
	end

	return "unknown"
end

function getTargetCompiler()

	-- gmake - android
	if  (_OPTIONS["gcc"] == "android-arm") then
		return "gcc-arm"
	end
	if	(_OPTIONS["gcc"] == "android-mips") then
		return "gcc-mips"
	end
	if	(_OPTIONS["gcc"] == "android-x86") then
		return "gcc-x86"
	end

	-- gmake - asmjs
	if _OPTIONS["gcc"] == "asmjs" then
		return "gcc"
	end

	-- gmake - freebsd
	if _OPTIONS["gcc"] == "freebsd" then
		return "gcc"
	end

	-- gmake - linux
	if	(_OPTIONS["gcc"] == "linux-gcc") then
		return "gcc"
	end
	if	(_OPTIONS["gcc"] == "linux-gcc-5") then
		return "gcc-5"
	end
	if	(_OPTIONS["gcc"] == "linux-clang") then
		return "clang"
	end

	-- gmake - ios
	-- xcode - ios	
	if (_OPTIONS["gcc"] == "ios-arm") then
		return "gcc-arm"
	end
	if (_OPTIONS["gcc"] == "ios-simulator") then
		return "gcc-sim"
	end
	if _OPTIONS["xcode"] == "ios" then
		return "xcode";
	end

	-- gmake - nacl
	if	(_OPTIONS["gcc"] == "nacl") then
		return "gcc"
	end
	if	(_OPTIONS["gcc"] == "nacl-arm") then
		return "gcc-arm"
	end
	if	(_OPTIONS["gcc"] == "pnacl") then
		return "gcc-pnacl"
	end

	-- gmake - osx
	-- xcode - osx
	if _OPTIONS["gcc"] == "osx" then
		return "gcc"
	end
	if _OPTIONS["xcode"] == "osx" then
		return "xcode";
	end

	if _OPTIONS["gcc"] == "qnx-arm" then
		return "gcc"
	end

	if _OPTIONS["gcc"] == "rpi" then
		return "gcc"
	end

	-- visual studio - multi
	if	(_OPTIONS["vs"] ~= nil) then
		return _OPTIONS["vs"]
	end
	
	-- gmake - mingw
	-- visual studio - *
	if	(_OPTIONS["gcc"] == "mingw-gcc") then
		return "mingw-gcc"
	end
	if	(_OPTIONS["gcc"] == "mingw-clang") then
		return "mingw-clang"
	end
	if (_ACTION ~= nil and _ACTION:find("vs")) then
		return _ACTION
	end
	
	return "unknown"
end

function mkdir(_dirname)
	local dir = _dirname
	if os.is("windows") then
		dir = string.gsub( _dirname, "([/]+)", "\\" )
	end

	if not os.isdir(dir) then
		if not os.is("windows") then
			os.execute("mkdir " .. dir .. " -p")
		else
			os.execute("mkdir " .. dir)
		end
	end
end

function rmdir(_dirname)
	local dir = _dirname
	if os.is("windows") then
		dir = string.gsub( _dirname, "([/]+)", "\\" )
	end

	if os.isdir(dir) then
		if os.is("windows") then
			dir = "rmdir /s /q " .. dir
		else
			dir = "rm -rf " .. dir
		end
		os.execute(dir)
	end
end

function getLocationDir(_buildDir)
	local locationDir = getTargetOS() .. "/" .. getTargetCompiler() .. "/projects/" .. solution().name .. "/"
	return path.join(_buildDir, locationDir)
end

function toolchain(_buildDir)

	-- Avoid error when invoking genie --help.
	if (_ACTION == nil) then return false end

	local fullLocation = getLocationDir(_buildDir)

	location (fullLocation)
	mkdir(fullLocation)

	if _ACTION == "clean" then
		rmdir(_buildDir)
	end


	if _OPTIONS["with-android"] then
		androidTarget = _OPTIONS["with-android"]
		androidPlatform = "android-" .. androidTarget
	end

	if _OPTIONS["with-ios"] then
		iosPlatform = _OPTIONS["with-ios"]
	end

	if _ACTION == "gmake" then

		if nil == _OPTIONS["gcc"] then
			print("GCC flavor must be specified!")
			os.exit(1)
		end

		if "android-arm" == _OPTIONS["gcc"] then

			if not os.getenv("ANDROID_NDK_ARM") or not os.getenv("ANDROID_NDK_ROOT") then
				print("Set ANDROID_NDK_ARM and ANDROID_NDK_ROOT envrionment variables.")
			end

			premake.gcc.cc  = "$(ANDROID_NDK_ARM)/bin/arm-linux-androideabi-gcc"
			premake.gcc.cxx = "$(ANDROID_NDK_ARM)/bin/arm-linux-androideabi-g++"
			premake.gcc.ar  = "$(ANDROID_NDK_ARM)/bin/arm-linux-androideabi-ar"

		elseif "android-mips" == _OPTIONS["gcc"] then

			if not os.getenv("ANDROID_NDK_MIPS") or not os.getenv("ANDROID_NDK_ROOT") then
				print("Set ANDROID_NDK_MIPS and ANDROID_NDK_ROOT envrionment variables.")
			end

			premake.gcc.cc  = "$(ANDROID_NDK_MIPS)/bin/mipsel-linux-android-gcc"
			premake.gcc.cxx = "$(ANDROID_NDK_MIPS)/bin/mipsel-linux-android-g++"
			premake.gcc.ar  = "$(ANDROID_NDK_MIPS)/bin/mipsel-linux-android-ar"

		elseif "android-x86" == _OPTIONS["gcc"] then

			if not os.getenv("ANDROID_NDK_X86") or not os.getenv("ANDROID_NDK_ROOT") then
				print("Set ANDROID_NDK_X86 and ANDROID_NDK_ROOT envrionment variables.")
			end

			premake.gcc.cc  = "$(ANDROID_NDK_X86)/bin/i686-linux-android-gcc"
			premake.gcc.cxx = "$(ANDROID_NDK_X86)/bin/i686-linux-android-g++"
			premake.gcc.ar  = "$(ANDROID_NDK_X86)/bin/i686-linux-android-ar"

		elseif "asmjs" == _OPTIONS["gcc"] then

			if not os.getenv("EMSCRIPTEN") then
				print("Set EMSCRIPTEN enviroment variables.")
			end

			premake.gcc.cc   = "$(EMSCRIPTEN)/emcc"
			premake.gcc.cxx  = "$(EMSCRIPTEN)/em++"
			premake.gcc.ar   = "$(EMSCRIPTEN)/emar"
			premake.gcc.llvm = true

		elseif "freebsd" == _OPTIONS["gcc"] then

		elseif "ios-arm" == _OPTIONS["gcc"] then
			premake.gcc.cc  = "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang"
			premake.gcc.cxx = "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++"
			premake.gcc.ar  = "ar"

		elseif "ios-simulator" == _OPTIONS["gcc"] then
			premake.gcc.cc  = "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang"
			premake.gcc.cxx = "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++"
			premake.gcc.ar  = "ar"

		elseif "linux-gcc" == _OPTIONS["gcc"] then

		elseif "linux-gcc-5" == _OPTIONS["gcc"] then
			premake.gcc.cc  = "gcc-5"
			premake.gcc.cxx = "g++-5"
			premake.gcc.ar  = "ar"

		elseif "linux-clang" == _OPTIONS["gcc"] then
			premake.gcc.cc  = "clang"
			premake.gcc.cxx = "clang++"
			premake.gcc.ar  = "ar"

		elseif "mingw-gcc" == _OPTIONS["gcc"] then
			premake.gcc.cc  = "$(MINGW)/bin/x86_64-w64-mingw32-gcc"
			premake.gcc.cxx = "$(MINGW)/bin/x86_64-w64-mingw32-g++"
			premake.gcc.ar  = "$(MINGW)/bin/ar"

		elseif "mingw-clang" == _OPTIONS["gcc"] then
			premake.gcc.cc   = "$(CLANG)/bin/clang"
			premake.gcc.cxx  = "$(CLANG)/bin/clang++"
			premake.gcc.ar   = "$(MINGW)/bin/ar"
--			premake.gcc.ar   = "$(CLANG)/bin/llvm-ar"
--			premake.gcc.llvm = true

		elseif "nacl" == _OPTIONS["gcc"] then

			if not os.getenv("NACL_SDK_ROOT") then
				print("Set NACL_SDK_ROOT enviroment variables.")
			end

			naclToolchain = "$(NACL_SDK_ROOT)/toolchain/win_x86_newlib/bin/x86_64-nacl-"
			if os.is("macosx") then
				naclToolchain = "$(NACL_SDK_ROOT)/toolchain/mac_x86_newlib/bin/x86_64-nacl-"
			elseif os.is("linux") then
				naclToolchain = "$(NACL_SDK_ROOT)/toolchain/linux_x86_newlib/bin/x86_64-nacl-"
			end

			premake.gcc.cc  = naclToolchain .. "gcc"
			premake.gcc.cxx = naclToolchain .. "g++"
			premake.gcc.ar  = naclToolchain .. "ar"

		elseif "nacl-arm" == _OPTIONS["gcc"] then

			if not os.getenv("NACL_SDK_ROOT") then
				print("Set NACL_SDK_ROOT enviroment variables.")
			end

			naclToolchain = "$(NACL_SDK_ROOT)/toolchain/win_arm_newlib/bin/arm-nacl-"
			if os.is("macosx") then
				naclToolchain = "$(NACL_SDK_ROOT)/toolchain/mac_arm_newlib/bin/arm-nacl-"
			elseif os.is("linux") then
				naclToolchain = "$(NACL_SDK_ROOT)/toolchain/linux_arm_newlib/bin/arm-nacl-"
			end

			premake.gcc.cc  = naclToolchain .. "gcc"
			premake.gcc.cxx = naclToolchain .. "g++"
			premake.gcc.ar  = naclToolchain .. "ar"

		elseif "osx" == _OPTIONS["gcc"] then

			if os.is("linux") then
				local osxToolchain = "x86_64-apple-darwin13-"
				premake.gcc.cc  = osxToolchain .. "clang"
				premake.gcc.cxx = osxToolchain .. "clang++"
				premake.gcc.ar  = osxToolchain .. "ar"
			end

		elseif "pnacl" == _OPTIONS["gcc"] then

			if not os.getenv("NACL_SDK_ROOT") then
				print("Set NACL_SDK_ROOT enviroment variables.")
			end

			naclToolchain = "$(NACL_SDK_ROOT)/toolchain/win_pnacl/bin/pnacl-"
			if os.is("macosx") then
				naclToolchain = "$(NACL_SDK_ROOT)/toolchain/mac_pnacl/bin/pnacl-"
			elseif os.is("linux") then
				naclToolchain = "$(NACL_SDK_ROOT)/toolchain/linux_pnacl/bin/pnacl-"
			end

			premake.gcc.cc  = naclToolchain .. "clang"
			premake.gcc.cxx = naclToolchain .. "clang++"
			premake.gcc.ar  = naclToolchain .. "ar"

		elseif "qnx-arm" == _OPTIONS["gcc"] then

			if not os.getenv("QNX_HOST") then
				print("Set QNX_HOST enviroment variables.")
			end

			premake.gcc.cc  = "$(QNX_HOST)/usr/bin/arm-unknown-nto-qnx8.0.0eabi-gcc"
			premake.gcc.cxx = "$(QNX_HOST)/usr/bin/arm-unknown-nto-qnx8.0.0eabi-g++"
			premake.gcc.ar  = "$(QNX_HOST)/usr/bin/arm-unknown-nto-qnx8.0.0eabi-ar"

		elseif "rpi" == _OPTIONS["gcc"] then
		end
	elseif _ACTION == "vs2012" or _ACTION == "vs2013" or _ACTION == "vs2015" then

		if (_ACTION .. "-clang") == _OPTIONS["vs"] then
			premake.vstudio.toolset = ("LLVM-" .. _ACTION)

		elseif "winphone8" == _OPTIONS["vs"] then
			premake.vstudio.toolset = "v110_wp80"

		elseif "winphone81" == _OPTIONS["vs"] then
			premake.vstudio.toolset = "v120_wp81"
			premake.vstudio.storeapp = "8.1"
--			platforms { "ARM" }

		elseif "winstore81" == _OPTIONS["vs"] then
			premake.vstudio.toolset = "v120"
			premake.vstudio.storeapp = "8.1"
--			platforms { "ARM" }

		elseif "winstore82" == _OPTIONS["vs"] then
			premake.vstudio.toolset = "v140"
			premake.vstudio.storeapp = "8.2"
--			platforms { "ARM" }

		elseif ("vs2012-xp") == _OPTIONS["vs"] then
			premake.vstudio.toolset = ("v110_xp")

		elseif ("vs2013-xp") == _OPTIONS["vs"] then
			premake.vstudio.toolset = ("v120_xp")

		elseif ("vs2015-xp") == _OPTIONS["vs"] then
			premake.vstudio.toolset = ("v140_xp")
		end

	elseif _ACTION == "xcode4" then

		if "osx" == _OPTIONS["xcode"] then
			premake.xcode.toolset = "macosx"

		elseif "ios" == _OPTIONS["xcode"] then
			premake.xcode.toolset = "iphoneos"
		end
	end

	configuration {} -- reset configuration

	return true
end

function getBuildDirRoot(_filter)
	local pathAdd = ""
	for _,dir in ipairs(_filter) do
		pathAdd = pathAdd .. "/" .. dir
	end
	local subDir = getTargetOS() .. "/" .. getTargetCompiler() .. pathAdd .. "/"
	return RTM_BUILD_DIR .. subDir .. solution().name.. "/"
end

function commonConfig(_filter, _isLib, _isSharedLib, _rappUsed)

	configuration {}
	
	local binDir = getBuildDirRoot(_filter) .. "bin/"
	local libDir = getBuildDirRoot(_filter) .. "lib/"
	local objDir = getBuildDirRoot(_filter) .. "obj/" .. project().name .. "/"

	mkdir(binDir)
	mkdir(libDir)
	mkdir(objDir)

	if _isLib and not _isSharedLib then
		binDir = libDir
	end

	configuration { _filter }
		targetdir (binDir)
		objdir (objDir)
		libdirs {libDir}
		debugdir (binDir)

	defines {
		"__STDC_LIMIT_MACROS",
		"__STDC_FORMAT_MACROS",
		"__STDC_CONSTANT_MACROS",
	}

	configuration { "vs*", "x32", _filter }
		flags {
			"EnableSSE2",
		}

	configuration { "vs*", _filter }
		includedirs { path.join(getProjectPath("rbase"), "inc/compat/msvc") }
		defines {
			"WIN32",
			"_WIN32",
			"_HAS_EXCEPTIONS=0",
			"_HAS_ITERATOR_DEBUGGING=0",
			"_SCL_SECURE=0",
			"_SECURE_SCL=0",
			"_SCL_SECURE_NO_WARNINGS",
			"_CRT_SECURE_NO_WARNINGS",
			"_CRT_SECURE_NO_DEPRECATE",
			"_WINSOCK_DEPRECATED_NO_WARNINGS",
		}
		buildoptions {
			"/Oy-",		-- Suppresses creation of frame pointers on the call stack.
			"/Ob2",		-- The Inline Function Expansion
		}
		linkoptions {
			"/ignore:4221", -- LNK4221: This object file does not define any previously undefined public symbols, so it will not be used by any link operation that consumes this library
		}

	configuration { "vs2008", _filter }
		includedirs { path.join(getProjectPath("rbase"), "inc/compat/msvc/pre1600") }

	configuration { "x32", "vs*", _filter }
		defines { "RTM_WIN32", "RTM_WINDOWS" }

	configuration { "x64", "vs*", _filter }
		defines { "RTM_WIN64", "RTM_WINDOWS", "_WIN64" }

	configuration { "ARM", "vs*", _filter }

	configuration { "vs*-clang", _filter }
		buildoptions {
			"-Qunused-arguments",
		}

	configuration { "x32", "vs*-clang", _filter }
		defines { "RTM_WIN32", "RTM_WINDOWS" }

	configuration { "x64", "vs*-clang", _filter }
		defines { "RTM_WIN64", "RTM_WINDOWS" }

	configuration { "winphone8* or winstore8*", _filter }
		removeflags {
			"StaticRuntime",
			"NoExceptions",
		}

	configuration { "*-gcc* or osx", _filter }
		buildoptions {
			"-Wshadow",
		}

	configuration { "mingw-*", _filter }
		defines { "WIN32" }
		includedirs { path.join(getProjectPath("rbase"), "inc/compat/mingw") }
		buildoptions {
			"-Wunused-value",
			"-fdata-sections",
			"-ffunction-sections",
			"-fopenmp",
			"-msse2",
			"-Wunused-value",
			"-Wundef",
		}
		buildoptions_cpp {
			"-std=c++11",
		}
		links { 
			"gomp", 
			"ole32",
			"oleaut32",
			"uuid"
		}
		linkoptions {
			"-Wl,--gc-sections",
			"-static-libgcc",
			"-static-libstdc++"
		}

	configuration { "x32", "mingw-gcc", _filter }
		defines { "RTM_WIN32", "RTM_WINDOWS", "WINVER=0x0601", "_WIN32_WINNT=0x0601" }
		buildoptions { "-m32" }
		libdirs {
			"$(MINGW)/x86_64-w64-mingw32/lib32"
		}

	configuration { "x64", "mingw-gcc", _filter }
		defines { "RTM_WIN64", "RTM_WINDOWS", "WINVER=0x0601", "_WIN32_WINNT=0x0601" }
		libdirs {
			"$(GLES_X64_DIR)",
			"$(MINGW)/x86_64-w64-mingw32/lib"
		}
		buildoptions { "-m64" }

	configuration { "mingw-clang", _filter }
		buildoptions {
			"-isystem$(MINGW)/lib/gcc/x86_64-w64-mingw32/4.8.1/include/c++",
			"-isystem$(MINGW)/lib/gcc/x86_64-w64-mingw32/4.8.1/include/c++/x86_64-w64-mingw32",
			"-isystem$(MINGW)/x86_64-w64-mingw32/include",
		}
		linkoptions {
			"-Qunused-arguments",
			"-Wno-error=unused-command-line-argument-hard-error-in-future",
		}

	configuration { "x32", "mingw-clang", _filter }
		defines { "RTM_WIN32", "RTM_WINDOWS", "WINVER=0x0601", "_WIN32_WINNT=0x0601" }
		buildoptions { "-m32" }

	configuration { "x64", "mingw-clang", _filter }
		defines { "RTM_WIN64", "RTM_WINDOWS", "WINVER=0x0601", "_WIN32_WINNT=0x0601" }
		libdirs {
			"$(GLES_X64_DIR)",
		}
		buildoptions { "-m64" }

	configuration { "linux-clang", _filter }

	configuration { "linux-gcc-5", _filter }
		buildoptions {
--			"-fno-omit-frame-pointer",
--			"-fsanitize=address",
--			"-fsanitize=undefined",
--			"-fsanitize=float-divide-by-zero",
--			"-fsanitize=float-cast-overflow",
		}
		links {
--			"asan",
--			"ubsan",
		}

	configuration { "linux-g*", _filter }
		buildoptions {
			"-mfpmath=sse", -- force SSE to get 32-bit and 64-bit builds deterministic.
		}

	configuration { "linux-*", _filter }
		defines { "RTM_LINUX" }
		buildoptions {
			"-msse2",
			"-Wunused-value",
			"-Wundef",
		}
		buildoptions_cpp {
			"-std=c++11",
		}
		links {
			"rt",
			"dl",
		}
		linkoptions {
			"-Wl,--gc-sections",
		}

	configuration { "linux-g*", "x32", _filter }
		buildoptions {
			"-m32",
		}

	configuration { "linux-g*", "x64", _filter }
		buildoptions {
			"-m64",
		}

	configuration { "linux-clang", "x32", _filter }
		buildoptions {
			"-m32",
		}

	configuration { "linux-clang", "x64", _filter }
		buildoptions {
			"-m64",
		}

	configuration { "android-*", "debug", _filter }
		defines { "NDK_DEBUG=1" }

	configuration { "android-*", _filter }
		defines { "RTM_ANDROID" }
		flags {
			"NoImportLib",
		}
		includedirs {
			"$(ANDROID_NDK_ROOT)/sources/cxx-stl/gnu-libstdc++/4.8/include",
			"$(ANDROID_NDK_ROOT)/sources/android/native_app_glue",
		}
		linkoptions {
			"-nostdlib",
			"-static-libgcc",
		}
		links {
			"c",
			"dl",
			"m",
			"android",
			"log",
			"gnustl_static",
			"gcc",
		}
		buildoptions {
			"-fPIC",
			"-no-canonical-prefixes",
			"-Wa,--noexecstack",
			"-fstack-protector",
			"-ffunction-sections",
			"-Wno-psabi", -- note: the mangling of 'va_list' has changed in GCC 4.4.0
			"-Wunused-value",
			"-Wundef",
		}
		buildoptions_cpp {
			"-std=c++11",
		}
		linkoptions {
			"-no-canonical-prefixes",
			"-Wl,--no-undefined",
			"-Wl,-z,noexecstack",
			"-Wl,-z,relro",
			"-Wl,-z,now",
		}

	configuration { "android-arm", _filter }
		libdirs {
			"$(ANDROID_NDK_ROOT)/sources/cxx-stl/gnu-libstdc++/4.8/libs/armeabi-v7a",
		}
		includedirs {
			"$(ANDROID_NDK_ROOT)/sources/cxx-stl/gnu-libstdc++/4.8/libs/armeabi-v7a/include"
		}
		buildoptions {
			"--sysroot=" .. path.join("$(ANDROID_NDK_ROOT)/platforms", androidPlatform, "arch-arm"),
			"-mthumb",
			"-march=armv7-a",
			"-mfloat-abi=softfp",
			"-mfpu=neon",
			"-Wunused-value",
			"-Wundef",
		}
		linkoptions {
			"--sysroot=" .. path.join("$(ANDROID_NDK_ROOT)/platforms", androidPlatform, "arch-arm"),
			path.join("$(ANDROID_NDK_ROOT)/platforms", androidPlatform, "arch-arm/usr/lib/crtbegin_so.o"),
			path.join("$(ANDROID_NDK_ROOT)/platforms", androidPlatform, "arch-arm/usr/lib/crtend_so.o"),
			"-march=armv7-a",
			"-Wl,--fix-cortex-a8",
		}

	configuration { "android-mips", _filter }
		libdirs {
			"$(ANDROID_NDK_ROOT)/sources/cxx-stl/gnu-libstdc++/4.8/libs/mips",
		}
		includedirs {
			"$(ANDROID_NDK_ROOT)/sources/cxx-stl/gnu-libstdc++/4.8/libs/mips/include",
		}
		buildoptions {
			"--sysroot=" .. path.join("$(ANDROID_NDK_ROOT)/platforms", androidPlatform, "arch-mips"),
			"-Wunused-value",
			"-Wundef",
		}
		linkoptions {
			"--sysroot=" .. path.join("$(ANDROID_NDK_ROOT)/platforms", androidPlatform, "arch-mips"),
			path.join("$(ANDROID_NDK_ROOT)/platforms", androidPlatform, "arch-mips/usr/lib/crtbegin_so.o"),
			path.join("$(ANDROID_NDK_ROOT)/platforms", androidPlatform, "arch-mips/usr/lib/crtend_so.o"),
		}

	configuration { "android-x86", _filter }
		libdirs {
			"$(ANDROID_NDK_ROOT)/sources/cxx-stl/gnu-libstdc++/4.8/libs/x86",
		}
		includedirs {
			"$(ANDROID_NDK_ROOT)/sources/cxx-stl/gnu-libstdc++/4.8/libs/x86/include",
		}
		buildoptions {
			"--sysroot=" .. path.join("$(ANDROID_NDK_ROOT)/platforms", androidPlatform, "arch-x86"),
			"-march=i686",
			"-mtune=atom",
			"-mstackrealign",
			"-msse3",
			"-mfpmath=sse",
			"-Wunused-value",
			"-Wundef",
		}
		linkoptions {
			"--sysroot=" .. path.join("$(ANDROID_NDK_ROOT)/platforms", androidPlatform, "arch-x86"),
			path.join("$(ANDROID_NDK_ROOT)/platforms", androidPlatform, "arch-x86/usr/lib/crtbegin_so.o"),
			path.join("$(ANDROID_NDK_ROOT)/platforms", androidPlatform, "/arch-x86/usr/lib/crtend_so.o"),
		}

	configuration { "asmjs", _filter }
		defines { "RTM_ASMJS" }
		buildoptions {
			"-isystem$(EMSCRIPTEN)/system/include",
			"-isystem$(EMSCRIPTEN)/system/include/libc",
			"-Wunused-value",
			"-Wundef",
		}

	configuration { "freebsd", _filter }
		defines { "RTM_FREEBSD" }
		includedirs {
			path.join(getProjectPath("rbase"), "inc/compat/freebsd"),
		}

	configuration { "nacl or nacl-arm or pnacl", _filter }
		defines { "RTM_NACL" }
		buildoptions {
			"-U__STRICT_ANSI__", -- strcasecmp, setenv, unsetenv,...
			"-fno-stack-protector",
			"-fdiagnostics-show-option",
			"-fdata-sections",
			"-ffunction-sections",
			"-Wunused-value",
			"-Wundef",
		}
		buildoptions_cpp {
			"-std=c++11",
		}
		includedirs {
			"$(NACL_SDK_ROOT)/include",
			path.join(getProjectPath("rbase"), "inc/compat/nacl"),
		}

	configuration { "nacl", _filter }
		buildoptions {
			"-pthread",
			"-mfpmath=sse", -- force SSE to get 32-bit and 64-bit builds deterministic.
			"-msse2",
		}
		linkoptions {
			"-Wl,--gc-sections",
		}

	configuration { "x32", "nacl", _filter }
		linkoptions { "-melf32_nacl" }

	configuration { "x32", "nacl", "Debug", _filter }
		libdirs { "$(NACL_SDK_ROOT)/lib/newlib_x86_32/Debug" }

	configuration { "x32", "nacl", "Release", _filter }
		libdirs { "$(NACL_SDK_ROOT)/lib/newlib_x86_32/Release" }

	configuration { "x32", "nacl", "Retail", _filter }
		libdirs { "$(NACL_SDK_ROOT)/lib/newlib_x86_32/Release" }

	configuration { "x64", "nacl", _filter }
		linkoptions { "-melf64_nacl" }

	configuration { "x64", "nacl", "Debug", _filter }
		libdirs { "$(NACL_SDK_ROOT)/lib/newlib_x86_64/Debug" }

	configuration { "x64", "nacl", "Release", _filter }
		libdirs { "$(NACL_SDK_ROOT)/lib/newlib_x86_64/Release" }

	configuration { "x64", "nacl", "Retail", _filter }
		libdirs { "$(NACL_SDK_ROOT)/lib/newlib_x86_64/Release" }

	configuration { "nacl-arm", _filter }
		buildoptions {
			"-Wno-psabi", -- note: the mangling of 'va_list' has changed in GCC 4.4.0
		}

	configuration { "nacl-arm", "Debug", _filter }
		libdirs { "$(NACL_SDK_ROOT)/lib/newlib_arm/Debug" }

	configuration { "nacl-arm", "Release", _filter }
		libdirs { "$(NACL_SDK_ROOT)/lib/newlib_arm/Release" }

	configuration { "nacl-arm", "Retail", _filter }
		libdirs { "$(NACL_SDK_ROOT)/lib/newlib_arm/Release" }

	configuration { "pnacl", _filter }

	configuration { "pnacl", "Debug", _filter }
		libdirs { "$(NACL_SDK_ROOT)/lib/pnacl/Debug" }

	configuration { "pnacl", "Release", _filter }
		libdirs { "$(NACL_SDK_ROOT)/lib/pnacl/Release" }

	configuration { "pnacl", "Retail", _filter }
		libdirs { "$(NACL_SDK_ROOT)/lib/pnacl/Release" }

	configuration { "Xbox360", _filter }
		defines { "RTM_XBOX360" }
		includedirs { path.join(getProjectPath("rbase"), "inc/compat/msvc") }
		defines {
			"NOMINMAX",
			"_XBOX",
		}

	configuration { "osx", "x32", _filter }
		buildoptions {
			"-m32",
		}

	configuration { "osx", "x64", _filter }
		buildoptions {
			"-m64",
		}

	configuration { "osx", _filter }
		defines { "RTM_OSX" }
		buildoptions {
			"-Wfatal-errors",
			"-msse2",
			"-Wunused-value",
			"-Wundef",
		}
		includedirs { path.join(getProjectPath("rbase"), "inc/compat/osx") }

	configuration { "ios*", _filter }
		defines { "RTM_IOS" }
		linkoptions {
			"-lc++",
		}
		buildoptions {
			"-Wfatal-errors",
			"-Wunused-value",
			"-Wundef",
		}
		includedirs { path.join(getProjectPath("rbase"), "inc/compat/ios") }

	configuration { "ios-arm", _filter }
		linkoptions {
			"-miphoneos-version-min=7.0",
			"-arch armv7",
			"--sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS" ..iosPlatform .. ".sdk",
			"-L/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS" ..iosPlatform .. ".sdk/usr/lib/system",
			"-F/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS" ..iosPlatform .. ".sdk/System/Library/Frameworks",
			"-F/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS" ..iosPlatform .. ".sdk/System/Library/PrivateFrameworks",
		}
		buildoptions {
			"-miphoneos-version-min=7.0",
			"-arch armv7",
			"--sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS" ..iosPlatform .. ".sdk",
		}

	configuration { "ios-simulator", _filter }
		linkoptions {
			"-mios-simulator-version-min=7.0",
			"-arch i386",
			"--sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator" ..iosPlatform .. ".sdk",
			"-L/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator" ..iosPlatform .. ".sdk/usr/lib/system",
			"-F/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator" ..iosPlatform .. ".sdk/System/Library/Frameworks",
			"-F/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator" ..iosPlatform .. ".sdk/System/Library/PrivateFrameworks",
		}
		buildoptions {
			"-mios-simulator-version-min=7.0",
			"-arch i386",
			"--sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator" ..iosPlatform .. ".sdk",
		}

	configuration { "qnx-arm", _filter }
		defines { "RTM_QNX" }
--		includedirs { path.join(getProjectPath("rbase"), "inc/compat/qnx") }
		buildoptions {
			"-Wno-psabi", -- note: the mangling of 'va_list' has changed in GCC 4.4.0
			"-Wunused-value",
			"-Wundef",
		}
		buildoptions_cpp {
			"-std=c++11",
		}

	configuration { "rpi", _filter }
		defines { "RTM_RPI" }
		libdirs {
			"/opt/vc/lib",
		}
		defines {
			"__VCCOREVER__=0x04000000", -- There is no special prefedined compiler symbol to detect RaspberryPi, faking it.
			"__STDC_VERSION__=199901L",
		}
		buildoptions {
			"-Wunused-value",
			"-Wundef",
		}
		buildoptions_cpp {
			"-std=c++11",
		}
		includedirs {
			"/opt/vc/include",
			"/opt/vc/include/interface/vcos/pthreads",
			"/opt/vc/include/interface/vmcs_host/linux",
		}
		links {
			"rt",
		}
		linkoptions {
			"-Wl,--gc-sections",
		}

	configuration {}

	if _rappUsed == true then
		rappUsed(_filter, binDir)
	end
end

function strip()

	configuration { "android-arm", "Release" }
		postbuildcommands {
			"$(SILENT) echo Stripping symbols.",
			"$(SILENT) $(ANDROID_NDK_ARM)/bin/arm-linux-androideabi-strip -s \"$(TARGET)\""
		}

	configuration { "android-mips", "Release" }
		postbuildcommands {
			"$(SILENT) echo Stripping symbols.",
			"$(SILENT) $(ANDROID_NDK_MIPS)/bin/mipsel-linux-android-strip -s \"$(TARGET)\""
		}

	configuration { "android-x86", "Release" }
		postbuildcommands {
			"$(SILENT) echo Stripping symbols.",
			"$(SILENT) $(ANDROID_NDK_X86)/bin/i686-linux-android-strip -s \"$(TARGET)\""
		}

	configuration { "linux-* or rpi", "Release" }
		postbuildcommands {
			"$(SILENT) echo Stripping symbols.",
			"$(SILENT) strip -s \"$(TARGET)\""
		}

	configuration { "mingw*", "Release" }
		postbuildcommands {
			"$(SILENT) echo Stripping symbols.",
			"$(SILENT) $(MINGW)/bin/strip -s \"$(TARGET)\""
		}

	configuration { "pnacl" }
		postbuildcommands {
			"$(SILENT) echo Running pnacl-finalize.",
			"$(SILENT) " .. naclToolchain .. "finalize \"$(TARGET)\""
		}

	configuration { "*nacl*", "Release" }
		postbuildcommands {
			"$(SILENT) echo Stripping symbols.",
			"$(SILENT) " .. naclToolchain .. "strip -s \"$(TARGET)\""
		}

	configuration { "asmjs" }
		postbuildcommands {
			"$(SILENT) echo Running asmjs finalize.",
			"$(SILENT) $(EMSCRIPTEN)/emcc -O2 -s TOTAL_MEMORY=268435456 \"$(TARGET)\" -o \"$(TARGET)\".html"
			-- ALLOW_MEMORY_GROWTH
		}

	configuration {} -- reset configuration
end

function rappUsed(_filter, _binDir)

	if _OPTIONS["with-sdl"] then
		defines { "ENTRY_CONFIG_USE_SDL=1" }
		links   { "SDL2" }

		configuration { "x32", "windows", _filter }
			libdirs { "$(SDL2_DIR)/lib/x86" }

		configuration { "x64", "windows", _filter }
			libdirs { "$(SDL2_DIR)/lib/x64" }

		configuration {}
	end

	if _OPTIONS["with-glfw"] then
		defines { "ENTRY_CONFIG_USE_GLFW=1" }
		links   {
			"glfw3"
		}

		configuration { "linux or freebsd", _filter }
			links {
				"Xrandr",
				"Xinerama",
				"Xi",
				"Xxf86vm",
				"Xcursor",
			}

		configuration { "osx", _filter }
			linkoptions {
				"-framework CoreVideo",
				"-framework IOKit",
			}

		configuration {}
	end

	if _OPTIONS["with-ovr"] then
		links   {
			"winmm",
			"ws2_32",
		}

		-- Check for LibOVR 5.0+
		if os.isdir(path.join(os.getenv("OVR_DIR"), "LibOVR/Lib/Windows/Win32/Debug/VS2012")) then

			configuration { "x32", "Debug", _filter }
				libdirs { path.join("$(OVR_DIR)/LibOVR/Lib/Windows/Win32/Debug", _ACTION) }

			configuration { "x32", "Release", _filter }
				libdirs { path.join("$(OVR_DIR)/LibOVR/Lib/Windows/Win32/Release", _ACTION) }

			configuration { "x64", "Debug", _filter }
				libdirs { path.join("$(OVR_DIR)/LibOVR/Lib/Windows/x64/Debug", _ACTION) }

			configuration { "x64", "Release", _filter }
				libdirs { path.join("$(OVR_DIR)/LibOVR/Lib/Windows/x64/Release", _ACTION) }

			configuration { "x32 or x64", _filter }
				links { "libovr" }
		else
			configuration { "x32", _filter }
				libdirs { path.join("$(OVR_DIR)/LibOVR/Lib/Win32", _ACTION) }

			configuration { "x64", _filter }
				libdirs { path.join("$(OVR_DIR)/LibOVR/Lib/x64", _ACTION) }

			configuration { "x32", "Debug", _filter }
				links { "libovrd" }

			configuration { "x32", "Release", _filter }
				links { "libovr" }

			configuration { "x64", "Debug", _filter }
				links { "libovr64d" }

			configuration { "x64", "Release", _filter }
				links { "libovr64" }
		end

		configuration {}
	end

	configuration { "vs*", _filter }
		linkoptions {
			"/ignore:4199", -- LNK4199: /DELAYLOAD:*.dll ignored; no imports found from *.dll
		}
		links { -- this is needed only for testing with GLES2/3 on Windows with VS2008
			"DelayImp",
		}

	configuration { "vs201*", _filter }
		linkoptions { -- this is needed only for testing with GLES2/3 on Windows with VS201x
			"/DELAYLOAD:\"libEGL.dll\"",
			"/DELAYLOAD:\"libGLESv2.dll\"",
		}

	configuration { "mingw*", _filter }
		targetextension ".exe"

	configuration { "vs20* or mingw*", _filter }
		links {
			"gdi32",
			"psapi",
		}

	configuration { "winphone8* or winstore8*", _filter }
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

	-- WinRT targets need their own output directories or build files stomp over each other
	configuration { "x32", "winphone8* or winstore8*", _filter }
		targetdir (path.join(BGFX_BUILD_DIR, "win32_" .. _ACTION, "bin", _name))
		objdir (path.join(BGFX_BUILD_DIR, "win32_" .. _ACTION, "obj", _name))

	configuration { "x64", "winphone8* or winstore8*", _filter }
		targetdir (path.join(BGFX_BUILD_DIR, "win64_" .. _ACTION, "bin", _name))
		objdir (path.join(BGFX_BUILD_DIR, "win64_" .. _ACTION, "obj", _name))

	configuration { "ARM", "winphone8* or winstore8*", _filter }
		targetdir (path.join(BGFX_BUILD_DIR, "arm_" .. _ACTION, "bin", _name))
		objdir (path.join(BGFX_BUILD_DIR, "arm_" .. _ACTION, "obj", _name))

	configuration { "mingw-clang", _filter }
		kind "ConsoleApp"

	configuration { "android*", _filter }
		kind "ConsoleApp"
		targetextension ".so"
		linkoptions {
			"-shared",
		}
		links {
			"EGL",
			"GLESv2",
		}

	configuration { "nacl*", _filter }
		kind "ConsoleApp"
		targetextension ".nexe"
		links {
			"ppapi",
			"ppapi_gles2",
			"pthread",
		}

	configuration { "pnacl", _filter }
		kind "ConsoleApp"
		targetextension ".pexe"
		links {
			"ppapi",
			"ppapi_gles2",
			"pthread",
		}

	configuration { "asmjs", _filter }
		kind "ConsoleApp"
		targetextension ".bc"

	configuration { "linux-* or freebsd", _filter }
		links {
--			"X11",
--			"GL",
			"pthread",
		}

	configuration { "rpi", _filter }
		links {
--			"X11",
--			"GLESv2",
--			"EGL",
			"bcm_host",
			"vcos",
			"vchiq_arm",
			"pthread",
		}

	configuration { "osx", _filter }
		files {
			path.join(BGFX_DIR, "examples/common/**.mm"),
		}
		links {
			"Cocoa.framework",
			"OpenGL.framework",
		}

	configuration { "ios*", _filter }
		kind "ConsoleApp"
		files {
			path.join(BGFX_DIR, "examples/common/**.mm"),
		}
		linkoptions {
			"-framework CoreFoundation",
			"-framework Foundation",
			"-framework OpenGLES",
			"-framework UIKit",
			"-framework QuartzCore",
		}

	configuration { "xcode4", "ios", _filter }
		if getTargetOS() == "ios" then
		kind "WindowedApp"
		files {
			path.join(BGFX_DIR, "examples/runtime/iOS-Info.plist"),
		}
		end

	configuration { "qnx*", _filter }
		targetextension ""
		links {
			"EGL",
			"GLESv2",
		}

	configuration {}

	if _OPTIONS["no-deploy"] == nil then
		prepareProjectDeployment(_filter, _binDir)
	end
	
	configuration {}

end

