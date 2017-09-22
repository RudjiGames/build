--
-- Copyright (c) 2017 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

function addProject_3rdParty_lib(_name, _libFiles, _exceptions, _includes, _additionalDefines, _extraConfig)

	group ("3rd")
	project ( _name )

		_exceptions			= _exceptions or false
		_includes			= _includes or {}
		_additionalDefines	= _additionalDefines or {}

		language	"C++"
		kind		"StaticLib"
		uuid		( os.uuid(project().name) )

		files 		{ _libFiles }

		includedirs { _includes }
		defines { _additionalDefines }
		
		flags { Flags_ThirdParty }
		if _exceptions == false then
			flags { "NoExceptions" }
		end

		assert(loadfile(RTM_SCRIPTS_DIR .. "configurations.lua"))(	_libFiles,
																	_extraConfig,
																	true,	-- IS_LIBRARY
																	false,	-- IS_SHARED_LIBRARY
																	false,	-- COPY_QT_DLLS
																	false,	-- WITH_QT
																	false	-- EXECUTABLE
																	)
end
