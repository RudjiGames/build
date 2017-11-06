--
-- Copyright (c) 2017 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

local params		= { ... }
local BOX2D_ROOT	= params[1]

local BOX2D_INC  = BOX2D_ROOT .. "Box2D/Box2D/"

local BOX2D_FILES = {
	BOX2D_INC .. "**h",
	BOX2D_INC .. "**.c"
}

function projectAdd_box2d()
	addProject_3rdParty_lib("box2D", BOX2D_FILES, false, BOX2D_INC)
end

