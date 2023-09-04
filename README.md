![build logo](https://raw.githubusercontent.com/milostosic/build/gh-pages/images/build_logo.png)

[![License](https://img.shields.io/badge/license-BSD--2%20clause-blue.svg)](https://github.com/milostosic/rmem/blob/master/LICENSE)

**build** is a set of scripts for a build system based on [GENie](https://github.com/bkaradzic/GENie) and other tools.  
Goal of **build** is to minimize efforts that go into maintaining project configurations and their physical organization on disk.  
Some highlight features of **build**:  
 * Centralized location to control configrations of projects/solutions (VS lingo)
 * Ability to add projects/solutions with just a few lines of Lua script
 * Dependencies added hierarchically - dependencies of dependencies added automatically
 * Per project custom settings (dependencies, include paths, etc.)
 * Support for Qt based projects
 * Shipping with a number of scripts to build 3rd party libraries
 * Predefined project types (library, samples, tools, executable, etc.)
 * Platform specific deployment (WIP)

Source Code
======

You can get the latest source code by cloning it from github:

      git clone https://github.com/milostosic/build.git 

Dependencies
======

**build** requires Lua to be installed for Qt based projects as it's used for MOC-ing and similar tasks.

Documentation
======

**build**  documentation can be found [here](https://rudjigames.github.io/build/).

Author
======

The author of **build** is Milos Tosic  
[ <img src="https://github.com/milostosic/build/raw/gh-pages/images/twitter.png">](https://twitter.com/milostosic)[ <img src="https://github.com/milostosic/build/raw/gh-pages/images/mail.png">](mailto:milostosic77@gmail.com)  

License (BSD 2-clause)
======

<a href="http://opensource.org/licenses/BSD-2-Clause" target="_blank">
<img align="right" src="http://opensource.org/trademarks/opensource/OSI-Approved-License-100x137.png">
</a>

	Copyright (c) 2023 Milos Tosic. All rights reserved.
	
	https://github.com/milostosic/build
	
	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions are met:
	
	   1. Redistributions of source code must retain the above copyright notice,
	      this list of conditions and the following disclaimer.
	
	   2. Redistributions in binary form must reproduce the above copyright
	      notice, this list of conditions and the following disclaimer in the
	      documentation and/or other materials provided with the distribution.
	
	THIS SOFTWARE IS PROVIDED BY COPYRIGHT HOLDER ``AS IS'' AND ANY EXPRESS OR
	IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
	MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
	EVENT SHALL COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
	INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
	THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
