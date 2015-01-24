---------------------------------------------------------------------------
-------------------------------RUNES---------------------------------------
--	Runes, un mod par turbogus, revisité par Mg et Ataron				 --
---------------------------------------------------------------------------
---------------------------------------------------------------------------

-- Runes : Déclaration récursive grâce à un tableau des runes.
-- Les runes de base pour mes tests seront les suivantes :
---> Smith, Forgeron, la première rune : réparer(/upgrader) des outils.
---> Thief, Voleur, voir dans l'inventaire "main" d'un joueur connecté quelconque.
-----> Si assez de XP, prendre au hasard un item à un joueur du serveur dans un de ses inventaires.
---> Assassin, Assassin, infliger des dégâts laissant le joueurs à 1/2 coeur.
---> Pyromaniac, Pyromane, allumer le feu à la position d'un joueur
---> Necromancer, Nécromancien, invoquer un monstre au hasard
---> Mortis Angelum, L'Ange de la Mort, tuer toutes les entités joueurs/animales/monstres dans un rayon de 100 blocs
---- Les plus violentes de ces runes coûteront au joueur d'énormes sommes, des items, et ne seront sûrement pas gardées.

if not rawget(_G, "runes") then
	runes = {}
end

-- Fields initialization
runes.handlers = {["smith"] = {},["thief"] = {},["assassin"] = {},["pyromaniac"] = {},
					["necromancer"] = {},["mortisangelum"] = {}}

runes.runes = {
	{"smith"		,"Rune du Forgeron"			,"#00FF00"},
	{"thief"		,"Rune du Voleur"			,"#667722"},
	{"assassin"		,"Rune de l'Assassin"		,"#888888"},
	{"pyromaniac"	,"Rune du Pyromane"			,"#FFBB11"},
	{"necromancer"	,"Rune du Necromancien"		,"#660000"},
	{"mortisangelum","Rune de l'Ange de la Mort","#222222"},
}

runes.needed_xp = {
	["smith"]			= 10,
	["thief"] 			= 250,
	["assassin"] 		= 300,
	["pyromaniac"] 		= 2000,
	["necromancer"]	 	= 8000,
	["mortisangelum"] 	= 60000
}

-- Loading modules
dofile(minetest.get_modpath("runes").."/util.lua")
dofile(minetest.get_modpath("runes").."/cauldron.lua")

------------------------------------------------------------------------
------------------------------------------------------------------------
---- TABLES
----

-- Enregistrement de la table vide.
minetest.register_node ("runes:table_empty", {
	description = "Table d'enchantement vide",
	tiles = {"default_cobble.png"},
	groups = {oddly_breakable_by_hand = 2},
	drawtype = "nodebox",
	paramtype = "light",
	light_source = 8,
	node_box = {
		type = 'fixed',
		fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
	},
	-- TODO: Remplacer le système d'inventaire par un push?
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv  = meta:get_inventory()
		
		meta:set_string("infotext","Viens a moi apprenti(e) magicien(ne)...")
		meta:set_string("formspec",
			"size[10,7]"..
			"list[context;ginput;4,1;1,1;]"..
			"list[current_player;main;1,3;8,4]"
		)
		inv:set_size("ginput",1*1)
		inv:set_size("main",8*4)
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if minetest.registered_items[stack:get_name()]
			and minetest.registered_items[stack:get_name()].groups["runes"] then

			local code = stack:get_name():split(":")[2]:split("_")[2]
			local xp = runes.get_xp(player:get_player_name())
			if xp < runes.needed_xp[code] then
				core.chat_send_player(player:get_player_name(),"You're not experimented enough to use that spell...")
				core.chat_send_player(player:get_player_name(),"You need ".. runes.needed_xp[code] .."XP.")
				return 0
			else
				runes.set_xp(player:get_player_name(),xp - runes.needed_xp[code])
				return stack:get_count()
			end
		else
			return 0
		end
	end,
	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		local code = stack:get_name():split(":")[2]:split("_")[2]
		local node = minetest.get_node(pos)
		
		minetest.remove_node(pos)
		minetest.add_node(pos,{name = "runes:table_"..code})
	end,
})
		
for _, row in ipairs(runes.runes) do
	local code = row[1] -- Code d'identification de la rune
	local desc = row[2] -- Description de la rune
	local colo = row[3] -- Couleur associée
	
	-- Load handlers
	dofile(minetest.get_modpath("runes").."/".. code ..".lua")
	
	-- Registering item : rune
	minetest.register_craftitem("runes:rune_"..code, {
		description = desc,
		inventory_image = "runes_rune_"..code..".png",
		groups = {runes = 1}
	})
	
	-- Registering node : table d'enchantement
	minetest.register_node("runes:table_"..code, {
		description = "Table d'enchantement active",
		tiles = {"(table_active_top.png^[colorize:"..colo..")^table_active_top.png","table_active_bottom.png","table_active_side.png"},
		groups = {oddly_breakable_by_hand = 2},
		drawtype = "nodebox",
		paramtype = "light",
		light_source = 8,
		node_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
		},
		on_construct 					= runes.handlers[code].on_construct or nil,
		allow_metadata_inventory_put	= runes.handlers[code].allow_metadata_inventory_put or nil,
		allow_metadata_inventory_take	= runes.handlers[code].allow_metadata_inventory_take or nil,
		can_dig 						= runes.handlers[code].can_dig or nil,
		on_receive_fields 				= runes.handlers[code].on_receive_fields or nil,
		on_metadata_inventory_take 		= runes.handlers[code].on_metadata_inventory_take or nil,
		drop = "runes:table_empty",
	})
end
