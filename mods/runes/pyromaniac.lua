------------ PYROMANIAC -----------

if rawget(_G, "runes") then
	runes = runes
else
	runes = {}
end

runes.handlers["pyromaniac"].on_construct = function(pos)
	local meta = minetest.get_meta(pos)
	local inv  = meta:get_inventory()
	
	pos.y = pos.y + 1
	minetest.add_item(pos,"fire:basic_flame 20")
	minetest.add_item(pos,"flint:lighter")
	pos.y = pos.y - 1

	meta:set_string("infotext","Fire invocation!")
	meta:set_string("formspec",nil)
	
	minetest.remove_node(pos)
	minetest.add_node(pos, {name = "runes:table_empty"})
	
	for dx = -5,5 do
		for dy = -5,5 do
			for dz = -5,5 do
				pos.x = pos.x + dx
				pos.y = pos.y + dy
				pos.z = pos.z + dz
	
				if minetest.get_node(pos).name == "air" then
					minetest.add_node(pos, {name = "fire:basic_flame"})
				end

				pos.x = pos.x - dx
				pos.y = pos.y - dy
				pos.z = pos.z - dz
			end
		end
	end
end
