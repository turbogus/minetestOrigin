---------------------------------------------------------------------------
-------------------------------RUNES---------------------------------------
--	Runes, un mod par turbogus, revisité par Mg et Ataron				 --
---------------------------------------------------------------------------
---------------------------------------------------------------------------

-- Runes : Déclaration récursive grâce à un tableau des runes.
-- Les runes de base pour mes tests seront les suivantes :
---> Smith, Forgeron, la première rune : réparer/upgrader des outils.
---> Thief, Voleur, voir dans l'inventaire "main" d'un joueur connecté quelconque.
-----> Si assez de XP, prendre au hasard un item à un joueur du serveur dans un de ses inventaires.
---> Assassin, Assassin, infliger des dégâts pouvant laisser le joueurs à 1/2 coeur.
---> Pyromaniac, Pyromane, allumer le feu à la position d'un joueur
---> Necromancer, Nécromancien, invoquer un monstre au hasard
---> Mortis Angelum, L'Ange de la Mort, tuer toutes les entités joueurs/animales/monstres dans un rayon de 100 blocs
---- Les plus violentes de ces runes coûteront au joueur d'énormes sommes, des items, et ne seront sûrement pas gardées.

runes = {}

-- Loading modules
dofile(minetest.get_modpath("runes").."/cauldron.lua")

runes.runes = {
	{"smith","Rune du Forgeron","#00FF00"},
	{"thief","Rune du Voleur","#667722"},
	{"assassin","Rune de l'Assassin","#888888"},
	{"pyromaniac","Rune du Pyromane","#FFBB11"},
	{"necromancer","Rune du Nécromancien","#660000"},
	{"mortisangelum","Rune de l'Ange de la Mort","#222222"},
}

-- Fields initialization
runes.handlers = {}

-- Handlers' tables
runes.handlers.smith = {}
runes.handlers.thief = {}
runes.handlers.assassin = {}
runes.handlers.pyromaniac = {}
runes.handlers.necromancer = {}
runes.handlers.mortisangelum = {}

-- On construct handlers
runes.handlers.smith.on_construct = function(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()

	meta:set_string("infotext", "Smith invocation!")
	meta:set_string("formspec",
		"size[10,8]"..
		"list[context;smith_input;4.5,1;1,1]"..
		"list[current_player;main;1,3;8,4]"..
		"button[6,1;1,1;improve;~]"
	)
	inv:set_size("smith_input",1*1)
	inv:set_size("main",4*8)
end

runes.handlers.smith.allow_metadata_inventory_put = function (pos, listname, index, stack, player)
	if minetest.registered_tools[stack:get_name()] then
		return stack:get_count()
	else
		return 0
	end
end

runes.handlers.smith.can_dig = function (pos, player)
	local meta = minetest.get_meta(pos)
	local inv  = meta:get_inventory()

	return inv:is_empty("smith_input")
end

runes.handlers.smith.on_receive_fields = function (pos, formname, fields, sender)
	table.foreach(fields, print)
	local meta = minetest.get_meta(pos)
	local inv  = meta:get_inventory()
	
	if fields.improve then
		local t_stack = inv:get_list("smith_input")[1]
		local xp = io.open(minetest.get_worldpath().."/"..sender:get_player_name().."_experience", "r")
		local experience = xp:read("*l")+0
		if t_stack:get_wear() == 0 then
			core.chat_send_player(sender:get_player_name(),"You don't need to use this spell, the tool is brand new..")
			return
		end
		-- Tool's properties
		-- table.foreach(minetest.registered_tools[t_stack:get_name()]["tool_capabilities"].groupcaps.cracky,print)
		local crack_xp = math.ceil(minetest.registered_tools[t_stack:get_name()]["tool_capabilities"].groupcaps.cracky.uses + 
			(minetest.registered_tools[t_stack:get_name()]["tool_capabilities"].groupcaps.cracky.times[3] *
				minetest.registered_tools[t_stack:get_name()]["tool_capabilities"].groupcaps.cracky.maxlevel))
		

		print(crack_xp)
		print(t_stack:get_wear())
		print(t_stack:get_wear()%(65535/crack_xp))
		if experience < 65535/math.ceil(crack_xp * t_stack:get_wear()%(65535/crack_xp)) then
			core.chat_send_player(sender:get_player_name(),"Sorry, you don't have enough experience to use that spell young magician...")
			return
		end
		
		local new_wear = t_stack:get_wear() - (65535/crack_xp)
		if new_wear < 0 then new_wear = 0 end
		t_stack:set_wear(new_wear)
		print(t_stack:get_wear())
		inv:set_list("smith_input", {[1] = t_stack})
		local new_xp = experience - 50
		xp:write(new_xp)
		xp:close()
		
		--Mise à jour du HUD avec les nouveaux points d'XP
		local nom = sender:get_player_name()
		if xpHUD[nom] then
			sender:hud_change(xpHUD[nom].id, "text","XP :"..new_xp.."")
		end
	elseif fields.quit then
		if not inv:is_empty("smith_input") then
			local inv_stack = inv:get_list("smith_input")[1]
			minetest.add_item({x = pos.x, y = pos.y + 1, z = pos.z}, {name = inv_stack:get_name(), wear = inv_stack:get_wear()})
		end
		minetest.remove_node(pos)
		minetest.add_node(pos,{name = "runes:table_empty"})
	end
end

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
			return stack:get_count()
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
	-- COMING SOON --
	
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
		on_construct = runes.handlers.smith.on_construct,
		allow_metadata_inventory_put = runes.handlers.smith.allow_metadata_inventory_put,
		can_dig = runes.handlers.smith.can_dig,
		on_receive_fields = runes.handlers.smith.on_receive_fields,
		drop = "runes:table_empty",
	})
end
