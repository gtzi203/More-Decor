
--init

more_decor = {}

more_decor.groups = {}
more_decor.sounds = {}

if minetest.get_modpath("default") then
    more_decor.item_names = {
        ["steel_ingot"] = "default:steel_ingot",
        ["tin_ingot"] = "default:tin_ingot",
        ["cast_iron_ingot"] = "more_decor:cast_iron_ingot",
        ["copper_ingot"] = "default:copper_ingot",
        ["bronze_ingot"] = "default:bronze_ingot",
        ["gold_ingot"] = "default:gold_ingot",

        ["white_dye"] = "dye:white",
        ["grey_dye"] = "dye:grey",
        ["dark_grey_dye"] = "dye:dark_grey",
        ["black_dye"] = "dye:black",
        ["violet_dye"] = "dye:violet",
        ["blue_dye"] = "dye:blue",
        ["cyan_dye"] = "dye:cyan",
        ["dark_green_dye"] = "dye:dark_green",
        ["green_dye"] = "dye:green",
        ["yellow_dye"] = "dye:yellow",
        ["brown_dye"] = "dye:brown",
        ["orange_dye"] = "dye:orange",
        ["red_dye"] = "dye:red",
        ["magenta_dye"] = "dye:magenta",
        ["pink_dye"] = "dye:pink",

        ["wood"] = "default:wood",
        ["stick"] = "default:stick",
        ["torch"] = "default:torch",

        ["brick"] = "default:clay_brick",
        ["glass"] = "default:glass",
        ["obsidian_glass"] = "default:obsidian_glass",
        ["white_wool"] = "wool:white"
    }

    more_decor.groups = {
        ["wood"] = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
        ["metal"] = {cracky = 1, level = 2, metal = 1},
        ["glass"] = {cracky = 3, oddly_breakable_by_hand = 3, glass = 1},
        ["brick"] = {cracky = 3, stone = 1},

        ["press"] = {cracky = 1, level = 2, not_in_creative_inventory = 1},
        ["glass2"] = {cracky = 3, oddly_breakable_by_hand = 3, not_in_creative_inventory = 1, glass = 1}
    }

    more_decor.sounds = {
        ["wood"] = default.node_sound_wood_defaults(),
        ["stone"] = default.node_sound_stone_defaults(),
        ["metal"] = default.node_sound_metal_defaults(),
        ["glass"] = default.node_sound_glass_defaults()
    }
elseif minetest.get_modpath("mcl_core") then
    more_decor.item_names = {
        --some of the items in this list do not exist in mineclone (voxelibre and mineclonia)
        ["steel_ingot"] = "mcl_core:iron_ingot",
        ["tin_ingot"] = "mcl_core:tin_ingot",
        ["cast_iron_ingot"] = "more_decor:cast_iron_ingot",
        ["copper_ingot"] = "mcl_core:copper_ingot",
        ["bronze_ingot"] = "mcl_core:bronze_ingot",
        ["gold_ingot"] = "mcl_core:gold_ingot",

        ["white_dye"] = "mcl_dye:white",
        ["grey_dye"] = "mcl_dye:grey",
        ["dark_grey_dye"] = "mcl_dye:dark_grey",
        ["black_dye"] = "mcl_dye:black",
        ["violet_dye"] = "mcl_dye:violet",
        ["blue_dye"] = "mcl_dye:blue",
        ["cyan_dye"] = "mcl_dye:cyan",
        ["dark_green_dye"] = "mcl_dye:dark_green",
        ["green_dye"] = "mcl_dye:green",
        ["yellow_dye"] = "mcl_dye:yellow",
        ["brown_dye"] = "mcl_dye:brown",
        ["orange_dye"] = "mcl_dye:orange",
        ["red_dye"] = "mcl_dye:red",
        ["magenta_dye"] = "mcl_dye:magenta",
        ["pink_dye"] = "mcl_dye:pink",

        ["wood"] = "mcl_core:wood",
        ["stick"] = "mcl_core:stick",
        ["torch"] = "mcl_torches:torch",

        ["brick"] = "mcl_core:brick",
        ["glass"] = "mcl_core:glass",
        ["obsidian_glass"] = "mcl_core:obsidian_glass",
        ["white_wool"] = "mcl_wool:white"
    }

    more_decor.groups = {
        ["wood"] = {handy = 1, axey = 1, flammable = 3, wood = 1, building_block = 1, fire_encouragement = 5, fire_flammability = 20},
        ["metal"] = {pickaxey = 2, building_block = 1, metal = 1},
        ["glass"] = {handy = 1, glass = 1, building_block = 1, material_glass = 1},
        ["brick"] = {pickaxey = 1, building_block = 1, material_stone = 1},

        ["press"] = {pickaxey = 2, not_in_creative_inventory = 1},
        ["glass2"] = {handy = 1, glass = 1, building_block = 1, material_glass = 1, not_in_creative_inventory = 1}
    }

    more_decor.sounds = {
        ["wood"] = mcl_sounds.node_sound_wood_defaults(),
        ["stone"] = mcl_sounds.node_sound_stone_defaults(),
        ["metal"] = mcl_sounds.node_sound_metal_defaults(),
        ["glass"] = mcl_sounds.node_sound_glass_defaults()
    }
end

--helper functions

function more_decor.round(n, d)
    local mult = 10 ^ (d or 0)
    
    return math.floor(n * mult + 0.5) / mult
end

function more_decor.add_item_to_player(player, itemstack)
    local inv = player:get_inventory()

    if inv:room_for_item("main", itemstack) then
        inv:add_item("main", itemstack)

        return true
    else
        minetest.add_item(player:get_pos(), itemstack)

        return false
    end
end

local modpath = minetest.get_modpath(minetest.get_current_modname())

dofile(modpath .. "/api.lua")
dofile(modpath .. "/nodes.lua")
dofile(modpath .. "/items.lua")
dofile(modpath .. "/stairs_and_slabs_register.lua")
dofile(modpath .. "/crafting.lua")
