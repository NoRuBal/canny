-----------------------------------
-- password.lua
-- dated password saving system
-----------------------------------

function ternary(decimal) --decimal  to ternary. only 2 numbers.
	local a
	local tmparr
	local tmp
		
	tmparr = {}
	tmp = decimal
	for a = 1, 2 do
		tmparr[a] = tmp % 3
		tmp = math.floor(tmp/3)
	end

	if tmparr[2] == "" then
		tmparr[2] = 0
	end

	return (tmparr[2]..tmparr[1])
end

function maptocode(decimal) --map number to code
	local a
	local tmparr
	local tmp
	local errnum
	local tblrtn
		
	tmparr = {}
	tmp = decimal
	for a = 1, 3 do
		tmparr[a] = tmp % 3
		tmp = math.floor(tmp/3)
	end

	if tmparr[2] == "" then
		tmparr[2] = 0
	end
	
	if tmparr[3] == "" then
		tmparr[3] = 0
	end
	
	errnum = ternary(tmparr[3] + tmparr[2] + tmparr[1])
	
	return (tmparr[1]..errnum..tmparr[3]..tmparr[2])
	
end

function codetonum(code) --code to map number, return 0 if it's wrong code.
	local tmparr = {}
	tmparr[1] = math.floor(code / 10000)
	tmparr[2] = math.floor(code / 1000) - tmparr[1] * 10
	tmparr[3] = math.floor(code / 100) - tmparr[1] * 100 - tmparr[2] * 10
	tmparr[4] = math.floor(code / 10) - tmparr[1] * 1000 - tmparr[2] * 100 - tmparr[3] * 10
	tmparr[5] = code - tmparr[1] * 10000 - tmparr[2] * 1000 - tmparr[3] * 100 - tmparr[4] * 10

	if ternary(tmparr[1] + tmparr[4] + tmparr[5]) == tmparr[2]..tmparr[3] then
		if tmparr[1] + tmparr[4] + tmparr[5] > 7 then
			return 0
		else
			return tmparr[1] + tmparr[5] * 3 + tmparr[4] * 9
		end
	else
		return 0
	end
end