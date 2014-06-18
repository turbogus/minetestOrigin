minetest.register_craftitem("mushroom:spore1",{
	description = "Unidentified Mushroom Spore",
	inventory_image = "mushroom_spore.png",
	wield_image = "mushroom_spore.png",
})

minetest.register_craftitem("mushroom:spore2",{
	description = "Unidentified Mushroom Spore",
	inventory_image = "mushroom_spore.png",
	wield_image = "mushroom_spore.png",
})

minetest.register_craftitem("mushroom:identifier",{
	description = "Mushroom Spore Identifier/Spore Extractor",
	inventory_image = "mushroom_identifier.png",
	wield_image = "mushroom_identifier.png",
})

minetest.register_craftitem("mushroom:brown_essence",{
	description = "Healthy Brown Mushroom Essence",
	inventory_image = "mushroom_essence.png",
	wield_image = "mushroom_essence.png",
	on_use = minetest.item_eat(10),
})

minetest.register_craftitem("mushroom:poison",{
	description = "Red Mushroom Poison",
	inventory_image = "mushroom_poison.png",
	wield_image = "mushroom_poison.png",
	on_use = minetest.item_eat(-10),
})
