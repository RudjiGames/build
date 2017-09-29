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

local iosPlatform      = ""
local tvosPlatform     = ""

androidTarget          = "14"
local androidPlatform  = "android-" .. androidTarget

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
        { "linux-gcc-6",   "Linux (GCC-6 compiler)" },
        { "linux-clang",   "Linux (Clang compiler)" },
        { "ios-arm",       "iOS - ARM"              },
        { "ios-arm64",     "iOS - ARM64"            },
        { "ios-simulator", "iOS - Simulator"        },
        { "tvos-arm64",    "tvOS - ARM64"           },
        { "tvos-simulator","tvOS - Simulator"       },
        { "mingw-gcc",     "MinGW"                  },
        { "mingw-clang",   "MinGW (clang compiler)" },
        { "osx",           "OSX"                    },
        { "orbis",         "Orbis"                  },
        { "rpi",           "RaspberryPi"            },
    },
}

newoption {
	trigger = "vs",
	value = "toolset",
	description = "Choose VS toolset",
	allowed = {
        { "vs2012-clang",  "Clang 3.6"                       },
        { "vs2013-clang",  "Clang 3.6"                       },
        { "vs2015-clang",  "Clang 3.9"                       },
        { "vs2017-clang",  "Clang with MS CodeGen"           },
        { "vs2012-xp",     "Visual Studio 2012 targeting XP" },
        { "vs2013-xp",     "Visual Studio 2013 targeting XP" },
        { "vs2015-xp",     "Visual Studio 2015 targeting XP" },
        { "vs2017-xp",     "Visual Studio 2017 targeting XP" },
        { "winphone8",     "Windows Phone 8.0"               },
        { "winphone81",    "Windows Phone 8.1"               },
        { "winstore81",    "Windows Store 8.1"               },
        { "winstore82",    "Universal Windows App"           },
        { "durango",       "Durango"                         },
        { "orbis",         "Orbis"                           }
    },
}

newoption {
	trigger = "xcode",
	value = "xcode_target",
	description = "Choose XCode target",
	allowed = {
		{ "osx",  "OSX"  },
		{ "ios",  "iOS"  },
		{ "tvos", "tvOS" },
	}
}

newoption {
	trigger     = "with-android",
	value       = "#",
	description = "Set Android platform version (default: android-14).",
}

newoption {
	trigger     = "with-ios",
	value       = "#",
	description = "Set iOS target version (default: 8.0).",
}

newoption {
	trigger     = "with-tvos",
	value       = "#",
	description = "Set tvOS target version (default: 9.0).",
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
		(_OPTIONS["gcc"] == "linux-gcc-6") or
		(_OPTIONS["gcc"] == "linux-clang") then
		return "linux"
	end

	-- gmake - ios
	-- xcode - ios	
	if	(_OPTIONS["xcode"] == "ios") or
		(_OPTIONS["gcc"]   == "ios-arm") or
		(_OPTIONS["gcc"]   == "ios-arm64") or
		(_OPTIONS["gcc"]   == "ios-simulator") then
		return "ios"
	end

	-- gmake - tvos
	-- xcode - tvos	
	if	(_OPTIONS["xcode"] == "tvos") or
		(_OPTIONS["gcc"]   == "tvos-arm64") or
		(_OPTIONS["gcc"]   == "tvos-simulator") then
		return "tvos"
	end

	-- gmake - osx
	-- xcode - osx
	if	(_OPTIONS["xcode"] == "osx") or
		(_OPTIONS["gcc"]   == "osx") then
		return "osx"
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

	if  (_OPTIONS["vs"]  == "orbis") or
		(_OPTIONS["gcc"] == "orbis") then
		return "orbis"
	end

	if (_OPTIONS["vs"]  == "durango") then
		return "durango"
	end
	
	-- visual studio - windows
	-- gmake - mingw
	if	(_OPTIONS["gcc"] == "mingw-gcc") or
		(_OPTIONS["gcc"] == "mingw-clang") or
		(_OPTIONS["vs"]  == "vs2012-clang") or
		(_OPTIONS["vs"]  == "vs2013-clang") or
		(_OPTIONS["vs"]  == "vs2015-clang") or
		(_OPTIONS["vs"]  == "vs2017-clang") or
		(_OPTIONS["vs"]  == "vs2012-xp") or
		(_OPTIONS["vs"]  == "vs2013-xp") or
		(_OPTIONS["vs"]  == "vs2015-xp") or
		(_OPTIONS["vs"]  == "vs2017-xp") or
		(_ACTION ~= nil and _ACTION:find("vs")) then
		return "windows"
	end

	return "unknown"
end

function getTargetCompiler()

	-- gmake - android
	if  (_OPTIONS["gcc"] == "android-arm")  then	return "gcc-arm"		end
	if	(_OPTIONS["gcc"] == "android-mips") then	return "gcc-mips"		end
	if	(_OPTIONS["gcc"] == "android-x86")  then	return "gcc-x86"		end

	-- gmake - asmjs
	if (_OPTIONS["gcc"] == "asmjs")			then	return "gcc"			end

	-- gmake - freebsd
	if (_OPTIONS["gcc"] == "freebsd")		then	return "gcc"			end

	-- gmake - linux
	if	(_OPTIONS["gcc"] == "linux-gcc")	then	return "gcc"			end
	if	(_OPTIONS["gcc"] == "linux-gcc-6")  then	return "gcc-6"			end
	if	(_OPTIONS["gcc"] == "linux-clang")	then	return "clang"			end

	-- gmake - ios
	-- xcode - ios	
	if (_OPTIONS["gcc"] == "ios-arm")		then	return "gcc-arm"		end
	if (_OPTIONS["gcc"] == "ios-arm64")		then	return "gcc-arm64"		end
	if (_OPTIONS["gcc"] == "ios-simulator") then	return "gcc-sim"		end
	if (_OPTIONS["xcode"] == "ios")			then	return "xcode"			end

	-- gmake - tvos
	-- xcode - tvos	
	if (_OPTIONS["gcc"] == "tvos-arm64")	then	return "gcc-arm64"		end
	if (_OPTIONS["gcc"] == "tvos-simulator")then	return "gcc-sim"		end
	if (_OPTIONS["xcode"] == "tvos")		then	return "xcode"			end

	-- gmake - osx
	-- xcode - osx
	if (_OPTIONS["gcc"] == "osx")			then	return "gcc"			end
	if (_OPTIONS["xcode"] == "osx")			then	return "xcode"			end

	-- gmake - rpi
	if (_OPTIONS["gcc"] == "rpi")			then	return "gcc"			end

	-- gmake - orbis
	-- visuul studio - orbis
	if (_OPTIONS["gcc"] == "orbis")			then	return "orbis-clang"	end
	if (_OPTIONS["vs"]  == "orbis")			then	return "orbis-clang"	end

	-- visuul studio - durango
	if (_OPTIONS["vs"]  == "durango")		then	return _ACTION			end

	-- visual studio - multi
	if	(_OPTIONS["vs"] ~= nil)				then	return _OPTIONS["vs"]	end
	
	-- gmake - mingw
	-- visual studio - *
	if	(_OPTIONS["gcc"] == "mingw-gcc")	then	return "mingw-gcc"		end
	if	(_OPTIONS["gcc"] == "mingw-clang")	then	return "mingw-clang"	end
	if (_ACTION ~= nil and _ACTION:find("vs")) then	return _ACTION			end

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

function getSolutionBaseDir()
	local locationDir = getTargetOS() .. "/" .. getTargetCompiler() .. "/" .. solution().name
	return path.join(RTM_BUILD_DIR, locationDir)
end

function getLocationDir()
	return getSolutionBaseDir() .. "/projects/"
end

function getBuildDirRoot(_filter)
	local pathAdd = ""
	for _,dir in ipairs(_filter) do
		pathAdd = pathAdd .. "/" .. dir
	end
	return getSolutionBaseDir() .. "/" .. pathAdd .. "/"
end

function toolchain()

	-- Avoid error when invoking genie --help.
	if (_ACTION == nil) then return false end

	local fullLocation = getLocationDir()

	RTM_LOCATION_PATH = fullLocation
	location (fullLocation)
	mkdir(fullLocation)

	if _ACTION == "clean" then
		rmdir(RTM_BUILD_DIR)
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

			if not os.getenv("ANDROID_NDK_ARM") or not os.getenv("ANDROID_NDK_CLANG") or not os.getenv("ANDROID_NDK_ROOT") then
				print("Set ANDROID_NDK_ARM, ANDROID_NDK_CLANG, and ANDROID_NDK_ROOT environment variables.")
			end 

			premake.gcc.cc   = "$(ANDROID_NDK_CLANG)/bin/clang"
			premake.gcc.cxx  = "$(ANDROID_NDK_CLANG)/bin/clang++"
			premake.gcc.ar   = "$(ANDROID_NDK_ARM)/bin/arm-linux-androideabi-ar"
			premake.gcc.llvm = true

		elseif "android-mips" == _OPTIONS["gcc"] then

			if not os.getenv("ANDROID_NDK_MIPS") or not os.getenv("ANDROID_NDK_CLANG") or not os.getenv("ANDROID_NDK_ROOT") then
				print("Set ANDROID_NDK_MIPS, ANDROID_NDK_CLANG, and ANDROID_NDK_ROOT environment variables.")
			end 

			premake.gcc.cc   = "$(ANDROID_NDK_CLANG)/bin/clang"
			premake.gcc.cxx  = "$(ANDROID_NDK_CLANG)/bin/clang++"
			premake.gcc.ar   = "$(ANDROID_NDK_MIPS)/bin/mipsel-linux-android-ar"
			premake.gcc.llvm = true

		elseif "android-x86" == _OPTIONS["gcc"] then

			if not os.getenv("ANDROID_NDK_X86") or not os.getenv("ANDROID_NDK_CLANG") or not os.getenv("ANDROID_NDK_ROOT") then
				print("Set ANDROID_NDK_X86, ANDROID_NDK_CLANG, and ANDROID_NDK_ROOT environment variables.")
			end 

			premake.gcc.cc   = "$(ANDROID_NDK_CLANG)/bin/clang"
			premake.gcc.cxx  = "$(ANDROID_NDK_CLANG)/bin/clang++"
			premake.gcc.ar   = "$(ANDROID_NDK_X86)/bin/i686-linux-android-ar"
			premake.gcc.llvm = true

		elseif "asmjs" == _OPTIONS["gcc"] then

			if not os.getenv("EMSCRIPTEN") then
				print("Set EMSCRIPTEN enviroment variables.")
			end

			premake.gcc.cc   = "\"$(EMSCRIPTEN)/emcc\""
			premake.gcc.cxx  = "\"$(EMSCRIPTEN)/em++\""
			premake.gcc.ar   = "\"$(EMSCRIPTEN)/emar\""
			premake.gcc.llvm = true

		elseif "freebsd" == _OPTIONS["gcc"] then

		elseif "ios-arm" == _OPTIONS["gcc"] or "ios-arm64" == _OPTIONS["gcc"] then
			premake.gcc.cc  = "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang"
			premake.gcc.cxx = "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++"
			premake.gcc.ar  = "ar"

		elseif "ios-simulator" == _OPTIONS["gcc"] then
			premake.gcc.cc  = "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang"
			premake.gcc.cxx = "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++"
			premake.gcc.ar  = "ar"

		elseif "tvos-arm64" == _OPTIONS["gcc"] then
			premake.gcc.cc  = "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang"
			premake.gcc.cxx = "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++"
			premake.gcc.ar  = "ar"
			
		elseif "tvos-simulator" == _OPTIONS["gcc"] then
			premake.gcc.cc  = "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang"
			premake.gcc.cxx = "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++"
			premake.gcc.ar  = "ar"
			
		elseif "linux-gcc" == _OPTIONS["gcc"] then

		elseif "linux-gcc-6" == _OPTIONS["gcc"] then
			premake.gcc.cc  = "gcc-6"
			premake.gcc.cxx = "g++-6"
			premake.gcc.ar  = "ar"

		elseif "linux-clang" == _OPTIONS["gcc"] then
			premake.gcc.cc  = "clang"
			premake.gcc.cxx = "clang++"
			premake.gcc.ar  = "ar"

		elseif "mingw-gcc" == _OPTIONS["gcc"] then

			if not os.getenv("MINGW") then
				print("Set MINGW environment variable.")
			end

			premake.gcc.cc  = "$(MINGW)/bin/x86_64-w64-mingw32-gcc"
			premake.gcc.cxx = "$(MINGW)/bin/x86_64-w64-mingw32-g++"
			premake.gcc.ar  = "$(MINGW)/bin/ar"

		elseif "mingw-clang" == _OPTIONS["gcc"] then

			if not os.getenv("CLANG") or not os.getenv("MINGW") then
				print("Set CLANG and MINGW environment variables.")
			end

			premake.gcc.cc   = "$(CLANG)/bin/clang"
			premake.gcc.cxx  = "$(CLANG)/bin/clang++"
			premake.gcc.ar   = "$(MINGW)/bin/ar"
			premake.gcc.llvm = true

		elseif "osx" == _OPTIONS["gcc"] then

			if os.is("linux") then
				if not os.getenv("OSXCROSS") then
					print("Set OSXCROSS environment variable.")
				end

				local osxToolchain = "x86_64-apple-darwin15-"
				premake.gcc.cc  = "$(OSXCROSS)/target/bin/" .. osxToolchain .. "clang"
				premake.gcc.cxx = "$(OSXCROSS)/target/bin/" .. osxToolchain .. "clang++"
				premake.gcc.ar  = "$(OSXCROSS)/target/bin/" .. osxToolchain .. "ar"
			end

		elseif "orbis" == _OPTIONS["gcc"] then

			if not os.getenv("SCE_ORBIS_SDK_DIR") then
				print("Set SCE_ORBIS_SDK_DIR environment variable.")
			end

			orbisToolchain = "\"$(SCE_ORBIS_SDK_DIR)/host_tools/bin/orbis-"

			premake.gcc.cc  = orbisToolchain .. "clang\""
			premake.gcc.cxx = orbisToolchain .. "clang++\""
			premake.gcc.ar  = orbisToolchain .. "ar\""

		elseif "rpi" == _OPTIONS["gcc"] then
		end

		elseif _ACTION == "vs2012" or _ACTION == "vs2013" or _ACTION == "vs2015" or _ACTION == "vs2017" then

			if (_ACTION .. "-clang") == _OPTIONS["vs"] then
				if "vs2017-clang" == _OPTIONS["vs"] then
					premake.vstudio.toolset = "v141_clang_c2"
				elseif "vs2015-clang" == _OPTIONS["vs"] then
					premake.vstudio.toolset = "LLVM-vs2014"
				else
					premake.vstudio.toolset = ("LLVM-" .. _ACTION)
				end

			elseif "winphone8" == _OPTIONS["vs"] then
				premake.vstudio.toolset = "v110_wp80"

			elseif "winphone81" == _OPTIONS["vs"] then
				premake.vstudio.toolset = "v120_wp81"
				premake.vstudio.storeapp = "8.1"
				platforms { "ARM" }

			elseif "winstore81" == _OPTIONS["vs"] then
				premake.vstudio.toolset = "v120"
				premake.vstudio.storeapp = "8.1"
				platforms { "ARM" }

			elseif "winstore82" == _OPTIONS["vs"] then
				premake.vstudio.toolset = "v140"
				premake.vstudio.storeapp = "8.2"
				platforms { "ARM" }

			elseif "durango" == _OPTIONS["vs"] then
				if not os.getenv("DurangoXDK") then
					print("DurangoXDK not found.")
				end

				premake.vstudio.toolset = "v140"
				premake.vstudio.storeapp = "durango"
				platforms { "Durango" } 

			elseif "orbis" == _OPTIONS["vs"] then
				if not os.getenv("SCE_ORBIS_SDK_DIR") then
					print("Set SCE_ORBIS_SDK_DIR environment variable.")
				end
				platforms { "Orbis" }
	 			premake.vstudio.toolset = "Clang"

			elseif ("vs2012-xp") == _OPTIONS["vs"] then
				premake.vstudio.toolset = ("v110_xp")

			elseif ("vs2013-xp") == _OPTIONS["vs"] then
				premake.vstudio.toolset = ("v120_xp")

			elseif ("vs2015-xp") == _OPTIONS["vs"] then
				premake.vstudio.toolset = ("v140_xp")
			end

			elseif ("vs2017-xp") == _OPTIONS["vs"] then
				premake.vstudio.toolset = ("v141_xp")

			elseif _ACTION == "xcode4" then

				if "osx" == _OPTIONS["xcode"] then
					premake.xcode.toolset = "macosx"

			elseif "ios" == _OPTIONS["xcode"] then
				premake.xcode.toolset = "iphoneos"

			elseif "tvos" == _OPTIONS["xcode"] then
				premake.xcode.toolset = "appletvos"
			end
		end

	configuration {} -- reset configuration

	return true
end

function commonConfig(_filter, _isLib, _isSharedLib, _executable)

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

	configuration { "vs*", _filter, "not orbis" }
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
			"/Ob2"		-- The Inline Function Expansion
		}
		linkoptions {
			"/ignore:4221", -- LNK4221: This object file does not define any previously undefined public symbols, so it will not be used by any link operation that consumes this library
		}

	configuration { "vs2008", _filter }
		includedirs { path.join(getProjectPath("rbase"), "inc/compat/msvc/pre1600") }

	configuration { "x32", "vs*", "not orbis", _filter }
		defines { "RTM_WIN32", "RTM_WINDOWS" }

	configuration { "x64", "vs*", "not orbis", _filter }
		defines { "RTM_WIN64", "RTM_WINDOWS", "_WIN64" }

	configuration { "ARM", "vs*", "not orbis", _filter }

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
			"-fopenmp",
		}
		links {
			"gomp", 
		}

	configuration { "mingw-*", _filter }
		defines { "WIN32" }
		includedirs { path.join(getProjectPath("rbase"), "inc/compat/mingw") }
		buildoptions {
			"-Wunused-value",
			"-fdata-sections",
			"-ffunction-sections",
			"-msse2",
			"-Wunused-value",
			"-Wundef",
		}
		buildoptions_cpp {
			"-std=c++11",
		}
		links { 
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

	configuration { "linux-gcc-6", _filter }
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

	configuration { "linux-gcc* or linux-clang*" }
		buildoptions {
			"-msse2",
--			"-Wdouble-promotion",
--			"-Wduplicated-branches",
--			"-Wduplicated-cond",
--			"-Wjump-misses-init",
			"-Wlogical-op",
			"-Wshadow",
--			"-Wnull-dereference",
			"-Wunused-value",
			"-Wundef",
--			"-Wuseless-cast",
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
			"-Wl,--as-needed",
		}

	configuration { "linux-*", "x32", _filter }
		buildoptions {
			"-m32",
		}

	configuration { "linux-*", "x64", _filter }
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
			"$(ANDROID_NDK_ROOT)/sources/cxx-stl/llvm-libc++/include",
			"$(ANDROID_NDK_ROOT)/sources/android/native_app_glue",
		}
		linkoptions {
			"-nostdlib"
		}
		links {
			"c",
			"dl",
			"m",
			"android",
			"log",
			"c++",
			"gcc",
		}
		buildoptions {
			"-fPIC",
			"-no-canonical-prefixes",
			"-Wa,--noexecstack",
			"-fstack-protector-strong",
			"-ffunction-sections",
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
			"$(ANDROID_NDK_ROOT)/sources/cxx-stl/llvm-libc++/libs/armeabi-v7a"
		}
		includedirs {
			"$(ANDROID_NDK_ROOT)/sources/cxx-stl/llvm-libc++/libs/armeabi-v7a/include",
			"$(ANDROID_NDK_ROOT)/sources/cxx-stl/llvm-libc++/include"
		}
		buildoptions {
			"-gcc-toolchain $(ANDROID_NDK_ARM)",
			"--sysroot=" .. path.join("$(ANDROID_NDK_ROOT)/platforms", androidPlatform, "arch-arm"),
			"-target armv7-none-linux-androideabi",
			"-mthumb",
			"-march=armv7-a",
			"-mfloat-abi=softfp",
			"-mfpu=neon",
			"-Wunused-value",
			"-Wundef"
		}
		linkoptions {
			"-gcc-toolchain $(ANDROID_NDK_ARM)",
			"--sysroot=" .. path.join("$(ANDROID_NDK_ROOT)/platforms", androidPlatform, "arch-arm"),
			path.join("$(ANDROID_NDK_ROOT)/platforms", androidPlatform, "arch-arm/usr/lib/crtbegin_so.o"),
			path.join("$(ANDROID_NDK_ROOT)/platforms", androidPlatform, "arch-arm/usr/lib/crtend_so.o"),
			"-target armv7-none-linux-androideabi",
			"-march=armv7-a",
			"-Wl,--fix-cortex-a8"
		}

	configuration { "android-mips", _filter }
		libdirs {
			"$(ANDROID_NDK_ROOT)/sources/cxx-stl/llvm-libc++/libs/mips"
		}
		includedirs {
			"$(ANDROID_NDK_ROOT)/sources/cxx-stl/llvm-libc++/libs/mips/include"
		}
		buildoptions {
			"-gcc-toolchain $(ANDROID_NDK_MIPS)",
			"--sysroot=" .. path.join("$(ANDROID_NDK_ROOT)/platforms", androidPlatform, "arch-mips"),
			"-target mipsel-none-linux-android",
			"-mips32",
			"-Wunused-value",
			"-Wundef"
		}
		linkoptions {
			"-gcc-toolchain $(ANDROID_NDK_MIPS)",
			"--sysroot=" .. path.join("$(ANDROID_NDK_ROOT)/platforms", androidPlatform, "arch-mips"),
			path.join("$(ANDROID_NDK_ROOT)/platforms", androidPlatform, "arch-mips/usr/lib/crtbegin_so.o"),
			path.join("$(ANDROID_NDK_ROOT)/platforms", androidPlatform, "arch-mips/usr/lib/crtend_so.o"),
			"-target mipsel-none-linux-android",
			"-mips32"
		}

	configuration { "android-x86", _filter }
		libdirs {
			"$(ANDROID_NDK_ROOT)/sources/cxx-stl/llvm-libc++/libs/x86"
		}
		includedirs {
			"$(ANDROID_NDK_ROOT)/sources/cxx-stl/llvm-libc++/libs/x86/include"
		}
		buildoptions {
			"-gcc-toolchain $(ANDROID_NDK_X86)",
			"--sysroot=" .. path.join("$(ANDROID_NDK_ROOT)/platforms", androidPlatform, "arch-x86"),
			"-target i686-none-linux-android",
			"-march=i686",
			"-mtune=atom",
			"-mstackrealign",
			"-msse3",
			"-mfpmath=sse",
			"-Wunused-value",
			"-Wundef"
		}
		linkoptions {
			"-gcc-toolchain $(ANDROID_NDK_X86)",
			"--sysroot=" .. path.join("$(ANDROID_NDK_ROOT)/platforms", androidPlatform, "arch-x86"),
			path.join("$(ANDROID_NDK_ROOT)/platforms", androidPlatform, "arch-x86/usr/lib/crtbegin_so.o"),
			path.join("$(ANDROID_NDK_ROOT)/platforms", androidPlatform, "arch-x86/usr/lib/crtend_so.o"),
			"-target i686-none-linux-android"
		}

	configuration { "asmjs", _filter }
		defines { "RTM_ASMJS" }
		buildoptions {
			"-i\"system$(EMSCRIPTEN)/system/include\"",
			"-i\"system$(EMSCRIPTEN)/system/include/libcxx\"",
			"-i\"system$(EMSCRIPTEN)/system/include/libc\"",
			"-Wunused-value",
			"-Wundef"
		}
		buildoptions_cpp {
			"-std=c++11",
		}

	configuration { "freebsd", _filter }
		defines { "RTM_FREEBSD" }
		includedirs {
			path.join(getProjectPath("rbase"), "inc/compat/freebsd"),
		}

	configuration { "durango", _filter }
		includedirs {
			path.join(getProjectPath("rbase"), "inc/compat/msvc"),
		}
		removeflags { 
			"StaticRuntime", 
			"NoExceptions" 
		}
		buildoptions { "/EHsc /await /std:c++latest" }
		linkoptions { "/ignore:4264" }


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
		buildoptions_cpp {
			"-std=c++11",
		}
		buildoptions_objcpp {
			"-std=c++11",
		}
		buildoptions {
			"-Wfatal-errors",
			"-msse2",
			"-Wunused-value",
			"-Wundef",
		}
		includedirs { path.join(getProjectPath("rbase"), "inc/compat/osx")
		}

	configuration { "ios*", _filter }
		defines { "RTM_IOS" }
		linkoptions {
			"-lc++",
		}
		buildoptions_cpp {
			"-std=c++11",
		}
		buildoptions_objcpp {
			"-std=c++11",
		}
		buildoptions {
			"-Wfatal-errors",
			"-Wunused-value",
			"-Wundef",
		}
		includedirs { path.join(getProjectPath("rbase"), "inc/compat/ios") }

	configuration { "ios-arm", _filter }
		linkoptions {
			"-arch armv7",
		}
		buildoptions {
			"-arch armv7",
		}

	configuration { "ios-arm64", _filter }
		linkoptions {
			"-arch arm64",
		}
		buildoptions {
			"-arch arm64",
		}

	configuration { "ios-arm*" }
		linkoptions {
			"-miphoneos-version-min=7.0",
			"--sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS" ..iosPlatform .. ".sdk",
			"-L/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS" ..iosPlatform .. ".sdk/usr/lib/system",
			"-F/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS" ..iosPlatform .. ".sdk/System/Library/Frameworks",
			"-F/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS" ..iosPlatform .. ".sdk/System/Library/PrivateFrameworks",
		}
		buildoptions {
			"-miphoneos-version-min=7.0",
			"--sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS" ..iosPlatform .. ".sdk",
		}

	configuration { "ios-simulator" }
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
	configuration { "tvos*" }
		linkoptions {
			"-lc++",
		}
		buildoptions {
			"-Wfatal-errors",
			"-Wunused-value",
			"-Wundef",
		}
		includedirs { path.join(getProjectPath("rbase"), "inc/compat/ios") }

	configuration { "tvos-arm64" }
		linkoptions {
			"-mtvos-version-min=9.0",
			"-arch arm64",
			"--sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/AppleTVOS.platform/Developer/SDKs/AppleTVOS" ..tvosPlatform .. ".sdk",
			"-L/Applications/Xcode.app/Contents/Developer/Platforms/AppleTVOS.platform/Developer/SDKs/AppleTVOS" ..tvosPlatform .. ".sdk/usr/lib/system",
			"-F/Applications/Xcode.app/Contents/Developer/Platforms/AppleTVOS.platform/Developer/SDKs/AppleTVOS" ..tvosPlatform .. ".sdk/System/Library/Frameworks",
			"-F/Applications/Xcode.app/Contents/Developer/Platforms/AppleTVOS.platform/Developer/SDKs/AppleTVOS" ..tvosPlatform .. ".sdk/System/Library/PrivateFrameworks",
		}
		buildoptions {
			"-mtvos-version-min=9.0",
			"-arch arm64",
			"--sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/AppleTVOS.platform/Developer/SDKs/AppleTVOS" ..tvosPlatform .. ".sdk",
		}

	configuration { "tvos-simulator" }
		linkoptions {
			"-mtvos-simulator-version-min=9.0",
			"-arch i386",
			"--sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/AppleTVSimulator.platform/Developer/SDKs/AppleTVSimulator" ..tvosPlatform .. ".sdk",
			"-L/Applications/Xcode.app/Contents/Developer/Platforms/AppleTVSimulator.platform/Developer/SDKs/AppleTVSimulator" ..tvosPlatform .. ".sdk/usr/lib/system",
			"-F/Applications/Xcode.app/Contents/Developer/Platforms/AppleTVSimulator.platform/Developer/SDKs/AppleTVSimulator" ..tvosPlatform .. ".sdk/System/Library/Frameworks",
			"-F/Applications/Xcode.app/Contents/Developer/Platforms/AppleTVSimulator.platform/Developer/SDKs/AppleTVSimulator" ..tvosPlatform .. ".sdk/System/Library/PrivateFrameworks",
		}
		buildoptions {
			"-mtvos-simulator-version-min=9.0",
			"-arch i386",
			"--sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/AppleTVSimulator.platform/Developer/SDKs/AppleTVSimulator" ..tvosPlatform .. ".sdk",
		}

	configuration { "orbis" }
		includedirs {
			path.join(getProjectPath("rbase"), "inc/compat/freebsd"),
			"$(SCE_ORBIS_SDK_DIR)/target/include",
			"$(SCE_ORBIS_SDK_DIR)/target/include_common",
		}
		buildoptions_cpp {
			"-std=c++11",
		}

	configuration { "durango", _filter }
		defines { "NOMINMAX" }
		links {
			"d3d11_x",
			"d3d12_x",
			"combase",
			"kernelx"
		}

	configuration { "rpi", _filter }
		defines { "RTM_RPI" }
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
			"dl",
		}
		linkoptions {
			"-Wl,--gc-sections",
		}

	configuration {}

	if _executable == true then
		rappUsed(_filter, binDir)
	end
end

function strip()

	configuration { "android-arm", "Release" or "Retail" }
		postbuildcommands {
			"$(SILENT) echo Stripping symbols.",
			"$(SILENT) $(ANDROID_NDK_ARM)/bin/arm-linux-androideabi-strip -s \"$(TARGET)\"" 
		}

	configuration { "android-mips", "Release" or "Retail" }
		postbuildcommands {
			"$(SILENT) echo Stripping symbols.",
			"$(SILENT) $(ANDROID_NDK_MIPS)/bin/mipsel-linux-android-strip -s \"$(TARGET)\"" 
		}

	configuration { "android-x86", "Release" or "Retail" }
		postbuildcommands {
			"$(SILENT) echo Stripping symbols.",
			"$(SILENT) $(ANDROID_NDK_X86)/bin/i686-linux-android-strip -s \"$(TARGET)\"" 
		}

	configuration { "linux-* or rpi", "Release" or "Retail" }
		postbuildcommands {
			"$(SILENT) echo Stripping symbols.",
			"$(SILENT) strip -s \"$(TARGET)\""
		}

	configuration { "mingw*", "Release" or "Retail" }
		postbuildcommands {
			"$(SILENT) echo Stripping symbols.",
			"$(SILENT) $(MINGW)/bin/strip -s \"$(TARGET)\""
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

	configuration { "vs*", "not orbis", "not durango", _filter }
		linkoptions {
			"/ignore:4199", -- LNK4199: /DELAYLOAD:*.dll ignored; no imports found from *.dll
		}
		links { -- this is needed only for testing with GLES2/3 on Windows with VS2008
			"DelayImp",
		}

	configuration { "vs201*", "not orbis", "not durango", _filter }
		linkoptions { -- this is needed only for testing with GLES2/3 on Windows with VS201x
			"/DELAYLOAD:\"libEGL.dll\"",
			"/DELAYLOAD:\"libGLESv2.dll\"",
		}

	configuration { "mingw*", _filter }
		targetextension ".exe"

	configuration { "orbis", _filter }
		targetextension ".elf"
		
	configuration { "vs20* or mingw*", "not orbis", "not durango", _filter }
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
-- 		files {
-- 			path.join(BGFX_DIR, "examples/common/**.mm"),
-- 		}
		links {
			"Cocoa.framework",
			"OpenGL.framework",
		}

	configuration { "ios*", _filter }
		kind "ConsoleApp"
--		files {
--			path.join(BGFX_DIR, "examples/common/**.mm"),
--		}
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
--			files {
--				path.join(BGFX_DIR, "examples/runtime/iOS-Info.plist"),
--			}
		end

	configuration {}

	if _OPTIONS["no-deploy"] == nil then
		prepareProjectDeployment(_filter, _binDir)
	end		
end

