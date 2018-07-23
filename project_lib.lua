--
-- Copyright (c) 2017 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

function addProject_lib(_name, _libType, _shared, _prebuildcmds, _extraConfig, _extraFiles, _extraIncludes, _extraDefines, _nameAppend)

	if _libType == Lib.Tool then
		group ("toollibs")
	elseif _libType == Lib.Game then
		group ("gamelibs")
	else
		group ("libs")
	end

	_nameAppend = _nameAppend or ""

	project (_name .. _nameAppend)

		LastLibLoaded = project().name

		_libType		= _libType or Lib.Runtime
		_shared			= _shared or false
		_prebuildcmds	= _prebuildcmds or {}

		local libKind = "StaticLib"
		if _shared then
			libKind = "SharedLib"
		end
		
		language    "C++"
		kind        ( libKind )
		uuid		( os.uuid(project().name) )
		
		local libsPath = getProjectPath(_name, ProjectPath.Root)

		local projectPath = libsPath .. _name

		table.insert(RTM_PROJECT_PATHS, projectPath)

		local srcFilesPath = projectPath .. "/src/"
		local incFilesPath = projectPath .. "/inc/"

		local	sourceFiles = mergeTables(	{ srcFilesPath .. "**.cpp" },
											{ srcFilesPath .. "**.cxx" },
											{ srcFilesPath .. "**.h" },
											{ incFilesPath .. "**.h" } )
		files  { sourceFiles }
	
		if _extraFiles ~= nil then
			files { _extraFiles }
		end

		if _extraDefines ~= nil then
			defines { _extraDefines }
		end

		local targetOS = getTargetOS()
		if targetOS == "ios" or targetOS == "osx" then
			files  { srcFilesPath .. "**.mm" }
		end

		excludes { projectPath .. "/test/**.*" }
		excludes { projectPath .. "/samples/**.*" }

		if _extraFiles == nil then
			addPCH( srcFilesPath, _name )
		end

		shaderFiles	= os.matchfiles( srcFilesPath .. "**.sc" )

		includedirs	{
			libsPath, 
			incFilesPath,
			srcFilesPath			
		}

		addIncludePath(_name, projectPath .. "/3rd/")

		if _extraIncludes ~= nil then
			includedirs { _extraIncludes }
		end

		flags { Flags_Libraries }
		
		assert(loadfile(RTM_SCRIPTS_DIR .. "configurations.lua"))(	sourceFiles,
																	_extraConfig,
																	true,		-- IS_LIBRARY
																	_shared,	-- IS_SHARED_LIBRARY
																	false,		-- COPY_QT_DLLS
																	false,		-- WITH_QT
																	false,		-- EXECUTABLE
																	_name
																	)

		for _,cmd in ipairs( _prebuildcmds ) do
			prebuildcommands {cmd}
		end

		addDependencies(project().name)
end

