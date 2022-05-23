# doom_lua
A collection of scripts for Doom Builder X or the lua fork of Ultimate Doom Builder

### bevel.lua

* Adds bevels to the intersection of all selected linedefs.
* I've mostly tested this on 1S linedefs drawn in the void, I can't vouch for it behaving well with more complicated selections.

### bezier.lua

* Draws a bezier curve through selected vertices.

### circularizer.lua

* Transform a map from a rectangle into a ring.
* Originally described [here](https://rbkz.blogspot.com/2020/05/circularizer-lua.html).

### flank.lua

* Adds border linedefs to the interior of all selected linedefs.
* Useful for adding vertical border/support textures to oddly-rotated geometry

### floodfill_things_random.lua

* Randomly scatters things in selected sectors.
* Based on anotak's "sector_fill_things" script.

### join_identical_sectors.lua

* Join (or merge) all selected sectors that have the same floor, ceiling, brightness, tag, effect, floortex, and ceiltex.

### make242c.lua

* Apply fake floor, ceiling, and colormap effects to all selected sectors.
* [Example usage](https://youtu.be/Vpt8MCL1u7U)

### meteor_prefab.lua

* Draws meteor launching machinery as used in wormwood3.wad and jumpwad.wad

### print_used_tag_ranges.lua

* Prints a concise list of all the tags used in the selected linedefs/sectors.

### select_overlapping_monsters.lua

* Selects monsters that are stuck on each other (overlapping bounding box and same difficulty)

### spline.lua

* Interpolates a cubic spline through selected vertices.

### squarifier.lua

* "Squarifies" all selected linedefs.

### randomly_select_things.lua

* Randomly selects a specified fraction of selected things.
