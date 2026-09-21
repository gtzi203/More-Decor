
--stairs and slabs register

local S = minetest.get_translator(minetest.get_current_modname())

local function register_stuff(name, description)
    local def = minetest.registered_nodes["more_decor:" .. name]
    local texture = def.tiles
    local groups = def.groups
    local sounds = def.sounds

    if minetest.get_modpath("moreblocks") then
        stairsplus:register_all(
            "more_decor", 
            name,
            "more_decor:" .. name,
            {
                description = description,
                tiles = texture,
                groups = groups,
                sounds = sounds
            }
        )
    elseif minetest.get_modpath("stairs") then
        stairs.register_stair(name, "more_decor:" .. name, groups, texture, description .. " " .. S("Stairs"), sounds, "")
        stairs.register_stair_inner(name, "more_decor:" .. name, groups, texture, "", sounds, "", S("Inner") .. " " .. description .. " " .. S("Stairs"))
        stairs.register_stair_outer(name, "more_decor:" .. name, groups, texture, "", sounds, "", S("Outer") .. " " .. description .. " " .. S("Stairs"))
        stairs.register_slab(name, "more_decor:" .. name, groups, texture, description .. " " .. S("Slab"), sounds, "")
    elseif minetest.get_modpath("mcl_stairs") then
        mcl_stairs.register_stair(
            name, 
            "more_decor:" .. name,
            groups,
            texture,
            description .. " " .. S("Stairs"),
            sounds,
            nil,
            nil
        )
        mcl_stairs.register_slab(
            name, 
            "more_decor:" .. name,
            groups,
            texture,
            description .. " " .. S("Slab"),
            sounds,
            nil,
            nil
        )
    end
end

--cast iron

register_stuff("cast_iron_block", S("Cast Iron"))

--bricks

for name, def in pairs(more_decor.bricks) do
    for type, type_def in pairs(more_decor.brick_types) do
        register_stuff(type .. "_" .. name .. "_bricks", type_def.description .. " " .. def.description.node)
    end
end

--lamps

register_stuff("industrial_lamp_on", S("Industrial Lamp"))
register_stuff("tiled_industrial_lamp_on", S("Tiled Industrial Lamp"))