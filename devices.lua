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

