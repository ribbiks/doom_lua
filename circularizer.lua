
function round(val)
	return math.floor(val+0.5)
end

function circularize(vList, tList, r_off, x_buff, r_scale)
	local min_x = 999999
	local max_x = -999999
	local min_y = 999999
	local max_y = -999999
	local x = 0
	local y = 0
	local r = 0
	local theta = 0
	local new_x = 0
	local new_y = 0
	local new_angle = 0
	for i=1, #vList do
		x = vList[i].position.x
		y = vList[i].position.y
		if x < min_x then
			min_x = x
		end
		if x > max_x then
			max_x = x
		end
		if y < min_y then
			min_y = y
		end
		if y > max_y then
			max_y = y
		end
	end
	local scale = {max_x-min_x, max_y-min_y}
	local offset = {(min_x+max_x)/2.0, (min_y+max_y)/2.0}

	for i=1, #vList do
		x = vList[i].position.x
		y = vList[i].position.y
		r = r_scale*(y-min_y) + r_off
		theta = -(2*math.pi*(x-min_x))/(x_buff+max_x-min_x) - math.pi/2.0
		new_x = r*math.cos(theta) + offset[1]
		new_y = r*math.sin(theta) + offset[2]
		vList[i].position = Vector2D.From(round(new_x), round(new_y))
	end

	for i=1, #tList do
		x = tList[i].position.x
		y = tList[i].position.y
		r = r_scale*(y-min_y) + r_off
		theta = -(2*math.pi*(x-min_x))/(x_buff+max_x-min_x) - math.pi/2.0
		new_x = r*math.cos(theta) + offset[1]
		new_y = r*math.sin(theta) + offset[2]
		new_angle = math.floor(tList[i].GetAngleDoom() + (theta*360)/(2*math.pi) - 90)%360
		tList[i].position = Vector2D.From(round(new_x), round(new_y))
		tList[i].SetAngleDoom(new_angle)
	end
end

UI.AddParameter("rad_min", "radius offset (r0)", 128)
UI.AddParameter("theta_buff", "theta buffer", 0)
UI.AddParameter("scale", "scaling factor", 1.0)
parameters = UI.AskForParameters()
p1 = tonumber(parameters.rad_min)
p2 = tonumber(parameters.theta_buff)
p3 = tonumber(parameters.scale)

vertices = Map.GetSelectedVertices()
things   = Map.GetSelectedThings()
circularize(vertices, things, p1, p2, p3)
