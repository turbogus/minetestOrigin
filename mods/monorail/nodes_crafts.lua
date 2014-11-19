--------------------------------------------------------------------------------
--
-- Crafts
--
--------------------------------------------------------------------------------
if minetest.is_yes(minetest.setting_get("monorail_carts_mimicry")) then
	minetest.register_craft({
		output = "monorail:cart",
		recipe = {
			{"", "", ""},
			{"default:steel_ingot", "", "default:steel_ingot"},
			{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
		},
	})

		minetest.register_craft({
		output = "monorail:transport_cart",
		recipe = {
			{"", "", ""},
			{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
			{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
		},
	})
else
	minetest.register_craft({
	    output = "monorail:cart",
	    recipe = {
	        {"default:steel_ingot",'',"default:steel_ingot"},
	        {"default:steel_ingot","default:mese_crystal","default:steel_ingot"},
	    }
	})

	minetest.register_craft({
	    output = "monorail:transport_cart",
	    recipe = {
	        {"default:steel_ingot","default:steel_ingot","default:steel_ingot"},
	        {"default:steel_ingot","default:mese_crystal","default:steel_ingot"},
	    }
	})
end


minetest.register_craft({
    output = 'craft "monorail:switch_off" 1',
    recipe = {
        {"default:stick"},
        {"default:steel_ingot"},
    }
})

if not minetest.is_yes(minetest.setting_get("monorail_carts_mimicry")) then
	minetest.register_craft({
	    output = 'node "monorail:slider" 10',
	    recipe = {
	        {"default:sand"},
	        {"default:steel_ingot"},
	        {"default:sand"},
	    }
	})
end

if minetest.is_yes(minetest.setting_get("monorail_carts_mimicry")) then
	minetest.register_craft({
		output = "monorail:booster 2",
		recipe = {
			{"default:steel_ingot", "default:mese_crystal_fragment", "default:steel_ingot"},
			{"default:steel_ingot", "default:stick", "default:steel_ingot"},
			{"default:steel_ingot", "", "default:steel_ingot"},
		}
	})

	minetest.register_craft({
		output = "monorail:booster 2",
		recipe = {
			{"default:steel_ingot", "", "default:steel_ingot"},
			{"default:steel_ingot", "default:stick", "default:steel_ingot"},
			{"default:steel_ingot", "default:mese_crystal_fragment", "default:steel_ingot"},
		}
	})

	--register break reciep only if mesecons is not present
	if minetest.get_modpath("mesecons") == nil then
	minetest.register_craft({
		output = "monorail:break 2",
		recipe = {
			{"default:steel_ingot", "default:coal_lump", "default:steel_ingot"},
			{"default:steel_ingot", "default:stick", "default:steel_ingot"},
			{"default:steel_ingot", "", "default:steel_ingot"},
		}
	})

	minetest.register_craft({
		output = "monorail:break 2",
		recipe = {
			{"default:steel_ingot", "", "default:steel_ingot"},
			{"default:steel_ingot", "default:stick", "default:steel_ingot"},
			{"default:steel_ingot", "default:coal_lump", "default:steel_ingot"},
		}
	})

	end
else
	minetest.register_craft({
	    output = "monorail:booster 10",
	    recipe = {
	        {"default:sand"},
	        {"default:mese_crystal"},
	        {"default:sand"},
	    }
	})

	--register break reciep only if mesecons is not present
	if minetest.get_modpath("mesecons") == nil then
	minetest.register_craft({
	    output = "monorail:break 10",
	    recipe = {
	        {"default:sand"},
	        {"default:stone"},
	        {"default:sand"},
	    }
	})
	end
end



minetest.register_craft({
    output = 'node "monorail:accelerator_off" 5',
    recipe = {
        {"default:cobble", "default:mese_crystal","default:cobble"},
        {"default:mese_crystal", "default:glass", "default:mese_crystal"},
        {"default:cobble", "default:mese_crystal","default:cobble"},
        }
    })

minetest.register_craft({
        output = 'node "monorail:cart_detector_off" 5',
    recipe = {
        {"default:cobble", "default:glass","default:cobble"},
        {"default:glass", "default:mese_crystal", "default:glass"},
        {"default:cobble", "default:glass","default:cobble"},
    }
})
--------------------------------------------------------------------------------
--
-- Craftitems
--
--------------------------------------------------------------------------------

local cart_inventorycube = minetest.inventorycube("monorail_cart.png")
local name = "Monorail Cart"
if minetest.is_yes(minetest.setting_get("monorail_carts_mimicry")) then
	cart_inventorycube = minetest.inventorycube("monorail_pa_cart_top.png",
												"monorail_pa_cart_side.png",
												"monorail_pa_cart_side.png")
	name = "Cart"
end

minetest.register_craftitem("monorail:cart", {
	description = name,
	image = cart_inventorycube,

	on_place = function(item, placer, pointed_thing)
		if pointed_thing.type == "node" then
			local pos = pointed_thing.above
			local new_object = minetest.env:add_entity(pos,"monorail:cart_ent")

			if new_object ~= nil then
				local slidertype = detect_slider_type({x=pos.x,y=pos.y-1,z=pos.z}, nil)

				--print("slidertype: " .. dump(slidertype))

				if slidertype == "x" then
					new_object:setyaw(0)
				end

				if slidertype == "z" then
					new_object:setyaw(0 + math.pi/2)
				end
			end

			item:take_item()
		end
		return item
	end
})

local tcart_inventorycube = minetest.inventorycube("monorail_transport_cart.png")
name = "Monorail Transport Cart"
if minetest.is_yes(minetest.setting_get("monorail_carts_mimicry")) then
	tcart_inventorycube = minetest.inventorycube("monorail_pa_cart_top.png",
													"monorail_pa_cart_side.png",
													"monorail_pa_cart_side.png")
	name = "Transport Cart"
end

minetest.register_craftitem("monorail:transport_cart", {
	description = name,
	image = tcart_inventorycube,

	on_place = function(item, placer, pointed_thing)
		if pointed_thing.type == "node" then
			local pos = pointed_thing.above
			minetest.env:add_entity(pos,"monorail:transport_cart_ent")

			if new_object ~= nil then
				local slidertype = detect_slider_type({x=pos.x,y=pos.y-1,z=pos.z}, nil)

				--print("slidertype: " .. dump(slidertype))

				if slidertype == "x" then
					new_object:setyaw(0)
				end

				if slidertype == "z" then
					new_object:setyaw(0 + math.pi/2)
				end
			end

			item:take_item()
		end
		return item
	end
})

--------------------------------------------------------------------------------
--
-- Nodes
--
--------------------------------------------------------------------------------

local slidertiles = {"monorail_monorail.png",
					"monorail_monorail_curved.png",
					"monorail_monorail_t_junction.png",
					"monorail_monorail_crossing.png"}
local inventoryimage = "monorail_monorail.png"
local slidername = "Slider"

if minetest.is_yes(minetest.setting_get("monorail_carts_mimicry")) then
	slidertiles = {"default_rail.png", "default_rail_curved.png", "default_rail_t_junction.png", "default_rail_crossing.png"}
	inventoryimage = "default_rail.png"
	slidername = "Rail"
end

minetest.register_node(monorail_basic_slider, {
	description = slidername,
	drawtype = "raillike",
	tiles = slidertiles,
	inventory_image = inventoryimage,
	wield_image = inventoryimage,
	paramtype = "light",
	is_ground_content = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-1/2, -1/2, -1/2, 1/2, -1/2+1/16, 1/2},
	},
	groups = {bendy=2,snappy=1,dig_immediate=2,attached_node=1,rail=1},
	})

slidername = "Slider (Vertical)"

if minetest.is_yes(minetest.setting_get("monorail_carts_mimicry")) then
	slidername = "Rail (Vertical)"
end

minetest.register_node("monorail:slider_vertical", {
	description = slidername,
	drawtype = "signlike",
	tiles = { inventoryimage },
	inventory_image = inventoryimage,
	wield_image = inventoryimage,
	paramtype = "light",
	paramtype2 = "wallmounted",
	is_ground_content = true,
	walkable = false,
	selection_box = {
		type = "wallmounted",
		--wall_top = = <default>
		--wall_bottom = = <default>
		--wall_side = = <default>
		},
	groups = {bendy=2,snappy=1,dig_immediate=2,attached_node=1,rail=1},
	})


slidertiles = {"monorail_monorail_boost.png",
					"monorail_monorail_curved_boost.png",
					"monorail_monorail_t_junction_boost.png",
					"monorail_monorail_crossing_boost.png"}
inventoryimage = "monorail_monorail_boost.png"
slidername = "Booster"

if minetest.is_yes(minetest.setting_get("monorail_carts_mimicry")) then
	slidertiles = {"monorail_pa_carts_rail_pwr.png",
					"monorail_pa_carts_rail_curved_pwr.png",
					"monorail_pa_carts_rail_t_junction_pwr.png",
					"monorail_pa_carts_rail_crossing_pwr.png"}
	inventoryimage = "monorail_pa_carts_rail_pwr.png"
	slidername = "Powered Rail"

	minetest.register_alias("default:rail","monorail:slider")
end

minetest.register_node("monorail:booster", {
	description = slidername,
	drawtype = "raillike",
	tiles = slidertiles,
	inventory_image = inventoryimage,
	wield_image = inventoryimage,
	paramtype = "light",
	is_ground_content = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-1/2, -1/2, -1/2, 1/2, -1/2+1/16, 1/2},
	},
	groups = {bendy=2,snappy=1,dig_immediate=2,attached_node=1,rail=1},

	mesecons = { conductor = {
				state = "on",
				offstate = "monorail:break",
				} }
})

slidertiles = {"monorail_monorail_break.png",
					"monorail_monorail_curved_break.png",
					"monorail_monorail_t_junction_break.png",
					"monorail_monorail_crossing_break.png"}
inventoryimage = "monorail_monorail_break.png"
slidername = "Brake"

if minetest.is_yes(minetest.setting_get("monorail_carts_mimicry")) then
	slidertiles = {"monorail_pa_carts_rail_brk.png",
					"monorail_pa_carts_rail_curved_brk.png",
					"monorail_pa_carts_rail_t_junction_brk.png",
					"monorail_pa_carts_rail_crossing_brk.png"}
	inventoryimage = "monorail_pa_carts_rail_pwr.png"
	slidername = "Brake Rail"

	minetest.register_alias("default:rail","monorail:slider")
end

minetest.register_node("monorail:break", {
	description = slidername,
	drawtype = "raillike",
	tiles = slidertiles,
	inventory_image = inventoryimage,
	wield_image = inventoryimage,
	paramtype = "light",
	is_ground_content = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-1/2, -1/2, -1/2, 1/2, -1/2+1/16, 1/2},
	},
	groups = {bendy=2,snappy=1,dig_immediate=2,attached_node=1,rail=1},
	mesecons = { conductor = {
				state = "off",
				onstate = "monorail:booster",
				} }
})

minetest.register_node("monorail:accelerator_off", {
	description = "Mese Monorail Accelerator off",
	tiles ={"monorail_accelerator_off.png"},
	is_ground_content = true,
	groups = {cracky=3, mesecon=2},
	drop = 'monorail:accelerator_off 1',

	mesecons = { conductor = {
				state = "off",
				onstate = "monorail:accelerator_on",
				} }
})

minetest.register_node("monorail:accelerator_on", {
	description = "Mese Monorail Accelerator on",
	tiles ={"monorail_accelerator_on.png"},
	is_ground_content = true,
	groups = {cracky=3, mesecon=2},
	drop = 'monorail:accelerator_off 1',

	mesecons = { conductor = {
				state = "on",
				offstate = "monorail:accelerator_off",
				} }

})

minetest.register_node("monorail:cart_detector_on", {
	description = "Mese Monorail Cart Detector (On)",
	tiles ={"monorail_cart_detector.png"},
	is_ground_content = true,
	groups = {cracky=3, mesecon=2},
	drop = 'monorail:cart_detector_off 1',
	mesecons = { receptor = {
					state = "on"
					} }

})

minetest.register_abm({
	nodenames = { "monorail:cart_detector_on" },
	interval = 2,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		minetest.env:add_node(pos,{name="monorail:cart_detector_off"})
		mesecon:receptor_off(pos, mesecon.rules.default)
		pb_debug_lvl2("disabling mesecon detector at: " .. printpos(pos))
	end
	})

minetest.register_node("monorail:cart_detector_off", {
	description = "Mese Monorail Cart Detector (Off)",
	tiles ={"monorail_cart_detector.png"},
	is_ground_content = true,
	groups = {cracky=3, mesecon=2},
	drop = 'monorail:cart_detector_off 1',
	mesecons = { receptor = {
					state = "off"
					} }
})
