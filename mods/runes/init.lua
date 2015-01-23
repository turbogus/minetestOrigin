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

-- XP function
function runes.get_xp(playername)
	local xp = io.open(minetest.get_worldpath().."/"..playername.."_experience", "r")
	local experience = xp:read("*l")+0
	xp:close()
	return experience
end

function runes.set_xp(playername, value)
	local xp = io.open(minetest.get_worldpath().."/"..playername.."_experience", "w")
	xp:write(value)
	xp:close()
	
	--Mise à jour du HUD avec les nouveaux points d'XP
	if xpHUD[playername] then
		minetest.get_player_by_name(playername):hud_change(xpHUD[playername].id, "text","XP :"..value.."")
	end
end

-- Fields initialization
runes.handlers = {["smith"] = {},["thief"] = {},["assassin"] = {},["pyromaniac"] = {},
					["necromancer"] = {},["mortisangelum"] = {}}

--------------- SMITH -----------------
runes.handlers["smith"].on_construct = function(pos)
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

runes.handlers["smith"].allow_metadata_inventory_put = function (pos, listname, index, stack, player)
	if minetest.registered_tools[stack:get_name()] then
		return stack:get_count()
	else
		return 0
	end
end

runes.handlers["smith"].can_dig = function (pos, player)
	local meta = minetest.get_meta(pos)
	local inv  = meta:get_inventory()

	return inv:is_empty("smith_input")
end

runes.handlers["smith"].on_receive_fields = function (pos, formname, fields, sender)
	local meta = minetest.get_meta(pos)
	local inv  = meta:get_inventory()
	
	if fields.improve then
		local t_stack = inv:get_list("smith_input")[1]
		local thief_name = sender:get_player_name()
		local experience = runes.get_xp(thief_name)
		if t_stack:get_wear() == 0 then
			core.chat_send_player(sender:get_player_name(),"You don't need to use this spell, the tool is brand new..")
			return
		end
		-- Tool's properties
		-- table.foreach(minetest.registered_tools[t_stack:get_name()]["tool_capabilities"].groupcaps.cracky,print)
		local group = minetest.registered_tools[t_stack:get_name()]["tool_capabilities"].groupcaps.cracky
			or minetest.registered_tools[t_stack:get_name()]["tool_capabilities"].groupcaps.crumbly
			or minetest.registered_tools[t_stack:get_name()]["tool_capabilities"].groupcaps.choppy
			or minetest.registered_tools[t_stack:get_name()]["tool_capabilities"].groupcaps.snappy
		local crack_xp = math.ceil(group.uses + (group.times[3] * group.maxlevel))
		
		if experience < 65535/math.ceil(crack_xp * t_stack:get_wear()%(65535/crack_xp)) then
			core.chat_send_player(sender:get_player_name(),"Sorry, you don't have enough experience to use that spell young magician...")
			return
		end
		
		local new_wear = t_stack:get_wear() - (65535/crack_xp)
		if new_wear < 0 then new_wear = 0 end
		t_stack:set_wear(new_wear)
		inv:set_list("smith_input", {[1] = t_stack})
		local new_xp = experience - 50
		print(new_xp)
		runes.set_xp(thief_name, new_xp)
		
	elseif fields.quit then
		if not inv:is_empty("smith_input") then
			local inv_stack = inv:get_list("smith_input")[1]
			minetest.add_item({x = pos.x, y = pos.y + 1, z = pos.z}, {name = inv_stack:get_name(), wear = inv_stack:get_wear()})
		end
		minetest.remove_node(pos)
		minetest.add_node(pos,{name = "runes:table_empty"})
	end
end

----------------- THIEF ------------------
runes.handlers["thief"].on_construct = function(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()

	meta:set_string("stolen_name","")
	meta:set_string("infotext", "Thief invocation!")
	meta:set_string("formspec",
		"size[7,2.5]"..
		"field[1,1;5,1;stolen_name;Player to steal to:;<player>]"..
		"button[5.8,0.7;1,1;improve;~]"
	)
end

runes.handlers["thief"].allow_metadata_inventory_put = function(pos)
	return 0
end

runes.handlers["thief"].on_metadata_inventory_take = function(pos, listname, index, stack, player)
	local meta = minetest.get_meta(pos)
	local inv  = meta:get_inventory()
	local playername 	= player:get_player_name()
	local stolen_name 	= meta:get_string("stolen_name")
	local stolen_inv	= minetest.get_player_by_name(stolen_name):get_inventory()
	local thief_inv		= player:get_inventory()
	
	runes.set_xp(playername, runes.get_xp(playername) - 90)
	stolen_inv:remove_item("main",stack)
end

runes.handlers["thief"].on_receive_fields = function (pos, formname, fields, sender)
	-- table.foreach(fields, print)
	local meta = minetest.get_meta(pos)
	local inv  = meta:get_inventory()

	if fields.quit then
		minetest.remove_node(pos)
		minetest.add_node(pos,{name = "runes:table_empty"})
	elseif fields.stolen_name and (fields.stolen_name == "<player>" or stolen_name == "") then
		core.chat_send_player(sender:get_player_name(),"Enter a name young magician...")
		return
	elseif fields.stolen_name then
		local found_qm = false
		local sender_name = sender:get_player_name()
		for k,v in pairs(minetest.get_connected_players()) do
			if v:get_player_name() == fields.stolen_name then
				found_qm = true
			end
		end

		if not found_qm then
			core.chat_send_player(sender_name,"There is no such player young magician...")
			return
		end

		core.chat_send_player(sender_name,"Do as if you were home...")
		
		local experience = runes.get_xp(sender_name)
		runes.set_xp(sender_name, experience - 70)
		
		meta:set_string("formspec",
			"size[10,9]"..
			"list[context;stolen_main;1,0.5;8,4]"..
			"list[current_player;main;1,5;8,4]"
		)
		inv:set_size("stolen_main", 8*4)
		
		local target = minetest.get_player_by_name(fields.stolen_name)
		local stolen_inv = target:get_inventory()
		local stolen_buf = stolen_inv:get_list("main")
		inv:set_list("stolen_main",stolen_buf)
		meta:set_string("stolen_name",fields.stolen_name)
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
		can_dig 						= runes.handlers[code].can_dig or nil,
		on_receive_fields 				= runes.handlers[code].on_receive_fields or nil,
		on_metadata_inventory_take 		= runes.handlers[code].on_metadata_inventory_take or nil,
		drop = "runes:table_empty",
	})
end
