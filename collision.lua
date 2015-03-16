--------------------------------
-- collision.lua
-- check and respond to collision.
--------------------------------

function objtocorner(x, y, direction) --returns four corner of rect.
	if direction == "leftup" or direction == 0 then
		return x, y
	elseif direction == "leftdown" or direction == 1 then
		return x, y + CHARSIZE - 1
	elseif direction == "rightup" or direction == 2 then
		return x + CHARSIZE - 1, y
	elseif direction == "rightdown" or direction == 3 then
		return x + CHARSIZE - 1, y + CHARSIZE - 1
	end
end

function postotile(x, y) --change pixel coordinate to tile coordinate.
	local tx, ty
	tx = math.floor(x / TILESIZE) + 1
	ty = math.floor(y / TILESIZE) + 1
	return tx, ty
end

function charmove(direction, speed) --move player.
	local fakex
	local fakey
	
	local tx1
	local ty1
	local tx2
	local ty2
	
	local a
	
	local colltile
	
	fakex = player["x"]
	fakey = player["y"]

	if direction == "up" then
		fakey = fakey - speed
		tx1, ty1 = postotile(objtocorner(fakex, fakey, 0))
		tx2, ty2 = postotile(objtocorner(fakex, fakey, 2))
		
		if map[tx1][ty1] == 1 or map[tx2][ty2] == 1 then
			fakey = ty1 * TILESIZE
			player["jump"] = false
		end
		
		for a = 1, #tbldebris do
			if tbldebris[a]["enabled"] == true then
				if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, tbldebris[a]["x"], tbldebris[a]["y"], CHARSIZE, CHARSIZE) == true then
					--fakey = tbldebris[a]["y"] + CHARSIZE
					debmove(direction, player["y"] - fakey, a)
					fakey = tbldebris[a]["y"] + CHARSIZE
					player["jump"] = false
				end
			end
		end
		
		for a = 1, #tbllava do --lava
			if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, tbllava[a]["x"], tbllava[a]["y"], TILESIZE, TILESIZE) == true then
				-- effect: player explode
				neweffect(player["x"], player["y"], 1)
				
				player["x"] = startx * 48
				player["y"] = starty * 48
				
				player["blink"] = true
				player["blinktime"] = 5
				return
			end
		end
		
		player["y"] = fakey
	
	elseif direction == "down" then
		fakey = fakey + speed
		tx1, ty1 = postotile(objtocorner(fakex, fakey, 1))
		tx2, ty2 = postotile(objtocorner(fakex, fakey, 3))
		
		if map[tx1][ty1] == 1 or map[tx2][ty2] == 1 then
			fakey = (ty1 * TILESIZE) - TILESIZE - CHARSIZE
		end
		
		for a = 1, #tbldebris do
			if tbldebris[a]["enabled"] == true then
				if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, tbldebris[a]["x"], tbldebris[a]["y"], CHARSIZE, CHARSIZE) == true then
					-- fakey = tbldebris[a]["y"] - CHARSIZE
					debmove(direction, fakey - player["y"]  , a)
					fakey = tbldebris[a]["y"] - CHARSIZE
				end
			end
		end
		
		for a = 1, #tbllava do --lava
			if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, tbllava[a]["x"], tbllava[a]["y"], TILESIZE, TILESIZE) == true then
				-- effect: player explode
				neweffect(player["x"], player["y"], 1)
				
				player["x"] = startx * 48
				player["y"] = starty * 48
				
				player["blink"] = true
				player["blinktime"] = 5
				return
			end
		end
		
		player["y"] = fakey
		
	elseif direction == "left" then
		fakex = fakex - speed
		
		tx1, ty1 = postotile(objtocorner(fakex, fakey, 0))
		tx2, ty2 = postotile(objtocorner(fakex, fakey, 1))
		
		if map[tx1][ty1] == 1 or map[tx2][ty2] == 1 then
			fakex = tx1 * TILESIZE
		end
		
		for a = 1, #tbldebris do
			if tbldebris[a]["enabled"] == true then
				if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, tbldebris[a]["x"], tbldebris[a]["y"], CHARSIZE, CHARSIZE) == true then
					--fakex = tbldebris[a]["x"] + CHARSIZE
					debmove(direction, player["x"] - fakex, a)
					fakex = tbldebris[a]["x"] + CHARSIZE
				end
			end
		end
		
		for a = 1, #tbllava do --lava
			if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, tbllava[a]["x"], tbllava[a]["y"], TILESIZE, TILESIZE) == true then
				-- effect: player explode
				neweffect(player["x"], player["y"], 1)
				
				player["x"] = startx * 48
				player["y"] = starty * 48
				
				player["blink"] = true
				player["blinktime"] = 5
				return
			end
		end
		
		player["x"] = fakex
		
	elseif direction == "right" then
		fakex = fakex + speed
		
		tx1, ty1 = postotile(objtocorner(fakex, fakey, 2))
		tx2, ty2 = postotile(objtocorner(fakex, fakey, 3))
		
		if map[tx1][ty1] == 1 or map[tx2][ty2] == 1 then
			fakex = (tx1 * TILESIZE) - TILESIZE - CHARSIZE
		end
		
		for a = 1, #tbldebris do
			if tbldebris[a]["enabled"] == true then
				if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, tbldebris[a]["x"], tbldebris[a]["y"], CHARSIZE, CHARSIZE) == true then
					--fakex = tbldebris[a]["x"] - CHARSIZE
					debmove(direction, fakex - player["x"], a)
					fakex = tbldebris[a]["x"] - CHARSIZE
				end
			end
		end
		
		for a = 1, #tbllava do --lava
			if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, tbllava[a]["x"], tbllava[a]["y"], TILESIZE, TILESIZE) == true then
				-- effect: player explode
				neweffect(player["x"], player["y"], 1)
				
				player["x"] = startx * 48
				player["y"] = starty * 48
				
				player["blink"] = true
				player["blinktime"] = 5
				return
			end
		end
		
		player["x"] = fakex
		
	end
	
	-- collision with boss
	if currentstage == 25 then
		if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, 48 * 11, 48 * 7, 144, 96) == true then
			-- effect: player explode
			neweffect(player["x"], player["y"], 1)
			
			corecorruption = corecorruption + 5
			if corecorruption >= 100 then
				bossdefeated = true
				love.audio.stop()
			end
			
			player["x"] = startx * 48
			player["y"] = starty * 48
			
			player["blink"] = true
			player["blinktime"] = 5
			return
		end
	end
end

function collcheck(pic1x, pic1y, pic1width, pic1height, pic2x, pic2y, pic2width, pic2height)
-- check pix1 and pix2 are collide
-- usage: collcheck(blabla~) => true|false
    if (pic1x + pic1width) > pic2x and pic1x < (pic2x + pic2width) then
        if (pic1y + pic1height) > pic2y and pic1y < (pic2y + pic2height) then
            return true
        end
    end

	return false
end

function debmove(direction, speed, index) -- move debris.
	local fakex
	local fakey
	
	local tx1
	local ty1
	local tx2
	local ty2
	
	local a
	
	local colltile
	
	fakex = tbldebris[index]["x"]
	fakey = tbldebris[index]["y"]

	if direction == "up" then
		fakey = fakey - speed
		tx1, ty1 = postotile(objtocorner(fakex, fakey, 0))
		tx2, ty2 = postotile(objtocorner(fakex, fakey, 2))
		
		if map[tx1][ty1] == 1 or map[tx2][ty2] == 1 then
			fakey = ty1 * TILESIZE
		end
		
		for a = 1, #tbldebris do
			if tbldebris[a]["enabled"] == true and not (a == index) then
				if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, tbldebris[a]["x"], tbldebris[a]["y"], CHARSIZE, CHARSIZE) == true then
					fakey = tbldebris[a]["y"] + CHARSIZE
				end
			end
		end
		
		--[[
		-- no collision with traps
		for a = 1, #tbltrap do
			if tbltrap[a]["enabled"] == true then
				if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, tbltrap[a]["x"], tbltrap[a]["y"], CHARSIZE, CHARSIZE) == true then
					if tbltrap[a]["kind"] == 0 then --get damage with only static traps
						tbldebris[index]["damage"] = tbldebris[index]["damage"] + 1
						if tbldebris[index]["damage"] == 3 then
							tbldebris[index]["enabled"] = false
							-- effect: explode debris
							neweffect(tbldebris[index]["x"], tbldebris[index]["y"], 1)
						end
					end
					trapcollide(a)
					fakey = tbltrap[a]["y"] + CHARSIZE
				end
			end
		end
		]]--
		
		-- no collision with doors
		if collcheck(tbldebris[index]["x"], tbldebris[index]["y"], CHARSIZE, CHARSIZE, startx, starty, TILESIZE, TILESIZE) == true then
			fakey = starty * 48 + CHARSIZE
		elseif collcheck(tbldebris[index]["x"], tbldebris[index]["y"], CHARSIZE, CHARSIZE, endx, endy, TILESIZE, TILESIZE) == true then
			fakey = endy * 48 + CHARSIZE
		end
		
		for a = 1, #tbllava do --lava
			if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, tbllava[a]["x"], tbllava[a]["y"], TILESIZE, TILESIZE) == true then
				tbldebris[index]["enabled"] = false
				-- maybe eff..
				-- effect: explode debris
				neweffect(tbldebris[index]["x"], tbldebris[index]["y"], 1)
				return
			end
		end
		
		tbldebris[index]["y"] = fakey
	
	elseif direction == "down" then
		fakey = fakey + speed
		tx1, ty1 = postotile(objtocorner(fakex, fakey, 1))
		tx2, ty2 = postotile(objtocorner(fakex, fakey, 3))
		
		if map[tx1][ty1] == 1 or map[tx2][ty2] == 1 then
			fakey = (ty1 * TILESIZE) - TILESIZE - CHARSIZE
		end
		
		for a = 1, #tbldebris do
			if tbldebris[a]["enabled"] == true and not (a == index) then
				if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, tbldebris[a]["x"], tbldebris[a]["y"], CHARSIZE, CHARSIZE) == true then
					fakey = tbldebris[a]["y"] - CHARSIZE
				end
			end
		end
		
		--[[
		-- no collision with traps
		for a = 1, #tbltrap do
			if tbltrap[a]["enabled"] == true then
				if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, tbltrap[a]["x"], tbltrap[a]["y"], CHARSIZE, CHARSIZE) == true then
					if tbltrap[a]["kind"] == 0 then --get damage with only static traps
						tbldebris[index]["damage"] = tbldebris[index]["damage"] + 1
						if tbldebris[index]["damage"] == 3 then
							tbldebris[index]["enabled"] = false
							-- effect: explode debris
							neweffect(tbldebris[index]["x"], tbldebris[index]["y"], 1)
						end
					end
					trapcollide(a)
					fakey = tbltrap[a]["y"] - CHARSIZE
				end
			end
		end
		]]--
		
		-- no collision with doors
		if collcheck(tbldebris[index]["x"], tbldebris[index]["y"], CHARSIZE, CHARSIZE, startx, starty, TILESIZE, TILESIZE) == true then
			fakey = starty * 48 - CHARSIZE
		elseif collcheck(tbldebris[index]["x"], tbldebris[index]["y"], CHARSIZE, CHARSIZE, endx, endy, TILESIZE, TILESIZE) == true then
			fakey = endy * 48 - CHARSIZE
		end
		
		for a = 1, #tbllava do --lava
			if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, tbllava[a]["x"], tbllava[a]["y"], TILESIZE, TILESIZE) == true then
				tbldebris[index]["enabled"] = false
				-- effect: explode debris
				neweffect(tbldebris[index]["x"], tbldebris[index]["y"], 1)
				return
			end
		end
		
		tbldebris[index]["y"] = fakey
		
	elseif direction == "left" then
		fakex = fakex - speed
		
		tx1, ty1 = postotile(objtocorner(fakex, fakey, 0))
		tx2, ty2 = postotile(objtocorner(fakex, fakey, 1))
		
		if map[tx1][ty1] == 1 or map[tx2][ty2] == 1 then
			fakex = tx1 * TILESIZE
		end
		
		for a = 1, #tbldebris do
			if tbldebris[a]["enabled"] == true and not (a == index) then
				if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, tbldebris[a]["x"], tbldebris[a]["y"], CHARSIZE, CHARSIZE) == true then
					fakex = tbldebris[a]["x"] + CHARSIZE
				end
			end
		end
		
		--[[
		-- no collision with traps
		for a = 1, #tbltrap do
			if tbltrap[a]["enabled"] == true then
				if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, tbltrap[a]["x"], tbltrap[a]["y"], CHARSIZE, CHARSIZE) == true then
					if tbltrap[a]["kind"] == 0 then --get damage with only static traps
						tbldebris[index]["damage"] = tbldebris[index]["damage"] + 1
						if tbldebris[index]["damage"] == 3 then
							tbldebris[index]["enabled"] = false
							-- effect: explode debris
							neweffect(tbldebris[index]["x"], tbldebris[index]["y"], 1)
						end
					end
					trapcollide(a)
					fakex = tbltrap[a]["x"] + CHARSIZE
				end
			end
		end
		]]--
		
		-- no collision with doors
		if collcheck(tbldebris[index]["x"], tbldebris[index]["y"], CHARSIZE, CHARSIZE, startx, starty, TILESIZE, TILESIZE) == true then
			fakex = startx * 48 + CHARSIZE
		elseif collcheck(tbldebris[index]["x"], tbldebris[index]["y"], CHARSIZE, CHARSIZE, endx, endy, TILESIZE, TILESIZE) == true then
			fakex = endx * 48 + CHARSIZE
		end
		
		for a = 1, #tbllava do --lava
			if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, tbllava[a]["x"], tbllava[a]["y"], TILESIZE, TILESIZE) == true then
				tbldebris[index]["enabled"] = false
				-- effect: explode debris
				neweffect(tbldebris[index]["x"], tbldebris[index]["y"], 1)
				return
			end
		end
		
		tbldebris[index]["x"] = fakex
		
	elseif direction == "right" then
		fakex = fakex + speed
		
		tx1, ty1 = postotile(objtocorner(fakex, fakey, 2))
		tx2, ty2 = postotile(objtocorner(fakex, fakey, 3))
		
		if map[tx1][ty1] == 1 or map[tx2][ty2] == 1 then
			fakex = (tx1 * TILESIZE) - TILESIZE - CHARSIZE
		end
		
		for a = 1, #tbldebris do
			if tbldebris[a]["enabled"] == true and not (a == index) then
				if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, tbldebris[a]["x"], tbldebris[a]["y"], CHARSIZE, CHARSIZE) == true then
					fakex = tbldebris[a]["x"] - CHARSIZE
				end
			end
		end
		
		--[[
		-- no collision with traps
		for a = 1, #tbltrap do
			if tbltrap[a]["enabled"] == true then
				if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, tbltrap[a]["x"], tbltrap[a]["y"], CHARSIZE, CHARSIZE) == true then
					if tbltrap[a]["kind"] == 0 then --get damage with only static traps
						tbldebris[index]["damage"] = tbldebris[index]["damage"] + 1
						if tbldebris[index]["damage"] == 3 then
							tbldebris[index]["enabled"] = false
							-- effect: explode debris
							neweffect(tbldebris[index]["x"], tbldebris[index]["y"], 1)
						end
					end
					trapcollide(a)
					fakex = tbltrap[a]["x"] - CHARSIZE
				end
			end
		end
		]]--
		
		-- no collision with doors
		if collcheck(tbldebris[index]["x"], tbldebris[index]["y"], CHARSIZE, CHARSIZE, startx, starty, TILESIZE, TILESIZE) == true then
			fakex = startx * 48 - CHARSIZE
		elseif collcheck(tbldebris[index]["x"], tbldebris[index]["y"], CHARSIZE, CHARSIZE, endx, endy, TILESIZE, TILESIZE) == true then
			fakex = endx * 48 - CHARSIZE
		end
		
		for a = 1, #tbllava do --lava
			if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, tbllava[a]["x"], tbllava[a]["y"], TILESIZE, TILESIZE) == true then
				tbldebris[index]["enabled"] = false
				-- effect: explode debris
				neweffect(tbldebris[index]["x"], tbldebris[index]["y"], 1)
				return
			end
		end
		
		tbldebris[index]["x"] = fakex
		
	end
	
	-- with boss
	if currentstage == 25 then
		if bossdefeated == false then
			if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, 48 * 11, 48 * 7, 144, 96) == true then
				corecorruption = corecorruption + 20
				tbldebris[index]["enabled"] = false
				-- effect: explode debris
				neweffect(tbldebris[index]["x"], tbldebris[index]["y"], 1)
				
				if corecorruption >= 100 then
					bossdefeated = true
					love.audio.stop()
				end
				return
			end
		end
	end
end

function debcollplayer(direction, index)
	if direction == 0 then --to right
		if collcheck(tbldebris[index]["x"], tbldebris[index]["y"], CHARSIZE, CHARSIZE, player["x"], player["y"], CHARSIZE, CHARSIZE) == true then
			tbldebris[index]["x"] = player["x"] - CHARSIZE
		end
	elseif direction == 1 then -- to left
		if collcheck(tbldebris[index]["x"], tbldebris[index]["y"], CHARSIZE, CHARSIZE, player["x"], player["y"], CHARSIZE, CHARSIZE) == true then
			tbldebris[index]["x"] = player["x"] + CHARSIZE
		end
	elseif direction ==3 then -- to down
		if collcheck(tbldebris[index]["x"], tbldebris[index]["y"], CHARSIZE, CHARSIZE, player["x"], player["y"], CHARSIZE, CHARSIZE) == true then
			tbldebris[index]["y"] = player["y"] - CHARSIZE
		end
	end
end

function trapcollide(index) -- when trap collide with tile/player/debris
	if tbltrap[index]["kind"] == 0 then -- fire
		tbltrap[index]["enabled"] = false
		-- smoke effect
		neweffect(tbltrap[index]["x"], tbltrap[index]["y"], 0)
	elseif tbltrap[index]["kind"] == 1 then -- proto-cog
		tbltrap[index]["enabled"] = false
		-- explosion effect
		neweffect(tbltrap[index]["x"], tbltrap[index]["y"], 1)
	elseif tbltrap[index]["kind"] == 2 then -- cog
		-- switch direction
		if tbltrap[index]["direction"] == 0 then -- right
			tbltrap[index]["direction"] = 1
		elseif tbltrap[index]["direction"] == 1 then -- left
			tbltrap[index]["direction"] = 0
		elseif tbltrap[index]["direction"] == 2 then -- up
			tbltrap[index]["direction"] = 3
		elseif tbltrap[index]["direction"] == 3 then -- down
			tbltrap[index]["direction"] = 2
		end		
	end
end

function trapmove(direction, speed, index) --move trap.
	local fakex
	local fakey
	
	local tx1
	local ty1
	local tx2
	local ty2
	
	local a
	
	local colltile
	
	fakex = tbltrap[index]["x"]
	fakey = tbltrap[index]["y"]
	
	if tbltrap[index]["kind"] == 0 then --fire can't move!
		speed = 0
	end

	if direction == "up" then
		fakey = fakey - speed
		tx1, ty1 = postotile(objtocorner(fakex, fakey, 0))
		tx2, ty2 = postotile(objtocorner(fakex, fakey, 2))
		
		if map[tx1][ty1] == 1 or map[tx2][ty2] == 1 then
			fakey = ty1 * TILESIZE
			-- collide with wall
			trapcollide(index)
		end
		
		for a = 1, #tbldebris do
			if tbldebris[a]["enabled"] == true then
				if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, tbldebris[a]["x"], tbldebris[a]["y"], CHARSIZE, CHARSIZE) == true then
					-- collide with debris
					print("debris got damage by trap "..a..". "..direction..".")
					tbldebris[a]["damage"] = tbldebris[a]["damage"] + 1
					if tbldebris[a]["damage"] == 3 then
						tbldebris[a]["enabled"] = false
						-- maybe eff..
						-- effect: explode debris
						neweffect(tbldebris[a]["x"], tbldebris[a]["y"], 1)
					end
					
					fakey = tbldebris[a]["y"] + CHARSIZE
					trapcollide(index)
					return
				end
			end
		end
		
		-- collide with player..
		if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, player["x"], player["y"], CHARSIZE, CHARSIZE) == true then
			fakey = player["y"] + CHARSIZE
			if collcheck(startx * TILESIZE, starty * TILESIZE, TILESIZE, TILESIZE, player["x"], player["y"], CHARSIZE, CHARSIZE) == false then
				-- effect: player become debris
				neweffect(player["x"], player["y"], 0)
				newdebris(player["x"], player["y"], player["direction"])
				player["x"] = startx * 48
				player["y"] = starty * 48

				player["blink"] = true
				player["blinktime"] = 5
				print("player become debris, "..direction)
			end
			trapcollide(index)
		 end
		
		tbltrap[index]["y"] = fakey
	
	elseif direction == "down" then
		fakey = fakey + speed
		tx1, ty1 = postotile(objtocorner(fakex, fakey, 1))
		tx2, ty2 = postotile(objtocorner(fakex, fakey, 3))
		
		if map[tx1][ty1] == 1 or map[tx2][ty2] == 1 then -- with wall
			fakey = (ty1 * TILESIZE) - TILESIZE - CHARSIZE
			trapcollide(index)
		end
		
		for a = 1, #tbldebris do
			if tbldebris[a]["enabled"] == true then
				if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, tbldebris[a]["x"], tbldebris[a]["y"], CHARSIZE, CHARSIZE) == true then
					-- with debris
					print("debris got damage by trap "..a..". "..direction..".")
					tbldebris[a]["damage"] = tbldebris[a]["damage"] + 1
					if tbldebris[a]["damage"] == 3 then
						tbldebris[a]["enabled"] = false
						-- effect: explode debris
						neweffect(tbldebris[a]["x"], tbldebris[a]["y"], 1)
						print("debris "..a.." disabled")
					end
					
					fakey = tbldebris[a]["y"] - CHARSIZE
					trapcollide(index)
					return
				end
			end
		end
		
		-- with player
		if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, player["x"], player["y"], CHARSIZE, CHARSIZE) == true then
			fakey = player["y"] - CHARSIZE
			if collcheck(startx * TILESIZE, starty * TILESIZE, TILESIZE, TILESIZE, player["x"], player["y"], CHARSIZE, CHARSIZE) == false then
				-- effect: player become debris
				neweffect(player["x"], player["y"], 0)
				newdebris(player["x"], player["y"], player["direction"])
				player["x"] = startx * 48
				player["y"] = starty * 48

				player["blink"] = true
				player["blinktime"] = 5
				print("player become debris, "..direction)
			end
			trapcollide(index)
		 end
		
		tbltrap[index]["y"] = fakey
		
	elseif direction == "left" then
		fakex = fakex - speed
		
		tx1, ty1 = postotile(objtocorner(fakex, fakey, 0))
		tx2, ty2 = postotile(objtocorner(fakex, fakey, 1))
		
		if map[tx1][ty1] == 1 or map[tx2][ty2] == 1 then
			fakex = tx1 * TILESIZE
			-- with wall
			trapcollide(index)
		end
		
		for a = 1, #tbldebris do
			if tbldebris[a]["enabled"] == true then
				if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, tbldebris[a]["x"], tbldebris[a]["y"], CHARSIZE, CHARSIZE) == true then
					-- with debris
					print("debris got damage by trap "..a..". "..direction..".")
					tbldebris[a]["damage"] = tbldebris[a]["damage"] + 1
					if tbldebris[a]["damage"] == 3 then
						tbldebris[a]["enabled"] = false
						-- effect: explode debris
						neweffect(tbldebris[a]["x"], tbldebris[a]["y"], 1)
						print("debris "..a.." disabled")
					end
					
					fakex = tbldebris[a]["x"] + CHARSIZE
					trapcollide(index)
					return
				end
			end
		end
		
		 -- with player
		 if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, player["x"], player["y"], CHARSIZE, CHARSIZE) == true then
			fakex = player["x"] + CHARSIZE
			if collcheck(startx * TILESIZE, starty * TILESIZE, TILESIZE, TILESIZE, player["x"], player["y"], CHARSIZE, CHARSIZE) == false then
				-- effect: player become debris
				neweffect(player["x"], player["y"], 0)
				
				newdebris(player["x"], player["y"], player["direction"])
				player["x"] = startx * 48
				player["y"] = starty * 48

				player["blink"] = true
				player["blinktime"] = 5
				print("player become debris, "..direction)
			end
			trapcollide(index)
		 end
		
		tbltrap[index]["x"] = fakex
		
	elseif direction == "right" then
		fakex = fakex + speed
		
		tx1, ty1 = postotile(objtocorner(fakex, fakey, 2))
		tx2, ty2 = postotile(objtocorner(fakex, fakey, 3))
		
		if map[tx1][ty1] == 1 or map[tx2][ty2] == 1 then
			fakex = (tx1 * TILESIZE) - TILESIZE - CHARSIZE
			-- with wall
			trapcollide(index)
		end
		
		for a = 1, #tbldebris do
			if tbldebris[a]["enabled"] == true then
				if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, tbldebris[a]["x"], tbldebris[a]["y"], CHARSIZE, CHARSIZE) == true then
					-- with debris
					print("debris got damage by trap "..a..". "..direction..".")
					tbldebris[a]["damage"] = tbldebris[a]["damage"] + 1
					if tbldebris[a]["damage"] == 3 then
						tbldebris[a]["enabled"] = false
						-- effect: explode debris
						neweffect(tbldebris[a]["x"], tbldebris[a]["y"], 1)
						print("debris "..a.." disabled")
					end
					
					fakex = tbldebris[a]["x"] - CHARSIZE
					trapcollide(index)
					return
				end
			end
		end
		
		-- with player
		if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, player["x"], player["y"], CHARSIZE, CHARSIZE) == true then
			fakex = player["x"] - CHARSIZE
			if collcheck(startx * TILESIZE, starty * TILESIZE, TILESIZE, TILESIZE, player["x"], player["y"], CHARSIZE, CHARSIZE) == false then
				-- effect: player become debris
				neweffect(player["x"], player["y"], 0)
				newdebris(player["x"], player["y"], player["direction"])
				player["x"] = startx * 48
				player["y"] = starty * 48
				
				player["blink"] = true
				player["blinktime"] = 5
			end
			trapcollide(index)
		 end
		
		tbltrap[index]["x"] = fakex
		
	end
end