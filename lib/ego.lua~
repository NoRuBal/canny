module (..., package.seeall)

--[[
======================================================================================
======================================================================================
============================================================
							EGO			
============================================================

An extremely simple way to save and load small amounts of data
in your iOS or Android application.

	
	Created by Peach Pellen - http://Techority.com/
				December 26, 2011
				
	(Example usage tutorial available on Techority)
				
============================================================
							SETUP
============================================================

ego = require "ego"
saveFile = ego.saveFile
loadFile = ego.loadFile

============================================================
							SAVING
============================================================

To save a file you simply use;

saveFile( "filename.txt", value)

Filenames can be anything you like provided they end in .txt and the value can
be a string, number or variable.

============================================================
							LOADING
============================================================
To load a file you simply use;

valueName = loadFile( "filename.txt" )

If you have previously saved a value to "filename.txt", valueName will be set
accordingly.

If no file is present the file will be created and automatically saved as "empty".

======================================================================================
======================================================================================
--]]

--Save function
function saveFile( fileName, fileData )
	--Path for file
	local path = system.pathForFile( fileName, system.DocumentsDirectory )
	--Open the file
	local file = io.open( path, "w+" )
	
	--Save specified value to the file
	if file then
	   file:write( fileData )
	   io.close( file )
	end
end

--Load function
function loadFile( fileName )
--Path for file
local path = system.pathForFile( fileName, system.DocumentsDirectory )
--Open the file
local file = io.open( path, "r" )
	
	--If the file exists return the data
	if file then
	   local fileData = file:read( "*a" )
	   io.close( file )
	   return fileData
	--If the file doesn't exist create it and write it with "empty"
	else
	   file = io.open( path, "w" )
	   file:write( "empty" )
	   io.close( file )
	   return "empty"
	end
end