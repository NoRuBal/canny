---------------------------------------
-- main.lua
-- main core of the game, don't write 'raw' code here!
---------------------------------------

-- require modules
require "init" -- init everything
require "debris" -- manage debris
require "collision" -- detect and respond to collision
require "map" --about map
require "trap" --about trap
require "devices" --about trap

init() --init everything.
loadmap("test.txt") --load example map. "asdf.txt"
newtrapgen(48 * 5, 48 * 5, 2, 3, 1)
-- to make player blink
player["blink"] = true
player["blinktime"] = 5

function love.load()
	local a, b

	-- load image
	imgchar = love.graphics.newImage("Graphics/can_sprite.png") -- load player sprite
	imgdeb = love.graphics.newImage("Graphics/debris_sprite.png") -- load debris sprite
    imgtile = love.graphics.newImage("Graphics/tile.png") --load tile graphic
	imgpoints = love.graphics.newImage("Graphics/points.png") --load start/goal points
	imgtraps = love.graphics.newImage("Graphics/traps.png") --load trap sprite
	imglava = love.graphics.newImage("Graphics/lava.png") --load trap sprite
	imgbelt = love.graphics.newImage("Graphics/belt.png") --load belt sprite
	imgtrapgen = love.graphics.newImage("Graphics/trapgen.png") --load trap generator graphioc
	
	-- quad to draw player
	quadchar = {}
    for a = 1, 8 do
        quadchar[a] = love.graphics.newQuad(CHARSIZE * (a - 1), 0, CHARSIZE, CHARSIZE, CHARSIZE * 8, CHARSIZE)
    end

	-- quad to draw debris
	quaddeb = {}
    for a = 1, 6 do
        quaddeb[a] = love.graphics.newQuad(CHARSIZE * (a - 1), 0, CHARSIZE, CHARSIZE, CHARSIZE * 6, CHARSIZE)
    end
	
	-- quad to draw map
	quadtile = {}
    for a = 1, 2 do
        quadtile[a] = love.graphics.newQuad(TILESIZE * (a - 1), 0, TILESIZE, TILESIZE, TILESIZE * 2, TILESIZE)
    end
	
	-- quad to draw start point/goal
	quadpoints = {}
	quadpoints[1] = love.graphics.newQuad(0, 0, TILESIZE, TILESIZE, TILESIZE * 2, TILESIZE)
	quadpoints[2] = love.graphics.newQuad(TILESIZE, 0, TILESIZE, TILESIZE, TILESIZE * 2, TILESIZE)
	
	-- quad to draw trap
	quadtrap = {}
    for a = 1, 3 do
		for b = 1, 2 do
			quadtrap[a * 2 + b - 2] = love.graphics.newQuad(CHARSIZE * (b - 1), CHARSIZE * (a - 1), CHARSIZE, CHARSIZE, CHARSIZE * 2, CHARSIZE * 3)
		end
	end
	
	-- quad to draw belts
	quadbelt = {}
    for a = 1, 2 do
		for b = 1, 2 do
			quadbelt[a * 2 + b - 2] = love.graphics.newQuad(TILESIZE * (b - 1), TILESIZE * (a - 1), TILESIZE, TILESIZE, TILESIZE * 2, TILESIZE * 2)
		end
	end
	
end

function love.draw()
	local a
	local b
	local dbgx, dbgy
	
	-- draw tiles
	for a = 1, 17 do
		for b = 1, 10 do
			love.graphics.drawq(imgtile, quadtile[map[a][b] + 1], (a - 1) * TILESIZE, (b - 1) * TILESIZE)
		end
	end
	
	--draw doors
	love.graphics.drawq(imgpoints, quadpoints[1], startx * 48, starty * 48)
	love.graphics.drawq(imgpoints, quadpoints[2], endx * 48, endy * 48)
	
	--draw debris
	for a = 1, #tbldebris do
		if tbldebris[a]["enabled"] == true then
			love.graphics.drawq(imgdeb, quaddeb[(tbldebris[a]["direction"] * 3) + 1 + tbldebris[a]["damage"]], tbldebris[a]["x"], tbldebris[a]["y"])
		end
	end
	
	--draw traps
	for a = 1, #tbltrap do
		if tbltrap[a]["enabled"] == true then
			love.graphics.drawq(imgtraps, quadtrap[tbltrap[a]["kind"] * 2 + 1 + tbltrap[a]["animation"]], tbltrap[a]["x"], tbltrap[a]["y"])
		end
	end
	
	--draw player
	if player["blink"] == false then
		love.graphics.drawq(imgchar, quadchar[(player["direction"] * 4) + 1 + player["motion"]], player["x"], player["y"])
	end
	
	--draw lava
	for a = 1, #tbllava do
		love.graphics.draw(imglava, tbllava[a]["x"], tbllava[a]["y"])
	end
	
	-- draw belt
	for a = 1, #tblbelt do
		love.graphics.drawq(imgbelt, quadbelt[tblbelt[a]["direction"] * 2 + 1 + tblbelt[a]["animation"]], tblbelt[a]["x"], tblbelt[a]["y"])
	end
	
	-- draw trap generator
	for a = 1, #tbltrapgen do
		love.graphics.draw(imgtrapgen, tbltrapgen[a]["x"], tbltrapgen[a]["y"])
	end
	
	--[[
	--debug
	love.graphics.setColor(255, 255, 255)
	dbgx, dbgy = postotile(objtocorner(player["x"], player["y"], "leftup"))
	love.graphics.print("LEFT UP: "..dbgx..":"..dbgy, 0, 0)
	dbgx, dbgy = postotile(objtocorner(player["x"], player["y"], "leftdown"))
	love.graphics.print("LEFT DOWN: "..dbgx..":"..dbgy, 0, 15)
	dbgx, dbgy = postotile(objtocorner(player["x"], player["y"], "rightup"))
	love.graphics.print("RIGHT UP: "..dbgx..":"..dbgy, 0, 30)
	dbgx, dbgy = postotile(objtocorner(player["x"], player["y"], "rightdown"))
	love.graphics.print("RIGHT DOWN: "..dbgx..":"..dbgy, 0, 45)
	
	love.graphics.setColor(255, 0, 0)
	dbgx, dbgy = objtocorner(player["x"], player["y"], 0)
	--love.graphics.rectangle("fill", dbgx, dbgy, 1, 1)
	dbgx, dbgy = objtocorner(player["x"], player["y"], 1)
	love.graphics.rectangle("fill", dbgx, dbgy, 1, 1)
	dbgx, dbgy = objtocorner(player["x"], player["y"], 2)
	--love.graphics.rectangle("fill", dbgx, dbgy, 1, 1)
	dbgx, dbgy = objtocorner(player["x"], player["y"], 3)
	love.graphics.rectangle("fill", dbgx, dbgy, 1, 1)
	]]--
end

function love.update(dt)
	local a
	local tx1, ty1, tx2, ty2
	-- move player
	if love.keyboard.isDown("left") then
		player["direction"] = 1
		charmove("left", 100 * dt)
	end
	if love.keyboard.isDown("right") then
		player["direction"] = 0
		charmove("right", 100 * dt)
	end
	
	-- move traps
	for a = 1, #tbltrap do
		if tbltrap[a]["enabled"] == true then
			if tbltrap[a]["direction"] == 0 then --right
				trapmove("right", 100 * dt, a)
			elseif tbltrap[a]["direction"] == 1 then --left
				trapmove("left", 100 * dt, a)
			elseif tbltrap[a]["direction"] == 2 then --up
				trapmove("up", 100 * dt, a)
			elseif tbltrap[a]["direction"] == 3 then --down
				trapmove("down", 100 * dt, a)
			end
		end
	end
	
	-- belt
	-- move player
	for a = 1, #tblbelt do
		if collcheck(player["x"], player["y"] + 1, CHARSIZE, CHARSIZE, tblbelt[a]["x"], tblbelt[a]["y"], TILESIZE, TILESIZE) == true then
			if tblbelt[a]["direction"] == 0 then
				charmove("right", 90 * dt)
				break
			else
				charmove("left", 90 * dt)
				break
			end
		end
	end
	
	-- move debris
	for a = 1, #tblbelt do
		for b = 1, #tbldebris do
			if tbldebris[b]["enabled"] == true then
				if collcheck(tbldebris[b]["x"], tbldebris[b]["y"] + 1, CHARSIZE, CHARSIZE, tblbelt[a]["x"], tblbelt[a]["y"], TILESIZE, TILESIZE) == true then
					if tblbelt[a]["direction"] == 0 then
						debmove("right", 90 * dt, b)
					else
						debmove("left", 90 * dt, b)
					end
					-- check collision & player
					debcollplayer(tblbelt[a]["direction"], b)
				end
			end
		end
	end
	
	--jump
	if love.keyboard.isDown("up") then
		tx1, ty1 = postotile(objtocorner(player["x"], player["y"] + 1, 1))
		tx2, ty2 = postotile(objtocorner(player["x"], player["y"] + 1, 3))
		if map[tx1][ty1] == 1 then -- right down
			player["jump"] = true
			tmrjump = 0
		elseif map[tx2][ty2] == 1 then -- 왼쪽 아래
			player["jump"] = true
			tmrjump = 0
		end
		
		for a = 1, #tbldebris do
			if tbldebris[a]["enabled"] == true then
				if collcheck(player["x"], player["y"] + 1, CHARSIZE, CHARSIZE, tbldebris[a]["x"], tbldebris[a]["y"], CHARSIZE, CHARSIZE) == true then
					player["jump"] = true
					tmrjump = 0
					break
				end
			end
		end
	end
	
	tmrgravity = tmrgravity + dt
	if tmrgravity >= 0.01 then
		tmrgravity = tmrgravity - 0.01
		if player["jump"] == true then
			charmove("up", 200 * dt)
		else
			--don't move down through bottom..
			tx1, ty1 = postotile(objtocorner(player["x"], player["y"] + 1, 1))
			tx2, ty2 = postotile(objtocorner(player["x"], player["y"] + 1, 3))
			if not(map[tx1][ty1] == 1) or not(map[tx2][ty2] == 1) then
				charmove("down", 200 * dt)
			end
		end
		
		for a = 1, #tbldebris do
			if tbldebris[a]["enabled"] == true then
				--don't move down through bottom..
				tx1, ty1 = postotile(objtocorner(tbldebris[a]["x"], tbldebris[a]["y"] + 1, 1))
				tx2, ty2 = postotile(objtocorner(tbldebris[a]["x"], tbldebris[a]["y"] + 1, 3))
				
				if not(map[tx1][ty1] == 1) or not(map[tx2][ty2] == 1) then
					debmove("down", 200 * dt, a)
				end
			end
		end
	end
	
	-- jumping during 300ms
	if player["jump"] == true then
		tmrjump = tmrjump + dt
		if tmrjump >= 0.3 then
			tmrjump = 0
			player["jump"] = false
		end
	else
		tmrjump = 0
	end
	
	-- change animation of everything, 300ms per 1 frame.
	tmranimation = tmranimation + dt
	if tmranimation >= 0.3 then
		tmranimation = tmranimation - 0.3
		
		if love.keyboard.isDown("left") or love.keyboard.isDown("right") then
			if player["motion"] + 1 == 4 then
				player["motion"] = 0
			else
				player["motion"] = player["motion"] + 1
			end
		else
			player["motion"] = 0
		end
		
		for a = 1, #tbltrap do
			-- toggle varible "animation" between 0 and 1
			if tbltrap[a]["enabled"] == true then
				if tbltrap[a]["animation"] == 0 then
					tbltrap[a]["animation"] = 1
				elseif tbltrap[a]["animation"] == 1 then
					tbltrap[a]["animation"] = 0
				end
			end
		end
		
		for a = 1, #tblbelt do
			--toggle vars 0<->1
			if tblbelt[a]["animation"] == 1 then
				tblbelt[a]["animation"] = 0
			else
				tblbelt[a]["animation"] = 1
			end
		end
	end
	
	-- blink player
	if not (player["blinktime"] == 0) then
		tmrblink = tmrblink + dt
		if tmrblink >= 0.1 then
			tmrblink = tmrblink - 0.1
			player["blinktime"] = player["blinktime"] - 1
			if player["blink"] == true then
				player["blink"] = false
			else
				player["blink"] = true
			end
		end
	end
	
	-- generate trap from trap generator
	for a = 1, #tbltrapgen do
		tbltrapgen[a]["timer"] = tbltrapgen[a]["timer"] + dt
		if tbltrapgen[a]["timer"] >= tbltrapgen[a]["delay"] then
			tbltrapgen[a]["timer"] = tbltrapgen[a]["timer"] - tbltrapgen[a]["delay"]
			newtrap(tbltrapgen[a]["x"], tbltrapgen[a]["y"], tbltrapgen[a]["kind"], tbltrapgen[a]["direction"])
		end
	end
end