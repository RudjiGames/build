--
-- Copyright (c) 2017 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

function addProject_qt(_name, _libProjNotExe, _includes, _prebuildcmds, _extraConfig)

	_libProjNotExe	= _libProjNotExe or false
	_includes		= _includes or {}
	_prebuildcmds	= _prebuildcmds or {}
	
	if _libProjNotExe == true then
		group ("toollibs")
	else
		group ("tools")
	end
	
	project (_name)

		local projKind = "WindowedApp"
		if _libProjNotExe == true then
			projKind = "StaticLib"
		end
	
		language	"C++"
		kind		( projKind )
		uuid		( os.uuid(project().name) )

		project().path = getProjectPath(project().name, ProjectPath.Root) .. _name .. "/"
		
		local	sourceFiles = mergeTables(	{ project().path .. "inc/**.h" },
											{ project().path .. "src/**.cpp" },
											{ project().path .. "src/**.h" },
											{ project().path .. "src/**.ui" },
											{ project().path .. "src/**.qrc" },
											{ project().path .. "src/**.ts" } )
		files  { sourceFiles }

		mocFiles	=	{ os.matchfiles( project().path .. "inc/**.h"), os.matchfiles( project().path .. "src/**.h"), os.matchfiles(headersPath) }
		uiFiles		=	{ os.matchfiles( project().path .. "src/**.ui") }
		qrcFiles	= 	{ os.matchfiles( project().path .. "src/**.qrc") }
		tsFiles		= 	{ os.matchfiles( project().path .. "src/**.ts") }

		if os.is("windows") then
			extras = "WinExtras"
		elseif os.is("linux") then
			extras = "X11Extras"
		else
			extras = nil
		end

		libsToLink	=	{ "Core", "Gui", "Widgets", "Network", extras }

		addPCH( project().path .. "src/", project().name )

		configuration {}

		includedirs
		{ 
			getProjectPath(project().name, ProjectPath.Root),
			project().path .. "src/",
			_includes
		}

		flags { Flags_QtTool }
		if os.is("linux") then
			buildoptions { "-fPIC" }
		end

		local outputDir = RTM_OUT_DIR
		if _libProjNotExe == true then
			outputDir = RTM_LIB_DIR
		end

		assert(loadfile(RTM_SCRIPTS_DIR .. "configurations.lua"))(	sourceFiles,
																	_extraConfig, 
																	false,	-- IS_LIBRARY
																	false,	-- IS_SHARED_LIBRARY
																	true,	-- COPY_QT_DLLS
																	true,	-- WITH_QT
																	false	-- WITH_RAPP
																	)

		configuration {"windows", "x32", "not gmake" }
			libdirs { getProjectPath("DIA", ProjectPath.Root) .. "DIA/lib/x32/" }
		configuration {"windows", "x64", "not gmake" }
			libdirs { getProjectPath("DIA", ProjectPath.Root) .. "DIA/lib/x64/" }

		configuration {}

		for _,cmd in ipairs( _prebuildcmds ) do
			prebuildcommands {cmd}
		end
		
		addDependencies(_name)
end

