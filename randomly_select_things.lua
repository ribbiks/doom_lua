-- randomly select a fraction of the specified things on a map
--
-- this is pretty niche, I just made this for managing jumpwad snow

things = Map.GetSelectedThings()
if #things < 1 then
	UI.LogLine("Must select at least 1 thing!")
end

UI.AddParameter("thing_id", "thing id", 3004)
UI.AddParameter("select_fraction", "selection fraction", 0.5)
UI.AddParameter("rng", "rng seed", 123)
parameters = UI.AskForParameters()

tid = tonumber(parameters.thing_id)
frac = tonumber(parameters.select_fraction)

math.randomseed(tonumber(parameters.rng))

-- deselect everything
for i=1, #things do
	things[i].selected = false
end

-- re-select a fraction of them
for i=1, #things do
	r = math.random()
	if things[i].type == tid and r <= frac then
		things[i].selected = true
	end
end
