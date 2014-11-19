-- mod health, by turbogus
-- licence gpl v2 or +

-- provide health pack for minetest origin
-- Cook poison ivy to make health potion !

-- cooked poison ivy
minetest.register_craft({
	type = "cooking",
	output = "health:poison_ivy_dries",
	recipe = "poisonivy:seedling",
})
minetest.register_craft({
	type = "cooking",
	output = "health:poison_ivy_dries",
	recipe = "poisonivy:sproutling",
})
minetest.register_craft({
	type = "cooking",
	output = "health:poison_ivy_dries",
	recipe = "poisonivy:climbing",
})

minetest.register_craftitem("health:poison_ivy_dries", {
	description = "poison ivy dries",
	inventory_image = "poison_ivy_dries.png",
	on_use = minetest.item_eat(2),
})
