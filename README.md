# doom_lua
A collection of scripts for Doom Builder X or the lua fork of Ultimate Doom Builder

### bevel.lua

* Adds bevels to the intersection of all selected linedefs.
* I've mostly tested this on 1S linedefs drawn in the void, I can't vouch for it behaving well with more complicated selections.

### circularizer.lua

* Transform a map from a rectangle into a ring.
* Originally described [here](https://rbkz.blogspot.com/2020/05/circularizer-lua.html).

### join_identical_sectors.lua

* Join (or merge) all selected sectors that have the same floor, ceiling, brightness, tag, effect, floortex, and ceiltex.

### make242c.lua

* Apply fake floor, ceiling, and colormap effects to all selected sectors.
* [Example usage](https://youtu.be/Vpt8MCL1u7U)
