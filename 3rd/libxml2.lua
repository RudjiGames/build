--
-- Copyright 2024 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/GNOME/libxml2.git

local params		= { ... }
local LIBXML2_ROOT	= params[1]

local LIBXML2_FILES = {
	LIBXML2_ROOT .. "*.c",
	LIBXML2_ROOT .. "*.h",
}

function projectDependencies_libxml2()
	return { "zlib" }
end 

function projectExtraConfig_libxml2()
	defines { "WITH_ZLIB", "LIBXML_SCHEMAS_ENABLED", "LIBXML_REGEXP_ENABLED", "LIBXML_AUTOMATA_ENABLED", "LIBXML_PATTERN_ENABLED", "LIBXML_VALID_ENABLED"}
	includedirs { LIBXML2_ROOT .. "include" }
	excludes {	LIBXML2_ROOT .. "test*.c",
				LIBXML2_ROOT .. "run*.c",
				LIBXML2_ROOT .. "xmlcatalog.c",
				LIBXML2_ROOT .. "xmllint.c"
	}
end

function projectAdd_libxml2()

	local replaceConfig = {
		{ "HAVE_LIBHISTORY 1",			"HAVE_LIBHISTORY 0" },
		{ "HAVE_LIBREADLINE 1",			"HAVE_LIBREADLINE_UNDEF 0" },
		{ "HAVE_SYS_TIME_H 1",			"HAVE_SYS_TIME_H_UNDEF 0" },
		{ "HAVE_UNISTD_H 1",			"HAVE_UNISTD_H_UNDEF 0" },
		{ "HAVE_SYS_MMAN_H 1",			"HAVE_SYS_MMAN_H_UNDEF 0" },
		{ "HAVE_MMAP 1",				"HAVE_MMAP_H_UNDEF 0" },
		{ "HAVE_GETTIMEOFDAY 1",		"HAVE_GETTIMEOFDAY_UNDEF 0" },
		{ "HAVE_SYS_TIMEB_H 1",			"HAVE_SYS_TIMEB_H_UNDEF 0" }
	}

	local replaceXMLver = {
		{ "@VERSION@",					"1.2.3" },
		{ "@LIBXML_VERSION_NUMBER@",	"10203" }
	}

	setupCMakeProjectHeaders(LIBXML2_ROOT .. "config.h.cmake.in", LIBXML2_ROOT .. "config.h", replaceConfig)
	setupCMakeProjectHeaders(LIBXML2_ROOT .. "include/libxml/xmlversion.h.in", LIBXML2_ROOT .. "include/libxml/xmlversion.h", replaceXMLver)

	addProject_3rdParty_lib("libxml2", LIBXML2_FILES)
end
