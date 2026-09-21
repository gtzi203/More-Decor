
--nodes

local S = minetest.get_translator(minetest.get_current_modname())

--cast iron

minetest.register_node("more_decor:cast_iron_block", {
    description = S("Cast Iron Block"),
    tiles = {"more_decor_cast_iron_block.png"},
    groups = more_decor.groups["metal"],
    sounds = more_decor.sounds["metal"]
})

--chisel bench

more_decor.register_workbench("chisel_bench", {
    description = S("Chisel Bench"),
    texture = "more_decor_chisel_bench.png",
    mesh = "more_decor_chisel_bench.obj",
    formspec = {
        description = "",
        input1_description = S("Bricks"),
        button_texture = "more_decor_chisel_icon.png"
    }
})

--glass workbench

more_decor.register_workbench("glass_workbench", {
    description = S("Glass Workbench"),
    texture = "more_decor_glass_workbench.png",
    mesh = "more_decor_glass_workbench.obj",
    formspec = {
        description = "",
        input1_description = S("Glass"),
        input2_description = S("Extra Material"),
        button_texture = "more_decor_hammer_icon.png"
    }
})

--signs workbench

more_decor.register_workbench("signs_workbench", {
    description = S("Signs Workbench"),
    texture = "more_decor_signs_workbench.png",
    mesh = "more_decor_signs_workbench.obj",
    formspec = {
        description = "",
        input1_description = S("Sign"),
        input2_description = S("Dye"),
        button_texture = "more_decor_stamp_icon.png"
    }
})

--press

more_decor.register_press("press", {
    description = S("Press"),
    texture = "more_decor_press.png",
    mesh = "more_decor_press.obj"
})

--bricks

more_decor.register_bricks("white", {description = {node = S("White Bricks"), item = S("White Brick")}, color = {inner = "#e3e2e2", outer = "#8f8383"}, dye = "white"})
more_decor.register_bricks("black", {description = {node = S("Black Bricks"), item = S("Black Brick")}, color = {inner = "#4a4747", outer = "#848484"}, dye = "black"})
more_decor.register_bricks("orange", {description = {node = S("Orange Bricks"), item = S("Orange Brick")}, color = {inner = "#aa7545", outer = "#a1a1a1"}, dye = "orange"})
more_decor.register_bricks("brown", {description = {node = S("Brown Bricks"), item = S("Brown Brick")}, color = {inner = "#734739", outer = "#9b9b9b"}, dye = "brown"})
more_decor.register_bricks("red", {description = {node = S("Red Bricks"), item = S("Red Brick")}, color = {inner = "#871e1e", outer = "#b1b1b1"}, dye = "red"})
more_decor.register_bricks("dark_green", {description = {node = S("Dark Green Bricks"), item = S("Dark Green Brick")}, color = {inner = "#425627", outer = "#a2a2a2"}, dye = "dark_green"})
more_decor.register_bricks("blue", {description = {node = S("Blue Bricks"), item = S("Blue Brick")}, color = {inner = "#5c6574", outer = "#a2a2a2"}, dye = "blue"})

--signs

more_decor.register_sign("empty", {description = S("Empty Sign")})
more_decor.register_sign("warn", {description = S("Warn Sign"), dye = "yellow"})
more_decor.register_sign("do_not_enter", {description = S("Do not Enter Sign"), dye = "red"})
more_decor.register_sign("electricity", {description = S("Electricity Sign"), dye = "yellow"})
more_decor.register_sign("danger_to_life", {description = S("Danger of Life Sign"), dye = "white"})
more_decor.register_sign("arrow_up", {description = S("Arrow Up Sign"), dye = "white"})
more_decor.register_sign("arrow_down", {description = S("Arrow Down Sign"), dye = "white"})
more_decor.register_sign("arrow_right", {description = S("Arrow Right Sign"), dye = "white"})
more_decor.register_sign("arrow_left", {description = S("Arrow Left Sign"), dye = "white"})

--glass

--nodes

more_decor.register_glass("clear", {description = S("Clear Glass")})
more_decor.register_glass("tiled", {description = S("Tiled Glass")})
more_decor.register_glass("horizontal", {description = S("Horizontal Glass")})
more_decor.register_glass("vertical", {description = S("Vertical Glass")})

more_decor.register_glass("tiled_obsidian", {description = S("Tiled Obsidian Glass")})
more_decor.register_glass("horizontal_obsidian", {description = S("Horizontal Obsidian Glass")})
more_decor.register_glass("vertical_obsidian", {description = S("Vertical Obsidian Glass")})

more_decor.register_glass("factory", {description = S("Factory Glass")})
more_decor.register_glass("old_factory", {description = S("Old Factory Glass") .. "\n" ..  S("Note: Preview does not look like the actual node."), texture_alpha = "blend"})
more_decor.register_glass("industrial", {description = S("Industrial Glass"), connects = true})

--panes

more_decor.register_glass_pane("clear", {description = S("Clear Glass Pane")})
more_decor.register_glass_pane("tiled", {description = S("Tiled Glass Pane"), pane_top_texture = "clear"})
more_decor.register_glass_pane("horizontal", {description = S("Horizontal Glass Pane"), pane_top_texture = "clear"})
more_decor.register_glass_pane("vertical", {description = S("Vertical Glass Pane"), pane_top_texture = "clear"})

more_decor.register_glass_pane("tiled_obsidian", {description = S("Tiled Obsidian Glass Pane")})
more_decor.register_glass_pane("horizontal_obsidian", {description = S("Horizontal Obsidian Glass Pane"), pane_top_texture = "tiled_obsidian"})
more_decor.register_glass_pane("vertical_obsidian", {description = S("Vertical Obsidian Glass Pane"), pane_top_texture = "tiled_obsidian"})

more_decor.register_glass_pane("factory", {description = S("Factory Glass Pane"), pane_top_texture = "industrial"})
more_decor.register_glass_pane("old_factory", {description = S("Old Factory Glass Pane") .. "\n" ..  S("Note: Preview does not look like the actual node."), texture_alpha = "blend"})
more_decor.register_glass_pane("industrial", {description = S("Industrial Glass Pane"), connects = true})

--lamps

more_decor.register_lamp("industrial", {description = S("Industrial Lamp"), texture = "more_decor_industrial_lamp.png", drawtype = "normal", node_box = {{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}}, light_source = 14})
more_decor.register_lamp("tiled_industrial", {description = S("Tiled Industrial Lamp"), texture = "more_decor_tiled_industrial_lamp.png", drawtype = "normal", node_box = {{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}}, light_source = 14})

more_decor.register_lamp("small_factory", {description = S("Small Factory Lamp"), texture = "more_decor_small_factory_lamp.png", drawtype = "mesh", mesh = "more_decor_small_factory_lamp.obj", node_box = {{-0.4375, 0.4375, -0.1875, 0.4375, 0.5000, 0.1875}}, light_source = 14, sound = {name = "more_decor_light_humm_v2", length = 1}})
more_decor.register_lamp("medium_factory", {description = S("Medium Factory Lamp"), texture = "more_decor_medium_factory_lamp.png", drawtype = "mesh", mesh = "more_decor_medium_factory_lamp.obj", node_box = {{-1.438, 0.4375, -0.1875, 1.438, 0.5000, 0.1875}}, light_source = 14, sound = {name = "more_decor_light_humm_v2", length = 1}})
more_decor.register_lamp("large_factory", {description = S("Large Factory Lamp"), texture = "more_decor_large_factory_lamp.png", drawtype = "mesh", mesh = "more_decor_large_factory_lamp.obj", node_box = {{-2.438, 0.4375, -0.1875, 2.438, 0.5000, 0.1875}}, light_source = 14, sound = {name = "more_decor_light_humm_v2", length = 1}})
more_decor.register_lamp("small_old_factory", {description = S("Small Old Factory Lamp"), texture = "more_decor_small_old_factory_lamp.png", drawtype = "mesh", mesh = "more_decor_small_factory_lamp.obj", node_box = {{-0.4375, 0.4375, -0.1875, 0.4375, 0.5000, 0.1875}}, light_source = 9, sound = {name = "more_decor_light_humm_v2", length = 1}, flicker = {time_min = 17.0, time_max = 40.0}})
more_decor.register_lamp("medium_old_factory", {description = S("Medium Old Factory Lamp"), texture = "more_decor_medium_old_factory_lamp.png", drawtype = "mesh", mesh = "more_decor_medium_factory_lamp.obj", node_box = {{-1.438, 0.4375, -0.1875, 1.438, 0.5000, 0.1875}}, light_source = 9, sound = {name = "more_decor_light_humm_v2", length = 1}, flicker = {time_min = 17.0, time_max = 40.0}})
more_decor.register_lamp("large_old_factory", {description = S("Large Old Factory Lamp"), texture = "more_decor_large_old_factory_lamp.png", drawtype = "mesh", mesh = "more_decor_large_factory_lamp.obj", node_box = {{-2.438, 0.4375, -0.1875, 2.438, 0.5000, 0.1875}}, light_source = 9, sound = {name = "more_decor_light_humm_v2", length = 1}, flicker = {time_min = 17.0, time_max = 40.0}})

more_decor.encased_lapms = {
    ["white"] = {description = S("White Encased Lamp"), color = "#eeeeee"},
    ["grey"] = {description = S("Grey Encased Lamp"), color = "#9c9c9c"},
    ["dark_grey"] = {description = S("Dark Gray Encased Lamp"), color = "#494949"},
    --["black"] = {description = S("Black Encased Lamp"), color = "#292929"},
    ["yellow"] = {description = S("Yellow Encased Lamp"), color = "#fcf611"},
    ["orange"] = {description = S("Orange Encased Lamp"), color = "#e0601a"},
    ["red"] = {description = S("Red Encased Lamp"), color = "#c91818"},
    ["pink"] = {description = S("Pink Encased Lamp"), color = "#ffa5a5"},
    ["magenta"] = {description = S("Magenta Encased Lamp"), color = "#d80481"},
    ["violet"] = {description = S("Violet Encased Lamp"), color = "#480680"},
    ["blue"] = {description = S("Blue Encased Lamp"), color = "#00519d"},
    ["cyan"] = {description = S("Cyan Encased Lamp"), color = "#00959d"},
    ["green"] = {description = S("Green Encased Lamp"), color = "#67eb1c"},
    ["dark_green"] = {description = S("Dark Green Encased Lamp"), color = "#2b7b00"},
    ["brown"] = {description = S("Brown Encased Lamp"), color = "#6c3800"}
}

for name, def in pairs(more_decor.encased_lapms) do
    more_decor.register_lamp(name .. "_encased", {
        description = def.description, 
        texture = "more_decor_encased_lamp_outer.png^(more_decor_encased_lamp_inner.png^[multiply:" .. def.color .. ")", 
        drawtype = "mesh", 
        mesh = "more_decor_encased_lamp.obj", 
        node_box = {
            {-0.1875, -0.5000, -0.1875, 0.1875, -0.3750, 0.1875},
		    {-0.1563, -0.3750, -0.1563, 0.1563, -0.03125, 0.1563}
        }, 
        light_source = 13,
        override_sound = "metal",
        override_param2 = "wallmounted"
    })
end

--pans

more_decor.pans = {
    ["steel"] = {description = S("Steel Pan")},
    ["cast_iron"] = {description = S("Cast Iron Pan")},
    ["bronze"] = {description = S("Bronze Pan")}
}

for name, def in pairs(more_decor.pans) do
    minetest.register_node("more_decor:" .. name .. "_pan", {
        description = def.description,
        tiles = {"more_decor_" .. name .. "_pan.png"},
        groups = more_decor.groups["metal"],
        sounds = more_decor.sounds["metal"],
        drawtype = "mesh",
        mesh = "more_decor_pan.obj",
        paramtype = "light",
        paramtype2 = "facedir",
        selection_box = {
            type = "fixed",
            fixed = {
                {-0.3750, -0.5000, -0.3750, 0.3750, -0.4375, 0.3750},
                {-0.4375, -0.4375, -0.4375, 0.4375, -0.3125, 0.4375},
                {-0.3750, -0.4375, -0.3750, 0.3750, -0.3125, 0.3750}
            }
        },
        collision_box = {
            type = "fixed",
            fixed = {
                {-0.3750, -0.5000, -0.3750, 0.3750, -0.4375, 0.3750},
                {-0.4375, -0.4375, -0.4375, -0.3750, -0.3125, 0.4375},
                {0.3750, -0.4375, -0.4375, 0.4375, -0.3125, 0.4375},
                {-0.3750, -0.4375, 0.3750, 0.3750, -0.3125, 0.4375},
                {-0.3750, -0.4375, -0.4375, 0.3750, -0.3125, -0.3750}
            }
        }
    })
end