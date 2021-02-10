
widths = {}
widths[3004] = 20
widths[9]    = 20
widths[64]   = 20
widths[66]   = 20
widths[67]   = 48
widths[65]   = 20
widths[3001] = 20
widths[3002] = 30
widths[58]   = 30
widths[3005] = 31
widths[3003] = 24
widths[69]   = 24
widths[3006] = 16
widths[7]    = 128
widths[68]   = 64
widths[16]   = 40
widths[71]   = 31
widths[84]   = 20

function spairs(t, order)
	local keys = {}
	for k in pairs(t) do keys[#keys+1] = k end
	if order then
		table.sort(keys, function(a,b) return order(t, a, b) end)
	else
		table.sort(keys)
	end
	local i = 0
	return function()
		i = i + 1
		if keys[i] then
			return keys[i], t[keys[i]]
		end
	end
end

things = Map.GetThings()

out_list = {}
for i=1, #things do
	for j=i+1, #things do
		-- both are monsters
		if widths[things[i].type] ~= nil and widths[things[j].type] ~= nil then
			-- both are present on same difficulty
			s2 = (things[i].IsFlagSet("1") and things[j].IsFlagSet("1"))
			s3 = (things[i].IsFlagSet("2") and things[j].IsFlagSet("2"))
			s4 = (things[i].IsFlagSet("4") and things[j].IsFlagSet("4"))
			if s2 == true or s3 == true or s4 == true then
				-- bounding boxes intersect
				x1 = things[i].position.x
				y1 = things[i].position.y
				w1 = widths[things[i].type]
				x2 = things[j].position.x
				y2 = things[j].position.y
				w2 = widths[things[j].type]
				a_l = x1 - w1
				a_t = y1 + w1
				a_r = x1 + w1
				a_b = y1 - w1
				b_l = x2 - w2
				b_t = y2 + w2
				b_r = x2 + w2
				b_b = y2 - w2
				if a_l < b_r and a_r > b_l and a_t > b_b and a_b < b_t then
					out_list[i] = true
					out_list[j] = true
				end
			end
		end
	end
end

-- deselect everything
for i=1, #things do
	things[i].selected = false
end
-- select overlapping monsters
for k, v in spairs(out_list) do
	things[k].selected = true
end
