--
-- Copyright (c) 2018 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/erincatto/Box2D

local params		= { ... }
local BOX2D_ROOT	= params[1]

local BOX2D_INCLUDE	= {
	BOX2D_ROOT .. "include",
	BOX2D_ROOT .. "src",
}

local BOX2D_FILES = {
	BOX2D_ROOT .. "include/**.h",
	BOX2D_ROOT .. "src/**.h",
	BOX2D_ROOT .. "src/**.cpp",
	BOX2D_ROOT .. "src/**.h"
}

function projectExtraConfig_box2d()
	includedirs { BOX2D_INCLUDE }
end

function projectAdd_box2d()
	addProject_3rdParty_lib("box2d", BOX2D_FILES)
end
