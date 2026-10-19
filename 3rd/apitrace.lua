--
-- Zidar - Build system scripts
-- Copyright (c) 2025-2026 Milos Tosic, Rudji Games. All rights reserved.
-- License: https://github.com/RudjiGames/zidar/blob/master/LICENSE
--

-- Tools for tracing OpenGL, Direct3D, and other graphics APIs
-- https://github.com/apitrace/apitrace
--
-- Zidar owns the DEPENDENCY, not the build: apitrace generates its trace/retrace sources with its own Python code
-- generators and builds them with CMake, so the consumer drives that build against the checkout zidar provides
-- (OmniProfiler: scripts/BuildDirect3DReplay.py, with its overlay from src/tools/OmniD3DReplay). What zidar does is
-- what it does for every other library here: clone into .3rd/apitrace - PINNED, because consumers patch the engine at
-- exact source anchors - with the submodules the Windows (Direct3D) build needs, and put a project in the solution.
-- That project carries the public headers (trace model / parser, os, image, retrace) for browsing and is header-only:
-- nothing links it.

local params		= { ... }
local APITRACE_ROOT	= params[1]

-- The pinned upstream revision - the ONE place it is declared. BuildDirect3DReplay.py reads this assignment (and the
-- submodule table below) from this file, so keep each in this exact shape.
local APITRACE_REVISION = "ceac241a8be6bcbaf2776c601f3c4ae52dea4680"

-- Submodules the Direct3D build needs. The GL test suites (frametrim/tests, tests/thirdparty/glfw) are left out.
local APITRACE_SUBMODULES = {
	"thirdparty/brotli",
	"thirdparty/gtest",
	"thirdparty/libbacktrace",
	"thirdparty/libpng",
	"thirdparty/snappy",
	"thirdparty/zlib",
	"thirdparty/zstd",
	"thirdparty/directxmath",
	"thirdparty/detours",
}

local APITRACE_INCLUDE = {
	APITRACE_ROOT .. "/lib/trace",
	APITRACE_ROOT .. "/lib/os",
	APITRACE_ROOT .. "/lib/image",
	APITRACE_ROOT .. "/retrace",
}

local APITRACE_FILES = {
	APITRACE_ROOT .. "/lib/trace/*.hpp",
	APITRACE_ROOT .. "/lib/os/*.hpp",
	APITRACE_ROOT .. "/lib/image/*.hpp",
	APITRACE_ROOT .. "/retrace/*.hpp",
}

function projectExtraConfig_apitrace()
	includedirs { APITRACE_INCLUDE }
end

function projectHeaderOnlyLib_apitrace()
end

function projectAdd_apitrace()
	-- Headers only, with an explicit language (nothing to auto-detect in a header set). The sources stay with CMake.
	addProject_3rdParty_lib("apitrace", APITRACE_FILES, false, "C++")
end

function projectSource_apitrace()
	return "https://github.com/apitrace/apitrace.git"
end

function projectSourceRevision_apitrace()
	return APITRACE_REVISION
end

function projectSourceSubmodules_apitrace()
	return APITRACE_SUBMODULES
end
