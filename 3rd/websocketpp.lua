--
-- Copyright (c) 2017 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

-- https://github.com/zaphoyd/websocketpp

local params		= { ... }
local UWS_ROOT		= params[1]

local UWS_FILES = {
	UWS_ROOT .. "src/**.cpp",
	UWS_ROOT .. "src/**.h"
}

function projectAdd_websocketpp()
	addProject_3rdParty_lib("websocketpp", UWS_FILES)
end

