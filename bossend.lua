--------------------------
-- bossend.lua
-- boss battle & ending
--------------------------

function newtmptrap(x, y)
	local a
	for a = 1, #tbltmptrap do
		if tbltmptrap[a]["enabled"] == false then
			tbltmptrap[a]["x"] = x
			tbltmptrap[a]["y"] = y
			tbltmptrap[a]["enabled"] = true
			return
		end
	end

	tbltmptrap[#tbltmptrap + 1] = {}
	tbltmptrap[#tbltmptrap]["x"] = x
	tbltmptrap[#tbltmptrap]["y"] = y
	tbltmptrap[#tbltmptrap]["enabled"] = true
end

function newanichar(x, y)
	local a
	for a = 1, #tblanichar do
		if tblanichar[a]["enabled"] == false then
			tblanichar[a]["x"] = x
			tblanichar[a]["y"] = y
			tblanichar[a]["motion"] = 0
			tblanichar[a]["enabled"] = true
			return
		end
	end
	
	tblanichar[#tblanichar + 1] = {}
	tblanichar[#tblanichar]["x"] = x
	tblanichar[#tblanichar]["y"] = y
	tblanichar[#tblanichar]["motion"] = 0 
	tblanichar[#tblanichar]["enabled"] = true
end