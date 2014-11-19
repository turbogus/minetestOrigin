

monorail_cart = {}


-------------------------------------------------------------------------------
-- name:precheck_position(self,current_state)
--
--! @brief check current position
--
--! @param entity to apply changes
--
--! @return true/false
-------------------------------------------------------------------------------
function monorail_cart.precheck_position(self,current_state)
	if current_state.slidertype == "inv" or
		current_state.slidertype == "in_air" then
		--reset moving up flag
		self.moving_up = false

		--move to last known pos if not end of track
		if self.last_known_good_pos ~= nil then
			if not self.end_of_track and
				not end_of_track(current_state.pos,self.last_known_good_pos) then
				self.object:moveto(self.last_known_good_pos)
				self.object:setvelocity(self.last_speed)
				current_state.velocity = self.last_speed
				current_state.pos      = self.last_known_good_pos
			else
				--print("invalid pos but end of track")
				self.end_of_track = true
				return false
			end
		else
			--print("invalid pos but no goof pos known")
			return false
		end
	else
		self.last_known_good_pos = current_state.pos
	end
	self.end_of_track = false
	return true
end

-------------------------------------------------------------------------------
-- name: align_to_track(self,current_state)
--
--! @brief align movement to track
--
--! @param entity to apply changes
--! @param current_state current movement state
-------------------------------------------------------------------------------
function monorail_cart.align_to_track(self,current_state)
	if	current_state.slidertype == "x" or
		current_state.slidertype == "x+a" or
		current_state.slidertype == "x-a" then
		current_state.pos.z      = math.floor(current_state.pos.z + 0.5)
		current_state.pos.y      = math.floor(current_state.pos.y + 0.5)
		current_state.velocity.z = 0
	end

	if	current_state.slidertype == "z" or
		current_state.slidertype == "z+a" or
		current_state.slidertype == "z-a" then
		current_state.pos.x      = math.floor(current_state.pos.x + 0.5)
		current_state.pos.y      = math.floor(current_state.pos.y + 0.5)
		current_state.velocity.x = 0
	end
end

-------------------------------------------------------------------------------
-- name: update_moving_up_flag(self,slidertype)
--
--! @brief align movement to track
--
--! @param entity to apply changes
--! @param slidertype
-------------------------------------------------------------------------------
function monorail_cart.update_moving_up_flag(self,slidertype)
	if	slidertype == "x-u" or
		slidertype == "x+u" or
		slidertype == "z-u" or
		slidertype == "z+u" or
		slidertype == "x-b" or
		slidertype == "x+b" or
		slidertype == "z-b" or
		slidertype == "z+b" then

		--self.moving_up = true
		--print("Moving up: " .. slidertype)
	else
		--print("NOT Moving up: " .. slidertype)
		self.moving_up = false
	end
end

-------------------------------------------------------------------------------
-- name: handle_straight_move_up_down(self,current_state)
--
--! @brief handle straight movement up/down
--
--! @param entity to apply changes
--! @param current_state
--
--! @return true/false if handled by this fct
-------------------------------------------------------------------------------
function monorail_cart.handle_straight_move_up_down(self,current_state)

	local toinc_y = 0

	--moving from x direction up/down
	if (current_state.slidertype == "x-u" and current_state.pos.x >= current_state.xpos_rounded) or
		(current_state.slidertype == "x+u" and
		current_state.pos.x <= current_state.xpos_rounded) then
		toinc_y = 1 - math.abs((current_state.xpos_rounded - current_state.pos.x) *2)
		--self.set_animation(self,1)
		--print("moving x1, velocity: " .. dump(current_state.velocity))
	end

	if (current_state.slidertype == "x-b" and current_state.pos.x >= current_state.xpos_rounded) or
		(current_state.slidertype == "x+b" and current_state.pos.x <= current_state.xpos_rounded) then
		toinc_y = 1 - math.abs((current_state.pos.x - current_state.xpos_rounded) *2)
		toinc_y = toinc_y + fix_on_step_move_up_jitter(	current_state.slidertype,
														current_state.velocity,
														current_state.pos,
														current_state.xpos_rounded,
														current_state.zpos_rounded)
		--print("moving x2, velocity: " .. dump(current_state.velocity))
	end

	--moving z direction up/down
	if (current_state.slidertype == "z-u" and current_state.pos.z >= current_state.zpos_rounded) or
		(current_state.slidertype == "z+u" and current_state.pos.z <= current_state.zpos_rounded) then
		toinc_y = 1 - math.abs((current_state.zpos_rounded - current_state.pos.z) *2)
		--print("moving z1, velocity: " .. dump(current_state.velocity))
	end

	if (current_state.slidertype == "z-b" and current_state.pos.z >= current_state.zpos_rounded) or
		(current_state.slidertype == "z+b" and current_state.pos.z <= current_state.zpos_rounded) then
		toinc_y = 1 - math.abs((current_state.pos.z - current_state.zpos_rounded) *2)
		toinc_y = toinc_y + fix_on_step_move_up_jitter(	current_state.slidertype,
														current_state.velocity,
														current_state.pos,
														current_state.xpos_rounded,
														current_state.zpos_rounded)
		--print("moving z2, velocity: " .. dump(current_state.velocity))
	end

	--calculate new y value to set
	if (toinc_y > 0) then
		--limit to maximum value
		if toinc_y > 1.5 then
			toinc_y = 1.5
		end
		local ground_level = get_ground_level(current_state.pos)
		--print("Ground level: " .. dump(ground_level))
		current_state.pos.y = ground_level.y + toinc_y

		--print("moving direction x: " .. current_state.velocity.x .. " slider: " .. current_state.slidertype)

		if current_state.velocity.x ~= 0 then
			if current_state.velocity.x < 0 then
				if (current_state.slidertype == "x+b" or
					current_state.slidertype == "x+u") then
					self.set_animation(self,2)
				else
				--current_state.slidertype == "x-b" or
				--current_state.slidertype == "x-u"
					self.set_animation(self,1)
				end

			else
				if (current_state.slidertype == "x-b" or
					current_state.slidertype == "x-u") then
					self.set_animation(self,2)
				else
				--current_state.slidertype == "x+b" or
				--current_state.slidertype == "x+u"
					self.set_animation(self,1)
				end
			end
			return true
		end

		if current_state.velocity.z ~= 0 then
			if current_state.velocity.z < 0 then
				if (current_state.slidertype == "z+b" or
					current_state.slidertype == "z+u") then
					self.set_animation(self,2)
				else
				--current_state.slidertype == "z-b" or
				--current_state.slidertype == "z-u"
					self.set_animation(self,1)
				end

			else
				if (current_state.slidertype == "z-b" or
					current_state.slidertype == "z-u") then
					self.set_animation(self,2)
				else
				--current_state.slidertype == "z+b" or
				--current_state.slidertype == "z+u"
					self.set_animation(self,1)
				end
			end
			return true
		end
		return true
	else
		--print("not moving up")
		self.set_animation(self,0)
	end

	return false
end

-------------------------------------------------------------------------------
-- name: handle_xpos_curve(self,current_state)
--
--! @brief handle curved movement
--
--! @param entity to apply changes
--! @param current_state
--
--! @return true/false if handled by this fct
-------------------------------------------------------------------------------
function monorail_cart.handle_xpos_curve(self,current_state)
	if current_state.slidertype == "x+" then
		if current_state.pos.z  >= current_state.zpos_rounded and
			current_state.velocity.z > 0 then

			pb_debug_lvl3("dir change z+ -> x+")

			current_state.velocity.x = math.abs(current_state.velocity.z)
			current_state.velocity.z = 0

			current_state.pos.z = math.floor(current_state.pos.z + 0.5)
			monorail_cart.update_orientation(self,current_state,true)
			return true
		else
			if current_state.pos.x <= current_state.xpos_rounded and
			current_state.velocity.x < 0 then
				pb_debug_lvl3("dir change x- -> z-")

				current_state.velocity.z = - math.abs(current_state.velocity.x)
				current_state.velocity.x = 0

				current_state.pos.x = math.floor(current_state.pos.x + 0.5)
				monorail_cart.update_orientation(self,current_state,false)
				return true
			end
		end
	end
	return false
end

-------------------------------------------------------------------------------
-- name: handle_xneg_curve(self,current_state)
--
--! @brief handle curved movement
--
--! @param entity to apply changes
--! @param current_state
--
--! @return true/false if handled by this fct
-------------------------------------------------------------------------------
function monorail_cart.handle_xneg_curve(self,current_state)
	if current_state.slidertype == "x-" then
		if current_state.pos.z >= current_state.zpos_rounded and
			current_state.velocity.z > 0 then

			pb_debug_lvl3("dir change z+ ->  x-")

			current_state.velocity.x = - math.abs(current_state.velocity.z)
			current_state.velocity.z = 0

			current_state.pos.z = math.floor(current_state.pos.z + 0.5)
			monorail_cart.update_orientation(self,current_state,false)
			return true
		else
			if current_state.pos.x >= current_state.xpos_rounded and
				current_state.velocity.x > 0 then

				pb_debug_lvl3("dir change x+ -> z-")

				current_state.velocity.z = - math.abs(current_state.velocity.x)
				current_state.velocity.x = 0

				current_state.pos.x = math.floor(current_state.pos.x + 0.5)
				monorail_cart.update_orientation(self,current_state,true)
				return true
			end
		end
	end
	return false
end

-------------------------------------------------------------------------------
-- name: handle_zpos_curve(self,current_state)
--
--! @brief handle curved movement
--
--! @param entity to apply changes
--! @param current_state
--
--! @return true/false if handled by this fct
-------------------------------------------------------------------------------
function monorail_cart.handle_zpos_curve(self,current_state)
	if current_state.slidertype == "z+" then
		if current_state.pos.x <= current_state.xpos_rounded and
			current_state.velocity.x < 0 then

			pb_debug_lvl3("dir change x- -> z+")

			current_state.velocity.z = math.abs(current_state.velocity.x)
			current_state.velocity.x = 0

			current_state.pos.x = math.floor(current_state.pos.x + 0.5)
			monorail_cart.update_orientation(self,current_state,true)
			return true
		else
			if current_state.pos.z <= current_state.zpos_rounded and
				current_state.velocity.z < 0 then

				pb_debug_lvl3("dir change z- -> x+")

				current_state.velocity.x = math.abs(current_state.velocity.z)
				current_state.velocity.z = 0

				current_state.pos.x = math.floor(current_state.pos.x + 0.5)
				monorail_cart.update_orientation(self,current_state,true)
				return true
			end
		end
	end
	return false
end

-------------------------------------------------------------------------------
-- name: handle_zneg_curve(self,current_state)
--
--! @brief handle curved movement
--
--! @param entity to apply changes
--! @param current_state
--
--! @return true/false if handled by this fct
-------------------------------------------------------------------------------
function monorail_cart.handle_zneg_curve(self,current_state)
	if current_state.slidertype == "z-" then
		if current_state.pos.x >= current_state.xpos_rounded and
			current_state.velocity.x > 0 then

			pb_debug_lvl3("dir change x+ -> z+")

			current_state.velocity.z = math.abs(current_state.velocity.x)
			current_state.velocity.x = 0

			current_state.pos.x = math.floor(current_state.pos.x + 0.5)
			monorail_cart.update_orientation(self,current_state,false)
			return true
		else
			if current_state.pos.z <= current_state.zpos_rounded and
				current_state.velocity.z < 0 then

				pb_debug_lvl3("dir change z- ->x+")

				current_state.velocity.x = - math.abs(current_state.velocity.z)
				current_state.velocity.z = 0

				current_state.pos.z = math.floor(current_state.pos.z + 0.5)
				monorail_cart.update_orientation(self,current_state,false)
				return true
			end
		end
	end
	return false
end
-------------------------------------------------------------------------------
-- name: update_orientation(linkedplayer,direction)
--
--! @brief update player orientation
--
--! @param player to update
--! @param direction to update
-------------------------------------------------------------------------------
function monorail_cart.update_orientation(self,current_state,direction)
	local yawmod = (3.14/2)

	if not direction then
		yawmod =  - (3.14/2)
	end

	if self.linkedplayer ~= nil and
		self.linkedplayer:is_player() then
		local current_yaw = self.linkedplayer:getyaw()

		if current_yaw ~= nil then
			self.linkedplayer:setyaw(current_yaw + yawmod)
		end
	end

	--print("vel: " .. dump(current_state.velocity))
	local current_yaw = self.object:getyaw()

	if (current_state.velocity.x > 0) and
		current_yaw ~= 0 then
		self.object:setyaw(0)
	end

	if (current_state.velocity.x < 0) and
		current_yaw ~= math.pi then
		self.object:setyaw(math.pi)
	end

	if (current_state.velocity.z > 0) and
		current_yaw ~= math.pi/2 then
		self.object:setyaw(0 + math.pi/2)
	end

	if (current_state.velocity.z < 0) and
		current_yaw ~= -math.pi/2 then
		self.object:setyaw(0 - math.pi/2)
	end
end
-------------------------------------------------------------------------------
-- name: handle_curve(self,current_state)
--
--! @brief handle curved movement
--
--! @param entity to apply changes
--! @param current_state
--
--! @return true/false if handled by this fct
-------------------------------------------------------------------------------
function monorail_cart.handle_curve(self,current_state)
	local handled = false

	--check if we didn't already handle this curve
	if not monorail_samepos(self.last_switch_pos,vector.round(current_state.pos)) then

		--reset position of last curve
		self.last_switch_pos = nil

		if not handled then
			handled = monorail_cart.handle_xpos_curve(self,current_state)
		end

		if not handled then
			handled = monorail_cart.handle_xneg_curve(self,current_state)
		end

		if not handled then
			handled = monorail_cart.handle_zpos_curve(self,current_state)
		end

		if not handled then
			handled = monorail_cart.handle_zneg_curve(self,current_state)
		end

		if handled then
			pb_debug_lvl2("Curve detected: " .. current_state.slidertype)
			self.last_switch_pos = vector.round(current_state.pos)
		end
	end

	return handled
end

-------------------------------------------------------------------------------
-- name: fix_speed_above_sliders(entity)
--
--! @brief find out what type of slider we are driving at
--
--! @param entity to apply changes
-------------------------------------------------------------------------------
function monorail_cart.fix_speed_above_sliders(self,current_state)

	if not monorail_cart.precheck_position(self,current_state) then
		return
	end

	--print("slidertype: " .. slidertype .. " velocity: " .. printpos(current_speed) .. " pos: " .. printpos(ownpos))

	monorail_cart.align_to_track(self,current_state)
	monorail_cart.update_moving_up_flag(self,current_state.slidertype)

	--TODO update function
	fix_collision_on_move_up(current_state.velocity,self,current_state.slidertype)
	--print("current_speed: " .. printpos(current_speed))

	--required for some calculations
	current_state.zpos_rounded = math.floor(current_state.pos.z + 0.5)
	current_state.xpos_rounded = math.floor(current_state.pos.x + 0.5)

	local handled = false

	handled = monorail_cart.handle_straight_move_up_down(self,current_state)

	if not handled then
		handled = monorail_cart.handle_curve(self,current_state)
	end

	--apply changes
	self.object:moveto(current_state.pos)
	self.object:setvelocity(current_state.velocity)
	self.last_speed = current_state.velocity
	--print("last speed is now: " .. dump(self.last_speed))
end

-------------------------------------------------------------------------------
-- name: get_accelerator(slidertype)
--
--! @brief find out if there's a accelerator around
--! @param slidertype
--
--! @return acceleration to set
-------------------------------------------------------------------------------
function monorail_cart.get_accelerator(slidertype)

	if slidertype == "x+a" then
		return {x=MESE_ACCEL_VALUE,y=0,z=0}
	end

	if slidertype == "x-a" then
		return {x=-MESE_ACCEL_VALUE,y=0,z=0}
	end

	if slidertype == "z+a" then
		return {x=0,y=0,z=MESE_ACCEL_VALUE}
	end

	if slidertype == "z-a" then
		return {x=0,y=0,z=-MESE_ACCEL_VALUE}
	end

	return {x=0,y=0,z=0}
end

-------------------------------------------------------------------------------
-- name: precheck_movement(self,current_state)
--
--! @brief find out if there's a accelerator around
--! @param self the cart itself
--! @param current_state current movement state
--
--! @return continue/abort
-------------------------------------------------------------------------------
function monorail_cart.precheck_movement(self,current_state)

	--don't do anything if block ain't moving
	if  current_state.velocity.z     == 0 and
		current_state.velocity.x     == 0 and
		current_state.acceleration.x == 0 and
		current_state.acceleration.z == 0 and
		current_state.gravity.x      == 0 and
		current_state.gravity.z      == 0 and
		current_state.mese_accel.x   == 0 and
		current_state.mese_accel.z   == 0 then
		return false
	end

	return true
end

-------------------------------------------------------------------------------
-- name: precheck_acceleration(self,current_state)
--
--! @brief find out if there's a accelerator around
--! @param self the cart itself
--! @param current_state current movement state
--
--! @return continue/abort
-------------------------------------------------------------------------------
function monorail_cart.precheck_acceleration(self,current_state)

	--don't continue if there isn't any acceleration targeted to entity
	if  current_state.mese_accel.x == 0 and
		current_state.mese_accel.z == 0 and
		current_state.velocity.z == 0 and
		current_state.velocity.x == 0 and
		current_state.gravity.x == 0 and
		current_state.gravity.z == 0 then

		self.object:setacceleration({x=0,y=current_state.acceleration.y,z=0})
		--print("Block to slow stopping")
		return false
	end
	return true
end

-------------------------------------------------------------------------------
-- name: calculate_accel(current_state)
--
--! @brief calculate effective acceleration
--! @param current_state current movement state
--
--! @return acceleration
-------------------------------------------------------------------------------
function monorail_cart.calculate_accel(current_state)
	local retval = {x=0,y=SLIDERS_GRAVITY,z=0}
	retval.x =	current_state.resistance.x +
				current_state.friction.x +
				current_state.gravity.x +
				current_state.boost.x +
				current_state.mese_accel.x

	retval.z =	current_state.resistance.z +
				current_state.friction.z +
				current_state.gravity.z +
				current_state.boost.z +
				current_state.mese_accel.z

	--enforce maximum speed
	if current_state.velocity.x > MAXIMUM_CART_SPEED and
		retval.x > 0 then
		retval.x = 0
	end

	if current_state.velocity.x < -MAXIMUM_CART_SPEED and
		retval.x < 0 then
		retval.x = 0
	end

	if current_state.velocity.z > MAXIMUM_CART_SPEED and
		retval.z > 0 then
		retval.z = 0
	end

	if current_state.velocity.z < -MAXIMUM_CART_SPEED and
		retval.z < 0 then
		retval.z = 0
	end

	return retval
end
-------------------------------------------------------------------------------
-- name: fix_speed(self,current_state)
--
--! @brief find out if there's a accelerator around
--! @param self the cart itself
--! @param current_state current movement state
--
--! @return continue/abort
-------------------------------------------------------------------------------
function monorail_cart.fix_speed(self,current_state)

	local speed_fix = false

	--make block stop on beeing to slow
	if math.abs(current_state.velocity.x) < MIN_SPEED_JITTER then
		current_state.velocity.x = 0
		speed_fix = true
	end

	if math.abs(current_state.velocity.z) < MIN_SPEED_JITTER then
		current_state.velocity.z = 0
		speed_fix = true
	end

	if speed_fix then
		self.object:setvelocity(current_state.velocity)
		--print("Fixing speed below threshold")
	end
end


-------------------------------------------------------------------------------
-- name: sound_handler(self,velocity,acceleration)
--
--! @brief find out if there's a accelerator around
--! @param self the cart itself
--! @param velocity current velocity
--! @param acceleration current acceleration
--
-------------------------------------------------------------------------------
function monorail_cart.sound_handler(self,velocity,acceleration)
	if minetest.is_yes(minetest.setting_get("monorail_carts_mimicry")) then
		return
	end
	if not monorail_pos_is_null(velocity) or
	   not monorail_pos_is_null(acceleration) then
		if self.soundhandle_moving == nil then
			self.soundhandle_moving = minetest.sound_play({
					object = self.object,
					name="monorail_cart_moving",
					gain = 1,
					max_hear_distance = 10,
					loop = true,
				})
		end
	else
		if self.soundhandle_moving ~= nil then
			minetest.sound_stop(self.soundhandle_moving)
			self.soundhandle_moving = nil
		end
	end
end

-------------------------------------------------------------------------------
-- name: onstep_handler(self, dtime)
--
--! @brief find out if there's a accelerator around
--! @param self the cart itself
--! @param dtime time since last call
--
-------------------------------------------------------------------------------
function monorail_cart.onstep_handler(self, dtime)

	local current_state = {}
	current_state.velocity             = self.object:getvelocity()
	current_state.acceleration         = self.object:getacceleration()
	current_state.pos                  = self.object:getpos()
	current_state.slidertype           = detect_slider_type(current_state.pos,
														current_state.velocity)

	--fix current speed
	monorail_cart.fix_speed_above_sliders(self,current_state)

	current_state.gravity              = calc_gravity(current_state.slidertype)
	current_state.mese_accel           = monorail_cart.get_accelerator(current_state.slidertype)

	if not monorail_cart.precheck_movement(self,current_state) then
		monorail_cart.sound_handler(self,current_state.velocity,{x=0,y=0,z=0})
		return
	end

	monorail_cart.fix_speed(self,current_state)

	if not monorail_cart.precheck_acceleration(self,current_state) then
		monorail_cart.sound_handler(self,current_state.velocity,{x=0,y=0,z=0})
		return
	end

	--print("current velocity:" .. printpos(current_state.velocity))

	--calculate acceleration modifiers
	current_state.resistance        = calc_resistance(current_state.velocity)
	current_state.friction  = calc_friction(current_state.velocity,current_state.pos)
	current_state.boost             = get_boost(current_state.velocity,current_state.pos)

	--get new acceleration
	local new_accel = monorail_cart.calculate_accel(current_state)

	--don't set gravity if currently moving up
	if self.moving_up then
		--print("moving up no y acceleration")
		new_accel.y = 0
	end

	--print("setting accel:" .. printpos(new_accel))
	self.object:setacceleration(new_accel)
	self.object:setvelocity(current_state.velocity)

	monorail_cart.sound_handler(self,current_state.velocity,new_accel)
	monorail_cart.update_orientation(self,{ velocity=current_state.velocity },nil)
end


-------------------------------------------------------------------------------
-- name: punch_move(self,hitter,own_pos,hitterpos)
--
--! @brief move cart due to punch
--! @param self the cart itself
--! @param own_pos position of cart
--! @param hitterpos position of hitting person
--
-------------------------------------------------------------------------------
function monorail_cart.punch_move(self,own_pos,hitterpos)
    local current_velocity = self.object:getvelocity()
    local speed_change = calc_accel_on_sliders(own_pos,hitterpos)

    local cleant_pos = vector.round(own_pos)

    if speed_change.z == 0 then
        self.object:moveto(cleant_pos)
        current_velocity.z = 0
        current_velocity.x = current_velocity.x + speed_change.x
    end

    if speed_change.x == 0 then
        self.object:moveto(cleant_pos)
        current_velocity.x = 0
        current_velocity.z = current_velocity.z + speed_change.z
    end


    --print("setting speed by punch: x="..current_velocity.x .. " z="..current_velocity.z .. " dir=".. speed_change.dir)

    if speed_change.dir == "inv" or
       speed_change.dir == "in_air" then
         current_velocity = {x = current_velocity.x + speed_change.x, y= current_velocity.y, z = current_velocity.z + speed_change.z}
    end

    self.object:setvelocity(current_velocity)

    monorail_cart.update_orientation(self,{ velocity=current_velocity },nil)
end