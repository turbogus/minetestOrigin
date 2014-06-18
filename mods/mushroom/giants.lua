minetest.register_node("mushroom:brown_meseshroom",{
	description = "Brown Mese-shroom (Giant Mushroom)",
	drawtype = "plantlike",
	sunlight_propagates = true,
	visual_scale = 4.0,
	tiles = {"mushroom_brown.png"},
	inventory_image = "mushroom_brown.png",
	wield_image = "mushroom_brown.png",
	groups = {oddly_breakable_by_hand=1,attached_node=1},
	paramtype = "light",
	on_use = minetest.item_eat(20),
	selection_box = {
		type = "fixed",
		fixed = {-3, -1.5, -3, 3, 5, 3}
	},
})

minetest.register_node("mushroom:red_meseshroom",{
	description = "Red Mese-shroom (Giant Mushroom)",
	drawtype = "plantlike",
	sunlight_propagates = true,
	visual_scale = 4.0,
	tiles = {"mushroom_red.png"},
	inventory_image = "mushroom_red.png",
	wield_image = "mushroom_red.png",
	groups = {oddly_breakable_by_hand=1,attached_node=1},
	paramtype = "light",
	on_use = minetest.item_eat(-20),
	selection_box = {
		type = "fixed",
		fixed = {-3, -1.5, -3, 3, 5, 3}
	},
})

minetest.register_craft( {
         type = "shapeless",
         output = "mushroom:brown_meseshroom",
         recipe = { "mushroom:brown" , "default:mese_crystal" },
})

minetest.register_craft( {
         type = "shapeless",
         output = "mushroom:red_meseshroom",
         recipe = { "mushroom:red" , "default:mese_crystal" },
})
