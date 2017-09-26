--
-- Copyright (c) 2017 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- Desc table members
-- 		version
--		shortname
--		longname
--		logosquare
--		logowide

--		@@ARCH@@			armeabi-v7a  mips  x86
--		@@ANDROID_VER@@		_OPTIONS["with-android"]
--		@@VERSION@@			getProjectDesc(_name).version
--		@@SHORT_NAME@@		getProjectDesc(_name).shortname
--		@@LONG_NAME@@		getProjectDesc(_name).longname
--		getProjectDesc(_name).logosquare
--		getProjectDesc(_name).logowide

function script_dir()
	return path.getdirectory(debug.getinfo(2, "S").source:sub(2)) .. "/"
end

Permissions = {
	AccessNetworkState	= {},
	Internet			= {},
	WriteStorage		= {},
}

function convertImage(_src, _dst, _width, _height)
	mkdir(path.getdirectory(_dst))

	local sss = path.getabsolute(script_dir() .. "/tools/")
	if os.is("windows") then
		sss = sss .. "windows/imageconv.exe"
	elseif os.is("linux") then
		sss = sss .. "linux/imageconv"
	elseif os.is("osx") then
		sss = sss .. "darwin/imageconv"
	end

	os.execute(sss .. " " .. _src .. " " .. _dst .. " " .. _width .. " " .. _height)
end

function cloneDir(_copySrc, _copyDst)
	srcFiles = os.matchfiles(_copySrc .. "**.*")

	for _,srcFile in ipairs(srcFiles) do
		local fileName		= path.getname(srcFile)
		local srcFileDir	= path.getdirectory(srcFile)
		local srcFileRel	= path.getrelative(_copySrc, srcFileDir)
		local srcPath		= path.join(_copySrc, srcFileRel)
		local srcFileToCopy	= srcPath .. "/" .. fileName

		local dstPath		= path.join(_copyDst, srcFileRel)
		local dstFileToCopy	= dstPath .. "/" .. fileName

		mkdir(dstPath)
		os.copyfile(srcFileToCopy, dstFileToCopy)
	end
end

function cloneDirWithSed(_copySrc, _copyDst, _sedCmd, _rename)
	srcFiles = os.matchfiles(_copySrc .. "**.*")

	for _,srcFile in ipairs(srcFiles) do
		local fileName		= path.getname(srcFile)
		local srcFileDir	= path.getdirectory(srcFile)
		local srcFileRel	= path.getrelative(_copySrc, srcFileDir)
		local srcPath		= path.join(_copySrc, srcFileRel)
		local srcFileToCopy	= srcPath .. "/" .. fileName

		local dstPath		= path.join(_copyDst, srcFileRel)
		local dstFileToCopy	= dstPath .. "/" .. fileName

		mkdir(dstPath)
		os.execute(_sedCmd .. " " .. srcFileToCopy .. " > " .. dstFileToCopy)
	end
end

function sedGetBinary()
	if os.is("windows") then
		return path.getabsolute(script_dir() .. "/tools/windows/sed.exe")
	end
	return "sed"
end

function sedAppendReplace(_str, _search, _replace, _last)
	_last = _last or false
	_replace = string.gsub(_replace, "/", "\\/")
	_str = _str .. "s/" .. _search .. "/" .. _replace .. "/g"
	if _last == false then
		_str = _str .. ';'
	end
	return _str
end

function prepareProjectDeployment(_filter, _binDir)
	
	if getTargetOS() == "android" then
		prepareDeploymentAndroid(_filer, _binDir)	return
	end

	if getTargetOS() == "durango" then
		prepareDeploymentDurango(_filer, _binDir)	return
	end
end

function prepareDeploymentAndroid(_filter, _binDir)
	local copyDst = _binDir .. "deploy/" .. project().name .. "/"
	local copySrc = script_dir() .. "deploy/android/"

	local desc = getProjectDesc(project().name)

	local str_arch = "armeabi-v7a"
	if  (_OPTIONS["gcc"] == "android-mips") then
		str_arch = "mips"
	elseif (_OPTIONS["gcc"] == "android-x86") then 
		str_arch = "x86"
	end

	local sedCmd = sedGetBinary() .. " -e " .. '"'

	sedCmd = sedAppendReplace(sedCmd, "@@ARCH@@",			str_arch)
	sedCmd = sedAppendReplace(sedCmd, "@@ANDROID_VER@@",	androidTarget)
	sedCmd = sedAppendReplace(sedCmd, "@@VERSION@@",		desc.version)
	sedCmd = sedAppendReplace(sedCmd, "@@SHORT_NAME@@",		desc.shortname)
	sedCmd = sedAppendReplace(sedCmd, "@@LONG_NAME@@",		desc.longname, true)

	sedCmd = sedCmd .. '" '

	local destFiles = os.matchfiles(copyDst .. "**.*")

	cloneDirWithSed(copySrc, copyDst, sedCmd)

	local logoSource = project().path .. desc.logosquare
	if os.isfile(desc.logosquare) == true then
		logoSource = desc.logosquare
	end

	convertImage(logoSource, copyDst .. "res/drawable-ldpi/icon.png",		32, 32)
	convertImage(logoSource, copyDst .. "res/drawable-mdpi/icon.png",		48, 48)
	convertImage(logoSource, copyDst .. "res/drawable-hdpi/icon.png",		72, 72)
	convertImage(logoSource, copyDst .. "res/drawable-xhdpi/icon.png",		96, 96)
	convertImage(logoSource, copyDst .. "res/drawable-xxhdpi/icon.png",		144, 144)
	convertImage(logoSource, copyDst .. "res/drawable-xxxhdpi/icon.png",	192, 192)

	-- dodati post build command prema filteru
end

-- Xbox one logo/splash dims
-- 56 x 56
-- 100 x 100
-- 208 x 208
-- 480 x 480
-- 1920 x 1080

function prepareDeploymentDurango(_filter, _binDir)
	local copyDst = RTM_LOCATION_PATH .. "/" .. project().name .. "/"
	local copySrc = script_dir() .. "deploy/durango/"

	mkdir(copyDst)

	local desc = getProjectDesc(project().name)
	
	desc.shortname = string.gsub(desc.shortname, "_", "")	-- remove invalid character from project names (default if no desc)
	desc.longname  = string.gsub(desc.longname, "_", "")

	local logoSquare_056	= path.getname(desc.logo_square_0056)
	local logoSquare_100	= path.getname(desc.logo_square_0100)
	local logoSquare_208	= path.getname(desc.logo_square_0208)
	local logoSquare_480	= path.getname(desc.logo_square_0480)
	local logoWide			= path.getname(desc.logo_wide_1920)

	os.copyfile(desc.logo_wide_1920,   copyDst .. logoWide)
	os.copyfile(desc.logo_square_0056, copyDst .. logoSquare_056)
	os.copyfile(desc.logo_square_0100, copyDst .. logoSquare_100)
	os.copyfile(desc.logo_square_0208, copyDst .. logoSquare_208)
	os.copyfile(desc.logo_square_0480, copyDst .. logoSquare_480)
	
	local sedCmd = sedGetBinary() .. " -e " .. '"'

	sedCmd = sedAppendReplace(sedCmd, "@@PUBLISHER_COMPANY@@",	desc.publisher.company)
	sedCmd = sedAppendReplace(sedCmd, "@@PUBLISHER_ORG@@",		desc.publisher.organization)
	sedCmd = sedAppendReplace(sedCmd, "@@PUBLISHER_LOCATION@@",	desc.publisher.location)
	sedCmd = sedAppendReplace(sedCmd, "@@PUBLISHER_STATE@@",	desc.publisher.state)
	sedCmd = sedAppendReplace(sedCmd, "@@PUBLISHER_COUNTRY@@",	desc.publisher.country)
	sedCmd = sedAppendReplace(sedCmd, "@@VERSION@@",			desc.version)
	sedCmd = sedAppendReplace(sedCmd, "@@SHORT_NAME@@",			desc.shortname)
	sedCmd = sedAppendReplace(sedCmd, "@@LONG_NAME@@",			desc.longname)
	sedCmd = sedAppendReplace(sedCmd, "@@LOGO_56@@",			logoSquare_056)
	sedCmd = sedAppendReplace(sedCmd, "@@LOGO_100@@",			logoSquare_100)
	sedCmd = sedAppendReplace(sedCmd, "@@LOGO_208@@",			logoSquare_208)
	sedCmd = sedAppendReplace(sedCmd, "@@LOGO_480@@",			logoSquare_480)
	sedCmd = sedAppendReplace(sedCmd, "@@LOGO_1920@@",			logoWide)
	sedCmd = sedAppendReplace(sedCmd, "@@DESCRIPTION@@",		desc.description, true)

	sedCmd = sedCmd .. '" '

	cloneDirWithSed(copySrc, copyDst, sedCmd)
	
	files { copyDst .. "Appxmanifest.xml" }
	files { copyDst .. "Package.appxmanifest" }

end

