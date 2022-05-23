-- based off of sector_fill_things.lua by anotak

function get_sector_bounding_box(sector)
	local lines  = sector.GetLinedefs()
	local center = sector.GetCenter()
	local east   = center.x
	local west   = center.x
	local north  = center.y
	local south  = center.y
	for _,line in ipairs(lines) do
		-- v1
		west = math.min(west, line.start_vertex.position.x)
		east = math.max(east, line.start_vertex.position.x)
		south = math.min(south, line.start_vertex.position.y)
		north = math.max(north, line.start_vertex.position.y)
		-- v2
		west = math.min(west, line.end_vertex.position.x)
		east = math.max(east, line.end_vertex.position.x)
		south = math.min(south, line.end_vertex.position.y)
		north = math.max(north, line.end_vertex.position.y)
	end
	return east, west, north, south
end

--
sectors = Map.GetSelectedSectors()
if #sectors < 1 then
	UI.LogLine("Must select at least 1 sector!")
end

UI.AddParameter("thing_id", "thing id", 3004)
UI.AddParameter("density", "density (things/mu^2)", 0.002)
UI.AddParameter("look_x", "look towards (x)", 0)
UI.AddParameter("look_y", "look towards (y)", 0)
UI.AddParameter("rng", "rng seed", 123)
parameters = UI.AskForParameters()

tid = tonumber(parameters.thing_id)
dns = tonumber(parameters.density)
lx  = tonumber(parameters.look_x)
ly  = tonumber(parameters.look_y)
lv  = Vector2D.From(lx,ly)

math.randomseed(tonumber(parameters.rng))

for i=1, #sectors do
	e, w, n, s  = get_sector_bounding_box(sectors[i])
	approx_area = (n-s)*(e-w)
	things_to_place = math.ceil(approx_area*dns)
	UI.LogLine("sector: " .. tostring(i) .. " things_to_place: " .. tostring(things_to_place))

	for j=1, things_to_place do
		tx = math.random(e,w)
		ty = math.random(s,n)
		local new_thing = Map.InsertThing(tx,ty)
		new_thing.type  = tid
		--new_thing.SetAngleDoom(0)
		dv = lv - new_thing.position
		new_thing.SetAngleRadians(dv.GetAngle())
		thing_sector = Map.DetermineSector(new_thing.position)
		if thing_sector == nil or thing_sector.GetIndex() ~= sectors[i].GetIndex() then
			new_thing.Dispose()
		end
	end
end
