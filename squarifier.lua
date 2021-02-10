
function squarify(linedefs, amount, min_degrees)
	for i=1, #linedefs do
		myLen = linedefs[i].GetLength()
		myAng = linedefs[i].GetAngleDegrees()
		myOrt = math.min(math.abs(myAng%90), math.abs(myAng%90 - 90))
		if myLen >= amount and myOrt >= min_degrees then
			myA = linedefs[i].start_vertex.position
			myB = linedefs[i].end_vertex.position
			splitvertex, lineA, lineB = linedefs[i].Split()
			try1 = splitvertex.TryToMove( myA.x, myB.y )
			if try1 == false then
				try2 = splitvertex.TryToMove( myB.x, myA.y )
			end
		end
	end
end

num_linedefs = #(Map.GetSelectedLinedefs())
if num_linedefs == 0 then
	UI.LogLine("No lines selected!")
end

UI.AddParameter("min_len", "don't squarify linedefs shorter than this:", 32)
UI.AddParameter("min_ang", "minimum degrees off-orthogonal to squarify", 3)
parameters = UI.AskForParameters()

p0       = tonumber(parameters.min_len)
p1       = tonumber(parameters.min_ang)
linedefs = Map.GetSelectedLinedefs()

squarify(linedefs, p0, p1)
