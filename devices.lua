-----------------------------
-- devices.lua
-- manage lava/trap generator/con belt
-----------------------------

function newlava(x, y)
	-- make new lava
	if tbllava[1] == nil then
		-- lava table don't exsist
		tbllava[1] = {}
		tbllava[1]["x"] = x
		tbllava[1]["y"] = y
		return
	end

	tbllava[#tbllava + 1] = {}
	tbllava[#tbllava]["x"] = x
	tbllava[#tbllava]["y"] = y
end

function newbelt(x, y, direction)
	-- make new conveyor belt
	if tblbelt[1] == nil then
		--belt table don't exsist
		tblbelt[1] = {}
		tblbelt[1]["x"] = x
		tblbelt[1]["y"] = y
		tblbelt[1]["animation"] = 0
		tblbelt[1]["direction"] = direction --0: to right 1: to left
		return
	end

	tblbelt[#tblbelt + 1] = {}
	tblbelt[#tblbelt]["x"] = x
	tblbelt[#tblbelt]["y"] = y
	tblbelt[#tblbelt]["animation"] = 0
	tblbelt[#tblbelt]["direction"] = direction --0: to right 1: to left
end

function newtrapgen(x, y, kind, direction, delay)
	-- make new trap generator
	-- kind: kind of trap, direction: direction of trap, delay: delay of trap generation(to second)
	if tbltrapgen[1] == nil then
		tbltrapgen[1] = {}
		tbltrapgen[1]["x"] = x
		tbltrapgen[1]["y"] = y
		tbltrapgen[1]["kind"] = kind
		tbltrapgen[1]["direction"] = direction
		tbltrapgen[1]["delay"] = delay
		tbltrapgen[1]["timer"] = 0
		return
	end
	
	tbltrapgen[#tbltrapgen + 1] = {}
	tbltrapgen[#tbltrapgen]["x"] = x
	tbltrapgen[#tbltrapgen]["y"] = y
	tbltrapgen[#tbltrapgen]["kind"] = kind
	tbltrapgen[#tbltrapgen]["direction"] = direction
	tbltrapgen[#tbltrapgen]["delay"] = delay
	tbltrapgen[#tbltrapgen]["timer"] = 0
end