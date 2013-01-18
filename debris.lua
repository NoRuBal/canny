-------------------------------------
-- debris.lua
-- module for making new debris, and other things
-------------------------------------

function newdebris(x, y, direction)
	-- make new debris
	-- how to use: newdebris(x, y, direction debris heads(0/1))
	local a
	for a = 1, #tbldebris do
		-- find not-enabled debris
		if tbldebris[a]["enabled"] == false then
			tbldebris[a]["x"] = x
			tbldebris[a]["y"] = y
			tbldebris[a]["direction"] = direction
			tbldebris[a]["damage"] = 0
			tbldebris[a]["enabled"] = true
			return
		end
	end
	
	-- can't find it? make new one
	tbldebris[#tbldebris + 1] = {}
	tbldebris[#tbldebris]["x"] = x
	tbldebris[#tbldebris]["y"] = y
	tbldebris[#tbldebris]["direction"] = direction
	tbldebris[#tbldebris]["damage"] = 0
	tbldebris[#tbldebris]["enabled"] = true
end