
function fix_on_step_move_up_jitter(slidertype,current_speed,ownpos,xpos_rounded,zpos_rounded)

    local retval = 0
    local adddelta = 0.1

    if ((slidertype == "x-u" and ownpos.x >= xpos_rounded) or
        (slidertype == "x-b" and ownpos.x >= xpos_rounded)) and
        current_speed.x < 0 then
            retval = adddelta * math.abs(current_speed.z)
    end

    if ((slidertype == "x+u" and ownpos.x <= xpos_rounded) or
        (slidertype == "x+b" and ownpos.x <= xpos_rounded)) and
        current_speed.x > 0 then
        retval = adddelta * math.abs(current_speed.z)
    end

    if ((slidertype == "z-u" and ownpos.z >= xpos_rounded) or
        (slidertype == "z-b" and ownpos.z >= xpos_rounded)) and
        current_speed.z < 0 then
        retval = adddelta * math.abs(current_speed.z)
    end

    if ((slidertype == "z+u" and ownpos.z <= xpos_rounded) or
        (slidertype == "z+b" and ownpos.z <= xpos_rounded)) and
        current_speed.z > 0 then
        retval = adddelta * math.abs(current_speed.z)
    end

    return retval
end


function fix_collision_on_move_up(current_speed,entity,slidertype)

    if current_speed.x == 0 and
        (slidertype == "x+b" or
        slidertype == "x-b" or
        slidertype == "x+u" or
        slidertype == "x-u" or
        slidertype == "x-" or
        slidertype == "x+" ) then
        --print("collision detected restoring speed")
        current_speed.x = entity.last_speed.x
    end

    if current_speed.z == 0 and
        (slidertype == "z+b" or
        slidertype == "z-b" or
        slidertype == "z+u" or
        slidertype == "z-u" or
        slidertype == "z-"  or
        slidertype == "z+")then
        --print("collision detected restoring speed")
        current_speed.z = entity.last_speed.z
    end

    if (current_speed.x == 0 and
    	current_speed.z == 0) and
    	(slidertype == "z+" or
    	 slidertype == "z-" or
    	 slidertype == "x+" or
    	 slidertype == "x-") then
    	 --print("corner collision detected restoring speed")
    	 current_speed.x = entity.last_speed.x
    	 current_speed.z = entity.last_speed.z
    end

    if (current_speed.x == 0 and current_speed.z == 0) and
		(entity.last_speed.x ~= 0 or entity.last_speed.z ~= 0) then
		--print("Just stopped: " .. slidertype)
		--print("Current: (" .. current_speed.x .."," ..current_speed.z .. ") " ..
		--"last: (" ..  entity.last_speed.x .. "," .. entity.last_speed.z .. ")")

		if slidertype == "z" and
			entity.last_speed.z ~= 0 then
			local current_pos = entity.object:getpos()
			local next_pos = current_pos
			if entity.last_speed.z > 0 then
				next_pos.z = next_pos.z+1
			else
				next_pos.z = next_pos.z-1
			end

			local current_node = minetest.env:get_node(next_pos)

			--we need to handle ignore as this may happen on slow machines
			if is_slider(current_node.name) or
				current_node.name == "ignore" then
				current_speed.z = entity.last_speed.z
				current_pos.y = current_pos.y + 0.1
				entity.object:setpos(current_pos)
			end
		end

		if slidertype == "x" and
			entity.last_speed.x ~= 0 then
			local current_pos = entity.object:getpos()
			local next_pos = current_pos
			if entity.last_speed.x > 0 then
				next_pos.x = next_pos.x+1
			else
				next_pos.x = next_pos.x-1
			end

			local current_node = minetest.env:get_node(next_pos)

			--we need to handle ignore as this may happen on slow machines
			if is_slider(current_node.name) or
				current_node.name == "ignore" then
				current_speed.x = entity.last_speed.x
				current_pos.y = current_pos.y + 0.1
				entity.object:setpos(current_pos)
			end
		end
    	--current_speed.x = entity.last_speed.x
    	--current_speed.z = entity.last_speed.z
	end
end

function end_of_track(pos, lastknownpos)
	if monorail_calc_distance(pos,lastknownpos) < 1 then
		local last_slidertype = detect_slider_type(lastknownpos)
		if last_slidertype == "x" or
			last_slidertype == "z" then
			return true
		end
	end

	return false
end