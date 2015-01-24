------------ ASSASSIN -------------

if rawget(_G, "runes") then
	runes = runes
else
	runes = {}
end

runes.handlers["assassin"].on_construct = function(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()

	meta:set_string("victim_name","")
	meta:set_string("infotext", "Assassin invocation!")
	meta:set_string("formspec",
		"size[7,2.5]"..
		"field[1,1;5,1;victim_name;Player to attack:;<player>]"..
		"button[5.8,0.7;1,1;improve;~]"
	)
end

runes.handlers["assassin"].on_receive_fields = function(pos, formname, fields, sender)
	--table.foreach(fields, print)
	local meta = minetest.get_meta(pos)
	local inv  = meta:get_inventory()
	local sender_name = sender:get_player_name()
	
	if fields.quit and not fields.victim_name then
		minetest.remove_node(pos)
		minetest.add_node(pos,{name = "runes:table_empty"})
		return
	elseif fields.victim_name and (fields.victim_name == "<player>" or victim_name == "") then
		core.chat_send_player(sender:get_player_name(),"Enter a name young magician...")
		return
	elseif fields.victim_name then
		local is_player_found = minetest.get_player_by_name(fields.victim_name)
		if is_player_found == nil then
			core.chat_send_player(sender_name, "Sorry young magician.. There is no such player connected right now...")
			return
		end
		
		core.chat_send_player(sender_name, "This player have been put under your spell, mouhaha!")
		is_player_found:set_hp(1)
		sender:set_hp(math.ceil(sender:get_hp()/2))
		meta:set_string("formspec","size[3,1.5]".."label[0.2,0.2;Player damaged.]".."label[0.2,0.8;Press esc or return.")
	end
end
