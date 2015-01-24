----------------- THIEF ------------------

if rawget(_G, "runes") then
	runes = runes
else
	runes = {}
end

runes.handlers["thief"].on_construct = function(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()

	meta:set_string("stolen_name","")
	meta:set_string("infotext", "Thief invocation!")
	meta:set_string("formspec",
		"size[7,2.5]"..
		"field[1,1;5,1;stolen_name;Player to steal from:;<player>]"..
		"button[5.8,0.7;1,1;improve;~]"
	)
end

runes.handlers["thief"].allow_metadata_inventory_put = function(pos)
	return 0
end

runes.handlers["thief"].allow_metadata_inventory_put = function(pos, listname, index, stack, player)
	if runes.get_xp(player:get_player_name()) >= 90 then
		return stack:get_count()
	else
		core.chat_send_player(player:get_player_name(), "You don't have enough experience young magician..")
		return 0
	end
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
		return
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
