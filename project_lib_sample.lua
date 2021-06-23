--
-- Copyright (c) 2018 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

function addProject_lib_sample(_name, _sampleName)
	
	if _ACTION == nil then return end

	group ("samples")
	project (_name .. "_sample_" ..  _sampleName)

		language	"C++"
		kind		"ConsoleApp"
		uuid		( os.uuid(project().name) )

		local libsPath = getProjectPath(_name, ProjectPath.Root)

		project().path = libsPath .. _name .. "/"

		local srcFilesPath = project().path .. "samples/" .. _sampleName .. "/"
		local incFilesPath = project().path .. "samples/" .. _sampleName .. "/"

		local	sourceFiles = mergeTables(	{ srcFilesPath .. "**.cpp" },
											{ incFilesPath .. "**.h" } )
		files  { sourceFiles }

		local withBGFX = false
		local headers = os.matchfiles( incFilesPath .. "**.h")
		for _,file in ipairs( headers ) do
			local headerSrc = readFile(file);
			if headerSrc:find("#define RAPP_WITH_BGFX 1") then
				withBGFX = true
				break
			end
		end

		local name = _sampleName
		if string.find(_sampleName, "_") ~= nil then
			name = string.sub(_sampleName, string.find(_sampleName, "_") + 1, string.len(_sampleName))
		end
	
		addPCH( srcFilesPath, name )

		includedirs
		{ 
			project().path .. "samples/",
			incFilesPath,
		}
		
		flags { Flags_Libraries }

		assert(loadfile(RTM_SCRIPTS_DIR .. "configurations.lua"))(	sourceFiles,
																	false,	-- IS_LIBRARY
																	false,	-- IS_SHARED_LIBRARY
																	false,	-- COPY_QT_DLLS
																	false,	-- WITH_QT
																	true	-- EXECUTABLE
																	)

		if _name == "rapp" then
			_name = ""
		end

		if withBGFX then
			addDependencies(_sampleName, {{ "rapp", "bgfx" }, _name })
		else
			addDependencies(_sampleName, { "rapp", _name })
		end
end
