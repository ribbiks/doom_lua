
function has_value (tab, val)
	for index, value in ipairs(tab) do
		if value == val then
			return true
		end
	end
	return false
end

function bevel(linedefs, amount)
	pairs_to_do = {}
	for i=1, #linedefs do
		myV = {linedefs[i].start_vertex.GetIndex(), linedefs[i].end_vertex.GetIndex()}
		for j=i+1, #linedefs do
			if has_value(myV,linedefs[j].start_vertex.GetIndex()) == true then
				pos1 = linedefs[j].start_vertex.position + Vector2D.FromAngle(linedefs[j].GetAngle(),amount)
				pos2 = linedefs[i].end_vertex.position - Vector2D.FromAngle(linedefs[i].GetAngle(),amount)
				splitvertex, lineA, lineB = linedefs[i].Split()
				linedefs[j].start_vertex.TryToMove(pos1)
				splitvertex.TryToMove(pos2)
			end
		end
	end
end

-- it doesn't make sense to run with no linedefs selected, so let's let the user know
num_linedefs = #(Map.GetSelectedLinedefs())
if num_linedefs < 2 then
	UI.LogLine("Must have at least 2 lines selected!")
end

UI.AddParameter("bevel_size", "bevel size", 32)
parameters = UI.AskForParameters()

p0       = tonumber(parameters.bevel_size)
linedefs = Map.GetSelectedLinedefs()

bevel(linedefs, p0)
