------------ NECROMANCER ----------
if rawget(_G, "runes") then
	runes = runes
else
	runes = {}
end

runes.random_monsters = {
	"animal_vombie:vombie",
	"animal_creeper:creeper",
	"mob_oerkki:oerkki",
	"animal_dm:dm",
	"animal_big_red:big_red"
}

runes.handlers["necromancer"].on_construct = function(pos)
	local meta = minetest.get_meta(pos)
	local inv  = meta:get_inventory()
	local alea = math.floor(math.random(1,5))
	alea = 4
	print(alea)
	minetest.remove_node(pos)
	minetest.add_node(pos, {name = "runes:table_empty"})

	if alea == 0 then
		pos.y = pos.y + 1
		for i = -5,5 do
			for u = -5,5 do
				pos.x = pos.x + i
				pos.z = pos.z + u
			
				if math.random(1,10) <= 4 and minetest.get_node(pos).name == "air" then
					minetest.add_entity(pos,"animal_vombie:vombie")
				end

				pos.x = pos.x - i
				pos.z = pos.z - u
			end
		end
		pos.y = pos.y - 1
	elseif alea == 1 then
		pos.y = pos.y + 1
		for i = -2,2 do
			for u = -2,2 do
				pos.x = pos.x + i
				pos.z = pos.z + u
			
				if math.random(1,10) <= 1 and minetest.get_node(pos).name == "air" then
					minetest.add_entity(pos,"animal_creeper:creeper")
				end

				pos.x = pos.x - i
				pos.z = pos.z - u
			end
		end
		pos.y = pos.y - 1
	elseif alea == 2 then
		pos.y = pos.y + 1
		for i = -1,1 do
			for u = -1,1 do
				pos.x = pos.x + i
				pos.z = pos.z + u
			
				if math.random(1,10) <= 3 and minetest.get_node(pos).name == "air" then
					minetest.add_entity(pos,"mob_oerkki:oerkki")
				end

				pos.x = pos.x - i
				pos.z = pos.z - u
			end
		end
		pos.y = pos.y - 1
	elseif alea == 3 then
		pos.y = pos.y + 1
		for i = -1,1 do
			for u = -1,1 do
				pos.x = pos.x + i
				pos.z = pos.z + u
			
				if math.random(1,10) <= 1.7 and minetest.get_node(pos).name == "air" then
					minetest.add_entity(pos,"animal_dm:dm")
				end

				pos.x = pos.x - i
				pos.z = pos.z - u
			end
		end
		pos.y = pos.y - 1
	elseif alea == 4 then
		pos.y = pos.y + 1
		minetest.add_entity(pos,"animal_big_red:big_red")
		pos.y = pos.y - 1
	end
end
