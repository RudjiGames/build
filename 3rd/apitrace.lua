--
-- Zidar - Build system scripts
-- Copyright (c) 2025-2026 Milos Tosic, Rudji Games. All rights reserved.
-- License: https://github.com/RudjiGames/zidar/blob/master/LICENSE
--

-- Tools for tracing OpenGL, Direct3D, and other graphics APIs
-- https://github.com/apitrace/apitrace
--
-- Zidar owns the DEPENDENCY only: the consumer reads the Python API specifications (specs/) at development time
-- (OmniProfiler: scripts/gen/gen_d3d_trace.py generates the native Direct3D call-trace hooks and replay decoders from
-- them; the generated files are checked in). Nothing of apitrace is built, linked or shipped. The checkout is
-- PINNED because the generator reads exact spec files; the project in the solution carries the public headers for
-- browsing and is header-only: nothing links it.

local params		= { ... }
local APITRACE_ROOT	= params[1]

-- The pinned upstream revision - the ONE place it is declared. scripts/gen/apitrace_pin.py and scripts/gen/gen_d3d_trace.py read this assignment (and the
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
