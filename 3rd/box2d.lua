--
-- Copyright (c) 2018 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/erincatto/Box2D

local params		= { ... }
local BOX2D_ROOT	= params[1]

local BOX2D_INC	= BOX2D_ROOT .. "include/"
local BOX2D_SRC	= BOX2D_ROOT .. "src/"

local BOX2D_FILES = {
	BOX2D_INC .. "**.h",
	BOX2D_SRC .. "**.cpp",
	BOX2D_SRC .. "**.h"
}

function projectExtraConfig_box2d()
	includedirs { BOX2D_INC }
end

function projectAdd_box2d()
	addProject_3rdParty_lib("box2D", BOX2D_FILES)
end
