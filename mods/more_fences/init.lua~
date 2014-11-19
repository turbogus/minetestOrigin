-- Crafting
minetest.register_craft({
	output = "more_fences:fence_iron 6",
	recipe = {
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
		{"default:steel_ingot","default:steel_ingot", "default:steel_ingot"},
	}
})
minetest.register_craft({
	output = "more_fences:fence_cobble 6",
	recipe = {
		{"default:cobble", "default:cobble", "default:cobble"},
		{"default:cobble", "default:cobble", "default:cobble"},
	}
})
minetest.register_craft({
	output = "more_fences:fence_stone 6",
	recipe = {
		{"default:stone", "default:stone", "default:stone"},
		{"default:stone", "default:stone", "default:stone"},
	}
})
minetest.register_craft({
	output = "more_fences:fence_brick 6",
	recipe = {
		{"default:brick", "default:brick","default:brick"},
		{"default:brick", "default:brick", "default:brick"},
	}
})
minetest.register_craft({
	output = "more_fences:fence_sandstone 6",
	recipe = {
		{"default:sandstone", "default:sandstone", "default:sandstone"},
		{"default:sandstone", "default:sandstone", "default:sandstone"},
	}
})
-- Nodes
minetest.register_node("more_fences:fence_iron", {
	drawtype = "fencelike",
	tile_images = {"default_steel_block.png"},
	inventory_image = "more_fences_iron.png",
	light_propagates = true,
	paramtype = "light",
	is_ground_content = true,
	diggable = true,
	groups = {choppy=2,oddly_breakable_by_hand=2,flammable=2},
	selection_box = {
		type = "fixed",
		fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
	},
	material = minetest.digprop_stonelike(2.5),
})

minetest.register_node("more_fences:fence_cobble", {
	drawtype = "fencelike",
	tile_images = {"default_cobble.png"},
	inventory_image = "more_fences_cobble.png",
	light_propagates = true,
	paramtype = "light",
	is_ground_content = true,
	diggable = true,
	groups = {choppy=2,oddly_breakable_by_hand=2,flammable=2},
	selection_box = {
		type = "fixed",
		fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
	},
	material = minetest.digprop_stonelike(0.9),
})
minetest.register_node("more_fences:fence_stone", {
	drawtype = "fencelike",
	tile_images = {"default_stone.png"},
	inventory_image = "more_fences_stone.png",
	light_propagates = true,
	paramtype = "light",
	is_ground_content = true,
	diggable = true,
	groups = {choppy=2,oddly_breakable_by_hand=2,flammable=2},
	selection_box = {
		type = "fixed",
		fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
	},
	material = minetest.digprop_stonelike(2.5),
})
minetest.register_node("more_fences:fence_brick", {
	drawtype = "fencelike",
	tile_images = {"default_brick.png"},
	inventory_image = "more_fences_brick.png",
	light_propagates = true,
	paramtype = "light",
	is_ground_content = true,
	diggable = true,
	groups = {choppy=2,oddly_breakable_by_hand=2,flammable=2},
	selection_box = {
		type = "fixed",
		fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
	},
	material = minetest.digprop_stonelike(1.0),
})
minetest.register_node("more_fences:fence_mese", {
	drawtype = "fencelike",
	tile_images = {"default_mese.png"},
	inventory_image = "more_fences_mese.png",
	light_propagates = true,
	paramtype = "light",
	is_ground_content = true,
	diggable = true,
	groups = {choppy=2,oddly_breakable_by_hand=2,flammable=2},
	selection_box = {
		type = "fixed",
		fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
	},
	material = minetest.digprop_stonelike(1.0),
})
minetest.register_node("more_fences:fence_cactus", {
	drawtype = "fencelike",
	tile_images = {"default_cactus_side.png"},
	inventory_image = "more_fences_cactus.png",
	light_propagates = true,
	paramtype = "light",
	is_ground_content = true,
	diggable = true,
	groups = {choppy=2,oddly_breakable_by_hand=2,flammable=2},
	selection_box = {
		type = "fixed",
		fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
	},
	material = minetest.digprop_stonelike(1.0),
})
minetest.register_node("more_fences:fence_sandstone", {
	drawtype = "fencelike",
	tile_images = {"default_sandstone.png"},
	inventory_image = "more_fences_sandstone.png",
	light_propagates = true,
	paramtype = "light",
	is_ground_content = true,
	diggable = true,
	groups = {choppy=2,oddly_breakable_by_hand=2,flammable=2},
	selection_box = {
		type = "fixed",
		fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
	},
	material = minetest.digprop_stonelike(1.0),
})

print("[MoreFences by sfan5] Loaded!")
