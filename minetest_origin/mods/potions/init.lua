local MOD_NAME = minetest.get_current_modname()
   local MOD_PATH = minetest.get_modpath(MOD_NAME)
   local Vec3 = dofile(MOD_PATH.."/lib/Vec3_1-0.lua")

potions = {}


function potions.register_potion(iname, color, exptime, action, expaction)
	local rname = string.gsub(iname, "[-%[%]()1023456789 ]", "")
	minetest.register_craftitem(minetest.get_current_modname()..":"..rname:lower(), {
		description = iname.." Potion",
		inventory_image = "potions_bottle.png^potions_"..color..".png",

		on_place = function(itemstack, user, pointed_thing)
			local cnt = 0
			if user:hud_get(0) and user:hud_get(1) and user:hud_get(2) and user:hud_get(3) then
				user:hud_remove(0)
				user:hud_remove(1)
				user:hud_remove(2)
				user:hud_remove(3)
				samepotion = false
			end
			local length1 = exptime+iname:len()
			local potions_hud_1 = user:hud_add( {
				hud_elem_type = "statbar",
				position = {x=0.206, y=0.009},
				name = "Potions HUD BG",
				scale = {x=1, y=1},
				number = length1*2+1,
				text = "potions_hud_bg.png",
			})
			local length2 = iname:len()/100
			local potions_hud_2 = user:hud_add( {
				hud_elem_type = "statbar",
				position = {x=0.206+length2, y=0.015},
				name = "Potions HUD COUNTER",
				scale = {x=1, y=1},
				number = exptime,
				text = "potions_hud_stat.png",
			})
			
						
			local potions_hud_3 = user:hud_add( {
				hud_elem_type = "text",
				position = {x=0.21, y=0.01},
				number = 0xFFFFFF,
				name = "POTIONS HUD TEXT",
				text = iname..":",
				scale = {x=100, y=100},
			})
			
			local potions_hud_4 = user:hud_add( {
				hud_elem_type = "image",
				position = {x=0.18, y=0.008},
				name = "POTIONS HUD BOTTLE",
				text = "potions_bottle.png^potions_"..color..".png",
				scale = {x=1, y=1},
			})
				local player = user

				local function timer(cnt, player)
					if cnt <= exptime and samepotion == true then
						player:hud_change(1, number, exptime-cnt)
						minetest.after(1, timer, cnt+1, player)
					else
						user:hud_remove(0)
						user:hud_remove(1)
						user:hud_remove(2)
						user:hud_remove(3)
						cnt = 0					
					end
				end
			samepotion = true
			timer(cnt, player)

			action(itemstack, user, pointed_thing)
  			 minetest.after(exptime, expaction, itemstack, user, pointed_thing)
  			 minetest.after(exptime, function(user)
					if user:hud_get(0) and user:hud_get(1) and user:hud_get(2) and user:hud_get(3) then
						user:hud_remove(0)
						user:hud_remove(1)
						user:hud_remove(2)
						user:hud_remove(3)
						cnt = 0
					end
				end, player)
				
  			 itemstack:take_item()
			--Particle Code
			--Potions Particles
			minetest.add_particlespawner(30, 0.2,
				pointed_thing.above, pointed_thing.above,
				{x=1, y= 2, z=1}, {x=-1, y= 2, z=-1},
				{x=0.2, y=0.2, z=0.2}, {x=-0.2, y=0.5, z=-0.2},
				5, 10,
				1, 3,
				false, "potions_"..color..".png")
  			 
  			 --Shatter Particles
  			 minetest.add_particlespawner(40, 0.1,
				pointed_thing.above, pointed_thing.above,
				{x=2, y=0.2, z=2}, {x=-2, y=0.5, z=-2},
				{x=0, y=-6, z=0}, {x=0, y=-10, z=0},
				0.5, 2,
				0.2, 5,
				true, "potions_shatter.png")
				
				local dir = Vec3(user:get_look_dir()) *20
				minetest.add_particle(
				{x=user:getpos().x, y=user:getpos().y+1.5, z=user:getpos().z}, {x=dir.x, y=dir.y, z=dir.z}, {x=0, y=-10, z=0}, 0.2,
					6, false, "potions_bottle.png^potions_"..color..".png")
			return itemstack
			
		end,
	})
end


minetest.register_craftitem("potions:glass_bottle", {
		description = "Glass Bottle",
		inventory_image = "potions_bottle.png",
		on_place = function(itemstack, user, pointed_thing)
			itemstack:take_item()
  			 --Shatter Particles
  			 minetest.add_particlespawner(40, 0.1,
   		 pointed_thing.above, pointed_thing.above,
   		 {x=2, y=0.2, z=2}, {x=-2, y=0.5, z=-2},
   		 {x=0, y=-6, z=0}, {x=0, y=-10, z=0},
   		 0.5, 2,
   		 0.2, 5,
  			 true, "potions_shatter.png")
		local dir = Vec3(user:get_look_dir()) *20
				minetest.add_particle(
				{x=user:getpos().x, y=user:getpos().y+1.5, z=user:getpos().z}, {x=dir.x, y=dir.y, z=dir.z}, {x=0, y=-10, z=0}, 0.2,
					6, false, "potions_bottle.png")
			return itemstack
		end,
})


