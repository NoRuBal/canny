---------------------------------------
-- main.lua
-- main core of the game, don't write 'raw' code here!
---------------------------------------

-- sequence control
scene = 0 -- 0: title 1: game 2: password 3: credit 4: opening scene  5: stage title
currentstage = 0 --current stage number

-- constants, don't change in game!
TILESIZE = 48
CHARSIZE = 40

------------------ var for title /password screen ------------------
-- select for input
selectinput = 0
-- in title screen: 0: start 1: password 2: credit 3: exit
-- in password input screen: 
-- in paused screen: 0: reset 1: back 2: quit

-- cursor animation in title screen
anicrs = 0 --equal as player animation
tmrcrs = 0

--password screen
tblcurcode = {}
tblcurcode[1] = 1
tblcurcode[2] = 1
tblcurcode[3] = 1
tblcurcode[4] = 1
tblcurcode[5] = 1
-----------------------------------------

-----------------------------var for opening-----------------------------
tmrcharani = 0 --timer for char animation
tmreffani = 0 --timer for effect
tmrcontrolani = 0 --timer for control everything about scene

controlani = 0 --  +1 for every sec

charani = 0 --char animation
effani = 0 --effect animation
-----------------------------------------

-- require modules
require "init" -- init everything
require "debris" -- manage debris
require "collision" -- detect and respond to collision
require "map" --about map
require "trap" --about trap
require "devices" --about trap
require "effect" --about effect
require "password" --about password

--[[
init() --init everything.
loadmap("asdf.txt") --load example map. "asdf.txt"
newtrap(48 * 10, 48 * 5, 2, 0)
newtrapgen(48 * 7, 48 * 7, 1, 0, 1)
newlava(48 * 1, 48 * 9)
newtrap(48 * 2, 48 * 8, 0, 0)
newbelt(48 * 5, 48 * 9, 1)
-- to make player blink
player["blink"] = true
player["blinktime"] = 5
]]--

function love.load()
	local a, b

	-- load image
	imgtitle = love.graphics.newImage("Graphics/title.png") -- load title screen
	imgpass = love.graphics.newImage("Graphics/password.png") -- load password screen
	imgcursor = love.graphics.newImage("Graphics/cursor.png") -- load cursor
	
	imgchar = love.graphics.newImage("Graphics/can_sprite.png") -- load player sprite
	imgdeb = love.graphics.newImage("Graphics/debris_sprite.png") -- load debris sprite
    imgtile = love.graphics.newImage("Graphics/tile.png") --load tile graphic
	imgpoints = love.graphics.newImage("Graphics/points.png") --load start/goal points
	imgtraps = love.graphics.newImage("Graphics/traps.png") --load trap sprite
	imglava = love.graphics.newImage("Graphics/lava.png") --load trap sprite
	imgbelt = love.graphics.newImage("Graphics/belt.png") --load belt sprite
	imgtrapgen = love.graphics.newImage("Graphics/trapgen.png") --load trap generator graphic
	imgeffect = love.graphics.newImage("Graphics/effect.png") -- load effect graphic
	
	imgpile = love.graphics.newImage("Graphics/back_pile.png") -- load garbage pile: for opening
	imgcanopen = love.graphics.newImage("Graphics/can_opening.png") -- load player animation: for opening
	imgeffopen = love.graphics.newImage("Graphics/eff_opening.png") -- load effect animation: for opening
	
	imgstagetitle = love.graphics.newImage("Graphics/stage.png") -- load stage title screen
	imgnumbers = love.graphics.newImage("Graphics/numbers.png") -- load numbers
	imgprogress = love.graphics.newImage("Graphics/progress.png") -- load numbers
	
	imgfinish = love.graphics.newImage("Graphics/can_dance.png") -- load can dance graphic
	imgpause = love.graphics.newImage("Graphics/paused.png") -- load pause graphic
	
	imgguide = love.graphics.newImage("Graphics/guide.png") -- load guide
	
	-- background
	imgback = love.graphics.newImage("Graphics/background.png") -- load background graphic
	
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
	
	-- quad to draw effects
	quadeffect = {}
    for a = 1, 2 do
		for b = 1, 2 do
			quadeffect[a * 2 + b - 2] = love.graphics.newQuad(CHARSIZE * (b - 1), CHARSIZE * (a - 1), CHARSIZE, CHARSIZE, CHARSIZE * 2, CHARSIZE * 2)
		end
	end
	
	-- quad to draw player animation for opening
	quadcanopen = {}
	for a = 1, 4 do
		quadcanopen[a] = love.graphics.newQuad(CHARSIZE * (a - 1), 0, CHARSIZE, CHARSIZE, CHARSIZE * 4, CHARSIZE)
	end
	
	-- quad to draw effect animation for opening
	quadeffopen = {}
	for a = 1, 4 do
		quadeffopen[a] = love.graphics.newQuad(CHARSIZE * (a - 1), 0, CHARSIZE, CHARSIZE, CHARSIZE * 4, CHARSIZE)
	end
	
	-- quad to draw numbers
	quadnumbers = {}
	for a = 0, 9 do
		quadnumbers[a] = love.graphics.newQuad(24 * a , 0, 24, 30, 240, 30)
	end
	
	--quad to draw can dance
	quadfinish = {}
	for a = 1, 2 do
		quadfinish[a] = love.graphics.newQuad(CHARSIZE * (a - 1), 0, CHARSIZE, CHARSIZE, CHARSIZE * 2, CHARSIZE)
	end
	
end

function love.draw()
	if scene == 0 then -- title screen
		local curx, cury
		-- draw title screen
		love.graphics.draw(imgtitle, 0, 0)
		--draw cursor
		if selectinput == 0 then
			curx = 304
			cury = 276
		elseif selectinput == 1 then
			curx = 271
			cury = 314
		elseif selectinput == 2 then
			curx = 296
			cury = 352
		elseif selectinput == 3 then
			curx = 320
			cury = 386
		end
		love.graphics.drawq(imgchar, quadchar[anicrs + 1], curx, cury)
	elseif scene == 1 or scene == 4 then --in game & story scene
		local a
		local b
		local dbgx, dbgy
		
		-- draw background
		love.graphics.draw(imgback, 0, 0)
		
		-- draw tiles
		for a = 1, 17 do
			for b = 1, 10 do
				if map[a][b] == 1 then
					love.graphics.drawq(imgtile, quadtile[map[a][b] + 1], (a - 1) * TILESIZE, (b - 1) * TILESIZE)
				end
			end
		end
		
		--draw doors
		love.graphics.drawq(imgpoints, quadpoints[1], startx * 48, starty * 48)
		love.graphics.drawq(imgpoints, quadpoints[2], endx * 48, endy * 48)
		
		-- draw story thing(garbage pile)
		if scene == 4 then --only opening
			love.graphics.draw(imgpile, 48 * 3, 48 * 5)
		end
		
		--draw debris
		for a = 1, #tbldebris do
			if tbldebris[a]["enabled"] == true then
				love.graphics.drawq(imgdeb, quaddeb[(tbldebris[a]["direction"] * 3) + 1 + tbldebris[a]["damage"]], math.floor(tbldebris[a]["x"]), math.floor(tbldebris[a]["y"]))
			end
		end
		
		--draw traps
		for a = 1, #tbltrap do
			if tbltrap[a]["enabled"] == true then
				love.graphics.drawq(imgtraps, quadtrap[tbltrap[a]["kind"] * 2 + 1 + tbltrap[a]["animation"]], math.floor(tbltrap[a]["x"]), math.floor(tbltrap[a]["y"]))
			end
		end
		
		-- draw belt
		for a = 1, #tblbelt do
			love.graphics.drawq(imgbelt, quadbelt[tblbelt[a]["direction"] * 2 + 1 + tblbelt[a]["animation"]], tblbelt[a]["x"], tblbelt[a]["y"])
		end
		
		--draw player
		if player["blink"] == false then
			if scene == 1 then --normal game
				if finished == true then --finish, dance!
					love.graphics.drawq(imgfinish, quadfinish[player["motion"]], math.floor(player["x"]), math.floor(player["y"]))
				else
					love.graphics.drawq(imgchar, quadchar[(player["direction"] * 4) + 1 + player["motion"]], math.floor(player["x"]), math.floor(player["y"]))
				end
			elseif scene == 4 then --opening
				love.graphics.drawq(imgcanopen, quadcanopen[charani], player["x"], player["y"])
			end
		end
		
		--draw lava
		for a = 1, #tbllava do
			love.graphics.draw(imglava, tbllava[a]["x"], tbllava[a]["y"])
		end
		
		-- draw trap generator
		for a = 1, #tbltrapgen do
			love.graphics.draw(imgtrapgen, tbltrapgen[a]["x"], tbltrapgen[a]["y"])
		end
		
		-- draw effect
		for a = 1, #tbleffect do
			if tbleffect[a]["enabled"] == true then
				love.graphics.drawq(imgeffect, quadeffect[tbleffect[a]["kind"] * 2 + 1 + tbleffect[a]["animation"]], math.floor(tbleffect[a]["x"]), math.floor(tbleffect[a]["y"]))
			end
		end
		
		-- draw effect for opening
		if scene == 4 then --opening
			if effani == 4 then
				if controlani > 7 then
					love.graphics.drawq(imgeffopen, quadeffopen[effani], player["x"], player["y"] - 48 + 2)
				end
			else
				love.graphics.drawq(imgeffopen, quadeffopen[effani], player["x"] + 48, player["y"])
			end
		end
		
		-- draw guide, only stage 1
		if currentstage == 1 then
			love.graphics.draw(imgguide, 48, 0)
		end
		
		-- draw window if paused
		if pause == true then
			local a
			local tmp
			local tmparr
			tmparr = {}
			
			love.graphics.draw(imgpause, 230, 70)
			
			-- display password
			tmp = maptocode(currentstage)
			tmparr[1] = math.floor(tmp / 10000)
			tmparr[2] = math.floor(tmp / 1000) - tmparr[1] * 10
			tmparr[3] = math.floor(tmp / 100) - tmparr[1] * 100 - tmparr[2] * 10
			tmparr[4] = math.floor(tmp / 10) - tmparr[1] * 1000 - tmparr[2] * 100 - tmparr[3] * 10
			tmparr[5] = tmp - tmparr[1] * 10000 - tmparr[2] * 1000 - tmparr[3] * 100 - tmparr[4] * 10
			
			for a = 1, 5 do
				if tmparr[a] == 0 then
					love.graphics.drawq(imgchar, quadchar[1], 258 + 44 * a, 70 + 120)
				elseif tmparr[a] == 1 then
					love.graphics.drawq(imgtraps, quadtrap[6], 258 + 44 * a, 70 + 120)
				elseif tmparr[a] == 2 then
					love.graphics.drawq(imgtraps, quadtrap[1], 258 + 44 * a, 70 + 120)
				end
			end
			
			local curx, cury
			if selectinput == 0 then
				curx = 230 + 116
				cury = 70 + 207
			elseif selectinput == 1 then
				curx = 230 + 128
				cury = 70 + 249
			elseif selectinput == 2 then
				curx = 230 + 128
				cury = 70 + 293
			end
			
			love.graphics.draw(imgcursor, curx, cury)
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
	elseif scene == 2 then --password
		local curx, cury
		-- draw title screen
		love.graphics.draw(imgpass, 0, 0)
		
		if selectinput == 0 then
			curx = 298
			cury = 224 + 40
		elseif selectinput == 1 then
			curx = 342
			cury = 224 + 40
		elseif selectinput == 2 then
			curx = 386
			cury = 224 + 40
		elseif selectinput == 3 then
			curx = 430
			cury = 224 + 40
		elseif selectinput == 4 then
			curx = 474
			cury = 224 + 40
		elseif selectinput == 5 then
			curx = 384
			cury = 330
		elseif selectinput == 6 then
			curx = 360
			cury = 370
		end
		
		-- draw password cursors
		local a
		for a = 1, 5 do
			if tblcurcode[a] == 0 then
				love.graphics.drawq(imgchar, quadchar[1], 254 + 44 * a, 224)
			elseif tblcurcode[a] == 1 then
				love.graphics.drawq(imgtraps, quadtrap[6], 254 + 44 * a, 224)
			elseif tblcurcode[a] == 2 then
				love.graphics.drawq(imgtraps, quadtrap[1], 254 + 44 * a, 224)
			end
		end
		
		--draw cursor
		love.graphics.draw(imgcursor, curx, cury)
	elseif scene == 5 then --stage title
		local tmp1, tmp2
		local tmp
		local tmparr
		local a
		
		tmparr = {}
		tmp1 = math.floor(currentstage / 10)
		tmp2 = currentstage - tmp1 * 10
		
		love.graphics.draw(imgstagetitle, 0, 0)
		--display current  stage number
		love.graphics.drawq(imgnumbers, quadnumbers[tmp1], 436, 40)
		love.graphics.drawq(imgnumbers, quadnumbers[tmp2], 460, 40)
		
		--display password
		tmp = maptocode(currentstage)
		tmparr[1] = math.floor(tmp / 10000)
		tmparr[2] = math.floor(tmp / 1000) - tmparr[1] * 10
		tmparr[3] = math.floor(tmp / 100) - tmparr[1] * 100 - tmparr[2] * 10
		tmparr[4] = math.floor(tmp / 10) - tmparr[1] * 1000 - tmparr[2] * 100 - tmparr[3] * 10
		tmparr[5] = tmp - tmparr[1] * 10000 - tmparr[2] * 1000 - tmparr[3] * 100 - tmparr[4] * 10
		
		for a = 1, 5 do
			if tmparr[a] == 0 then
				love.graphics.drawq(imgchar, quadchar[1], 258 + 44 * a, 400)
			elseif tmparr[a] == 1 then
				love.graphics.drawq(imgtraps, quadtrap[6], 258 + 44 * a, 400)
			elseif tmparr[a] == 2 then
				love.graphics.drawq(imgtraps, quadtrap[1], 258 + 44 * a, 400)
			end
		end
		
		-- draw current progress
		love.graphics.draw(imgprogress, 190 + 16 * currentstage, 288)
		
	end
end

function love.keypressed()
	if scene == 0 then --title screen
		-- move cursor up/down by input
		if love.keyboard.isDown("up") then
			if selectinput ~= 0 then
				selectinput = selectinput - 1
			end
		elseif love.keyboard.isDown("down") then
			if selectinput ~= 3 then
				selectinput = selectinput + 1
			end
		elseif love.keyboard.isDown("lctrl", "rctrl") then
			-- select
			if selectinput == 0 then -- start
				--[[
				-- see opening scene
				init() --init everything.
				loadmap("stage/00.txt") --load map for opening
				startx = 6
				starty = 8
				endx = 15
				endy = 8
				player["x"] = 4 + 48 * 8
				player["y"] = 8 + 48 * 8
				charani = 1
				effani = 1
				scene = 4 --opening
				]]--
				startstage(1)
				
			elseif selectinput == 1 then -- password
				tblcurcode[1] = 1
				tblcurcode[2] = 1
				tblcurcode[3] = 1
				tblcurcode[4] = 1
				tblcurcode[5] = 1
				selectinput = 0
				scene = 2
			elseif selectinput== 2 then --credit
				
			elseif selectinput == 3 then --exit
				love.event.quit()
			end
		end
	elseif scene == 1 then --in game
		--pause by esc
		if love.keyboard.isDown("escape") then
			pause = true
			selectinput = 1
		end
		if pause == true then
			if love.keyboard.isDown("up") then
				if selectinput ~= 0 then
					selectinput = selectinput - 1
				end
			elseif love.keyboard.isDown("down") then
				if selectinput ~= 2 then
					selectinput = selectinput + 1
				end
			elseif love.keyboard.isDown("rctrl", "lctrl") then
				if selectinput == 0 then --reset
					startstage(currentstage)
				elseif selectinput == 1 then -- back
					pause = false
				elseif selectinput == 2 then -- quit
					love.event.quit() -- bye!
				end
			end
		end
	elseif scene == 2 then --password screen
		if love.keyboard.isDown("left") then
			if selectinput ~= 0 then
				selectinput = selectinput - 1
			end
		elseif love.keyboard.isDown("right") then
			if selectinput ~= 6 then
				selectinput = selectinput + 1
			end
		elseif love.keyboard.isDown("up") then
			if selectinput < 5 then
				if tblcurcode[selectinput + 1] ~= 2 then
					tblcurcode[selectinput + 1] = tblcurcode[selectinput + 1] + 1
				else
					tblcurcode[selectinput + 1] = 0
				end
			end
		elseif love.keyboard.isDown("down") then
			if selectinput < 5 then
				if tblcurcode[selectinput + 1] ~= 0 then
					tblcurcode[selectinput + 1] = tblcurcode[selectinput + 1] - 1
				else
					tblcurcode[selectinput + 1] = 2
				end
			end
		elseif love.keyboard.isDown("lctrl", "rctrl") then
			if selectinput == 5 then
				--check password is right
				local tmp
				tmp = tblcurcode[1]..tblcurcode[2]..tblcurcode[3]..tblcurcode[4]..tblcurcode[5]
				if codetonum(tmp) == 0 then
					--wrong!
					selectinput = 0
					-- maybe sound..
				else
					startstage(codetonum(tmp))
				end
			elseif selectinput == 6 then
				selectinput = 0
				scene = 0
			end
		end
	elseif scene == 5 then --stage title screen.
		-- responce to any key
		loadmap("stage/"..currentstage..".txt") --load example map. "asdf.txt"
		scene = 1

		-- to make player blink
		player["blink"] = true
		player["blinktime"] = 5
		
	end
end

function love.update(dt)
	if scene == 0 then -- in title
		-- animate cursor
		tmrcrs = tmrcrs + dt
		if tmrcrs >= 0.3 then
			tmrcrs = tmrcrs - 0.3
			if anicrs + 1 == 4 then
				anicrs = 0
			else
				anicrs = anicrs + 1
			end
		end
	elseif scene == 1 then --in game
		if pause == false then --if paused, don't move anything.
			if finished == false then --if finished, don't move anything.
				local a
				local tx1, ty1, tx2, ty2
				
				--check for player&exit door. if it collide, finish stage.
				if collcheck(player["x"], player["y"], CHARSIZE, CHARSIZE, endx * TILESIZE, endy * TILESIZE, TILESIZE, TILESIZE) == true then
					finished = true
					player["motion"] = 1
				end
				
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
				for b = 1, #tbldebris do
					for a = 1, #tblbelt do
						if tbldebris[b]["enabled"] == true then
							if collcheck(tbldebris[b]["x"], tbldebris[b]["y"] + 1, CHARSIZE, CHARSIZE, tblbelt[a]["x"], tblbelt[a]["y"], TILESIZE, TILESIZE) == true then
								if tblbelt[a]["direction"] == 0 then
									debmove("right", 90 * dt, b)
								else
									debmove("left", 90 * dt, b)
								end
								-- check collision & player
								debcollplayer(tblbelt[a]["direction"], b)
								break
							end
						end
					end
				end
				
				--jump
				if love.keyboard.isDown("lctrl", "rctrl") then
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
				
				-- gravity
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
					
					for a = 1, #tbleffect do
						-- 0->1->disappear
						if tbleffect[a]["enabled"] == true then
							if tbleffect[a]["animation"] == 0 then
								tbleffect[a]["animation"] = 1
							else
								tbleffect[a]["enabled"] = false
							end
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
			elseif finished == true then
				tmrfinish = tmrfinish + dt
				if tmrfinish >= 0.5 then
					tmrfinish = tmrfinish - 0.5
					confinish = confinish + 0.5
					
					if player["motion"] == 1 then
						player["motion"] = 2
					end
					
					if confinish == 2 then
						startstage(currentstage + 1)
					end
				end
			end
		elseif pause == true then
			
		end
	elseif scene == 4 then --opening
		tmrcontrolani = tmrcontrolani + dt
		if tmrcontrolani >= 0.5 then
			tmrcontrolani = tmrcontrolani - 0.5
			controlani = controlani + 0.5
			
			if controlani == 5 then
				charani = 3
				effani = 3
			elseif controlani == 6 then
				charani = 4
				effani = 4
			elseif controlani == 9 then
				-- go to stage 1
				startstage(1)
			end
		end
		
		tmrcharani = tmrcharani + dt
		if tmrcharani >= 1 then
			tmrcharani = tmrcharani - 1
			if charani == 2 then
				charani = 1
			elseif charani == 1 then
				charani = 2
			elseif charani == 3 then
				charani = 3
			end
		end
		
		tmreffani = tmreffani + dt
		if tmreffani >= 0.5 then
			tmreffani = tmreffani - 0.5
			if effani == 2 then
				effani = 1
			elseif effani == 1 then
				effani = 2
			elseif effani == 3 then
				effani = 3
			elseif effani == 4 then
				effani = 4
			end
		end	
	end
end