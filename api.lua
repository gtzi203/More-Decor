
--api

--########################################
--every value marked with an * is optional
--########################################

local S = minetest.get_translator(minetest.get_current_modname())

--crafting recipes

--[[register craft

Crafting:
  For type = workbench:
    name                (e.g. "more_decor:medium_red_bricks")

    type = "workbench"
    workbench           (e.g. "more_decor:chisel_bench")
    *extra_input        (requires the workbench to have an extra slot)
    output:
      [index] = name,   (e.g. [1] = "more_decor:long_red_bricks")
      ... other outputs
    For type = "press":
      name

      type = "press"
      press             (e.g. "more_decor:press")
      output            (e.g. {name = "more_decor:steel_sheet", count = 1})
        name
        count
      time              (time for 1 item, multiplies with input count)

--]]

more_decor.crafting_recipes = {
    ["workbench"] = {},
    ["press"] = {}
}

function more_decor.register_craft(name, def)
    if def.type == "workbench" then
        more_decor.crafting_recipes["workbench"][def.workbench][name .. "|" .. (def.extra_input or "")] = def
    elseif def.type == "press" then
        more_decor.crafting_recipes["press"][def.press][name] = def
    end
end

--workbenches

function more_decor.update_workbench_output(pos)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()

    for i = 3, 14, 1 do
        inv:set_stack("main", i, "")
    end

    if meta:get_string("more_decor.await_button_interaction") == "true" then
        return
    end

    local input1 = inv:get_stack("main", 1)
    local input2 = inv:get_stack("main", 2)
    local input1_name = input1:get_name()
    local input2_name = input2:get_name()

    local recipe = more_decor.crafting_recipes["workbench"][minetest.get_node(pos).name][input1_name .. "|" .. input2_name]

    if not recipe then
        return
    end

    local max_output = input1:get_count()

    if recipe.extra_input and input2:get_count() < max_output then
        max_output = input2:get_count()
    end

    for index, name in pairs(recipe.output) do
        inv:set_stack("main", index + 2, name .. " " .. max_output)
    end
end

function more_decor.get_workbench_formspec(def, player, pos)
    local spos = pos.x .. "," .. pos.y .. "," .. pos.z
    local input_slots 

    if not def.input2_description then
        input_slots = (
            ((mcl_formspec and mcl_formspec.get_itemslot_bg_v4(1.75, 2.45, 1, 1)) or "") ..
            "list[nodemeta:" .. spos .. ";main;1.75,2.45;1,1;0]" ..

            "hypertext[0.245,3.61;4,0.35;input1_description;<style color=black><center>" .. def.input1_description .. "</center></style>]"
        )
    else
        input_slots = (
            ((mcl_formspec and mcl_formspec.get_itemslot_bg_v4(1.75, 1.7, 1, 1)) or "") ..
            ((mcl_formspec and mcl_formspec.get_itemslot_bg_v4(1.75, 3.2, 1, 1)) or "") ..
            "list[nodemeta:" .. spos .. ";main;1.75,1.7;1,1;0]" ..
            "list[nodemeta:" .. spos .. ";main;1.75,3.2;1,1;1]" ..

            "hypertext[0.245,1.2;4,0.35;input1_description;<style color=black><center>" .. def.input1_description .. "</center></style>]" ..
            "hypertext[0.245,4.36;4,0.35;input2_description;<style color=black><center>" .. def.input2_description .. "</center></style>]"
        )
    end
    
    local formspec = (
        "formspec_version[6]" ..
        "size[12,12]" ..

        "image[0,0;12,12;more_decor_chisel_bench_bg.png]" ..
        "style_type[label;textcolor=black]" ..
        "label[0.26,0.36;" .. def.description .. "]" ..

        input_slots ..

        ((mcl_formspec and mcl_formspec.get_itemslot_bg_v4(5.25, 1.2, 4, 3)) or "") ..
        "list[nodemeta:" .. spos .. ";main;5.25,1.2;4,3;2]" ..

        "style[output_button;bgcolor=brown]" ..
        "tooltip[output_button;" .. S("Craft") .. ";#6f4444;black]" ..    --either the person, who set the color value for bgcolor=brown is colorblind or i am
        "image_button[3.5,2.45;1,1;" .. def.button_texture .. ";output_button;;false;true]" ..

        ((mcl_formspec and mcl_formspec.get_itemslot_bg_v4(1.15, 6, 8, 1)) or "") ..
        ((mcl_formspec and mcl_formspec.get_itemslot_bg_v4(1.15, 7.4, 8, 3)) or "") ..
        "list[current_player;main;1.15,6;8,1;0]" ..
        "list[current_player;main;1.15,7.4;8,3;8]"
    )

    return formspec
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if not string.find(formname, "more_decor:workbench") then
        return
    end

    local pos = minetest.string_to_pos(string.sub(formname, 22))
    local meta = minetest.get_meta(pos)

    if fields.output_button then
        meta:set_string("more_decor.await_button_interaction", "false")

        more_decor.update_workbench_output(pos)
    end
end)

--[[register workbenches

Workbenches:
  name

  description
  texture
  mesh
  formspec
    description             (displayed in the top left corner. If unwanted use description = "")
    input1_description
    *input2_description     (creates an extra slot for crafting: required for items with an extra input)
    button_texture

--]]

function more_decor.register_workbench(name, def)
    more_decor.crafting_recipes["workbench"]["more_decor:" .. name] = {}

    minetest.register_node("more_decor:" .. name, {
        description = def.description,
        tiles = {def.texture},
        groups = more_decor.groups["wood"],
        sounds = more_decor.sounds["wood"],
        drawtype = "mesh",
        mesh = def.mesh,
        paramtype = "light",
        paramtype2 = "facedir",
        selection_box = {
            type = "fixed",
            fixed = {
                {-0.5000, 0.2500, -0.5000, 0.5000, 0.4375, 0.5000},
                {-0.3750, -0.5000, -0.3750, -0.2500, 0.2500, -0.2500},
                {-0.3750, -0.5000, 0.2500, -0.2500, 0.2500, 0.3750},
                {0.2500, -0.5000, -0.3750, 0.3750, 0.2500, -0.2500},
                {0.2500, -0.5000, 0.2500, 0.3750, 0.2500, 0.3750}
            }
        },
        collision_box = {
            type = "fixed",
            fixed = {
                {-0.5000, 0.2500, -0.5000, 0.5000, 0.4375, 0.5000},
                {-0.3750, -0.5000, -0.3750, -0.2500, 0.2500, -0.2500},
                {-0.3750, -0.5000, 0.2500, -0.2500, 0.2500, 0.3750},
                {0.2500, -0.5000, -0.3750, 0.3750, 0.2500, -0.2500},
                {0.2500, -0.5000, 0.2500, 0.3750, 0.2500, 0.3750}
            }
        },
        on_construct = function(pos)
            local meta = minetest.get_meta(pos)
            local inv = meta:get_inventory()

            inv:set_size("main", 14)

            meta:set_string("more_decor.await_button_interaction", "true")
        end,
        on_destruct = function(pos)
            local meta = minetest.get_meta(pos)
            local inv = meta:get_inventory()

            local input1 = inv:get_stack("main", 1)
            local input2 = inv:get_stack("main", 2)

            minetest.add_item(pos, input1:get_name() .. " " .. input1:get_count())
            minetest.add_item(pos, input2:get_name() .. " " .. input2:get_count())

            local players = minetest.get_connected_players()

            for _, player in ipairs(players) do
                minetest.close_formspec(player:get_player_name(), "more_decor:" .. name .. "_" .. minetest.pos_to_string(pos))
            end
        end,
        on_blast = function(pos, intensity)
            minetest.remove_node(pos)
        end,
        on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
            minetest.show_formspec(
                clicker:get_player_name(), 
                "more_decor:workbench_" .. minetest.pos_to_string(pos), 
                more_decor.get_workbench_formspec(
                    {description = def.formspec.description, input1_description = def.formspec.input1_description, input2_description = def.formspec.input2_description, button_texture = def.formspec.button_texture}, 
                    clicker, 
                    pos
                )
            )
        end,
        allow_metadata_inventory_put = function(pos, listname, index, stack, player)
            if index <= 2 then
                local meta = minetest.get_meta(pos)
                local inv = meta:get_inventory()

                if stack:get_name() ~= inv:get_stack("main", index):get_name() then
                    meta:set_string("more_decor.await_button_interaction", "true")
                end

                return stack:get_count()
            else  
                return 0
            end
        end,
        allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
            return 0
        end,
        on_metadata_inventory_put = function(pos, listname, index, stack, player)
            if index <= 2 then
                more_decor.update_workbench_output(pos)
            end
        end,
        on_metadata_inventory_take = function(pos, listname, index, stack, player)
            local meta = minetest.get_meta(pos)

            if index <= 2 then
                meta:set_string("more_decor.await_button_interaction", "true")

                more_decor.update_workbench_output(pos)
            else
                local inv = meta:get_inventory()

                local input1 = inv:get_stack("main", 1)
                local input2 = inv:get_stack("main", 2)

                local recipe = more_decor.crafting_recipes["workbench"][minetest.get_node(pos).name][input1:get_name() .. "|" .. input2:get_name()]

                if not recipe then
                    return -1
                end

                local new_input1_count = input1:get_count() - stack:get_count()
                local new_input2_count = 1

                inv:set_stack("main", 1, input1:get_name() .. " " .. new_input1_count)

                if recipe.extra_input then
                    new_input2_count = input2:get_count() - stack:get_count()

                    inv:set_stack("main", 2, input2:get_name() .. " " .. new_input2_count)
                end

                if new_input2_count <= 0 or new_input2_count <= 0 then
                    meta:set_string("more_decor.await_button_interaction", "true")
                end

                more_decor.update_workbench_output(pos)
            end
        end,
    })
end

--press

more_decor.press_item_entities = {}
more_decor.press_shaft_entities = {}

minetest.register_entity("more_decor:item_entity", {
    initial_properties = {
        visual = "wielditem",
        textures = {"air"},
        visual_size = {x = 0.175, y = 0.175},
        selectionbox = {0, 0, 0, 0, 0, 0},
        physical = false,
        collide_with_objects = false,
        hp_max = 20,
        damage_texture_modifier = "^[opacity:255"
    },
    get_staticdata = function(self)
        return minetest.serialize({
            wield_item = self.wield_item,
            wield_item_count = self.wield_item_count,
            pos = self.pos,
            rotation = self.rotation,
            move = self.move,
            move_for_id = self.move_for_id
        })
    end,
    on_activate = function(self, staticdata, dtime_s)
        if not staticdata and staticdata == "" then
            return
        end

        local data = minetest.deserialize(staticdata)

        self.wield_item = data.wield_item
        self.wield_item_count = data.wield_item_count
        self.pos = data.pos
        self.rotation = data.rotation
        self.move = data.move
        self.move_for_id = data.move_for_id or 0

        if not self.wield_item or not self.pos or not data.rotation then
            self.object:remove()
        end

        more_decor.press_item_entities[self.pos] = self

        self.object:set_rotation(vector.add(self.rotation, {x = 90 * math.pi / 180, y = 0, z = 0}))
        self.object:set_properties({wield_item = self.wield_item})

        if self.move then
            self:dir_move(self.move.pos, self.move.dist, self.move.time, self.move.after_anim)
        end
    end,
    on_deactivate = function(self, removal)
        self.move_for_id = self.move_for_id + 1
    end,
    dir_move = function(self, pos, dist, time, after_anim)
        local current_move_for_id = self.move_for_id

        self.move = {pos = pos, dist = dist, time = time, after_anim = after_anim}

        local after_anim = after_anim or {}

        local STEP = 0.01

        local yaw = self.object:get_yaw()
        local dir = minetest.yaw_to_dir(yaw)

        local meta = minetest.get_meta(minetest.string_to_pos(self.pos))

        for t = 0, time + 0.01, STEP do
            minetest.after(t, function()
                if current_move_for_id == self.move_for_id then
                    local new_pos = vector.add(pos, {x = ((dist * (t / time))) * math.abs(dir.x), y = 0, z = ((dist * (t / time))) * math.abs(dir.z)})

                    self.object:set_pos(new_pos)

                    meta:set_string("infotext", S("Processing") .. ": " .. minetest.registered_items[self.wield_item].description .. " (" .. self.wield_item_count .. ")" .. "\n" .. S("Time remaining") .. ": " .. more_decor.round(time - t, 0) .. "s (" .. more_decor.round((t * 100) / time, 0) .. "%)")

                    if self.move then
                        self.move.pos = new_pos
                        self.move.dist = (dist - ((dist * (t / time)))) * math.abs(dir.x) + (dist - ((dist * (t / time)))) * math.abs(dir.z)
                        self.move.time = time - t
                    end
                end
            end)
        end

        minetest.after(time, function()
            if current_move_for_id == self.move_for_id then
                more_decor.press_item_entities[self.pos] = nil

                if after_anim.type == "remove" then
                    self.object:remove()
                elseif after_anim.type == "drop" then
                    local item = (after_anim.item and after_anim.item.name)

                    if not item then
                        return
                    end

                    minetest.add_item(vector.add(pos, {x = dist * math.abs(dir.x), y = 0, z = dist * math.abs(dir.z)}), ItemStack(item .. " " .. after_anim.item.count or 1))
                
                    self:delete()
                end 
            end
        end)
    end,
    delete = function(self)
        self.move_for_id = self.move_for_id + 1

        local meta = minetest.get_meta(minetest.string_to_pos(self.pos))

        more_decor.press_item_entities[self.pos] = nil
        self.object:remove()

        meta:set_string("infotext", " ")
    end
})

minetest.register_entity("more_decor:press_shaft", {
    initial_properties = {
        visual = "mesh",
        mesh = "more_decor_press_shaft.obj",
        textures = {"more_decor_press_shaft.png"},
        visual_size = {x = 10, y = 10},
        selectionbox = {0, 0, 0, 0, 0, 0},
        physical = false,
        collide_with_objects = false,
        hp_max = 20,
        glow = 1,
        damage_texture_modifier = "^[opacity:255"
    },
    get_staticdata = function(self)
        return minetest.serialize({
            pos = self.pos,
            index = self.index,
            rotation = self.rotation,
            rotation_anim = self.rotation_anim,
            rotate_for_id = self.rotate_for_id
        })
    end,
    on_activate = function(self, staticdata, dtime_s)
        if not staticdata and staticdata == "" then
            return
        end

        local data = minetest.deserialize(staticdata)

        self.pos = data.pos
        self.index = data.index
        self.rotation = data.rotation
        self.rotation_anim = data.rotation_anim
        self.rotate_for_id = data.rotate_for_id or 0

        if not self.pos or not self.index or not self.rotation then
            self.object:remove()
        end

        more_decor.press_shaft_entities[self.pos .. "|" .. self.index] = self

        self.object:set_rotation(self.rotation)

        if self.rotation_anim then
            self:rotate(self.rotation_anim.time, self.rotation_anim.direction, self.rotation_anim.start_time)
        end
    end,
    on_deactivate = function(self, removal)
        self:cancel_rotation()
    end,
    rotate = function(self, time, direction, start_time)
        local current_rotate_for_id = self.rotate_for_id

        self.rotation_anim = {time = time, direction = direction, start_time = start_time or 0}

        local STEP = 0.01

        --adding a bit time to time, because the for loop will miss a step when the time is smaller 
        for t = 0, time + 0.01, STEP do
            minetest.after(((start_time or -1) < t and (t - (start_time or 0))) or 0, function()
                if current_rotate_for_id == self.rotate_for_id then
                    local new_rotation = vector.add(self.rotation, {x = (((360 / (time / STEP)) * (t / STEP)) * math.pi / 180) * direction, y = 0, z = 0})

                    self.object:set_rotation(new_rotation)

                    if self.rotation_anim then
                        self.rotation_anim.start_time = t
                    end
                end
            end)
        end

        minetest.after(time - (start_time or 0), function()
            self.rotation_anim = nil

            self.object:set_rotation(self.rotation)
        end)
    end,
    cancel_rotation = function(self)
        self.rotate_for_id = self.rotate_for_id + 1

        self.object:set_rotation(self.rotation)
    end,
    delete_rotation_data = function(self)
        self:cancel_rotation()

        self.rotation_anim = nil
    end
})

minetest.register_node("more_decor:press_inv", {
    description = S("Press"),
    tiles = {"more_decor_press_inv.png"},
    groups = more_decor.groups["metal"],
    sounds = more_decor.sounds["metal"],
    drawtype = "mesh",
    mesh = "more_decor_press_inv.obj",
    paramtype = "light",
    paramtype2 = "facedir",
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5000, -0.5000, -0.5000, 0.5000, -0.1875, 0.5000},
            {-0.3750, -0.1875, -0.3125, -0.2500, 0.5000, 0.3125},
            {0.2500, -0.1875, -0.3125, 0.3750, 0.5000, 0.3125},
            {-0.2500, 0.1875, -0.09375, 0.2500, 0.3750, 0.09375},
            {-0.2500, 0.000, -0.09375, 0.2500, 0.1875, 0.09375},
            {-0.4375, 0.06250, -0.03125, 0.4375, 0.1250, 0.03125},
            {-0.4375, 0.2500, -0.03125, 0.4375, 0.3125, 0.03125}
	    }
    },
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.5000, -0.5000, -0.5000, 0.5000, -0.1875, 0.5000},
            {-0.3750, -0.1875, -0.3125, -0.2500, 0.5000, 0.3125},
            {0.2500, -0.1875, -0.3125, 0.3750, 0.5000, 0.3125},
            {-0.2500, 0.1875, -0.09375, 0.2500, 0.3750, 0.09375},
            {-0.2500, 0.000, -0.09375, 0.2500, 0.1875, 0.09375},
            {-0.4375, 0.06250, -0.03125, 0.4375, 0.1250, 0.03125},
            {-0.4375, 0.2500, -0.03125, 0.4375, 0.3125, 0.03125}
	    }
    },
    on_construct = function(pos)
        local node = minetest.get_node(pos)

        minetest.set_node(pos, {name = "more_decor:press", param1 = node.param1, param2 = node.param2}) 
    end
})

--[[register press

Press:
  name

  description
  texture
  mesh

--]]

function more_decor.register_press(name, def)
    more_decor.crafting_recipes["press"]["more_decor:" .. name] = {}

    minetest.register_node("more_decor:" .. name, {
        description = def.description,
        tiles = {def.texture},
        groups = more_decor.groups["press"],
        sounds = more_decor.sounds["metal"],
        drawtype = "mesh",
        mesh = def.mesh,
        paramtype = "light",
        paramtype2 = "facedir",
        drop = "more_decor:press_inv",
        selection_box = {
            type = "fixed",
            fixed = {
                {-0.5000, -0.5000, -0.5000, 0.5000, -0.1875, 0.5000},
                {-0.3750, -0.1875, -0.3125, -0.2500, 0.5000, 0.3125},
                {0.2500, -0.1875, -0.3125, 0.3750, 0.5000, 0.3125},
                {-0.2500, 0.1875, -0.09375, 0.2500, 0.3750, 0.09375},
                {-0.2500, 0.000, -0.09375, 0.2500, 0.1875, 0.09375},
                {-0.4375, 0.06250, -0.03125, 0.4375, 0.1250, 0.03125},
                {-0.4375, 0.2500, -0.03125, 0.4375, 0.3125, 0.03125}
            }
        },
        collision_box = {
            type = "fixed",
            fixed = {
                {-0.5000, -0.5000, -0.5000, 0.5000, -0.1875, 0.5000},
                {-0.3750, -0.1875, -0.3125, -0.2500, 0.5000, 0.3125},
                {0.2500, -0.1875, -0.3125, 0.3750, 0.5000, 0.3125},
                {-0.2500, 0.1875, -0.09375, 0.2500, 0.3750, 0.09375},
                {-0.2500, 0.000, -0.09375, 0.2500, 0.1875, 0.09375},
                {-0.4375, 0.06250, -0.03125, 0.4375, 0.1250, 0.03125},
                {-0.4375, 0.2500, -0.03125, 0.4375, 0.3125, 0.03125}
            }
        },
        on_construct = function(pos)
            local node = minetest.get_node(pos)
            local spos = minetest.pos_to_string(pos)
            local rot = vector.dir_to_rotation(minetest.facedir_to_dir(node.param2))

            local shaft1_pos = {x = pos.x, y = pos.y + 0.2813 , z = pos.z}
            local shaft2_pos = {x = pos.x, y = pos.y + 0.0938, z = pos.z}

            minetest.add_entity(shaft1_pos, "more_decor:press_shaft", minetest.serialize({pos = spos, index = 1, rotation = rot}))
            minetest.add_entity(shaft2_pos, "more_decor:press_shaft", minetest.serialize({pos = spos, index = 2, rotation = rot}))    
        end,
        on_destruct = function(pos)
            local spos = minetest.pos_to_string(pos)

            local shaft1 = more_decor.press_shaft_entities[spos .. "|" .. 1]
            local shaft2 = more_decor.press_shaft_entities[spos .. "|" .. 2]

            local item_ent = more_decor.press_item_entities[spos]

            if shaft1 then
                shaft1.object:remove()
            end

            if shaft2 then
                shaft2.object:remove()
            end

            if item_ent then
                local stack = ItemStack(item_ent.wield_item .. " " .. item_ent.wield_item_count)

                item_ent:delete()
                
                minetest.add_item(pos, stack)
            end
        end,
        on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
            local spos = minetest.pos_to_string(pos)

            local shaft1 = more_decor.press_shaft_entities[spos .. "|" .. 1]
            local shaft2 = more_decor.press_shaft_entities[spos .. "|" .. 2]

            local item_ent = more_decor.press_item_entities[spos]

            if not item_ent then
                local wield_item = itemstack:get_name()
                local recipe = more_decor.crafting_recipes["press"][minetest.get_node(pos).name][wield_item]

                if not recipe then
                    return
                end

                local node = minetest.get_node(pos)
                local dir = minetest.facedir_to_dir(node.param2)
                local rot = vector.dir_to_rotation(dir)

                local item_pos = {x = pos.x - 0.15 * dir.x, y = pos.y + 0.186, z = pos.z - 0.15 * dir.z}
                minetest.add_entity(item_pos, "more_decor:item_entity", minetest.serialize({wield_item = wield_item, wield_item_count = itemstack:get_count(), pos = spos, rotation = rot}))

                local item_entity = more_decor.press_item_entities[spos]

                local stack_count = itemstack:get_count()

                if shaft1 then
                    shaft1:rotate(recipe.time * stack_count, 1)
                end

                if shaft2 then
                    shaft2:rotate(recipe.time * stack_count, -1)
                end

                if item_entity then
                    item_entity:dir_move(item_pos, 0.31 * dir.x + 0.31 * dir.z, recipe.time * stack_count, {type = "drop", item = {name = recipe.output.name, count = recipe.output.count or stack_count}})
                end

                return ItemStack("")
            else
                if not item_ent.move then
                    return
                end

                local inv = clicker:get_inventory()

                local stack = ItemStack(item_ent.wield_item .. " " .. item_ent.wield_item_count)

                item_ent:delete()

                if shaft1 then
                    shaft1:delete_rotation_data()
                end

                if shaft2 then
                    shaft2:delete_rotation_data()
                end

                if inv:room_for_item("main", stack) then
                    local left = inv:add_item("main", stack)

                    minetest.add_item(pos, left)
                else
                    minetest.add_item(pos, stack)
                end

                return clicker:get_wielded_item()
            end
        end
    })
end

--bricks

more_decor.brick_types = {
    ["tiled"] = {description = S("Tiled"), craft_index = 1},
    ["tiny"] = {description = S("Tiny"), craft_index = 2},
    ["small"] = {description = S("Small"), craft_index = 3},
    ["medium"] = {description = S("Medium"), craft_index = 4},
    ["long"] = {description = S("Long"), craft_index = 5}
}

more_decor.bricks = {}

--[[register bricks

Bricks:
  name          (e.g. "white")

  description
    node        (e.g. "White Bricks")
    item        (e.g. "White Brick" (name for the single brick))
  color
    inner
    outer
  dye           (e.g. "white")

--]]

function more_decor.register_bricks(name, def)
    more_decor.bricks[name] = def

    minetest.register_craftitem("more_decor:" .. name .. "_brick", {
        description = def.description.item,
        inventory_image = "more_decor_brick.png^[multiply:" .. def.color.inner
    })

    for type, type_def in pairs(more_decor.brick_types) do
        minetest.register_node("more_decor:" .. type .. "_" .. name .. "_bricks", {
            description = type_def.description .. " " .. def.description.node,
            tiles = {"(more_decor_" .. type .. "_bricks_inner.png^[multiply:" .. def.color.inner .. ")^(more_decor_" .. type .. "_bricks_outer.png^[multiply:" .. def.color.outer .. ")"},
            groups = more_decor.groups["brick"],
            sounds = more_decor.sounds["stone"]
        })
    end
end

--glass

more_decor.glass_nodes = {}
more_decor.glass_panes = {}

more_decor.glass_node_types = {}

function more_decor.update_glass_nodes(pos, name, swap)
    local node = minetest.get_node(pos)

    local node1_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
    local node2_pos = {x = pos.x, y = pos.y - 1, z = pos.z}

    local node1 = minetest.get_node(node1_pos)
    local node2 = minetest.get_node(node2_pos)

    local node_type = more_decor.glass_node_types[node.name]

    local node1_type = more_decor.glass_node_types[node1.name]
    local node2_type = more_decor.glass_node_types[node2.name]
   
    if node_type then
        if node_type ~= tostring(node1_type) then
            node1_type = nil
        end

        if node_type ~= tostring(node2_type) then
            node2_type = nil
        end
    end

    if swap then
        local swap_to = "air"

        if node1_type and node2_type then
            swap_to = "more_decor:" .. node_type .. "_middle"
        elseif node1_type and not node2_type then
            swap_to = "more_decor:" .. node_type .. "_bottom"
        elseif not node1_type and node2_type then
            swap_to = "more_decor:" .. node_type .. "_top"
        elseif not node1_type and not node2_type then
            swap_to = "more_decor:" .. node_type
        end

        minetest.swap_node(pos, {name = swap_to, param1 = node.param1, param2 = node.param2})
    else
        if node_type then
            more_decor.update_glass_nodes(pos, name, true)
        end

        if node1_type then
             more_decor.update_glass_nodes(node1_pos, name, true)
        end

        if node2_type then
            more_decor.update_glass_nodes(node2_pos, name, true)
        end
    end
end

--[[register glass

always required: texture named "more_decor_" .. name .. "_glass_side"

Glass:
  name                  (e.g. "clear")

  description
  *connects             (glass connects to columns. Requires extra textures: "more_decor_" .. name .. "_glass_side_" .. bottom/middle/top
                         !IMPORTANT: when this value is false, the drawtype will be "glasslike_framed_optional", so theres only one texture the node can have;
                                     when this value is true, another texture named "more_decor_" .. name .. "_glass_top")
  *texture_alpha        (set to "blend", if you use half-transparent pixels in your texture)

Glass panes:
  name                  (e.g. "clear")

  description
  *connects             (glass connects to columns. Requires extra textures: "more_decor_" .. name .. "_glass_side_" .. bottom/middle/top)
  *texture_alpha        (set to "blend", if you use half-transparent pixels in your texture)
  *pane_top_texture     (set, if you want to recycle the top texture from another pane. e.g. "clear")

--]]

function more_decor.register_glass(name, def, pane)
    local type
    local node_box
    local top_texture
    local inventory_image

    if not pane then
        more_decor.glass_nodes[name] = def

        type = "glass"
        node_box = {
            type = "fixed",
            fixed = {
                {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
            },
        }
        top_texture = "more_decor_" .. name .. "_glass_top.png"
        connect_sides = nil
        inventory_image = nil
    else
        more_decor.glass_panes[name] = def

        type = "glass_pane"
        node_box = {
			type = "connected",
			fixed = {{-1/32, -1/2, -1/32, 1/32, 1/2, 1/32}},
			connect_front = {{-1/32, -1/2, -1/2, 1/32, 1/2, -1/32}},
			connect_left = {{-1/2, -1/2, -1/32, -1/32, 1/2, 1/32}},
			connect_back = {{-1/32, -1/2, 1/32, 1/32, 1/2, 1/2}},
			connect_right = {{1/32, -1/2, -1/32, 1/2, 1/2, 1/32}},
		}
        top_texture =  "more_decor_" .. (def.pane_top_texture or name) .. "_glass_pane_top.png"
        inventory_image = "more_decor_" .. name .. "_glass_side.png"
    end

    local drawtype
    local tiles

    if not def.connects and not pane then
        drawtype = "glasslike_framed_optional"
        tiles = {
            "more_decor_" .. name .. "_glass_side.png"
        }
    else
        drawtype = "nodebox"
        tiles = {
            top_texture,
            top_texture,
            "more_decor_" .. name .. "_glass_side.png",
            "more_decor_" .. name .. "_glass_side.png",
            "more_decor_" .. name .. "_glass_side.png",
            "more_decor_" .. name .. "_glass_side.png"
        }
    end

    minetest.register_node("more_decor:" .. name .. "_" .. type, {
        description = def.description,
        inventory_image = inventory_image,
        wield_image = inventory_image,
        tiles = tiles,
        groups = more_decor.groups["glass"],
        sounds = more_decor.sounds["glass"],
        drawtype = drawtype,
        node_box = node_box,
        paramtype = "light",
        use_texture_alpha = def.texture_alpha or "clip",
	    sunlight_propagates = true,
	    is_ground_content = false,
        connects_to = {"group:pane", "group:stone", "group:glass", "group:wood", "group:metal", "group:tree"},
        on_construct = function(pos)
            if def.connects then
                more_decor.update_glass_nodes(pos, name, false)
            end
        end
    })

    more_decor.glass_node_types["more_decor:" .. name .. "_" .. type] = name .. "_" .. type

    if def.connects then
        for i, v in ipairs({"top", "middle", "bottom"}) do
            local top_tile
            local bottom_tile

            if v == "top" then
                top_tile = top_texture
                bottom_tile = "more_decor_blank.png"
            elseif v == "middle" then
                top_tile = "more_decor_blank.png"
                bottom_tile = "more_decor_blank.png"
            elseif v == "bottom" then
                top_tile = "more_decor_blank.png"
                bottom_tile = top_texture
            end

            minetest.register_node("more_decor:" .. name .. "_" .. type .. "_" .. v, {
                description = def.description,
                inventory_image = inventory_image,
                wield_image = inventory_image,
                tiles = {
                    top_tile,
                    bottom_tile,
                    "more_decor_" .. name .. "_glass_side_" .. v .. ".png",
                    "more_decor_" .. name .. "_glass_side_" .. v .. ".png",
                    "more_decor_" .. name .. "_glass_side_" .. v .. ".png",
                    "more_decor_" .. name .. "_glass_side_" .. v .. ".png"
                },
                groups = more_decor.groups["glass2"],
                sounds = more_decor.sounds["glass"],
                drawtype = "nodebox",
                node_box = node_box,
                paramtype = "light",
                use_texture_alpha = def.texture_alpha or "clip",
                sunlight_propagates = true,
                is_ground_content = false,
                connect_sides = connect_sides,
                connects_to = {"group:pane", "group:stone", "group:glass", "group:wood", "group:metal", "group:tree"},
                drop = "more_decor:" .. name .. "_" .. type,
                after_dig_node = function(pos, oldnode, oldmetadata, digger)
                    more_decor.update_glass_nodes(pos, name, false)
                end,
                on_blast = function(pos, intensity)
                    more_decor.update_glass_nodes(pos, name, false)

                    minetest.remove_node(pos)
                end
            })

            more_decor.glass_node_types["more_decor:" .. name .. "_" .. type .. "_" .. v] = name .. "_" .. type
        end
    end
end

function more_decor.register_glass_pane(name, def)
    more_decor.register_glass(name, def, true)
end

--lamps

--[[register lamps

Lamps:
  name

  description
  texture
  drawtype
  *mesh             (only if drawtype = "mesh")
  nodebox           (for selection and collision box)
  light_source      (0 - 14)
  *flicker          (e.g. {time_min = 10.0, time_max = 30.0})
    time_min
    time_max
  *override_sound   (e.g. "metal")
  *override_param2  (e.g. "wallmounted")      

--]]

more_decor.lamp_info = {}

more_decor.lamps = {}

function more_decor.register_lamp(name, def)
    more_decor.lamps[name] = def

    minetest.register_node("more_decor:" .. name .. "_lamp_on", {
        description = def.description,
        tiles = {def.texture},
        groups = more_decor.groups["glass"],
        sounds = more_decor.sounds[def.override_sound or "glass"],
        drawtype = def.drawtype,
        mesh = def.mesh,
        paramtype = "light",
        paramtype2 = def.override_param2 or "facedir",
        light_source = def.light_source,
        selection_box = {
            type = "fixed",
            fixed = def.node_box
        },
        collision_box = {
            type = "fixed",
            fixed = def.node_box
        },
        on_construct = function(pos)
            if not def.sound then
                return
            end

            local meta = minetest.get_meta(pos)

            meta:set_int("more_decor.elapsed_sound_time", 0)
            meta:set_int("more_decor.flicker_time", (def.flicker and math.random(def.flicker.time_min, def.flicker.time_max)) or 0)
            meta:set_int("more_decor.elapsed_flicker_time", 0)

            minetest.sound_play(def.sound.name, {pos = pos, max_hear_distance = 16, gain = 0.2, loop = false})

            minetest.get_node_timer(pos):start(1)
        end,
        on_timer = function(pos, elapsed)
            local meta = minetest.get_meta(pos)

            meta:set_int("more_decor.elapsed_sound_time", meta:get_int("more_decor.elapsed_sound_time") + 1)
            
            local elapsed_sound_time = meta:get_int("more_decor.elapsed_sound_time")

            if elapsed_sound_time >= def.sound.length then
                minetest.sound_play(def.sound.name, {pos = pos, max_hear_distance = 16, gain = 0.2})

                meta:set_int("more_decor.elapsed_sound_time", 0)
            end

            if def.flicker then
                local flicker_time = meta:get_int("more_decor.flicker_time")
                local elapsed_flicker_time = meta:get_int("more_decor.elapsed_flicker_time")

                meta:set_int("more_decor.elapsed_flicker_time", meta:get_int("more_decor.elapsed_flicker_time") + 1)

                if elapsed_flicker_time >= flicker_time then
                    local node = minetest.get_node(pos)

                    minetest.set_node(pos, {name = "more_decor:" .. name .. "_lamp_off", param1 = node.param1, param2 = node.param2})

                    return false
                end
            end

            return true
        end
    })

    if not def.flicker then
        return
    end

    minetest.register_node("more_decor:" .. name .. "_lamp_off", {
        description = def.description,
        tiles = {def.texture},
        groups = more_decor.groups["glass2"],
        sounds = more_decor.sounds[def.override_sound or "glass"],
        drawtype = def.drawtype,
        mesh = def.mesh,
        paramtype = "light",
        paramtype2 = "facedir",
        light_source = 0,
        drop = "more_decor:" .. name .. "_lamp_on",
        selection_box = {
            type = "fixed",
            fixed = def.node_box
        },
        collision_box = {
            type = "fixed",
            fixed = def.node_box
        },
        on_construct = function(pos)
            if not def.flicker then
                return
            end

            minetest.sound_play("more_decor_light_flicker", {pos = pos, max_hear_distance = 16, gain = 0.2})

            minetest.get_node_timer(pos):start(0.1)
        end,
        on_timer = function(pos, elapsed)
            local node = minetest.get_node(pos)

            minetest.set_node(pos, {name = "more_decor:" .. name .. "_lamp_on", param1 = node.param1, param2 = node.param2})

            return false
        end
    })
end

--signs

--[[register signs

always required: texture named more_decor_sign_icon_" .. name

Signs:
  name

  description
  dye           (required for crafting)

--]]

more_decor.sign_sizes = {
    ["small"] = {description = S("Small"), node_box = {-0.3750, -0.3750, 0.4375, 0.3750, 0.3750, 0.5000}},
    ["large"] = {description = S("Large"), node_box = {-0.4375, -0.4375, 0.4375, 0.4375, 0.4375, 0.5000}}
}

more_decor.sign_types = {
    ["wood"] = {description = S("Wood"), type = "wood", craft = "group:wood"},
    ["steel"] = {description = S("Steel"), type = "metal", craft = more_decor.item_names["steel_ingot"]},
    ["cast_iron"] = {description = S("Cast Iron"), type = "metal", craft = "more_decor:cast_iron_ingot"},
    ["copper"] = {description = S("Copper"), type = "metal", craft = more_decor.item_names["copper_ingot"]},
    ["bronze"] = {description = S("Bronze"), type = "metal", craft = more_decor.item_names["bronze_ingot"]}
}

--only for crafting sort
more_decor.sign_colors = {
    ["white"] = {},
    ["grey"] = {},
    ["dark_grey"] = {},
    ["black"] = {},
    ["violet"] = {},
    ["blue"] = {},
    ["cyan"] = {},
    ["dark_green"] = {},
    ["green"] = {},
    ["yellow"] = {},
    ["brown"] = {},
    ["orange"] = {},
    ["red"] = {},
    ["magenta"] = {},
    ["pink"] = {},
}

more_decor.signs = {}

function more_decor.register_sign(name, def)
    for type, type_def in pairs(more_decor.sign_types) do
        for size, size_def in pairs(more_decor.sign_sizes) do
            more_decor.signs[name] = def

            if def.dye then
                more_decor.sign_colors[def.dye][name] = true
            end

            minetest.register_node("more_decor:" .. size .. "_" .. name .. "_sign_" .. type, {
                description = size_def.description .. " " .. def.description .. " (" .. type_def.description .. ")",
                tiles = {
                    "more_decor_sign_edge_" .. type .. ".png",
                    "more_decor_sign_edge_" .. type .. ".png^[transformR180",
                    "more_decor_sign_edge_" .. type .. ".png^[transformR270",
                    "more_decor_sign_edge_" .. type .. ".png^[transformR90",
                    "more_decor_" .. size .. "_sign_plate_" .. type .. ".png",
                    "more_decor_" .. size .. "_sign_plate_" .. type .. ".png^more_decor_sign_icon_" .. name .. ".png"
                },
                groups = more_decor.groups[type_def.type],
                sounds = more_decor.sounds[type_def.type],
                drawtype = "nodebox",
                node_box = {
                    type = "fixed",
                    fixed = {
                        size_def.node_box
                    }
                },
                paramtype = "light",
                paramtype2 = "facedir",
                is_ground_content = false
            })
        end
    end
end