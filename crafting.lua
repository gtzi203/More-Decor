
--crafting

--cast iron

minetest.register_craft({
    type = "cooking",
    output = "more_decor:cast_iron_ingot 1",
    recipe = more_decor.item_names["steel_ingot"],
    cooktime = 7.5,
})

minetest.register_craft({
    output = "more_decor:cast_iron_block 1",
    recipe = {
        {"more_decor:cast_iron_ingot", "more_decor:cast_iron_ingot", "more_decor:cast_iron_ingot"},
        {"more_decor:cast_iron_ingot", "more_decor:cast_iron_ingot", "more_decor:cast_iron_ingot"},
        {"more_decor:cast_iron_ingot", "more_decor:cast_iron_ingot", "more_decor:cast_iron_ingot"}
    }
})

--bricks

--items
for name, def in pairs(more_decor.bricks) do
    for name2, def2 in pairs(more_decor.bricks) do
        local brick

        if name2 == name then
            brick = more_decor.item_names["brick"]
        else
            brick = "more_decor:" .. name2 .. "_brick"
        end

        minetest.register_craft({
            type = "shapeless",
            output = "more_decor:" .. name .. "_brick 1",
            recipe = {
                brick, more_decor.item_names[name .. "_dye"]
            }
        })
    end
end

--nodes
for name, def in pairs(more_decor.bricks) do
    for type, type_def in pairs(more_decor.brick_types) do
        if type == "medium" then
            local brick = "more_decor:" .. name .. "_brick"

            minetest.register_craft({
                output = "more_decor:" .. type .. "_" .. name .. "_bricks 1",
                recipe = {
                    {brick, brick, ""},
                    {brick, brick, ""},
                    {"", "", ""}
                }
            })
        end
    end
end

local brick_types_sorted = {
    [1] = "tiled",
    [2] = "tiny",
    [3] = "small",
    [4] = "medium",
    [5] = "long"
}

for name, def in pairs(more_decor.bricks) do
    for type, _ in pairs(more_decor.brick_types) do
        local output = {}
        local count = 1

            for _, type2 in pairs(brick_types_sorted) do
                if type ~= type2 then
                    output[count] = "more_decor:" .. type2 .. "_" .. name .. "_bricks"

                    count = count + 1
                end
            end

        more_decor.register_craft("more_decor:" .. type .. "_" .. name .. "_bricks", {
            type = "workbench",
            workbench = "more_decor:chisel_bench",
            output = output
        })
    end
end

--chisel bench

minetest.register_craft({
    output = "more_decor:chisel_bench 1",
    recipe = {
        {"group:wood", more_decor.item_names["steel_ingot"], "group:wood"},
        {more_decor.item_names["stick"], "", more_decor.item_names["stick"]},
        {more_decor.item_names["stick"], "", more_decor.item_names["stick"]}
    }
})

--glass workbench

minetest.register_craft({
    output = "more_decor:glass_workbench 1",
    recipe = {
        {"group:wood", "more_decor:cast_iron_ingot", "group:wood"},
        {more_decor.item_names["stick"], "", more_decor.item_names["stick"]},
        {more_decor.item_names["stick"], "", more_decor.item_names["stick"]}
    }
})

--signs workbench

minetest.register_craft({
    output = "more_decor:signs_workbench 1",
    recipe = {
        {"group:wood", more_decor.item_names["white_wool"], "group:wood"},
        {more_decor.item_names["stick"], "", more_decor.item_names["stick"]},
        {more_decor.item_names["stick"], "", more_decor.item_names["stick"]}
    }
})

--press

minetest.register_craft({
    output = "more_decor:press_inv 1",
    recipe = {
        {more_decor.item_names["stick"], more_decor.item_names["steel_ingot"], more_decor.item_names["stick"]},
        {more_decor.item_names["stick"], more_decor.item_names["steel_ingot"], more_decor.item_names["stick"]},
        {"group:wood", "group:wood", "group:wood"}
    }
})

local press_items = {
    [more_decor.item_names["wood"]] = {time = 1, output = {name = "more_decor:wood_sheet", count = 4}},
    [more_decor.item_names["steel_ingot"]] = {time = 1.5, output = {name = "more_decor:steel_sheet"}},
    [more_decor.item_names["tin_ingot"]] = {time = 1.5, output = {name = "more_decor:tin_sheet"}},
    ["more_decor:cast_iron_ingot"] = {time = 2, output = {name = "more_decor:cast_iron_sheet"}},
    [more_decor.item_names["copper_ingot"]] = {time = 1, output = {name = "more_decor:copper_sheet"}},
    [more_decor.item_names["bronze_ingot"]] = {time = 1.5, output = {name = "more_decor:bronze_sheet"}},
    [more_decor.item_names["gold_ingot"]] = {time = 1, output = {name = "more_decor:gold_sheet"}}
}

for name, def in pairs(press_items) do
    more_decor.register_craft(name, {
        type = "press",
        press = "more_decor:press",
        output = def.output,
        time = def.time
    })
end

--signs

for type, type_def in pairs(more_decor.sign_types) do
    for size, size_def in pairs(more_decor.sign_sizes) do
        local sheet = "more_decor:" .. type .. "_sheet"

        if size == "small" then
            minetest.register_craft({
                output = "more_decor:" .. size .. "_empty_sign_" .. type .. " 3",
                recipe = {
                    {sheet, sheet, ""},
                    {sheet, sheet, ""},
                    {"", "", ""}
                }
            })
        elseif size == "large" then
            minetest.register_craft({
                output = "more_decor:" .. size .. "_empty_sign_" .. type .. " 3",
                recipe = {
                    {sheet, sheet, sheet},
                    {sheet, sheet, sheet},
                    {sheet, sheet, sheet}
                }
            })
        end
    end
end

for type, type_def in pairs(more_decor.sign_types) do
    for size, size_def in pairs(more_decor.sign_sizes) do
        for color, names in pairs(more_decor.sign_colors) do
            local output = {}
            local count = 1

            for name, _ in pairs(names) do
                output[count] = "more_decor:" .. size .. "_" .. name .. "_sign_" .. type

                count = count + 1
            end

            more_decor.register_craft("more_decor:" .. size .. "_empty_sign_" .. type, {
                type = "workbench",
                workbench = "more_decor:signs_workbench",
                extra_input = more_decor.item_names[color .. "_dye"],
                output = output
            })
        end
    end
end

--glass nodes/panes

--nodes

local normal_glass_nodes = {
    [1] = more_decor.item_names["glass"],
    [2] = "more_decor:clear_glass", 
    [3] = "more_decor:tiled_glass", 
    [4] = "more_decor:horizontal_glass", 
    [5] = "more_decor:vertical_glass"
}

for index, name in pairs(normal_glass_nodes) do
    local output = {}
    local count = 1

    for _, name2 in pairs(normal_glass_nodes) do
        if name ~= name2 then
            output[count] = name2

            count = count + 1
        end
    end

    more_decor.register_craft(name, {
        type = "workbench",
        workbench = "more_decor:glass_workbench",
        output = output
    })
end

local normal_obsidian_glass_nodes = {
    [1] = more_decor.item_names["obsidian_glass"], 
    [3] = "more_decor:tiled_obsidian_glass", 
    [4] = "more_decor:horizontal_obsidian_glass", 
    [5] = "more_decor:vertical_obsidian_glass"
}

for index, name in pairs(normal_obsidian_glass_nodes) do
    local output = {}
    local count = 1

    for _, name2 in pairs(normal_obsidian_glass_nodes) do
        if name ~= name2 then
            output[count] = name2

            count = count + 1
        end
    end

    more_decor.register_craft(name, {
        type = "workbench",
        workbench = "more_decor:glass_workbench",
        output = output
    })
end

local other_glass_nodes = {
    [more_decor.item_names["steel_ingot"]] = {[1] = "more_decor:factory_glass", [2] = "more_decor:old_factory_glass"},
    ["more_decor:cast_iron_ingot"] = {[1] = "more_decor:industrial_glass"}
}

for extra_material, output in pairs(other_glass_nodes) do
    for index, name2 in pairs(normal_glass_nodes) do
        more_decor.register_craft(name2, {
            type = "workbench",
            workbench = "more_decor:glass_workbench",
            extra_input = extra_material,
            output = output
        })
    end
end

--panes

for name, def in pairs(more_decor.glass_panes) do
    local glass_node = "more_decor:" .. name .. "_glass"

     minetest.register_craft({
        output = "more_decor:" .. name .. "_glass_pane 16",
        recipe = {
            {glass_node, glass_node, glass_node},
            {glass_node, glass_node, glass_node},
            {"", "", ""}
        }
    })
end

--lamps

--industrial

minetest.register_craft({
    output = "more_decor:industrial_lamp_on 2",
    recipe = {
        {"", "more_decor:cast_iron_sheet", ""},
        {"", more_decor.item_names["torch"], ""},
        {"", "more_decor:cast_iron_sheet", ""}
    }
})

minetest.register_craft({
    output = "more_decor:tiled_industrial_lamp_on 2",
    recipe = {
        {"", "more_decor:cast_iron_sheet", ""},
        {"more_decor:cast_iron_sheet", more_decor.item_names["torch"], "more_decor:cast_iron_sheet"},
        {"", "more_decor:cast_iron_sheet", ""}
    }
})

--factory

minetest.register_craft({
    output = "more_decor:small_factory_lamp_on 9",
    recipe = {
        {"", "", ""},
        {"more_decor:industrial_lamp_on", "more_decor:industrial_lamp_on", "more_decor:industrial_lamp_on"},
        {"", "", ""}
    }
})

minetest.register_craft({
    output = "more_decor:medium_factory_lamp_on 1",
    recipe = {
        {"", "", ""},
        {"more_decor:small_factory_lamp_on", "more_decor:small_factory_lamp_on", ""},
        {"", "", ""}
    }
})

minetest.register_craft({
    output = "more_decor:large_factory_lamp_on 1",
    recipe = {
        {"", "", ""},
        {"more_decor:small_factory_lamp_on", "more_decor:small_factory_lamp_on", "more_decor:small_factory_lamp_on"},
        {"", "", ""}
    }
})

minetest.register_craft({
    type = "shapeless",
    output = "more_decor:small_factory_lamp_on 1",
    recipe = {
        "more_decor:small_old_factory_lamp_on"
    }
})

minetest.register_craft({
    type = "shapeless",
    output = "more_decor:medium_factory_lamp_on 1",
    recipe = {
        "more_decor:medium_old_factory_lamp_on"
    }
})

minetest.register_craft({
    type = "shapeless",
    output = "more_decor:large_factory_lamp_on 1",
    recipe = {
        "more_decor:large_old_factory_lamp_on"
    }
})

minetest.register_craft({
    type = "shapeless",
    output = "more_decor:small_old_factory_lamp_on 1",
    recipe = {
        "more_decor:small_factory_lamp_on"
    }
})

minetest.register_craft({
    type = "shapeless",
    output = "more_decor:medium_old_factory_lamp_on 1",
    recipe = {
        "more_decor:medium_factory_lamp_on"
    }
})

minetest.register_craft({
    type = "shapeless",
    output = "more_decor:large_old_factory_lamp_on 1",
    recipe = {
        "more_decor:large_factory_lamp_on"
    }
})

--encased

for name, def in pairs(more_decor.encased_lapms) do
    if name == "white" then
        minetest.register_craft({
            output = "more_decor:" .. name .. "_encased_lamp_on 2",
            recipe = {
                {"", "", ""},
                {"", more_decor.item_names["torch"], ""},
                {"", "more_decor:cast_iron_sheet", ""}
            }
        })
    else
        minetest.register_craft({
            type = "shapeless",
            output = "more_decor:" .. name .. "_encased_lamp_on 1",
            recipe = {
                "more_decor:white_encased_lamp_on", more_decor.item_names[name .. "_dye"],
            }
        })
    end
end

--pans

for name, def in pairs(more_decor.pans) do
    local sheet = "more_decor:" .. name .. "_sheet"
    local ingot = more_decor.item_names[name .. "_ingot"]

    minetest.register_craft({
        output = "more_decor:" .. name .. "_pan 1",
        recipe = {
            {"", "", ""},
            {sheet, "", ingot},
            {"", sheet, ""}
        }
    })
end
