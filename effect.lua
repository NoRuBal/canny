---------------------------------
-- effect.lua
-- make effect of game
---------------------------------

function neweffect(x, y, kind) --kind: 0-smoke 1-explode
	-- make new effect
	if kind == 0 then
		if mute == false then
			love.audio.play(tblse[5])
		end
	elseif kind == 1 then
		if mute == false then
			love.audio.play(tblse[4])
		end
	end
	
	local a
	for a = 1, #tbleffect do
		-- find not-enabled effect
		if tbleffect[a]["enabled"] == false then
			tbleffect[a]["x"] = x
			tbleffect[a]["y"] = y
			tbleffect[a]["kind"] = kind
			tbleffect[a]["animation"] = 0
			tbleffect[a]["enabled"] = true
			return
		end
	end
	
	-- can't find it? make new one
	tbleffect[#tbleffect + 1] = {}
	tbleffect[#tbleffect]["x"] = x
	tbleffect[#tbleffect]["y"] = y
	tbleffect[#tbleffect]["kind"] = kind
	tbleffect[#tbleffect]["animation"] = 0
	tbleffect[#tbleffect]["enabled"] = true
end