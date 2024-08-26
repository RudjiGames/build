--
-- Copyright 2018 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

function projectDependencies_txt2cs()
	return { "rbase" }
end

function projectAdd_txt2cs()
	addProject_cmd("txt2cs")
end
