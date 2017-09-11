--
-- Copyright (c) 2017 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

function addProject_game(_name, _extraConfig)

	group ("games")
	project (_name)

		language    "C++"
		uuid		( os.uuid(project().name) )

		configuration { "retail" }
			kind		"WindowedApp"
		configuration { "debug or release" }
			kind		"ConsoleApp"
		configuration {}

		project().path = getProjectPath(_name, ProjectPath.Dir)

		local srcFilesPath = project().path .. "src/"
print(srcFilesPath)
		local	sourceFiles = mergeTables(	{ srcFilesPath .. "**.cpp" },
											{ srcFilesPath .. "**.h" } )
		files  { sourceFiles }
		
		addPCH( srcFilesPath, project().name )
		
		includedirs	{ srcFilesPath }
	
		flags { Flags_Cmd }

		assert(loadfile(RTM_SCRIPTS_DIR .. "configurations.lua"))(	sourceFiles,
																	_extraConfig,
																	false,	-- IS_LIBRARY
																	false,	-- IS_SHARED_LIBRARY
																	false,	-- COPY_QT_DLLS
																	false,	-- WITH_QT
																	true	-- WITH_RAPP
																	)

		addDependencies(_name, { "rapp" })
end

