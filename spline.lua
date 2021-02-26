
function has_vec2d(tab, val)
	for index, value in ipairs(tab) do
		if value.x == val.x and value.y == val.y then
			return true
		end
	end
	return false
end

--
-- this is slow and horrible because apparently you can't rely
-- on vertex indices staying sensible whilst deleting things
--
function delete_stuff(lines, verts)
	v_pos = {}
	for i=1,#lines do
		v_pos[#v_pos+1] = lines[i].start_vertex.position
		v_pos[#v_pos+1] = lines[i].end_vertex.position
	end
	for i=1,#verts do
		v_pos[#v_pos+1] = verts[i].position
	end
	still_going = #v_pos
	while still_going > 0 do
		still_going = 0
		verts = Map.GetVertices()
		for i=1,#verts do
			if has_vec2d(v_pos, verts[i].position) == true then
				verts[i].Dispose()
				still_going = 1
				break
			end
		end
	end
end

-- cubic spline using finite-difference tangents
function spline(verts, n_points)
	v = {}
	for i=1,#verts do
		v[i] = verts[i].position
	end
	-- estimate arc length (and thus how many points to allocate to each cubic)
	arc_len = {}
	tot_len = 0
	for i=1,#v-1 do
		d = v[i+1]-v[i]
		arc_len[#arc_len+1] = d.GetLength()
		tot_len = tot_len + arc_len[#arc_len]
	end
	points_per_arc = {}
	for i=1,#v-1 do
		points_per_arc[i] = math.ceil(n_points*(arc_len[i]/tot_len))
	end
	-- compute tangents (apparently I shouldn't normalize them)
	m = {}
	m[1] = (v[2]-v[1])--/((v[2]-v[1]).GetLength())
	for i=2,#v-1 do
		d1 = (v[i+1]-v[i])--/((v[i+1]-v[i]).GetLength())
		d2 = (v[i]-v[i-1])--/((v[i]-v[i-1]).GetLength())
		m[i] = 0.5*(d1+d2)
	end
	m[#v] = (v[#v]-v[#v-1])--/((v[#v]-v[#v-1]).GetLength())
	-- cubics
	points = {}
	for i=1,#v-1 do
		p0 = v[i]
		m0 = m[i]
		p1 = v[i+1]
		m1 = m[i+1]
		for j=0,points_per_arc[i] do
			t  = j/(points_per_arc[i]+1)
			t1 =  2*(t^3) - 3*(t^2) + 1
			t2 =  1*(t^3) - 2*(t^2) + t
			t3 = -2*(t^3) + 3*(t^2)
			t4 =  1*(t^3) - 1*(t^2)
			points[#points+1] = t1*p0 + t2*m0 + t3*p1 + t4*m1
			--UI.LogLine("i: " .. tostring(i) .. ", t: " .. tostring(t) .. " (" .. tostring(points_per_arc[i]) .. "), " .. tostring(points[#points].x) .. " " .. tostring(points[#points].y))
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
UI.AddParameter("del_scaf", "delete selected verts? (0=no, 1=yes)", 1)
parameters = UI.AskForParameters()

np = tonumber(parameters.n_points)
dl = tonumber(parameters.del_scaf)

points_to_draw = spline(verts, np)
p0 = verts[1].position
pn = verts[#verts].position
if dl > 0 then
	delete_stuff(Map.GetSelectedLinedefs(), Map.GetSelectedVertices())
end

p  = Pen.From(p0.x, p0.y)
p.snaptogrid  = false
p.stitchrange = 1
--p.DrawVertexAt(p0)
for i=1,#points do
	p.DrawVertexAt(points[i])
end
p.DrawVertexAt(pn)
p.FinishPlacingVertices()
