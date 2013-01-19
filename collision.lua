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
		
		player["x"] = fakex
		
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
		
		-- no collision with traps
		for a = 1, #tbltrap do
			if tbltrap[a]["enabled"] == true then
				if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, tbltrap[a]["x"], tbltrap[a]["y"], CHARSIZE, CHARSIZE) == true then
					tbldebris[index]["damage"] = tbldebris[index]["damage"] + 1
					if tbldebris[index]["damage"] == 3 then
						tbldebris[index]["enabled"] = false
						-- maybe eff..
					end
					trapcollide(a)
					fakey = tbltrap[a]["y"] + CHARSIZE
				end
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
		
		-- no collision with traps
		for a = 1, #tbltrap do
			if tbltrap[a]["enabled"] == true then
				if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, tbltrap[a]["x"], tbltrap[a]["y"], CHARSIZE, CHARSIZE) == true then
					tbldebris[index]["damage"] = tbldebris[index]["damage"] + 1
					if tbldebris[index]["damage"] == 3 then
						tbldebris[index]["enabled"] = false
						-- maybe eff..
					end
					trapcollide(a)
					fakey = tbltrap[a]["y"] - CHARSIZE
				end
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
		
		-- no collision with traps
		for a = 1, #tbltrap do
			if tbltrap[a]["enabled"] == true then
				if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, tbltrap[a]["x"], tbltrap[a]["y"], CHARSIZE, CHARSIZE) == true then
					tbldebris[index]["damage"] = tbldebris[index]["damage"] + 1
					if tbldebris[index]["damage"] == 3 then
						tbldebris[index]["enabled"] = false
						-- maybe eff..
					end
					trapcollide(a)
					fakex = tbltrap[a]["x"] + CHARSIZE
				end
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
		
		-- no collision with traps
		for a = 1, #tbltrap do
			if tbltrap[a]["enabled"] == true then
				if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, tbltrap[a]["x"], tbltrap[a]["y"], CHARSIZE, CHARSIZE) == true then
					tbldebris[index]["damage"] = tbldebris[index]["damage"] + 1
					if tbldebris[index]["damage"] == 3 then
						tbldebris[index]["enabled"] = false
						-- maybe eff..
					end
					trapcollide(a)
					fakex = tbltrap[a]["x"] - CHARSIZE
				end
			end
		end
		
		tbldebris[index]["x"] = fakex
		
	end
end

function trapcollide(index) -- when trap collide with tile/player/debris
	if tbltrap[index]["kind"] == 0 then -- fire
		tbltrap[index]["enabled"] = false
	elseif tbltrap[index]["kind"] == 1 then -- proto-cog
		-- maybe some effs..
		tbltrap[index]["enabled"] = false
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
						print("debris "..a.." disabled")
					end
					
					fakey = tbldebris[a]["y"] + CHARSIZE
					trapcollide(index)
				end
			end
		end
		
		-- collide with player..
		if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, player["x"], player["y"], CHARSIZE, CHARSIZE) == true then
			fakey = player["y"] + CHARSIZE
			newdebris(player["x"], player["y"], player["direction"])
			player["x"] = startx * 48
			player["y"] = starty * 48
			-- eff..
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
						-- maybe eff..
						print("debris "..a.." disabled")
					end
					
					fakey = tbldebris[a]["y"] - CHARSIZE
					trapcollide(index)
				end
			end
		end
		
		-- with player
		if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, player["x"], player["y"], CHARSIZE, CHARSIZE) == true then
			fakey = player["y"] - CHARSIZE
			newdebris(player["x"], player["y"], player["direction"])
			player["x"] = startx * 48
			player["y"] = starty * 48
			-- eff..
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
						-- maybe eff..
						print("debris "..a.." disabled")
					end
					
					fakex = tbldebris[a]["x"] + CHARSIZE
					trapcollide(index)
				end
			end
		end
		
		 -- with player
		 if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, player["x"], player["y"], CHARSIZE, CHARSIZE) == true then
			fakex = player["x"] + CHARSIZE
			newdebris(player["x"], player["y"], player["direction"])
			player["x"] = startx * 48
			player["y"] = starty * 48
			-- eff..
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
						-- maybe eff..
						print("debris "..a.." disabled")
					end
					
					fakex = tbldebris[a]["x"] - CHARSIZE
					trapcollide(index)
				end
			end
		end
		
		-- with player
		if collcheck(fakex, fakey, CHARSIZE, CHARSIZE, player["x"], player["y"], CHARSIZE, CHARSIZE) == true then
			fakex = player["x"] - CHARSIZE
			newdebris(player["x"], player["y"], player["direction"])
			player["x"] = startx * 48
			player["y"] = starty * 48
			-- eff..
			trapcollide(index)
		 end
		
		tbltrap[index]["x"] = fakex
		
	end
end