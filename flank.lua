
function flank_linedefs(linedefs, amount)
	for i=1, #linedefs do
		myLen = linedefs[i].GetLength()
		if myLen > 2 * amount then
			splitvertex, lineA, lineB = linedefs[i].Split()
			--UI.LogLine(tostring(Vector2D.FromAngle(lineA.GetAngle(),amount).x) .. " " .. tostring(Vector2D.FromAngle(lineA.GetAngle(),amount).y))
			splitvertex.TryToMove( lineB.start_vertex.position + Vector2D.FromAngle(lineB.GetAngle(),amount) )

			splitvertex2, lineC, lineD = lineA.Split()
			splitvertex2.TryToMove( lineC.start_vertex.position + Vector2D.FromAngle(lineC.GetAngle(),lineC.GetLength() - amount) )
		
			myInd1, myInd2 = lineB.GetIndex(), lineC.GetIndex()

			sidedefs = Map.GetSidedefs()
			for j=1, #sidedefs do
				if sidedefs[j].GetLinedef().GetIndex() == myInd1 or sidedefs[j].GetLinedef().GetIndex() == myInd2 then
					sidedefs[j].offsetx = 0
					--sidedefs[j].uppertex = "LITE5"
					--sidedefs[j].midtex = "LITE5"
					--sidedefs[j].lowertex = "LITE5"
				end
			end

		end
	end
end

num_linedefs = #(Map.GetSelectedLinedefs())
if num_linedefs == 0 then
	UI.LogLine("No lines selected!")
end

UI.AddParameter("flank_size", "flank size", 16)
parameters = UI.AskForParameters()

p0       = tonumber(parameters.flank_size)
linedefs = Map.GetSelectedLinedefs()

flank_linedefs(linedefs, p0)
