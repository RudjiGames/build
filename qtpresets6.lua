--
-- Copyright 2023 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--
-- Based on Qt4 build script from Kyle Hendricks <kyle.hendricks@gentex.com> 
-- and Josh Lareau <joshua.lareau@gentex.com>
--

qt = {}
qt.version = "6" -- default Qt version
lua_version = "5.1"

RTM_QT_FILES_PATH_MOC	= "../.qt/qt_moc"
RTM_QT_FILES_PATH_UI	= "../.qt/qt_ui"
RTM_QT_FILES_PATH_QRC	= "../.qt/qt_qrc"
RTM_QT_FILES_PATH_TS	= "../.qt/qt_qm"

QT_LIB_PREFIX		= "Qt" .. qt.version

function qtConfigure( _config, _projectName, _mocfiles, _qrcfiles, _uifiles, _tsfiles, _libsToLink, _copyDynamicLibraries, _is64bit, _dbgPrefix )
		
		local sourcePath			= getProjectPath(_projectName) .. "/src/"
		local QT_PREBUILD_LUA_PATH	= '"' .. RTM_ROOT_DIR .. "build/qtprebuild.lua" .. '"'

		-- Defaults
		local QT_PATH = os.getenv("QTDIR")
    	if QT_PATH == nil then
	    	print ("ERROR: The QTDIR environment variable must be set to the Qt root directory to use qtpresets6.lua")
		    os.exit()
    	end

		if string.sub(QT_PATH, -1) ~= "/" then
			QT_PATH = QT_PATH .. "/"
		end

		print ("$QTDIR:  " .. QT_PATH)

		flatten( _mocfiles )
		flatten( _qrcfiles )
		flatten( _uifiles )
		flatten( _tsfiles )				

		local QT_MOC_FILES_PATH = sourcePath .. RTM_QT_FILES_PATH_MOC
		local QT_UI_FILES_PATH	= sourcePath .. RTM_QT_FILES_PATH_UI
		local QT_QRC_FILES_PATH = sourcePath .. RTM_QT_FILES_PATH_QRC
		local QT_TS_FILES_PATH	= sourcePath .. RTM_QT_FILES_PATH_TS

		recreateDir( QT_MOC_FILES_PATH )
		recreateDir( QT_QRC_FILES_PATH )
		recreateDir( QT_UI_FILES_PATH )
		recreateDir( QT_TS_FILES_PATH )

		local LUAEXE = "lua "
		if os.is("windows") then
			LUAEXE = "lua" .. lua_version .. ".exe "
		end

		local addedFiles = {}

		-- Set up Qt pre-build steps and add the future generated file paths to the pkg
		for _,file in ipairs( _mocfiles ) do
			local mocFile = stripExtension(file)
			local mocFileBase = path.getbasename(file)
			local mocFilePath = path.getabsolute(QT_MOC_FILES_PATH .. "/" .. mocFileBase .. "_moc.cpp")

			local headerSrc = file_read(file);
			if headerSrc:find("Q_OBJECT") then
				prebuildcommands { LUAEXE .. QT_PREBUILD_LUA_PATH .. ' -moc "' .. path.getabsolute(file) .. '" "' .. QT_PATH .. '" "' .. _projectName .. '" "' .. mocFilePath .. '"' }
				files { file, mocFilePath }
				table.insert(addedFiles, file)
			end
		end

		for _,file in ipairs( _qrcfiles ) do
			local qrcFile = stripExtension( file )
			local qrcFilePath = path.getabsolute(QT_QRC_FILES_PATH .. "/" .. path.getbasename(file) .. "_qrc.cpp")
			prebuildcommands { LUAEXE .. QT_PREBUILD_LUA_PATH .. ' -rcc "' .. path.getabsolute(file) .. '" "' .. QT_PATH .. '"' .. " " .. _projectName }

			files { file, qrcFilePath }
			table.insert(addedFiles, qrcFilePath)
		end

		for _,file in ipairs( _uifiles ) do
			local uiFile = stripExtension( file )
			local uiFilePath = path.getabsolute(QT_UI_FILES_PATH .. "/" .. path.getbasename(file) .. "_ui.h")
			prebuildcommands { LUAEXE .. QT_PREBUILD_LUA_PATH .. ' -uic "' .. path.getabsolute(file) .. '" "' .. QT_PATH .. '"' .. " " .. _projectName }
			files { file, uiFilePath }
			table.insert(addedFiles, uiFilePath)
		end

		for _,file in ipairs( _tsfiles ) do
			local tsFile = stripExtension( file )
			local tsFilePath = path.getabsolute(QT_TS_FILES_PATH .. "/" .. path.getbasename(file) .. "_ts.qm")
			prebuildcommands { LUAEXE .. QT_PREBUILD_LUA_PATH .. ' -ts "' .. path.getabsolute(file) .. '" "' .. QT_PATH .. '"' .. " " .. _projectName }
			files { file, tsFilePath }
			table.insert(addedFiles, tsFilePath)
		end				

		local subDir = getLocationDir()
		local binDir = getBuildDirRoot(_config)
	
		includedirs	{ QT_PATH .. "include" }

		local libsDirectory = QT_PATH .. "lib/"
		if os.is("macosx") then
			linkoptions { "-F " .. libsDirectory }
			includedirs { libsDirectory .. "symbol"}
		else
			libdirs { libsDirectory }
		end

		if os.is("windows") then

			_libsToLink = mergeTables(_libsToLink, "WinExtras")
			
			if _copyDynamicLibraries then

				local destPath = binDir
				destPath = string.gsub( destPath, "([/]+)", "\\" ) .. 'bin\\'

				for _, lib in ipairs( _libsToLink ) do
					local libname =  QT_LIB_PREFIX .. lib  .. _dbgPrefix .. '.dll'
					local source = QT_PATH .. 'bin\\' .. libname
					local dest = destPath .. "\\" .. libname

					if not os.isdir(destPath) then
						mkdir(destPath)
					end
					if not os.isdir(destPath .. "/platforms") then
						mkdir(destPath .. "/platforms")
					end
					if not os.isfile(dest) then
						os.copyfile( source, dest )
					end
				end

				otherDLLNames = { "libEGL" .. _dbgPrefix, "libGLESv2" .. _dbgPrefix, "platforms\\qwindows" .. _dbgPrefix, "platforms\\qminimal" .. _dbgPrefix }
				otherDLLSrcPrefix = { "\\bin\\", "\\bin\\", "\\plugins\\", "\\plugins\\", "\\bin\\" }
	
				if _ACTION:find("gmake") then
					if _is64bit then
						otherDLLNames = mergeTwoTables(otherDLLNames, {"libstdc++_64-6"})
					else
						otherDLLNames = mergeTwoTables(otherDLLNames, {"libstdc++-6"})
					end
				end
					
				for i=1, #otherDLLNames, 1 do
					local libname =  otherDLLNames[i] .. '.dll'
					local source = QT_PATH .. otherDLLSrcPrefix[i] .. libname
					local dest = destPath .. '\\' .. libname
					if not os.isfile(dest) then
						mkdir(path.getdirectory(dest))
						os.copyfile( source, dest )
					end
				end

				-- optional OpenSSL
				if os.isdir(RTM_ROOT_DIR .. "3rd\\openssl_winbinaries") then
					local winVer = "win32"
					if _is64bit then
						winVer = "win64"
					end
					local src1 = string.gsub( RTM_ROOT_DIR .. "3rd\\openssl_winbinaries\\" .. winVer .. "\\libeay32.dll", "([/]+)", "\\" )
					local src2 = string.gsub( RTM_ROOT_DIR .. "3rd\\openssl_winbinaries\\" .. winVer .. "\\ssleay32.dll", "([/]+)", "\\" )
					os.copyfile( src1, destPath .. "libeay32.dll" )
					os.copyfile( src2, destPath .. "ssleay32.dll" )
				end
			end

			defines { "QT_THREAD_SUPPORT", "QT_USE_QSTRINGBUILDER" }

			configuration { _config }

			includedirs	{ QT_PATH .. "qtwinextras/include" }
				
			if _ACTION:find("vs") then
					-- Qt rcc doesn't support forced header inclusion - preventing us to do PCH in visual studio (gcc accepts files that don't include pch)
					buildoptions( "/FI" .. '"' .. _projectName .. "_pch.h" .. '"' .. " " )
					-- 4127 conditional expression is constant
					-- 4275 non dll-interface class 'stdext::exception' used as base for dll-interface class 'std::bad_cast'
					buildoptions( "/wd4127 /wd4275 /Zc:__cplusplus /std:c++17 /permissive-" ) 
			end

			for _, lib in ipairs( _libsToLink ) do
				local libDebug = libsDirectory .. QT_LIB_PREFIX .. lib .. "d" -- .. ".lib"
				local libRelease = libsDirectory .. QT_LIB_PREFIX .. lib -- .. ".lib"
				configuration { "debug", _config }
					links( libDebug )

				configuration { "not debug", _config }
					links( libRelease )
			end
	
			configuration { _config }

		elseif os.is("linux") then

			-- check if X11Extras is needed
			local extrasLib = QT_PATH .. "lib/lib" .. QT_LIB_PREFIX .. "X11Extras.a"
			if os.isfile(extrasLib) == true then
				_libsToLink = mergeTables(_libsToLink, "X11Extras")
			end

			-- should run this first (path may vary):
			-- export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/home/user/Qt5.7.0/5.7/gcc_64/lib/pkgconfig
			-- lfs support is required too: sudo luarocks install luafilesystem
			local qtLinks = QT_LIB_PREFIX .. table.concat( libsToLink, " " .. QT_LIB_PREFIX )

			local qtLibs  = "pkg-config --libs " .. qtLinks
			local qtFlags = "pkg-config --cflags " .. qtLinks
			local libPipe = io.popen( qtLibs, 'r' )
			local flagPipe= io.popen( qtFlags, 'r' )

	
			qtLibs = libPipe:read( '*line' )
			qtFlags = flagPipe:read( '*line' )
			libPipe:close()
			flagPipe:close()

			configuration { _config }
			buildoptions { qtFlags }
			linkoptions { qtLibs }

		elseif os.is("macosx") then
			configuration { _config }
			buildoptions { qtFlags }
			for _,lib in ipairs(_libsToLink) do
				print("Linking framework: " .. libsDirectory .. "Qt" .. lib .. ".framework")
				--links { "Qt" .. lib .. ".framework" }
				os.outputof("mkdir " .. libsDirectory .. "symbol/Qt" .. lib)
				os.outputof("ln -s " .. libsDirectory .. "Qt" .. lib .. ".framework/Versions/A/Headers/ " .. libsDirectory .. "symbol/Qt" .. lib)
				linkoptions {
					"-framework " .. "Qt" .. lib,
				}
			end
		end

	configuration {}
	return addedFiles
end
