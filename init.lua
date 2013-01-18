-------------------------------------
-- init.lua
-- init game's variable, table, etc.
-------------------------------------

function init()
	-- constants, don't change in game!
	TILESIZE = 48
	CHARSIZE = 40

	-- map table
	map = {}
	for a = 1, 17 do
		map[a] = {}
		for b = 1, 10 do
			map[a][b] = 0
		end
	end

	-- player table
	player = {}
	player["x"] = 30
	player["y"] = 300
	player["jump"] = false --jumping?
	player["direction"] = 0 --heading left: 0 head right:1
	player["motion"] = 0 --motion for animation. 0:stopped 1: right foot 2:stopped 3: left foot

	-- debris table
	tbldebris = {}
	tbldebris[1] = {}
	tbldebris[1]["x"] = 0
	tbldebris[1]["y"] = 0
	tbldebris[1]["enabled"] = false
	tbldebris[1]["direction"] = 0
	tbldebris[1]["damage"] = 0
	
	-- init trap tables.
	tbltrap = {}
	tbltrap[1] = {}
	tbltrap[1]["x"] = 0
	tbltrap[1]["y"] = 0
	tbltrap[1]["enabled"] = false --enabled?
	tbltrap[1]["attr"] = 0 -- attribute. fire? cog? 0: moving fire 1: cog 2: prototype cog 3: static fire
	tbltrap[1]["direction"] = 0 -- head right:0 head left: 1
	tbltrap[1]["animation"] = 0 -- Animation. we have 2 frame per one trap.
	-- original coordinates of trap, moving fire need it.
	tbltrap[1]["startx"] = 0
	tbltrap[1]["starty"] = 0
	
	-- start point and goal
	-- start point X/Y
	startx = 0
	starty = 0
	
	-- goal X/Y
	endx = 0
	endy = 0

	-- timers
	tmrgravity = 0
	tmrjump = 0
	tmranimation = 0
	tmrtrapanimation = 0

	-- set key repeat
	love.keyboard.setKeyRepeat(0.1, 0.1)
end