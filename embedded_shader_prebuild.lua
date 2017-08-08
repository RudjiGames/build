#!/usr/local/bin/lua5.1
--
-- Copyright (c) 2017 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
-- ----------------------------------------------------------------------------


require("lfs")

function getFileNameNoExtNoPathFromPath( path )
	local i = 0
	local lastSlash = 0
	local lastPeriod = 0
	local returnFilename
	while true do
		i = string.find( path, "/", i+1 )
		if i == nil then break end
		lastSlash = i
	end

	i = 0
	while true do
		i = string.find( path, "%.", i+1 )
		if i == nil then break end
		lastPeriod = i
	end

	if lastPeriod < lastSlash then
		returnFilename = path:sub( lastSlash + 1 )
	else
		returnFilename = path:sub( lastSlash + 1, lastPeriod - 1 )
	end

	return returnFilename
end

function getFileNameNoExtFromPath( path )
	local i = 0
	local lastPeriod = 0
	local returnFilename

	i = 0
	while true do
		i = string.find( path, "%.", i+1 )
		if i == nil then break end
		lastPeriod = i
	end

	returnFilename = path:sub( 1, lastPeriod - 1 )
	return returnFilename
end

local dstFileNoExt = getFileNameNoExtFromPath(arg[2])
local dstFileName  =  getFileNameNoExtNoPathFromPath(arg[2])

-- arg[1] -- shader type
-- arg[2] -- src file
-- arg[3] -- shaderc path
-- arg[4] -- include dir 1
-- arg[5] -- include dir 2

if arg[1] == "-vs" then

--	if( 0 ~= os.execute( fullMOCPath ) ) then
--		print(error)
--	else
--
		os.execute( arg[3] .. ' -i ' .. arg[4] .. ' -i ' .. arg[5] .. ' --type vertex --platform linux                    -f ' .. arg[2] .. ' -o ' .. dstFileNoExt .. '.bin.h --bin2c ' .. dstFileName .. '_glsl' )
		os.execute( arg[3] .. ' -i ' .. arg[4] .. ' -i ' .. arg[5] .. ' --type vertex --platform linux   -p spirv         -f ' .. arg[2] .. ' -o ' .. dstFileNoExt .. '.temp  --bin2c ' .. dstFileName .. '_spv' )				os.execute( 'cat ' .. dstFileNoExt .. '.temp >>' .. dstFileNoExt .. '.bin.h' )
		os.execute( arg[3] .. ' -i ' .. arg[4] .. ' -i ' .. arg[5] .. ' --type vertex --platform windows -p vs_3_0 -O 3   -f ' .. arg[2] .. ' -o ' .. dstFileNoExt .. '.temp  --bin2c ' .. dstFileName .. '_dx9' )				os.execute( 'cat ' .. dstFileNoExt .. '.temp >>' .. dstFileNoExt .. '.bin.h' )
		os.execute( arg[3] .. ' -i ' .. arg[4] .. ' -i ' .. arg[5] .. ' --type vertex --platform windows -p vs_4_0 -O 3   -f ' .. arg[2] .. ' -o ' .. dstFileNoExt .. '.temp  --bin2c ' .. dstFileName .. '_dx11' )				os.execute( 'cat ' .. dstFileNoExt .. '.temp >>' .. dstFileNoExt .. '.bin.h' )
		os.execute( arg[3] .. ' -i ' .. arg[4] .. ' -i ' .. arg[5] .. ' --type vertex --platform ios     -p metal  -O 3   -f ' .. arg[2] .. ' -o ' .. dstFileNoExt .. '.temp  --bin2c ' .. dstFileName .. '_mtl' )				os.execute( 'cat ' .. dstFileNoExt .. '.temp >>' .. dstFileNoExt .. '.bin.h' )

elseif arg[1] == "-fs" then

		os.execute( arg[3] .. ' -i ' .. arg[4] .. ' -i ' .. arg[5] .. ' --type fragment --platform linux                    -f ' .. arg[2] .. ' -o ' .. dstFileNoExt .. '.bin.h --bin2c ' .. dstFileName .. '_glsl' )
		os.execute( arg[3] .. ' -i ' .. arg[4] .. ' -i ' .. arg[5] .. ' --type fragment --platform linux   -p spirv         -f ' .. arg[2] .. ' -o ' .. dstFileNoExt .. '.temp  --bin2c ' .. dstFileName .. '_spv' )			os.execute( 'cat ' .. dstFileNoExt .. '.temp >>' .. dstFileNoExt .. '.bin.h' )
		os.execute( arg[3] .. ' -i ' .. arg[4] .. ' -i ' .. arg[5] .. ' --type fragment --platform windows -p ps_3_0 -O 3   -f ' .. arg[2] .. ' -o ' .. dstFileNoExt .. '.temp  --bin2c ' .. dstFileName .. '_dx9' )			os.execute( 'cat ' .. dstFileNoExt .. '.temp >>' .. dstFileNoExt .. '.bin.h' )
		os.execute( arg[3] .. ' -i ' .. arg[4] .. ' -i ' .. arg[5] .. ' --type fragment --platform windows -p ps_4_0 -O 3   -f ' .. arg[2] .. ' -o ' .. dstFileNoExt .. '.temp  --bin2c ' .. dstFileName .. '_dx11' )			os.execute( 'cat ' .. dstFileNoExt .. '.temp >>' .. dstFileNoExt .. '.bin.h' )
		os.execute( arg[3] .. ' -i ' .. arg[4] .. ' -i ' .. arg[5] .. ' --type fragment --platform ios     -p metal  -O 3   -f ' .. arg[2] .. ' -o ' .. dstFileNoExt .. '.temp  --bin2c ' .. dstFileName .. '_mtl' )			os.execute( 'cat ' .. dstFileNoExt .. '.temp >>' .. dstFileNoExt .. '.bin.h' )
	
elseif arg[1] == "-cs" then

		os.execute( arg[3] .. ' -i ' .. arg[4] .. ' -i ' .. arg[5] .. ' --type compute --platform linux   -p 430           -f ' .. arg[2] .. ' -o ' .. dstFileNoExt .. '.bin.h --bin2c ' .. dstFileName .. '_glsl' )
		os.execute( arg[3] .. ' -i ' .. arg[4] .. ' -i ' .. arg[5] .. ' --type compute --platform linux   -p spirv         -f ' .. arg[2] .. ' -o ' .. dstFileNoExt .. '.temp  --bin2c ' .. dstFileName .. '_spv' )			os.execute( 'cat ' .. dstFileNoExt .. '.temp >>' .. dstFileNoExt .. '.bin.h' )
		os.execute( arg[3] .. ' -i ' .. arg[4] .. ' -i ' .. arg[5] .. ' --type compute --platform windows -p cs_5_0 -O 1   -f ' .. arg[2] .. ' -o ' .. dstFileNoExt .. '.temp  --bin2c ' .. dstFileName .. '_dx11' )		os.execute( 'cat ' .. dstFileNoExt .. '.temp >>' .. dstFileNoExt .. '.bin.h' )

end

	-- common for all embedded shaders

		os.execute( 'echo ' .. 'extern const uint8_t* ' .. dstFileName .. '_pssl; >> ' .. dstFileNoExt .. '.bin.h' )
		os.execute( 'echo ' .. 'extern const uint32_t ' .. dstFileName .. '_pssl_size; >> ' .. dstFileNoExt .. '.bin.h' )
	
		os.remove( dstFileNoExt .. '.temp' )

