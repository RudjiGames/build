--
-- Copyright 2025 Milos Tosic. All rights reserved.
-- License: http://www.opensource.org/licenses/BSD-2-Clause
--

function projectDependencies_bin2c()
	return { "rbase" }
end

function projectAdd_bin2c()
	addProject_cmd("bin2c")
end

