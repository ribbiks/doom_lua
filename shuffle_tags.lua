
lines    = Map.GetSelectedLinedefs()
sectors  = Map.GetSelectedSectors()
all_tags = {}

function spairs(t, order)
	local keys = {}
	for k in pairs(t) do keys[#keys+1] = k end
	if order then
		table.sort(keys, function(a,b) return order(t, a, b) end)
	else
		table.sort(keys)
	end
	local i = 0
	return function()
		i = i + 1
		if keys[i] then
			return keys[i], t[keys[i]]
		end
	end
end

for i=1,#lines do
	my_tag = lines[i].tag
	if my_tag > 0 and all_tags[my_tag] == nil then
		all_tags[my_tag] = my_tag
	end
end
for i=1,#sectors do
	my_tag = sectors[i].tag
	if my_tag > 0 and all_tags[my_tag] == nil then
		all_tags[my_tag] = my_tag
	end
end

UI.AddParameter("rng", "rng seed", 123)
UI.AddParameter("offset", "offset", 0)
parameters = UI.AskForParameters()

offset = tonumber(parameters.offset)

math.randomseed(tonumber(parameters.rng))

shuffled = {}
skeys    = {}
for i, v in spairs(all_tags) do
	table.insert(shuffled, math.random(1, #shuffled+1), v)
	skeys[#skeys+1] = v
end
for i=1,#skeys do
	all_tags[skeys[i]] = shuffled[i] + offset
end
for i, v in spairs(all_tags) do
	UI.LogLine(tostring(i) .. " --> " .. tostring(v))
end

for i=1,#lines do
	if lines[i].tag > 0 then
		lines[i].tag = all_tags[lines[i].tag]
	end
end
for i=1,#sectors do
	if sectors[i].tag > 0 then
		sectors[i].tag = all_tags[sectors[i].tag]
	end
end
