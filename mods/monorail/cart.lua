-------------------------------------------------------------------------------
-- name: cart_onpunch_handler(self,hitter)
--
--! @brief move cart due to punch
--! @param self the cart itself
--! @param hitter person hitting cart
--
-------------------------------------------------------------------------------
function cart_onpunch_handler(self,hitter)
	local own_pos = self.object:getpos()
	local hitterpos = hitter:getpos()

	local distance = monorail_calc_distance(own_pos,hitterpos)
	--print("Distance: " .. distance .. " linkedplayer=" .. dump(self.linkedplayer))

	if (distance > 1.5) and
		self.linkedplayer == nil then
		--print("attaching player")
		self.linkedplayer = hitter
		hitter:set_attach(self.object,"",{x=0,y=0,z=0}, {x=0,y=0,z=0})
	else
		if self.linkedplayer ~= nil then
			self.linkedplayer = nil
			--print("detaching player")
			hitter:set_detach()
		else
			monorail_cart.punch_move(self,own_pos,hitterpos)
		end
	end

	return true
end


local texture = "monorail_cart_mesh.png"
local model = "monorail_cart.b3d"

if minetest.is_yes(minetest.setting_get("monorail_carts_mimicry")) then
	texture = "monorail_pa_cart.png"
	model = "monorail_pa_cart.x"
end

minetest.register_entity(":monorail:cart_ent", {
	physical = true,
	collisionbox = {-0.5,-0.5,-0.5, 0.5,0.5,0.5},
	visual = "mesh",
	textures        = { texture },
	mesh= model,
	visual_size     = {x=1,y=1,z=1},
	groups = { immortal=1, },
	on_step  = monorail_cart.onstep_handler,
	on_punch = cart_onpunch_handler,

	on_activate = function(self,staticdata)

		local restored = minetest.deserialize(staticdata)

		if restored ~= nil then

			if restored.lastpos ~= nil then
				self.last_known_good_pos = restored.lastpos
				self.object:moveto(self.last_known_good_pos)
				--print(tostring(self) .. " restoring position: " .. dump(restored.lastpos))
			end

			if restored.velocity ~= nil then
				self.last_speed = restored.velocity
				self.object:setvelocity(self.last_speed)
				--print(tostring(self) .. " restoring velocity: " .. dump(restored.velocity))
			end
		end
		self.object:setacceleration({x=0,y=SLIDERS_GRAVITY,z=0})
		self.last_speed = self.object:getvelocity()
		self.object:set_armor_groups(self.groups)

		self.set_animation(self,0)
	end,

	on_rightclick = function(self,clicker)
		--print("Info: "..detect_slider_type(self.object:getpos()).. " :",self.moving_up)
		clicker:get_inventory():add_item("main", "monorail:cart")
		self.object:remove()
	end,

	get_staticdata = function(self)

		local tostore = {}
		tostore.velocity = self.object:getvelocity()

		if self.soundhandle_moving ~= nil then
			minetest.sound_stop(self.soundhandle_moving)
			self.soundhandle_moving = nil
		end

		tostore.lastpos = self.last_known_good_pos

		local storestring = minetest.serialize(tostore)
		--print(tostring(self) .. " storing: " .. dump(storestring))
		return storestring
	end,

	moving_up = false,
	linkedplayer = nil,

	lastanimation = -1,

	set_animation = function(self,animation)
		if minetest.is_yes(minetest.setting_get("monorail_carts_mimicry")) then

		else
			if lastanimation ~= animation then
				self.object:set_animation({	x=(animation * 10) + 1,
											y=(animation+1) * 10
											}, nil, nil)
				lastanimation = animation
			end
		end
	end

	})

