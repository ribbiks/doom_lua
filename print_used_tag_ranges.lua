
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

lines    = Map.GetSelectedLinedefs()
sectors  = Map.GetSelectedSectors()
all_tags = {}
max_tag  = 0

for i=1,#lines do
	if lines[i].tag > 0 then
		all_tags[lines[i].tag] = 1
	end
	if lines[i].tag > max_tag then
		max_tag = lines[i].tag
	end
end
for i=1,#sectors do
	if sectors[i].tag > 0 then
		all_tags[sectors[i].tag] = 1
	end
	if sectors[i].tag > max_tag then
		max_tag = sectors[i].tag
	end
end

ranges_out = {}
prev_is_in = 0
prev_start = 0
for i=1,max_tag do
	if all_tags[i] ~= nil then
		current_is_in = 1
	else
		current_is_in = 0
	end
	if prev_is_in == 0 and current_is_in == 1 then
		prev_start = i
	elseif prev_is_in == 1 and current_is_in == 0 then
		ranges_out[#ranges_out+1] = {prev_start,i-1}
	elseif i == max_tag then
		ranges_out[#ranges_out+1] = {prev_start,i}
	end
	prev_is_in = current_is_in
end

for i=1,#ranges_out do
	UI.LogLine(tostring(ranges_out[i][1]) .. " - " .. tostring(ranges_out[i][2]))
end
