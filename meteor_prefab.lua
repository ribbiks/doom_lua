---
--- meteor_prefab.lua
---
--- generates mechanistic bits needed for meteors
---

--- returns index of linedef with specified vertex coordinates
function get_linedef_index(linedefList, vpos1, vpos2)
	for i=1, #linedefList do
		local lv1 = linedefList[#linedefList-i+1].start_vertex.position
		local lv2 = linedefList[#linedefList-i+1].end_vertex.position
		if lv1 == vpos1 and lv2 == vpos2 then return #linedefList-i+1 end
		if lv1 == vpos2 and lv2 == vpos1 then return #linedefList-i+1 end
	end
end

-- get sector index of sector associated with front side of linedef with specified coordinates
function get_sector_index_from_linedef_coords(sectorList, linedefList, vpos1, vpos2)
	local lInd     = get_linedef_index(linedefList, vpos1, vpos2)
	local myFront  = linedefList[lInd].GetFront()
	local mySector = myFront.GetSector()
	return mySector.GetIndex()+1 --- +1 because sector indices are 0-indexed
end

function draw_launcher(x, y, tag_offset, fh, ch, game_type)
	local p = Pen.From(x,y)
	p.snaptogrid  = false
	p.stitchrange = 1
	--- border
	p.DrawVertexAt(Vector2D.From(x,y))
	p.DrawVertexAt(Vector2D.From(x+64,y))
	p.DrawVertexAt(Vector2D.From(x+64,y-128))
	p.DrawVertexAt(Vector2D.From(x,y-128))
	p.DrawVertexAt(Vector2D.From(x,y))
	p.FinishPlacingVertices()
	--- mid-line
	p.DrawVertexAt(Vector2D.From(x,y-64))
	p.DrawVertexAt(Vector2D.From(x+64,y-64))
	p.FinishPlacingVertices()
	--- inner-border
	p.DrawVertexAt(Vector2D.From(x+16,y-16))
	p.DrawVertexAt(Vector2D.From(x+48,y-16))
	p.DrawVertexAt(Vector2D.From(x+48,y-112))
	p.DrawVertexAt(Vector2D.From(x+16,y-112))
	p.DrawVertexAt(Vector2D.From(x+16,y-16))
	p.FinishPlacingVertices()
	--- inner-mid-line
	p.DrawVertexAt(Vector2D.From(x+16,y-48))
	p.DrawVertexAt(Vector2D.From(x+48,y-48))
	p.FinishPlacingVertices()
	--- control sector
	p.DrawVertexAt(Vector2D.From(x+48,y-48))
	p.DrawVertexAt(Vector2D.From(x+56,y-56))
	p.DrawVertexAt(Vector2D.From(x+48,y-64))
	p.FinishPlacingVertices()
	-- edit sectors
	local v1 = Vector2D.From(x,y)
	local v2 = Vector2D.From(x+64,y)
	local all_sectors  = Map.GetSectors()
	local all_linedefs = Map.GetLinedefs()
	local s_ind = get_sector_index_from_linedef_coords(all_sectors, all_linedefs, v1, v2)
	local l_ind = get_linedef_index(all_linedefs, v1, v2)
	all_sectors[s_ind].floorheight = ch
	all_sectors[s_ind].ceilheight  = ch
	all_linedefs[l_ind].action = 242
	all_linedefs[l_ind].tag    = tag_offset
	--
	v1 = Vector2D.From(x+48,y-48)
	v2 = Vector2D.From(x+56,y-56)
	s_ind = get_sector_index_from_linedef_coords(all_sectors, all_linedefs, v1, v2)
	all_sectors[s_ind].floorheight = ch
	all_sectors[s_ind].ceilheight  = fh
	--
	v1 = Vector2D.From(x+48,y-16)
	v2 = Vector2D.From(x+48,y-48)
	s_ind = get_sector_index_from_linedef_coords(all_sectors, all_linedefs, v1, v2)
	all_sectors[s_ind].floorheight = fh
	all_sectors[s_ind].ceilheight  = ch
	--
	v1 = Vector2D.From(x+48,y-64)
	v2 = Vector2D.From(x+48,y-112)
	s_ind = get_sector_index_from_linedef_coords(all_sectors, all_linedefs, v1, v2)
	all_sectors[s_ind].floorheight = fh
	all_sectors[s_ind].ceilheight  = ch
	all_sectors[s_ind].tag         = tag_offset
	--
	v1 = Vector2D.From(x+64,y-64)
	v2 = Vector2D.From(x+64,y-128)
	s_ind = get_sector_index_from_linedef_coords(all_sectors, all_linedefs, v1, v2)
	all_sectors[s_ind].floorheight = fh+16
	all_sectors[s_ind].ceilheight  = ch
	--
	v1 = Vector2D.From(x+16,y-48)
	v2 = Vector2D.From(x+48,y-48)
	s_ind = get_sector_index_from_linedef_coords(all_sectors, all_linedefs, v1, v2)
	all_sectors[s_ind].floorheight = ch
	all_sectors[s_ind].ceilheight  = ch
	all_sectors[s_ind].tag         = tag_offset+1
	--- add things
	local newThing1 = Map.InsertThing(x+32, y-32)
	local newThing2 = Map.InsertThing(x+32, y-96)
	if game_type == 'wormwood' then
		newThing1.type  = 70
		newThing2.type  = 84
	elseif game_type == 'jumpwad' then
		newThing1.type  = 70
		newThing2.type  = 41
	end
	newThing1.SetAngleDoom(270)
	newThing2.SetAngleDoom(270)
end

function draw_voodoo(x, y, tag_offset)
	local p = Pen.From(x,y)
	p.snaptogrid  = false
	p.stitchrange = 1
	--- border
	p.DrawVertexAt(Vector2D.From(x,y))
	p.DrawVertexAt(Vector2D.From(x+64,y))
	p.DrawVertexAt(Vector2D.From(x+64,y-112))
	p.DrawVertexAt(Vector2D.From(x+64,y-256))
	p.DrawVertexAt(Vector2D.From(x,y-256))
	p.DrawVertexAt(Vector2D.From(x,y))
	p.FinishPlacingVertices()
	--- lower/raise lines
	p.DrawVertexAt(Vector2D.From(x+48,y-64))
	p.DrawVertexAt(Vector2D.From(x+16,y-64))
	p.FinishPlacingVertices()
	p.DrawVertexAt(Vector2D.From(x+48,y-68))
	p.DrawVertexAt(Vector2D.From(x+16,y-68))
	p.FinishPlacingVertices()
	--- tele line
	p.DrawVertexAt(Vector2D.From(x+48,y-160))
	p.DrawVertexAt(Vector2D.From(x+16,y-160))
	p.FinishPlacingVertices()
	--- apply effects
	local v1 = Vector2D.From(x+64,y)
	local v2 = Vector2D.From(x+64,y-112)
	local all_sectors  = Map.GetSectors()
	local all_linedefs = Map.GetLinedefs()
	local s_ind = get_sector_index_from_linedef_coords(all_sectors, all_linedefs, v1, v2)
	local l_ind = get_linedef_index(all_linedefs, v1, v2)
	all_sectors[s_ind].tag     = tag_offset+2
	all_linedefs[l_ind].action = 253
	all_linedefs[l_ind].tag    = tag_offset+2
	--
	v1 = Vector2D.From(x+48,y-64)
	v2 = Vector2D.From(x+16,y-64)
	l_ind = get_linedef_index(all_linedefs, v1, v2)
	all_linedefs[l_ind].action = 25025
	all_linedefs[l_ind].tag    = tag_offset+1
	--
	v1 = Vector2D.From(x+48,y-68)
	v2 = Vector2D.From(x+16,y-68)
	l_ind = get_linedef_index(all_linedefs, v1, v2)
	all_linedefs[l_ind].action = 24577
	all_linedefs[l_ind].tag    = tag_offset+1
	--
	v1 = Vector2D.From(x+48,y-160)
	v2 = Vector2D.From(x+16,y-160)
	l_ind = get_linedef_index(all_linedefs, v1, v2)
	all_linedefs[l_ind].action = 208
	all_linedefs[l_ind].tag    = tag_offset+2
	--- add things
	local newThing1 = Map.InsertThing(x+32, y-16)
	local newThing2 = Map.InsertThing(x+32, y-48)
	newThing1.type  = 1
	newThing2.type  = 14
	newThing1.SetAngleDoom(270)
	newThing2.SetAngleDoom(270)
end

function draw_scroller(x, y, tag_offset, dist)
	local p = Pen.From(x,y)
	p.snaptogrid  = false
	p.stitchrange = 1
	--- border
	p.DrawVertexAt(Vector2D.From(x,y))
	p.DrawVertexAt(Vector2D.From(x+64,y))
	p.DrawVertexAt(Vector2D.From(x+64,y-dist))
	p.DrawVertexAt(Vector2D.From(x,y))
	p.FinishPlacingVertices()
	--- apply effects
	local v1 = Vector2D.From(x+64,y)
	local v2 = Vector2D.From(x+64,y-dist)
	local all_linedefs = Map.GetLinedefs()
	local l_ind = get_linedef_index(all_linedefs, v1, v2)
	all_linedefs[l_ind].action = 253
	all_linedefs[l_ind].tag    = tag_offset
end

-- by default suggest that we build control sectors at position where the user clicked to start the script
p = Pen.FromClick()
p.snaptogrid = true
default_x = p.position.x
default_y = p.position.y

-- by default suggest that we start at the highest tag + 1
max_tag = 0
sectors = Map.GetSectors()
for i=1, #sectors do
	if sectors[i].tag > max_tag then
		max_tag = sectors[i].tag
	end
end
linedefs = Map.GetLinedefs()
for i=1, #linedefs do
	if linedefs[i].tag > max_tag then
		max_tag = linedefs[i].tag
	end
end

-- get parameters
UI.AddParameter("x_offset",     "where to start drawing (x)", default_x)
UI.AddParameter("y_offset",     "where to start drawing (y)", default_y)
UI.AddParameter("tag_offset",   "starting tag #", tostring(max_tag+1))
UI.AddParameter("floor_height", "floor height to shoot meteors at", 0)
UI.AddParameter("ceil_height",  "ceil height of launcher", 64)
UI.AddParameter("closet_speed", "242-scroller speed for meteors", 768)
UI.AddParameter("closet_type",  "jumpwad/wormwood", "jumpwad")
parameters = UI.AskForParameters()
p0 = tonumber(parameters.x_offset)
p1 = tonumber(parameters.y_offset)
p2 = tonumber(parameters.tag_offset)
p3 = tonumber(parameters.floor_height)
p4 = tonumber(parameters.ceil_height)
p5 = tonumber(parameters.closet_speed)
p6 = tostring(parameters.closet_type)

if p6 ~= "wormwood" and p6 ~= "jumpwad" then
	UI.LogLine("closet type must be jumpwad or wormwood")
else
	-- get drawing!!!
	draw_launcher(p0, p1, p2, p3, p4, p6)
	draw_voodoo(p0+128, p1, p2)
	draw_scroller(p0+256, p1, p2, p5)
end
