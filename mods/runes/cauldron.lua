-- Cauldron --

runes.cauldron_formspec =
	"size[8,9]"..
	"image[2,2;1,1;runes_cauldron_side.png]"..
	"list[current_name;potion;2,3;1,1;]"..
	"list[current_name;input;2,1;1,1;]"..
	"list[current_name;output;5,1;2,2;]"..
	"list[current_player;main;0,5;8,4;]"
	

runes.cauldron_crafts = {
 -- {"foo:input_item","foo:potion_item","foo:output_item"}	
	{"farming:pumpkin","magic:potion_basic","potionspack:healthi"},
	{"default:coal_lump","potionspack:healthii","potionspack:healthi"},
	{"nether:glowstone_dust","potionspack:harmingi","potionspack:healthi"},
	{"nether:glowstone_dust","potionspack:healthi","potionspack:healthii"},
	{"nether:glowstone_dust","potionspack:harmingii","potionspack:healthii"},
}

------------------------------------------------------------------------------
-- Fonctions utiles pour la détection des crafts

runes.is_a_potion_item = function (itemstring)
	local is_potion = false
	for _,row in ipairs(runes.cauldron_crafts) do
		-- If the itemname is listes as a potion item, set true
		if itemstring == row[2] then
			is_potion = true
		end
	end
	return is_potion
end

runes.is_a_input_item = function (itemstring)
	local is_input = false
	for _,row in ipairs(runes.cauldron_crafts) do
		-- If the itemname is listed as an input item, set true
		if itemstring == row[1] then
			is_input = true
		end
	end
	return is_input
end

runes.is_a_output_item = function (itemstring)
	local is_output = false
	for _,row in ipairs(runes.cauldron_crafts) do
		-- If the itemname is listed as an output item, set true
		if itemstring == row[3] then
			is_output = true
		end
	end
	return is_output
end



minetest.register_node("runes:cauldron", {
	description = "Cauldron",
	--drawtype = "mesh",
	--mesh = "untitled.blend",
	tiles = {"runes_cauldron_top_inactive.png","runes_cauldron_side.png^[colorize:#000000","runes_cauldron_side.png"},
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", runes.cauldron_formspec)
		meta:set_string("infotext", "Chaudron")
		meta:set_int("tick",0)
		meta:set_string("status","disabled")
		
		local inv = meta:get_inventory()
		inv:set_size("output", 1)
		inv:set_size("input", 1)
		inv:set_size("potion", 1)
	end,

	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("output") then
		  return false
		elseif not inv:is_empty("tool") then
		  return false
		elseif not inv:is_empty("input") then
		  return false
		end
		return true
	end,
		
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if (listname == "input" and runes.is_a_input_item(stack:get_name()))
			or (listname == "potion" and runes.is_a_potion_item(stack:get_name())) then
			return stack:get_count()
		else
			return 0
		end
	end,
	  
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		
		if listname == "potion" and inv:is_empty("potion") then
			if inv:is_empty("input") then
				meta:set_string("infotext","Chaudron vide")
			else
				meta:set_string("infotext","Aucune potion presente!")
			end
		elseif listname == "input" and inv:is_empty("input") then
			if inv:is_empty("potion") then
				meta:set_string("infotext","Chaudron")
			else
				meta:set_string("infotext","Aucun item a verser dans la potion!")
			end
		end
	end,	
	groups = {oddly_breakable_by_hand = 2},
})

minetest.register_abm({
	nodenames = {"runes:cauldron"},
	interval = 1,
	chance = 1,
	action = function(pos)
		
		local meta = minetest.get_meta(pos)
		local inv 	= meta:get_inventory()
		
		local oldstate = meta:get_string("status")
		
		-- Update State --
		print("check")
		if not inv:is_empty("input") and not inv:is_empty("potion")
			and inv:is_empty("output") then
			meta:set_string("status","enabled")
			if oldstate ~= "enabled" then
				print("changed")
			end
		else
			meta:set_string("status","disabled")
			if oldstate ~= "disabled" then
				print("changed, again")
			end
		end
	end,
})
