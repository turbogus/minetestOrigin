-- Old runes declaration
--
--[[
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
	inventory_image = "pierre.png",
})
-- Metal
--
minetest.register_craftitem("runes:metal", {
	description = "Metal rune",
	inventory_image = "metal.png",
})
]]--
-------------------------------------------
-------------------------------------------

-- New runes declaration and craft
--

-- Vegetal rune
--
minetest.register_craftitem("runes:vegetal", {
	description = "Vegetal rune",
	inventory_image = "vegetal.png",
})
minetest.register_craft({
	output = "runes:vegetal",
	recipe = {
		{"runes:vegetalNegativ"},
	},
	replacements = {{"runes:vegetalNegativ", "runes:fire"}},
})
minetest.register_craft({
	output = "runes:vegetal",
	recipe = {
		{"runes:vegetalPedestal"},
	},
	replacements = {{"runes:vegetalPedestal", "default:cobble 3"}},
})

-- Vegetal negativ rune
--
minetest.register_craftitem("runes:vegetalNegativ", {
	description = "Negativ Vegetal rune",
	inventory_image = "vegetalNegativ.png",
})
minetest.register_craft({
	output = "runes:vegetalNegativ",
	recipe = {
		{"runes:vegetal"},
		{"runes:fire",},
	}
})
minetest.register_craft({
	output = "runes:vegetalNegativ",
	recipe = {
		{"runes:vegetalNegativPedestal"},
	},
	replacements = {{"runes:vegetalNegativPedestal", "default:cobble 3"}},
})

-- Animal rune
--
minetest.register_craftitem("runes:animal", {
	description = "Animal rune",
	inventory_image = "animal.png",
})
minetest.register_craft({
	output = "runes:animal",
	recipe = {
		{"runes:animalNegativ"},
	},
	replacements = {{"runes:animalNegativ", "runes:fire"}},
})
minetest.register_craft({
	output = "runes:animal",
	recipe = {
		{"runes:animalPedestal"},
	},
	replacements = {{"runes:animalPedestal", "default:cobble 3"}},
})

-- Animal negativ rune
--
minetest.register_craftitem("runes:animalNegativ", {
	description = "Negativ Animal rune",
	inventory_image = "animalNegativ.png",
})
minetest.register_craft({
	output = "runes:animalNegativ",
	recipe = {
		{"runes:animal"},
		{"runes:fire",},
	}
})
minetest.register_craft({
	output = "runes:animalNegativ",
	recipe = {
		{"runes:animalNegativPedestal"},
	},
	replacements = {{"runes:animalNegativPedestal", "default:cobble 3"}},
})

-- Mineral rune
--
minetest.register_craftitem("runes:mineral", {
	description = "Mineral rune",
	inventory_image = "mineral.png",
})
minetest.register_craft({
	output = "runes:mineral",
	recipe = {
		{"runes:cristal"},
	},
	replacements = {{"runes:cristal", "runes:fire"}},
})
minetest.register_craft({
	output = "runes:mineral",
	recipe = {
		{"runes:mineralPedestal"},
	},
	replacements = {{"runes:mineralPedestal", "default:cobble 3"}},
})

-- Cristal rune
--
minetest.register_craftitem("runes:cristal", {
	description = "Cristal rune",
	inventory_image = "cristal.png",
})
minetest.register_craft({
	output = "runes:cristal",
	recipe = {
		{"runes:mineral"},
		{"runes:fire",},
	}
})
minetest.register_craft({
	output = "runes:cristal",
	recipe = {
		{"runes:cristalPedestal"},
	},
	replacements = {{"runes:cristalPedestal", "default:cobble 3"}},
})

-- Fire or Nether rune
--
minetest.register_craftitem("runes:fire", {
	description = "Fire or Nether rune",
	inventory_image = "fire.png",
})

------------------------------------------

-- Alias to allow new runes in players inventory
--

-- feu --> fire or nether
minetest.register_alias("runes:feu", "runes:fire")

-- pierre --> mineral
minetest.register_alias("runes:pierre", "runes:mineral")

-- terre --> vegetal
minetest.register_alias("runes:terre", "runes:vegetal")

-- metal --> animals
minetest.register_alias("runes:metal", "runes:animal")

------------------------------------------
------------------------------------------

-- Pedestals declaration and craft 
--

-- vegetal Pedestal
--
minetest.register_craft({
	output = "runes:vegetalPedestal",
	recipe = {
		{"", "runes:vegetal", ""},
		{"group:stone", "group:stone", "group:stone"},
	}
})
minetest.register_node("runes:vegetalPedestal", {
	description = "Vegetal rune pedestal",
	tiles = {"default_stone_brick.png", "default_stone_brick.png", "default_stone_brick.png", "default_stone_brick.png", "default_stone_brick.png", "vegetalPedestal.png"},
	paramtype = "light",
	light_source = LIGHT_MAX - 1,
	paramtype2 = "facedir",
	is_ground_content = false,
	drop = "runes:vegetalPedestal",
	groups = {cracky=2, falling_node=1},
})

-- negativ vegetal pedestal
--
minetest.register_craft({
	output = "runes:vegetalNegativPedestal",
	recipe = {
		{"", "runes:vegetalNegativ", ""},
		{"group:stone", "group:stone", "group:stone"},
	}
})
minetest.register_node("runes:vegetalNegativPedestal", {
	description = "Negativ Vegetal rune pedestal",
	tiles = {"default_stone_brick.png", "default_stone_brick.png", "default_stone_brick.png", "default_stone_brick.png", "default_stone_brick.png", "vegetalNegativPedestal.png"},
	paramtype = "light",
	light_source = LIGHT_MAX - 1,
	paramtype2 = "facedir",
	is_ground_content = false,
	drop = "runes:vegetalNegativPedestal",
	groups = {cracky=2, falling_node=1},
})

-- animal pedestal
--
minetest.register_craft({
	output = "runes:animalPedestal",
	recipe = {
		{"", "runes:animal", ""},
		{"group:stone", "group:stone", "group:stone"},
	}
})
minetest.register_node("runes:animalPedestal", {
	description = "Animal rune pedestal",
	tiles = {"default_stone_brick.png", "default_stone_brick.png", "default_stone_brick.png", "default_stone_brick.png", "default_stone_brick.png", "animalPedestal.png"},
	paramtype = "light",
	light_source = LIGHT_MAX - 1,
	paramtype2 = "facedir",
	is_ground_content = false,
	drop = "runes:animalPedestal",
	groups = {cracky=2, falling_node=1},
})

-- negativ animals pedestal
--
minetest.register_craft({
	output = "runes:animalNegativPedestal",
	recipe = {
		{"", "runes:animalNegativ", ""},
		{"group:stone", "group:stone", "group:stone"},
	}
})
minetest.register_node("runes:animalNegativPedestal", {
	description = "Negativ Animal rune pedestal",
	tiles = {"default_stone_brick.png", "default_stone_brick.png", "default_stone_brick.png", "default_stone_brick.png", "default_stone_brick.png", "animalNegativPedestal.png"},
	paramtype = "light",
	light_source = LIGHT_MAX - 1,
	paramtype2 = "facedir",
	is_ground_content = false,
	drop = "runes:animalNegativPedestal",
	groups = {cracky=2, falling_node=1},
})

-- mineral pedestal
--
minetest.register_craft({
	output = "runes:mineralPedestal",
	recipe = {
		{"", "runes:mineral", ""},
		{"group:stone", "group:stone", "group:stone"},
	}
})
minetest.register_node("runes:mineralPedestal", {
	description = "Mineral rune pedestal",
	tiles = {"default_stone_brick.png", "default_stone_brick.png", "default_stone_brick.png", "default_stone_brick.png", "default_stone_brick.png", "mineralPedestal.png"},
	paramtype = "light",
	light_source = LIGHT_MAX - 1,
	paramtype2 = "facedir",
	is_ground_content = false,
	drop = "runes:mineralPedestal",
	groups = {cracky=2, falling_node=1},
})

-- cristal pedestal
--
minetest.register_craft({
	output = "runes:cristalPedestal",
	recipe = {
		{"", "runes:cristal", ""},
		{"group:stone", "group:stone", "group:stone"},
	}
})
minetest.register_node("runes:cristalPedestal", {
	description = "Cristal rune pedestal",
	tiles = {"default_stone_brick.png", "default_stone_brick.png", "default_stone_brick.png", "default_stone_brick.png", "default_stone_brick.png", "cristalPedestal.png"},
	paramtype = "light",
	light_source = LIGHT_MAX - 1,
	paramtype2 = "facedir",
	is_ground_content = false,
	drop = "runes:cristalPedestal",
	groups = {cracky=2, falling_node=1},
})

------------------------------------------
------------------------------------------

--
-- ENCHANTMENT BOX
--

-- Enchantment box craft
--
minetest.register_craft({
	output = 'runes:enchantmentBox',
	recipe = {
		{'default:obsidian', "default:book", 'default:obsidian'},
		{'default:obsidian', "default:diamond", 'default:obsidian'},
		{'default:obsidian', 'default:obsidian', 'default:obsidian'},
	}
})

-- Enchantment box formspec
--
enchantmentBox_formspec =
  "size[8,9]"..
  "list[current_name;IN;2,0;1,1;]"..
  "list[current_name;OUT;3,0;2,2;]"..
  "list[current_player;main;0,5;8,4;]"
  
-- Enchantment box declaration and algorythm
--
minetest.register_node("runes:enchantmentBox", {
	description = "Enchantment Box",
	tiles = {"enchantmentBoxTop.png", "default_obsidian.png", "enchantmentBoxSide.png", "enchantmentBoxSide.png", "enchantmentBoxSide.png", "enchantmentBoxSide.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {cracky=2, falling_node=1},
	
	-- Formatting inventory
	--
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", enchantmentBox_formspec)
		meta:set_string("infotext", "Enchantment Box")
		local inv = meta:get_inventory()
		inv:set_size("IN", 1)
		inv:set_size("OUT", 2*2)	
	end,
	
	-- You can only take empty enchantment box !
	--
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		
		if not inv:is_empty("IN") or not inv:is_empty("OUT") then
			return false
		end
		
		return true
	end,
})


------------------------------------------
------------------------------------------
------------------------------------------
-- SOCLE A RUNE VIDE
--


-- Craft du socle à runes vide
--
--[[
minetest.register_craft({
	output = 'runes:socleOFF',
	recipe = {
		{'default:obsidian', "default:diamond", 'default:obsidian'},
		{"default:diamond", 'default:obsidian', "default:diamond"},
		{'default:obsidian', "default:diamond", 'default:obsidian'},
	}
})
]]--

-- Table contenue dans le socle à runes
--
socleOFF_formspec = 
	"size[8,9]"..
	--"textarea[1,2;1,1;zonedetexte;Socle a rune;default]",..
	"list[current_name;rune1;2,0;1,1;]"..
	"list[current_name;rune2;3,0;1,1;]"..
	"list[current_name;rune3;4,0;1,1;]"..
	"list[current_name;rune4;5,0;1,1;]"..
	"list[current_name;rune5;6,0;1,1;]"..
	"list[current_name;rune6;7,0;1,1;]"..
	"list[current_player;main;0,5;8,4;]"


-- Fonction permettant d'échanger un node contre un autre
--
local function swap_node(pos,name)
	local node = minetest.get_node(pos)
	if node.name == name then
		return
	end
	node.name = name
	minetest.swap_node(pos,node)
end
	

-- socle à runes OFF
--
minetest.register_node("runes:socleOFF", {
	description = "Socle a runes",
	tiles = {"dessous.png", "dessous.png", "cote1OFF.png", "cote2OFF.png", "cote3OFF.png", "cote4OFF.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = true,
	groups = {cracky=2, falling_node=1},
	
	-- Mise en forme de l'inventaire
	--
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", socleOFF_formspec)
		meta:set_string("infotext", "Socle a runes")
		local inv = meta:get_inventory()
		inv:set_size("rune1", 1)
		inv:set_size("rune2", 1)
		inv:set_size("rune3", 1)
		inv:set_size("rune4", 1)
		inv:set_size("rune5", 1)
		inv:set_size("rune6", 1)	
	end,
	
	--Peut-être pris seulement si l'inventaire est vide !
	--
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		
		if not inv:is_empty("rune1") or not inv:is_empty("rune2") or not inv:is_empty("rune3") or not inv:is_empty("rune4") or not inv:is_empty("rune5") or not inv:is_empty("rune6") then
			return false
		end
		
		return true
	end,
	
	-- Basculement du node en combinaison "eau" si une rune de l'eau 
	-- est detectée dans l'emplacement rune1
	--
	--[[allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local count = stack:get_count()
		
		if listname == "rune1" then
			
			local itM = stack:get_name()
			
			if itM == "runes:eau" then
				
				minetest.chat_send_all("rune eau")
				swap_node(pos,"runes:socleEAU")
				return count
			
			end
				
		end
				
		return 0
	end,]]--
	
	
	
})


------------------------------------------
------------------------------------------
------------------------------------------
------------------------------------------
-- SOCLES A RUNES ACTIFS
--


--
-- socle à runes ON : combinaison EAU
--
minetest.register_node("runes:socleEAU", {
	description = "Socle a runes",
	tiles = {"dessous.png", "dessous.png", "cote1ON.png", "cote2ON.png", "cote3ON.png", "cote4ON.png"},
	paramtype = "light",
	light_source = LIGHT_MAX - 1,
	paramtype2 = "facedir",
	is_ground_content = true,
	groups = {cracky=2, falling_node=1},
	drop = "runes:socleOFF",
	
	-- Mise en forme de l'inventaire
	--
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", socleOFF_formspec)
		meta:set_string("infotext", "Socle a runes")
		local inv = meta:get_inventory()
		inv:set_size("rune1", 1)
		inv:set_size("rune2", 1)
		inv:set_size("rune3", 1)
		inv:set_size("rune4", 1)
		inv:set_size("rune5", 1)
		inv:set_size("rune6", 1)	
	end,
	
	--Peut-être pris seulement si l'inventaire est vide !
	--
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		
		if not inv:is_empty("rune1") or not inv:is_empty("rune2") or not inv:is_empty("rune3") or not inv:is_empty("rune4") or not inv:is_empty("rune5") or not inv:is_empty("rune6") then
			return false
		end
		
		return true
	end,
	
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local count = stack:get_count()
		
		if inv:is_empty("rune1") then
			
			minetest.chat_send_all("plus de rune")
			swap_node(pos,"runes:socleOFF")
			return count
			
		end
		
		return 0
	
	end,
})

