--------------- SMITH -----------------

if rawget(_G, "runes") then
	runes = runes
else
	runes = {}
end

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
