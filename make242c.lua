
-- returns index of linedef with specified vertex coordinates
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
	return mySector.GetIndex()+1 -- +1 because sector indices are 0-indexed
end

SQ_SIZE = 16
SQ_COLS = 32
BUFF    = 2*SQ_SIZE
function draw_square(x ,y, s_floor, s_ceil, s_tag, c_lower, c_middle, c_upper)
	local p = Pen.From(x,y)
	p.snaptogrid  = false
	p.stitchrange = 1
	p.DrawVertexAt(Vector2D.From(x,y))
	p.DrawVertexAt(Vector2D.From(x+SQ_SIZE,y))
	p.DrawVertexAt(Vector2D.From(x+SQ_SIZE,y-SQ_SIZE))
	p.DrawVertexAt(Vector2D.From(x,y-SQ_SIZE))
	p.DrawVertexAt(Vector2D.From(x,y))
	p.FinishPlacingVertices()
	--
	local v1 = Vector2D.From(x, y)
	local v2 = Vector2D.From(x+SQ_SIZE, y)
	local allSectors  = Map.GetSectors()
	local allLinedefs = Map.GetLinedefs()
	local sInd = get_sector_index_from_linedef_coords(allSectors, allLinedefs, v1, v2)
	local lInd = get_linedef_index(allLinedefs, v1, v2)
	allSectors[sInd].floorheight = s_floor
	allSectors[sInd].ceilheight  = s_ceil
	allLinedefs[lInd].action     = 242
	allLinedefs[lInd].GetFront().midtex = c_middle
	allLinedefs[lInd].tag = s_tag
end

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

-- by default suggest that we build control sectors at position where the user clicked to start the script
p = Pen.FromClick()
p.snaptogrid = true
default_x = p.position.x
default_y = p.position.y

-- get parameters
UI.AddParameter("x_offset",    "where to build control sectors (x)", default_x)
UI.AddParameter("y_offset",    "where to build control sectors (y)", default_y)
UI.AddParameter("tag_offset",  "starting tag #", tostring(max_tag+1))
UI.AddParameter("fake_floor",  "fake floor height", "-")
UI.AddParameter("fake_ceil",   "fake ceiling height", "-")
UI.AddParameter("cmap_lower",  "colormap to apply (lower)", "-")
UI.AddParameter("cmap_middle", "colormap to apply (middle)", "-")
UI.AddParameter("cmap_upper",  "colormap to apply (upper)", "-")
parameters = UI.AskForParameters()
p0 = tonumber(parameters.x_offset)
p1 = tonumber(parameters.y_offset)
p2 = tonumber(parameters.tag_offset)
c0 = tostring(parameters.cmap_lower)
c1 = tostring(parameters.cmap_middle)
c2 = tostring(parameters.cmap_upper)
f0 = tostring(parameters.fake_floor)
f1 = tostring(parameters.fake_ceil)
if f0 ~= "-" then f0 = tonumber(f0) end
if f1 ~= "-" then f1 = tonumber(f1) end

-- get info we need from selected sectors
sectors = Map.GetSelectedSectors()
fh_list = {}
ch_list = {}
tg_list = {}
current_tag = p2
for i=1, #sectors do
	fh_list[i] = sectors[i].floorheight
	ch_list[i] = sectors[i].ceilheight
	tg_list[i] = current_tag
	sectors[i].tag = current_tag
	current_tag = current_tag + 1
	-- change to fake floor/ceil, if specified
	if f0 ~= "-" then sectors[i].floorheight = f0 end
	if f1 ~= "-" then sectors[i].ceilheight = f1 end
end

-- draw the rest of the owl
for i=1, #fh_list do
	draw_square( BUFF*((i-1)%SQ_COLS)+p0, -BUFF*math.floor((i-1)/SQ_COLS)+p1, fh_list[i], ch_list[i], tg_list[i], c0, c1, c2 )
end
