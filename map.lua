----------------------------------------
-- map.lua
-- loading map, processing map data, etc..
----------------------------------------

function loadmap(mappath)
	local str = require "lib/string" -- to use 'split' function.

	-- store map data
	local chunkdata
	local mapdata
	local data
	
	-- for
	local a
	local b
	
	-- read line by line
	for a in love.filesystem.lines(tostring(mappath)) do
		chunkdata = a
	end
	
	mapdata = {}
	mapdata = split(chunkdata, ";")
	
	-- parse terrian data
	data = {}
	data = split(mapdata[1], ":")
	
	for a = 1, 17 do
		for b = 1, 10 do
			map[a][b] = tonumber(data[10 * (a - 1) + b])
		end
	end
	
	-- parse start point data
	data = {}
	data = split(mapdata[2], ":")
	startx = data[1]
	starty = data[2]
	
	-- parse goal data
	data = {}
	data = split(mapdata[3], ":")
	endx = data[1]
	endy = data[2]
	
	-- set player start point
	player["x"] = startx * 48
	player["y"] = starty * 48
	
end