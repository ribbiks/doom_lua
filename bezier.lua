
function log_factorial(n)
	result = 0
	for i=1,n do
		result = result + math.log(i)
	end
	return result
end

function nCk(n, k)
	if k == 1 then return n end
	if n == k then return 1 end
	if k == 0 then return 1 end
	if k > n or n <= 0 or k < 0 then
		UI.LogLine("bad nCk: " .. tostring(n) .. " " .. tostring(k))
	end
	return math.exp( log_factorial(n) - log_factorial(k) - log_factorial(n-k) )
end

function bezier(verts, n_points)
	v = {}
	for i=1,#verts do
		v[i] = verts[i].position
	end
	points = {}
	for i=1,n_points do
		t   = i/n_points
		omt = 1 - t
		points[i] = 0
		n = #verts - 1
		for j=0,n do
			points[i] = points[i] + nCk(n,j)*(omt^(n-j))*(t^j)*v[j+1]
		end
	end
	return points
end

--
verts = Map.GetSelectedVertices()
num_v = #(verts)
if #verts < 2 then
	UI.LogLine("Must select at least 2 vertices!")
end

UI.AddParameter("n_points", "number of points", 32)
parameters = UI.AskForParameters()

np = tonumber(parameters.n_points)

points_to_draw = bezier(verts, np)

p0 = verts[1].position
p  = Pen.From(p0.x, p0.y)
p.snaptogrid  = false
p.stitchrange = 1
p.DrawVertexAt(p0)
for i=1,#points do
	p.DrawVertexAt(points[i])
end
p.FinishPlacingVertices()
