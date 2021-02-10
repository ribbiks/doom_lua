
-- this algorithm is inefficient and horrible.
-- if you use select a ton of sectors be prepared to wait awhile.
function join_identical(join_or_merge)
	anyFound = true
	while anyFound == true do
		anyFound = false
		ind1, ind2 = -1, -1
		sectors = Map.GetSelectedSectors()
		for i=1, #sectors do
			for j=i+1, #sectors do
				f1, f2   = sectors[i].floorheight, sectors[j].floorheight
				c1, c2   = sectors[i].ceilheight, sectors[j].ceilheight
				b1, b2   = sectors[i].brightness, sectors[j].brightness
				t1, t2   = sectors[i].tag, sectors[j].tag
				e1, e2   = sectors[i].effect, sectors[j].effect
				ft1, ft2 = sectors[i].floortex, sectors[j].floortex
				ct1, ct2 = sectors[i].ceiltex, sectors[j].ceiltex
				if f1 == f2 and c1 == c2 and b1 == b2 and t1 == t2 and e1 == e2 and ft1 == ft2 and ct1 == ct2 then
					ind1, ind2 = i, j
					anyFound = true
				end
				if anyFound == true then break end
			end
			if anyFound == true then break end
		end
		if ind1 >= 0 and ind2 >= 0 then
			if join_or_merge == 0 then
				Map.JoinSectors({sectors[ind1], sectors[ind2]})
			elseif join_or_merge == 1 then
				Map.MergeSectors({sectors[ind1], sectors[ind2]})
			end
		end
	end
end

-- get parameters
UI.AddParameter("join_or_merge", "0 = join sectors, 1 = merge sectors", 0)
parameters    = UI.AskForParameters()
join_or_merge = tonumber(parameters.join_or_merge)

join_identical(join_or_merge)
