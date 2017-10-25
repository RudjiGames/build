--
-- Copyright (c) 2017 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

function addProject_lib_sample(_lib, _name, _toolLibSample, _extraConfig)
	
	group ("samples")
	project (_lib .. "_sample_" ..  _name)

		_toolLibSample = _toolLibSample or false

		language	"C++"
		kind		"ConsoleApp"
		uuid		( os.uuid(project().name) )

		local libsPath = getProjectPath(_lib, ProjectPath.Root)

		project().path = libsPath .. _lib .. "/"

		local srcFilesPath = project().path .. "samples/" .. _name .. "/"
		local incFilesPath = project().path .. "samples/" .. _name .. "/"

		local	sourceFiles = mergeTables(	{ srcFilesPath .. "**.cpp" },
											{ incFilesPath .. "**.h" } )
		files  { sourceFiles }
		
		local name = _name
		if string.find(_name, "_") ~= nil then
			name = string.sub(_name, string.find(_name, "_") + 1, string.len(_name))
		end
	
		addPCH( srcFilesPath, name )

		includedirs
		{ 
			project().path .. "samples/",
			incFilesPath,
		}
		
		flags { Flags_Libraries }

		assert(loadfile(RTM_SCRIPTS_DIR .. "configurations.lua"))(	sourceFiles,
																	_extraConfig,
																	false,	-- IS_LIBRARY
																	false,	-- IS_SHARED_LIBRARY
																	false,	-- COPY_QT_DLLS
																	false,	-- WITH_QT
																	true	-- EXECUTABLE
																	)

																			
		addDependencies(_name, { "rapp", _lib })
end

