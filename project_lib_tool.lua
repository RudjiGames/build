--
-- Copyright (c) 2017 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

function addProject_lib_tool(_name, _toolName)

	group ("libs_tools")
	project (_name .. "_tool_" ..  _toolName)

		language	"C++"
		kind		"ConsoleApp"
		uuid		( os.uuid(project().name) )

		project().path = getProjectPath(_name, ProjectPath.Root) .. "/tools/" .. _toolName .. "/"

		local	sourceFiles = mergeTables(	{ project().path .. "**.cpp" },
											{ project().path .. "**.h" } )
		files  { sourceFiles }

		addPCH( project().path, project().name )

		includedirs { incFilesPath }

		flags { Flags_nameraries }

		assert(loadfile(RTM_SCRIPTS_DIR .. "configurations.lua"))(	sourceFiles,
																	true,	-- IS_nameRARY
																	false,	-- IS_SHARED_nameRARY
																	false,	-- COPY_QT_DLLS
																	false,	-- WITH_QT
																	false	-- EXECUTABLE
																	)

		links { _name }

		addDependencies(project().name, { _name } )
end

