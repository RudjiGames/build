--
-- Copyright 2023 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/RudjiGames/vg_renderer.git

local params			= { ... }
local VGRENDERER_ROOT	= params[1]

local VGRENDERER_FILES = {
	VGRENDERER_ROOT .. "src/**.cpp",
	VGRENDERER_ROOT .. "src/**.h"
}

function projectDependencies_vg_renderer()
	return { "bgfx", "bx" }
end

function projectExtraConfig_vg_renderer()
	includedirs { VGRENDERER_ROOT .. "include" }
end

function projectExtraConfigExecutable_vg_renderer()
	includedirs { VGRENDERER_ROOT .. "include" }
end

function projectAdd_vg_renderer()
	addProject_3rdParty_lib("vg_renderer", VGRENDERER_FILES)
end
