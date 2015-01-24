-------- DEATH'S ANGEL ------------

if rawget(_G, "runes") then
	runes = runes
else
	runes = {}
end

runes.handlers["mortisangelum"].on_construct = function(pos)
	minetest.set_timeofday(0)
	minetest.setting_set("time_speed", 0)
	core.chat_send_all("Mortis Angelum sum, et destructori mundi!")

	for _,k in pairs(minetest.get_connected_players()) do
		minetest.remove_node(k:getpos())
		minetest.add_node(k:getpos(),{name = "tnt:tnt_burning"})
		boom(k:getpos(),0)
		for i=1,k:get_inventory():get_size("main") do
			k:get_inventory():set_stack("main", i, nil)
		end
		for i=1,k:get_inventory():get_size("craft") do
			k:get_inventory():set_stack("craft", i, nil)
		end
		for i=1,k:get_inventory():get_size("craftpreview") do
			k:get_inventory():set_stack("craftpreview", i, nil)
		end
		k:set_hp(0)
	end
	minetest.remove_node(pos)
	for dx=-10,10 do
		for dz=-10,10 do
			for dy=10,-10,-1 do
				pos.x = pos.x+dx
				pos.y = pos.y+dy
				pos.z = pos.z+dz
				
				if math.abs(dx)<2 and math.abs(dy)<2 and math.abs(dz)<2 then
					minetest.remove_node(pos)
				else
					if math.random(1,10) <= 9 then
						minetest.remove_node(pos)
					end
				end
				
				pos.x = pos.x-dx
				pos.y = pos.y-dy
				pos.z = pos.z-dz
			end
		end
	end
end
