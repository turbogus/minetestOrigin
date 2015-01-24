
-- list pour l'affichage des pts d'Xp dans le hud
xpHUD = {}


--[[level1 = 100
level1_drop = "default:steelblock 10"

level2 = 200
level2_drop = "default:steelblock 99"

level3 = 300
level3_drop = "default:mese 1"

level4 = 400
level4_drop = "default:mese 2"

level5 = 500
level5_drop = "default:mese 10"

level6 = 700
level6_drop = "default:mese 20"

level7 = 1000
level7_drop = "default:mese 30"

level8 = 1400
level8_drop = "default:mese 50"

level9 = 1800
level9_drop = "default:mese 70"

level10 = 2500
level10_drop = "default:mese 99"
]]--

level1 = 100
level1_drop ="default:copperblock 3"

level2 = 200
level2_drop = "default:steelblock 4"

level3 = 400
level3_drop = "default:goldblock 4"

level4 = 800
level4_drop = "default:diamondblock 6"

level5 = 1500
level5_drop = "default:mese 10"

level6 = 3000
level6_drop = "default:diamondblock 20"

level7 = 6500
level7_drop = "runes:septre"

level8 = 12800
level8_drop = "runes:death_hammer"

level9 = 25600
level9_drop = "nether:nether_pearl"

level10 = 51200
level10_drop = "nether:nether_book"
 



--add an experience orb if player digs node from xp group
minetest.register_on_dignode(function(pos, oldnode, digger)
	namer = oldnode.name
	see_if_mineral = minetest.get_item_group(namer, "xp")
	if see_if_mineral > 0 then
		minetest.env:add_entity(pos, "experience:orb")
	end
end)



-- Création d'un élément HUD à la connexion du joueurs
-- affichage des point dans le hud a la connexion du joueur
--
minetest.register_on_joinplayer(function(player)

	minetest.after(0.5, function ( self )
	
		--on récupère le nom du joueur
		local nom = player:get_player_name()
	
	
		--lecture du fichier contenant les points d'Xp
		fichier = io.open(minetest.get_worldpath().."/"..player:get_player_name().."_experience", "r")
			experience = fichier:read("*l")
		fichier:close()
	
		--parametrage du hud
		xpHUD[nom] = {}
		xpHUD[nom].id = player:hud_add({
			hud_elem_type = "text",
			name = "XPbar",
			number = 0xFFFFFF,
			position = {x=1, y=1},
			offset = {x=-80, y=-30},
			direction = 0,
			text = "XP :"..experience.."",
			alignment = {x=1, y=1},
	
		})
		
	end)
	
end)


-- Réinitialisation de l'élément HUD du joueur quand il quitte la partie
minetest.register_on_leaveplayer(function(player)
	xpHUD[player:get_player_name()] = nil
end)





--give a new player some xp
minetest.register_on_newplayer(function(player)
	file = io.open(minetest.get_worldpath().."/"..player:get_player_name().."_experience", "w")
	file:write("0")
	file:close()
end)

--set player's xp level to 0 if they die
--Modification : le joueur perd la moitié de ces Xp en mourrant
minetest.register_on_dieplayer(function(player)

	xp = io.open(minetest.get_worldpath().."/"..player:get_player_name().."_experience", "r")
				experience = xp:read("*l")
				xp:close()
				if experience ~= nil then
					new_xp = math.ceil(experience / 2)
					xp_write = io.open(minetest.get_worldpath().."/"..player:get_player_name().."_experience", "w")
					xp_write:write(new_xp)
					xp_write:close()
					
					--Mise à jour du HUD avec les nouveaux points d'XP
					local nom = player:get_player_name()
					if xpHUD[nom] then
						player:hud_change(xpHUD[nom].id, "text","XP :"..new_xp.."")
					end
				end
end)


--Allow people to collect orbs
minetest.register_globalstep(function(dtime)
	for _,player in ipairs(minetest.get_connected_players()) do
		local pos = player:getpos()
		pos.y = pos.y+0.5
		for _,object in ipairs(minetest.env:get_objects_inside_radius(pos, 1)) do
			if not object:is_player() and object:get_luaentity() and object:get_luaentity().name == "experience:orb" then
				--RIGHT HERE ADD IN THE CODE TO UPGRADE PLAYERS 
				object:setvelocity({x=0,y=0,z=0})
				object:get_luaentity().name = "STOP"
				minetest.sound_play("orb", {
					to_player = player:get_player_name(),
				})
				xp = io.open(minetest.get_worldpath().."/"..player:get_player_name().."_experience", "r")
				experience = xp:read("*l")
				xp:close()
				if experience ~= nil then
					new_xp = experience + 1
					xp_write = io.open(minetest.get_worldpath().."/"..player:get_player_name().."_experience", "w")
					xp_write:write(new_xp)
					xp_write:close()
					
					
					--Mise à jour du HUD avec les nouveaux points d'XP
					local nom = player:get_player_name()
					if xpHUD[nom] then
						player:hud_change(xpHUD[nom].id, "text","XP :"..new_xp.."")
					end
					
					
					
					
					
					if new_xp == level1 then
						minetest.env:add_item(pos, level1_drop)
						minetest.sound_play("level_up", {
							to_player = player:get_player_name(),
						})
					end
					if new_xp == level2 then
						minetest.env:add_item(pos, level2_drop)
						minetest.sound_play("level_up", {
							to_player = player:get_player_name(),
						})
					end
					if new_xp == level3 then
						minetest.env:add_item(pos, level3_drop)
						minetest.sound_play("level_up", {
							to_player = player:get_player_name(),
						})
					end	
					if new_xp == level4 then
						minetest.env:add_item(pos, level4_drop)
						minetest.sound_play("level_up", {
							to_player = player:get_player_name(),
						})
					end	
					if new_xp == level5 then
						minetest.env:add_item(pos, level5_drop)
						minetest.sound_play("level_up", {
							to_player = player:get_player_name(),
						})
					end	
					if new_xp == level6 then
						minetest.env:add_item(pos, level6_drop)
						minetest.sound_play("level_up", {
							to_player = player:get_player_name(),
						})
					end	
					if new_xp == level7 then
						minetest.env:add_item(pos, level7_drop)
						minetest.sound_play("level_up", {
							to_player = player:get_player_name(),
						})
					end	
					if new_xp == level8 then
						minetest.env:add_item(pos, level8_drop)
						minetest.sound_play("level_up", {
							to_player = player:get_player_name(),
						})
					end	
					if new_xp == level9 then
						minetest.env:add_item(pos, level9_drop)
						minetest.sound_play("level_up", {
							to_player = player:get_player_name(),
						})
					end	
					if new_xp == level10 then
						minetest.env:add_item(pos, level10_drop)
						minetest.sound_play("level_up", {
							to_player = player:get_player_name(),
						})
					end	
				end
				object:remove()
			end
		end
		for _,object in ipairs(minetest.env:get_objects_inside_radius(pos, 3)) do
			if not object:is_player() and object:get_luaentity() and object:get_luaentity().name == "experience:orb" then
				if object:get_luaentity().collect then
					local pos1 = pos
					pos1.y = pos1.y+0.2
					local pos2 = object:getpos()
					local vec = {x=pos1.x-pos2.x, y=pos1.y-pos2.y, z=pos1.z-pos2.z}
					vec.x = vec.x*3
					vec.y = vec.y*3
					vec.z = vec.z*3
					object:setvelocity(vec)
				end
			end
		end
	end
end)


minetest.register_entity("experience:orb", {
	physical = true,
	timer = 0,
	textures = {"orb.png"},
	visual_size = {x=0.3, y=0.3},
	collisionbox = {-0.17,-0.17,-0.17,0.17,0.17,0.17},
	on_activate = function(self, staticdata)
		self.object:set_armor_groups({immortal=1})
		self.object:setvelocity({x=0, y=1, z=0})
		self.object:setacceleration({x=0, y=-10, z=0})
	end,
	collect = true,
	on_step = function(self, dtime)
		self.timer = self.timer + dtime
		if (self.timer > 300) then
			self.object:remove()
		end
		local p = self.object:getpos()
		local nn = minetest.env:get_node(p).name
		noder = minetest.env:get_node(p).name
		p.y = p.y - 0.3
		local nn = minetest.env:get_node(p).name
		if not minetest.registered_nodes[nn] or minetest.registered_nodes[nn].walkable then
			if self.physical_state then
				self.object:setvelocity({x=0, y=0, z=0})
				self.object:setacceleration({x=0, y=0, z=0})
				self.physical_state = false
				self.object:set_properties({
					physical = false
				})
			end
		else
			if not self.physical_state then
				self.object:setvelocity({x=0,y=0,z=0})
				self.object:setacceleration({x=0, y=-10, z=0})
				self.physical_state = true
				self.object:set_properties({
					physical = true
				})
			end
		end
	end,
})


-- déclaration d'une orb d'XP en tant que node ( pour utilisation avec animals )
-- On récupère ainsi dans l'invente un item "orbs". Il faut le jeter par terre pui
-- taper dessus pour que le point d'XP soit prix en compte dans le compteur d'XP.
-- L'item est ensuite effaçé pour ne plus être réutilisé.
--
-- Orb donnant 1 pt d'XP
minetest.register_node("experience:orb_one", {
	
	description = "One orb experience.",
	drawtype = "plantlike",
	tile_images = {"orb.png"},
	inventory_image = "orb.png",
	walkable = false,
	paramtype = "light",
	sunlight_propagates = true,
	drop = "",
	groups = {fleshy=3, dig_immediate=3, xp=1},
})


-- Orb donnant 5 pts d'XP
minetest.register_node("experience:orb_five", {
	
	description = "Five orb experience.",
	drawtype = "plantlike",
	tile_images = {"orb_five.png"},
	inventory_image = "orb_five.png",
	walkable = false,
	paramtype = "light",
	sunlight_propagates = true,
	drop = "",
	groups = {fleshy=3, dig_immediate=3},
})
minetest.register_on_punchnode(function(p, node, player)
	if node.name == "experience:orb_five" then
		local pos = player:getpos()
		minetest.add_entity(pos,"experience:orb")
		minetest.add_entity(pos,"experience:orb")
		minetest.add_entity(pos,"experience:orb")
		minetest.add_entity(pos,"experience:orb")
		minetest.add_entity(pos,"experience:orb")
		
		
	end
end)


-- Orb donnant 10 pts d'XP
minetest.register_node("experience:orb_ten", {
	
	description = "Ten orb experience.",
	drawtype = "plantlike",
	tile_images = {"orb_ten.png"},
	inventory_image = "orb_ten.png",
	walkable = false,
	paramtype = "light",
	sunlight_propagates = true,
	drop = "",
	groups = {fleshy=3, dig_immediate=3},
})
minetest.register_on_punchnode(function(p, node, player)
	if node.name == "experience:orb_ten" then
		local pos = player:getpos()
		
		for i = 0, 9 do
			minetest.add_entity(pos,"experience:orb")
		end
		
	end
end)


-- Orb donnant 50 pts d'XP
minetest.register_node("experience:orb_fifty", {
	
	description = "Fifty orb experience.",
	drawtype = "plantlike",
	tile_images = {"orb_fifty.png"},
	inventory_image = "orb_fifty.png",
	walkable = false,
	paramtype = "light",
	sunlight_propagates = true,
	drop = "",
	groups = {fleshy=3, dig_immediate=3},
})
minetest.register_on_punchnode(function(p, node, player)
	if node.name == "experience:orb_fifty" then
		local pos = player:getpos()
		
		for i = 0, 49 do
			minetest.add_entity(pos,"experience:orb")
		end
		
	end
end)



--
-- Gestion du nether book pour la soustraction des pt d'experiences lors de 
-- sont utilisation
--
minetest.register_on_punchnode(function(p, node, player)
	
	if player:get_wielded_item():get_name() == "nether:nether_book" then
		
		-- Lecture du nombre de point d'experience du joueur
		xp_read = io.open(minetest.get_worldpath().."/"..player:get_player_name().."_experience", "r")
		experience = xp_read:read("*n")		--NB : on utilise ("*n") pour spécifier que l'on lit un nombre et pas un string
		xp_read:close()
		
		--TRANSFORMATION TREE EN NETHER TREE
		--
		if node.name == "default:tree" and experience > 0 then
		
			-- transformation du tree en nether_tree
			minetest.env:add_node(p,{name="nether:nether_tree"})
		
			-- on retire un 5 points d'experience au joueur	
			experience = experience - 5
		
			-- si après soustraction, le nombre de point est négatif, on mes à 0 et le joueur perd 1/2 point de vie !
			if experience <= 0 then
				experience = 0
				player:set_hp(player:get_hp()-0.5)
			end
		
			-- on écrit dans le fichier le nouveau nombre de point d'experience
			xp_write = io.open(minetest.get_worldpath().."/"..player:get_player_name().."_experience", "w")
			xp_write:write(experience)
			xp_write:close()
			
			--Mise à jour des points dans le hud
			--local nom = player:get_player_name()
			if xpHUD[player:get_player_name()] then
				player:hud_change(xpHUD[player:get_player_name()].id, "text","XP :"..experience.."")
			end

		end
		
		--TRANSFORMATION APPLE EN NETHER APPLE
		if node.name == "default:apple" and experience > 0 then
		
			-- transformation du tree en nether_tree
			minetest.env:add_node(p,{name="nether:nether_apple"})
		
			experience = experience - 5
		
			if experience <= 0 then
				experience = 0
				player:set_hp(player:get_hp()-0.5)
			end
		
			xp_write = io.open(minetest.get_worldpath().."/"..player:get_player_name().."_experience", "w")
			xp_write:write(experience)
			xp_write:close()
			
			if xpHUD[player:get_player_name()] then
				player:hud_change(xpHUD[player:get_player_name()].id, "text","XP :"..experience.."")
			end

		end
		
		if experience <= 0 then
			player:set_hp(player:get_hp()-0.5)
		end
		
	end

end)

-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------

-- Boite pour fe des enchantements !
--
--

-- Craft
--
minetest.register_craft({
	output = 'experience:magic_box',
	recipe = {
		{'default:obsidian', 'default:obsidian', 'default:obsidian'},
		{'default:steel_ingot', 'default:bookshelf', 'default:steel_ingot'},
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
	}
})


-- Déclaration du menu quand on 
-- clique sur le coffre
--
magic_box_formspec = 
	"size[8,9]"..
	--"image[2,2;1,1;default_furnace_fire_bg.png]"..
	"list[current_name;item;2,3;1,1;]"..
	"list[current_name;rune;2,1;1,1;]"..
	"list[current_name;transformation;5,1;2,2;]"..
	"list[current_player;main;0,5;8,4;]"


-- Déclaration du node
--
minetest.register_node("experience:magic_box", {
	description = "Coffre a Runes",
	tiles = {"default_obsidian.png", "default_steel_block.png", "default_steel_block.png",
		"default_steel_block.png", "default_steel_block.png", "default_bookshelf.png"},
	paramtype2 = "facedir",
	groups = {crumbly=3, falling_node=1, sand=1},
	legacy_facedir_simple = true,
	is_ground_content = false,
	
	-- Mise en forme de l'invente
	--
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", magic_box_formspec)
		meta:set_string("infotext", "Enchantement")
		local inv = meta:get_inventory()
		inv:set_size("item", 1)
		inv:set_size("rune", 1)
		inv:set_size("transformation", 1)
	end,
	
	--Peut-être pris seulement si l'invente est vide !
	--
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("item") then
			return false
		elseif not inv:is_empty("transformation") then
			return false
		elseif not inv:is_empty("rune") then
			return false
		end
		return true
	end,
	
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		if listname == "rune" then
			if minetest.get_craft_result({method="fuel",width=1,items={stack}}).time ~= 0 then
				if inv:is_empty("item") then
					meta:set_string("infotext","Aucune runes presentes!")
				end
				return stack:get_count()
			else
				return 0
			end
		elseif listname == "item" then
			return stack:get_count()
		elseif listname == "transformation" then
			return 0
		end
	end,
	
	--[[allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local stack = inv:get_stack(from_list, from_index)
		if to_list == "fuel" then
			if minetest.get_craft_result({method="fuel",width=1,items={stack}}).time ~= 0 then
				if inv:is_empty("src") then
					meta:set_string("infotext","Furnace is empty")
				end
				return count
			else
				return 0
			end
		elseif to_list == "src" then
			return count
		elseif to_list == "dst" then
			return 0
		end
	end,]]--
})









