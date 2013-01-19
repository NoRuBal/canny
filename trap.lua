-------------------------------
-- trap.lua
-- module to manage traps
-------------------------------

function newtrap(x, y, kind, direction)
	-- make new trap
	-- how to use: newtrap(x, y, attribute of trap, direction)
	local a
	for a = 1, #tbltrap do
		-- find not-enabled trap
		if tbltrap[a]["enabled"] == false then
			tbltrap[a]["x"] = x
			tbltrap[a]["y"] = y
			tbltrap[a]["kind"] = kind -- attribute. fire? cog?
			tbltrap[a]["direction"] = direction -- head right:0 head left: 1 head up:2 head down:3
			tbltrap[a]["animation"] = 0 -- Animation. we have 2 frame per one trap.
			tbltrap[a]["enabled"] = true --enabled?
			return
		end
	end
	
	-- can't find it? make new one
	tbltrap[#tbltrap + 1] = {}
	tbltrap[#tbltrap]["x"] = x
	tbltrap[#tbltrap]["y"] = y
	tbltrap[#tbltrap]["kind"] = kind -- attribute. fire? cog?
	tbltrap[#tbltrap]["direction"] = direction -- head right:0 head left: 1
	tbltrap[#tbltrap]["animation"] = 0 -- Animation. we have 2 frame per one trap.
	tbltrap[#tbltrap]["enabled"] = true --enabled?
end