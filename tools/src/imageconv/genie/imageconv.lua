--
-- Copyright (c) 2018 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

function projectExtraConfig_imageconv()
	includedirs	{
		path.getabsolute(find3rdPartyProject("stb") .. "../")
	}
end
 
function projectAdd_imageconv()
	addProject_cmd("imageconv")
end

