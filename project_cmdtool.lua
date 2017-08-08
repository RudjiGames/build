--
-- Copyright (c) 2017 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

function addProject_cmd(_name, _extraConfig)

	group ("tools_cmd")
	project (_name)
	
		_includes		= _includes or {}

		language	"C++"
		kind		"ConsoleApp"
		uuid		( os.uuid(project().name) )

		project().path = getProjectPath(_name) ..  "/src/"

		local	sourceFiles = mergeTables(	{ project().path .. "**.cpp" },
											{ project().path .. "**.h" } )
		files  { sourceFiles }

		addPCH( project().path, project().name )

		includedirs { getProjectPathRoot(_name), project().path }

		flags { Flags_Cmd }

		assert(loadfile(RTM_SCRIPTS_DIR .. "configurations.lua"))(	sourceFiles,
																	_extraConfig,
																	false,	-- IS_LIBRARY
																	false,	-- IS_SHARED_LIBRARY
																	false,	-- COPY_QT_DLLS
																	false,	-- WITH_QT
																	true	-- WITH_RAPP
																	)

		addDependencies(_name)
end
