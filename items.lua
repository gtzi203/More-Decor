
--items

local S = minetest.get_translator(minetest.get_current_modname())

--cast iron

minetest.register_craftitem("more_decor:cast_iron_ingot", {
    description = S("Cast Iron Ingot"),
    inventory_image = "more_decor_cast_iron_ingot.png"
})

--sheets

more_decor.sheets = {
    ["wood"] = {description = S("Wood Sheet")},    --revise texture (and name?)
    ["steel"] = {description = S("Steel Sheet")},
    ["tin"] = {description = S("Tin Sheet")},
    ["cast_iron"] = {description = S("Cast Iron Sheet")},
    ["copper"] = {description = S("Copper Sheet")},
    ["bronze"] = {description = S("Bronze Sheet")},
    ["gold"] = {description = S("Gold Sheet")}
}

for name, def in pairs(more_decor.sheets) do
    minetest.register_craftitem("more_decor:" .. name .. "_sheet", {
        description = def.description,
        inventory_image = "more_decor_" .. name .. "_sheet.png"
    })
end