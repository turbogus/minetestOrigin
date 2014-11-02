-- Mobs dispenser by turbogus
-- licence WTF

-- Push the node with the key and a specific node in your hand 
--to get a mobs !

-- list of node running to get mobs :
--
--[[

]]--

-- Key to have in your inventory to use this node
-- You have to give you this item (no craft possible)
--
minetest.register_craftitem("mobsdispenser:key", {
	description = "Mobs dispenser Activation Key",
	inventory_image = "key.png",
})


-- The distributor (craft is possible)
--
minetest.register_craft({
	output = "mobsdispenser:dispenser",
	recipe = {
		{"group:stone","group:stone","group:stone"},
		{"group:stone","","group:stone"},
		{"group:stone","default:diamond","group:stone"},
		}
})
minetest.register_node("mobsdispenser:dispenser", {
	description = "Mobs Dispenser",
	tiles = {"topOrBottom.png","topOrBottom.png","side.png","side.png","side.png","face.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	walkable = true,
	pointable = true,
	diggable = true,
	groups = {cracky=2},
	drop = "mobsdispenser:dispenser",
})

minetest.register_on_punchnode(function(p, node, player)

	local theItem = player:get_wielded_item():get_name()
	
	
	if  node.name=="mobsdispenser:dispenser" and theItem == "default:dirt" and player:get_inventory():contains_item('main', "mobsdispenser:key") then
		minetest.sound_play({
					name = "laser",
					gain = 0.2,
					max_hear_distance = 5,
					})
	end
	
end)