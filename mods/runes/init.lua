------------------------------------------
------------------------------------------
------------------------------------------
------------------------------------------
-- Déclaration des runes
--

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
------------------------------------------
------------------------------------------
-- SOCLE A RUNE VIDE
--


-- Craft du socle à runes vide
--
minetest.register_craft({
	output = 'runes:socleOFF',
	recipe = {
		{'default:obsidian', "default:diamond", 'default:obsidian'},
		{"default:diamond", 'default:obsidian', "default:diamond"},
		{'default:obsidian', "default:diamond", 'default:obsidian'},
	}
})


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

