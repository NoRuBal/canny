----------------------------------------
-- map.lua
-- loading map, processing map data, etc..
----------------------------------------

function startstage(stage) -- start stage, display stage title screen.
	init()
	scene = 5
	currentstage = stage
	love.audio.stop()
	if mute == false then
		tblbgm[2] = love.audio.newSource("Sound/bgm/stagetitle.ogg", "stream")
		tblbgm[2]:setLooping(true)
		love.audio.play(tblbgm[2])
	end
	if mute == true then
		love.audio.pause()
	end
	
	if stage == 25 then --final battle
		corecorruption = 0
		
		tbltmptrap = {}
		tbltmptrap[1] = {}
		tbltmptrap[1]["x"] = 0
		tbltmptrap[1]["y"] = 0
		tbltmptrap[1]["enabled"] = false
		
		tmrbossatk = 0
		tmrbossend = 0
		bosscont = 0
		
		bossdefeated = false
	end
	
	tmpkeydelay = nil
	tmpkeydelay = 0
end

function loadmap(mappath)
	local str = require "lib/string" -- to use 'split' function.

	-- store map data
	local chunkdata
	local mapdata
	local objdata
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
	data = split(mapdata[3], ":")
	startx = tonumber(data[1])
	starty = tonumber(data[2])
	
	-- parse goal data
	data = {}
	data = split(mapdata[2], ":")
	endx = tonumber(data[1])
	endy = tonumber(data[2])
	
	-- set lava
	data = {}
	data = split(mapdata[4], ":")
	for a = 1, #data - 1 do
		objdata = {}
		objdata = split(data[a], "/")
		newlava(tonumber(objdata[1]), tonumber(objdata[2]))
	end
	
	-- set belts
	data = {}
	data = split(mapdata[5], ":")
	for a = 1, #data - 1 do
		objdata = {}
		objdata = split(data[a], "/")
		newbelt(tonumber(objdata[1]), tonumber(objdata[2]), tonumber(objdata[3]))
	end
	
	-- set trap generators
	data = {}
	data = split(mapdata[6], ":")
	for a = 1, #data - 1 do
		objdata = {}
		objdata = split(data[a], "/")
		newtrapgen(tonumber(objdata[1]), tonumber(objdata[2]), tonumber(objdata[3]), tonumber(objdata[4]), tonumber(objdata[5]))
		print(tonumber(objdata[4]))
	end
	
	-- set traps
	data = {}
	data = split(mapdata[7], ":")
	for a = 1, #data - 1 do
		objdata = {}
		objdata = split(data[a], "/")
		newtrap(tonumber(objdata[1]), tonumber(objdata[2]), tonumber(objdata[3]), tonumber(objdata[4]))
	end
	
	-- set player start point
	player["x"] = startx * 48 + 3
	player["y"] = starty * 48 + 3
	
end