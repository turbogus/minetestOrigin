------------------------------------------
------------------------------------------
-- Déclaration des runes

-- Eau
--
minetest.register_craftitem("runes:eau", {
	description = "Water rune",
	inventory_image = "eau.png",
})

-- Feu
--
minetest.register_craftitem("runes:feu", {
	description = "Fire rune",
	inventory_image = "feu.png",
})

-- Terre
--
minetest.register_craftitem("runes:terre", {
	description = "Dirt rune",
	inventory_image = "terre.png",
})


-- Air
--
minetest.register_craftitem("runes:air", {
	description = "Air rune",
	inventory_image = "air.png",
})


-- Pierre
--
minetest.register_craftitem("runes:pierre", {
	description = "Stone rune",
	inventory_image = "stone.png",
})

-- Metal
--
minetest.register_craftitem("runes:metal", {
	description = "Metal rune",
	inventory_image = "metal.png",
})

------------------------------------------
------------------------------------------
-- Déclaration socle à runes (pour essais)

-- socle à runes OFF
--
minetest.register_node("runes:socleOFF", {
	description = "Cactus",
	tiles = {"dessous.png", "dessous.png", "cote1OFF.png", "cote2OFF.png", "cote3OFF.png", "cote4OFF.png"},
	paramtype = "light",
	--light_source = LIGHT_MAX - 1,
	paramtype2 = "facedir",
	is_ground_content = true,
	groups = {cracky=2, falling_node=1},
})

-- socle à runes ON
--
minetest.register_node("runes:socleON", {
	description = "Cactus",
	tiles = {"dessous.png", "dessous.png", "cote1ON.png", "cote2ON.png", "cote3ON.png", "cote4ON.png"},
	paramtype = "light",
	light_source = LIGHT_MAX - 1,
	paramtype2 = "facedir",
	is_ground_content = true,
	groups = {cracky=2, falling_node=1},
})
