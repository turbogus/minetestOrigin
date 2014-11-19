
-------------------------------------------------------------------------------
-- name: get_ground_level(pos)
--
-- action: detect ground level containing sliders
--
-- param1: position detect ground
-- retval: position of ground level slider
-------------------------------------------------------------------------------
function get_ground_level(pos)

    local current_pos =vector.round(pos)

    local tested_node = minetest.env:get_node(current_pos)



    while tested_node ~= nil and tested_node.name == "air" do
        current_pos = {x=current_pos.x,y=current_pos.y -1,z=current_pos.z}

        tested_node = minetest.env:get_node(current_pos)
    end

    return current_pos
end

-------------------------------------------------------------------------------
-- name: get_ground_level_(pos)
--
-- action: detect ground level containing sliders
--
-- param1: position detect ground
-- retval: position of ground level slider
-------------------------------------------------------------------------------
function get_ground_level_x(pos)

	local dirs = {
	   {x=0,z=0.5},
	   {x=0,z=-0.5},
	   {x=0.5,z=0},
	   {x=-0.5,z=0}
	}

    local current_ground_level = vector.round(pos)


    for i=1, #dirs do

        local current_pos = vector.round({x=pos.x+dirs[i].x,y=pos.y+2,z=pos.z+dirs[i].z})

        local tested_node = minetest.env:get_node(current_pos)

        while tested_node ~= nil and tested_node.name == "air" do
            current_pos = {x=current_pos.x,y=current_pos.y -1,z=current_pos.z}
            tested_node = minetest.env:get_node(current_pos)

            if current_pos.y > current_ground_level.y then
                current_ground_level = current_pos
            end
        end
    end

	return {x=pos.x,y=current_ground_level.y,z=pos.z}
end


-------------------------------------------------------------------------------
-- name: is_slider(name)
--
-- action: detect if node is a slider
--
-- param1: name of node
-- retval: true/false
-------------------------------------------------------------------------------
function is_slider(name)
	if 	name == monorail_basic_slider or
		name == monorail_basic_slider:sub(2) or
		name == "monorail:break" or
		name == "monorail:booster" then
		return true
	end

	return false
end

-------------------------------------------------------------------------------
-- name: is_booster(name)
--
-- action: detect if node is a slider
--
-- param1: name of node
-- retval: true/false
-------------------------------------------------------------------------------
function is_booster(name)

    if  name == "monorail:booster" then
        return true
    end

    return false
end

-------------------------------------------------------------------------------
-- name: is_break(name)
--
-- action: detect if node is a slider
--
-- param1: name of node
-- retval: true/false
-------------------------------------------------------------------------------
function is_break(name)

    if  name == "monorail:break" then
        return true
    end

    return false
end

-------------------------------------------------------------------------------
-- name: is_accelerator(name)
--
-- action: detect if node is a slider
--
-- param1: name of node
-- retval: true/false
-------------------------------------------------------------------------------
function is_accelerator(name)

    if  name == "monorail:accelerator_on" then
        return true
    end

    return false
end
-------------------------------------------------------------------------------
-- name: get_boost(speed,pos)
--
-- action: calculate boost
--
-- param1: name of node
-- retval: true/false
-------------------------------------------------------------------------------
function get_boost(speed,pos)

	local node_at_pos = minetest.env:get_node(pos)

	local x_accel = 0
	local z_accel = 0



	if  node_at_pos ~= nil and
		is_booster(node_at_pos.name) then

		--print("Found booster: " .. printpos(pos))

		if speed.x > 0 then
			x_accel = 5
		end

		if speed.x < 0 then
			x_accel = -5
		end

		if speed.z < 0 then
			z_accel = -5
		end

		if speed.z > 0 then
			z_accel = 5
		end
	end

	if  node_at_pos ~= nil and
        is_break(node_at_pos.name) then

        --print("Found booster: " .. printpos(pos))

        if speed.x > 0 then
            x_accel = -5
        end

        if speed.x < 0 then
            x_accel = 5
        end

        if speed.z < 0 then
            z_accel = 5
        end

        if speed.z > 0 then
            z_accel = -5
        end
    end

	return {x=x_accel,z=z_accel}
end

-------------------------------------------------------------------------------
-- name: detect_slider_type(pos)
--
-- action: find out what type of slider we are driving at
--
--! param pos position to detect
--! return slidertype
-------------------------------------------------------------------------------
function detect_slider_type(pos,cartdir)

	if pos == nil then
		return "inv"
	end

	local current_node =  minetest.env:get_node(pos)

	if current_node == nil then
		return "inv"
	end

	if is_slider(current_node.name) ~= true and
		current_node.name ~= "air" then
		print("not on slider:"..current_node.name)
		return "inv"
	end

	local node_x_prev = minetest.env:get_node({x=pos.x-1,y=pos.y,z=pos.z})
	local node_x_next = minetest.env:get_node({x=pos.x+1,y=pos.y,z=pos.z})
	local node_z_prev = minetest.env:get_node({x=pos.x,y=pos.y,z=pos.z-1})
	local node_z_next = minetest.env:get_node({x=pos.x,y=pos.y,z=pos.z+1})

	local node_x_prev_above = minetest.env:get_node({x=pos.x-1,y=pos.y+1,z=pos.z})
	local node_x_next_above = minetest.env:get_node({x=pos.x+1,y=pos.y+1,z=pos.z})
	local node_z_prev_above = minetest.env:get_node({x=pos.x,y=pos.y+1,z=pos.z-1})
	local node_z_next_above = minetest.env:get_node({x=pos.x,y=pos.y+1,z=pos.z+1})

    local node_x_prev_below = minetest.env:get_node({x=pos.x-1,y=pos.y-1,z=pos.z})
    local node_x_next_below = minetest.env:get_node({x=pos.x+1,y=pos.y-1,z=pos.z})
    local node_z_prev_below = minetest.env:get_node({x=pos.x,y=pos.y-1,z=pos.z-1})
    local node_z_next_below = minetest.env:get_node({x=pos.x,y=pos.y-1,z=pos.z+1})

	local node_below        = minetest.env:get_node({x=pos.x,y=pos.y-1,z=pos.z})

	--this does only work if guaranteed detect_slider is only called with current pos of cart
	mesecon_detector(pos,node_x_prev,node_x_next,node_z_prev,node_z_next)

	if node_x_prev ~= nil and
		node_below ~= nil and
		is_slider(node_x_prev.name) and
		is_slider(node_below.name) then
		return "x-b"
	end

	if node_x_next ~= nil and
		node_below ~= nil and
		is_slider(node_x_next.name) and
		is_slider(node_below.name) then
		return "x+b"
	end

	if node_z_prev ~= nil and
		node_below ~= nil and
		is_slider(node_z_prev.name) and
		is_slider(node_below.name) then
		return "z-b"
	end

	if node_z_next ~= nil and
		node_below ~= nil and
		is_slider(node_z_next.name) and
		is_slider(node_below.name) then
		return "z+b"
	end

	if current_node.name == "air" then
		return "in_air"
	end


	if node_x_prev_above ~= nil and
		is_slider(node_x_prev_above.name) then
		return "x-u"
	end

	if node_x_next_above ~= nil and
		is_slider(node_x_next_above.name) then
		return "x+u"
	end

	if node_z_prev_above ~= nil and
		is_slider(node_z_prev_above.name) then
		return "z-u"
	end

	if node_z_next_above ~= nil and
		is_slider(node_z_next_above.name) then

		return "z+u"
	end

	if (cartdir ~= nil) then

	    local switches_retval = handle_switches(pos,cartdir,
	                   node_z_prev,
                        node_z_next,
                        node_x_next,
                        node_x_prev,
                        node_x_prev_below,
                        node_x_next_below,
                        node_z_prev_below,
                        node_z_next_below)
        if switches_retval ~= nil then
            return switches_retval
        end
    end

    --curves
    local curves_retval = handle_curves(node_z_prev,
                                        node_z_next,
                                        node_x_next,
                                        node_x_prev,
                                        node_x_prev_below,
                                        node_x_next_below,
                                        node_z_prev_below,
                                        node_z_next_below)


    if curves_retval ~= nil then
        return curves_retval
    end

    local retval_accelerator = handle_accelerator(node_x_prev,node_x_next,
                                                    node_z_prev, node_z_next)

    if retval_accelerator ~= nil then
        return retval_accelerator
    end

	--only basic directions by now
	if node_x_prev ~= nil and
		node_x_next ~= nil and
		(is_slider(node_x_prev.name) or
		is_slider(node_x_next.name)) then

		return "x"
	end

	if node_z_prev ~= nil and
		node_z_next ~= nil and
		(is_slider(node_z_prev.name) or
		is_slider(node_z_next.name)) then

		return "z"
	end

	return "inv"
end

-------------------------------------------------------------------------------
-- name: handle_accelerator(node_x_prev,node_x_next,node_z_prev, node_x_prev)
--
--! @brief find direction of accelerator
--! @param
--
--! @return direction to move
-------------------------------------------------------------------------------
function handle_accelerator(node_x_prev,node_x_next,node_z_prev, node_z_next)

	pb_debug_lvl3("detect accel x: " ..	dump(node_x_prev) .. "," ..
								dump(node_x_next))
	pb_debug_lvl3("detect accel z: " ..	dump(node_z_prev) .. "," ..
								dump(node_z_next))

	if node_x_prev ~= nil and
		node_x_next ~= nil and
		is_slider(node_x_prev.name) and
		is_accelerator(node_x_next.name) then
		return "x-a"
	end

	if node_x_next ~= nil and
		node_x_prev ~= nil and
		is_slider(node_x_next.name) and
		is_accelerator(node_x_prev.name) then
		return "x+a"
	end

	if node_z_prev ~= nil and
		node_z_next ~= nil and
		is_slider(node_z_prev.name) and
		is_accelerator(node_z_next.name) then
		return "z-a"
	end

	if node_z_next ~= nil and
		node_z_prev ~= nil and
		is_slider(node_z_next.name) and
		is_accelerator(node_z_prev.name) then
		return "z+a"
	end

	return nil
end

-------------------------------------------------------------------------------
-- name:  handle_switches(pos,cartdir,
--                      node_z_prev,
--                      node_z_next,
--                      node_x_next,
--                      node_x_prev,
--                      node_x_prev_below,
--                      node_x_next_below,
--                      node_z_prev_below,
--                      node_z_next_below)
--
--! @brief find direction in case of switch next to track
--! @param
--
--! @return direction of track
-------------------------------------------------------------------------------
function handle_switches(pos,cartdir,
                        node_z_prev,
                        node_z_next,
                        node_x_next,
                        node_x_prev,
                        node_x_prev_below,
                        node_x_next_below,
                        node_z_prev_below,
                        node_z_next_below)

    --t-junctions
    if ((node_z_prev ~= nil and is_slider(node_z_prev.name)) or
        (node_z_prev_below ~= nil and is_slider(node_z_prev_below.name)))
       and
       ((node_z_next ~= nil and is_slider(node_z_next.name)) or
        (node_z_next_below ~= nil and is_slider(node_z_next_below.name)))
       and
       ((node_x_next ~= nil and is_slider(node_x_next.name)) or
        (node_x_next_below ~= nil and is_slider(node_x_next_below.name))
       ) then

        if switch_enabled({x=pos.x-1,y=pos.y,z=pos.z}) then
           --print("switch was enabled")
            if cartdir.x < 0 then
                --print("cartdir.x < 0 -->z+")
                return "z+"
            end

            --print("-->z")
            return "z"
        else
            --print("switch was disabled")
            --switching direction
            if cartdir.z > 0 then
                --print("cartdir.z > 0 -->x+")
                return "x+"
            end

            --running into switch from wrong side
            if cartdir.z < 0 then
                --print("cartdir.z < 0 -->z+")
                return "z+"
            end

            if cartdir.x < 0 then
                --print("cartdir.x < 0 -->x+")
                return "x+"
            end

            return "x"
        end
    end

    if ((node_z_prev ~= nil and is_slider(node_z_prev.name)) or
        (node_z_prev_below ~= nil and is_slider(node_z_prev_below.name)))
       and
       ((node_z_next ~= nil and is_slider(node_z_next.name)) or
        (node_z_next_below ~= nil and is_slider(node_z_next_below.name)))
       and
       ((node_x_prev ~= nil and is_slider(node_x_prev.name)) or
        (node_x_prev_below ~= nil and is_slider(node_x_prev_below.name))
       ) then
        if switch_enabled({x=pos.x+1,y=pos.y,z=pos.z}) then
            --print("switch was enabled")
            if cartdir.x > 0 then
                --print("cartdir.x > 0 -->x-")
                return "x-"
            end

            --print("-->z")
            return "z"
        else
            --print("switch was disabled")
            --switching direction
            if cartdir.z < 0 then
                --print("cartdir.z < 0 -->x-")
                return "z-"
            end

            --running into switch from wrong side
            if cartdir.z > 0 then
                --print("cartdir.z < 0 -->x-")
                return "x-"
            end

            if cartdir.x > 0 then
                --print("cartdir.x > 0 -->z-")
                return "z-"
            end

            return "x"
        end
    end

    if ((node_x_prev ~= nil and is_slider(node_x_prev.name)) or
        (node_x_prev_below ~= nil and is_slider(node_x_prev_below.name)))
       and
       ((node_x_next ~= nil and is_slider(node_x_next.name)) or
        (node_x_next_below ~= nil and is_slider(node_x_next_below.name)))
       and
       ((node_z_prev ~= nil and is_slider(node_z_prev.name)) or
        (node_z_prev_below ~= nil and is_slider(node_z_prev_below.name))
       ) then
        if switch_enabled({x=pos.x,y=pos.y,z=pos.z+1}) then
            --print("switch was enabled")
            if cartdir.z > 0 then
                --print("cartdir.z > 0 -->x+")
                return "x+"
            end

            --print("-->x")
            return "x"
        else
            --print("switch was disabled")
            --switching direction
            if cartdir.x > 0 then
                --print("cartdir.z > 0 -->x-")
                return "x-"
            end

            --running into switch from wrong side
            if cartdir.x < 0 then
                --print("cartdir.x < 0 -->x+")
                return "x+"
            end

            if cartdir.z > 0 then
                --print("cartdir.z > 0 -->x-")
                return "x-"
            end

            return "z"
        end
    end

    if ((node_x_prev ~= nil and is_slider(node_x_prev.name)) or
        (node_x_prev_below ~= nil and is_slider(node_x_prev_below.name)))
       and
       ((node_x_next ~= nil and is_slider(node_x_next.name)) or
        (node_x_next_below ~= nil and is_slider(node_x_next_below.name)))
       and
       ((node_z_next ~= nil and is_slider(node_z_next.name)) or
        (node_z_next_below ~= nil and is_slider(node_z_next_below.name))
       ) then
        if switch_enabled({x=pos.x,y=pos.y,z=pos.z-1}) then
            --print("switch was enabled")
            if cartdir.z < 0 then
                --print("cartdir.z < 0 -->x+")
                return "z-"
            end

            --print("-->x")
            return "x"
        else
            --print("switch was disabled")

            --running into switch from wrong side
            if cartdir.x > 0 then
                --print("cartdir.z < 0 -->z-")
                return "z-"
            end

            --switching direction
            if cartdir.x < 0 then
                --print("cartdir.x > 0 -->z+")
                return "z+"
            end

            if cartdir.z < 0 then
                --print("cartdir.z < 0 -->z+")
                return "z+"
            end

            return "z"
        end
    end

    return nil
end


-------------------------------------------------------------------------------
-- name:  handle_curves(node_z_prev,
--                      node_z_next,
--                      node_x_next,
--                      node_x_prev,
--                      node_x_prev_below,
--                      node_x_next_below,
--                      node_z_prev_below,
--                      node_z_next_below)
--
--! @brief find direction of curve
--! @param some node information
--
--! @return direction of curve
-------------------------------------------------------------------------------
function handle_curves(node_z_prev,
                        node_z_next,
                        node_x_next,
                        node_x_prev,
                        node_x_prev_below,
                        node_x_next_below,
                        node_z_prev_below,
                        node_z_next_below)

    if (node_z_prev ~= nil and is_slider(node_z_prev.name)) and (
       (node_x_next ~= nil and is_slider(node_x_next.name)) or
       (node_x_next_below ~= nil and is_slider(node_x_next_below.name))
        ) then
        return "x+"
    end

    if (node_x_prev ~= nil and is_slider(node_x_prev.name)) and (
       (node_z_prev ~= nil and is_slider(node_z_prev.name)) or
       (node_z_prev_below ~= nil and is_slider(node_z_prev_below.name))
        ) then
        return "x-"
    end

    if (node_z_next ~= nil and is_slider(node_z_next.name)) and (
       (node_x_prev ~= nil and is_slider(node_x_prev.name)) or
       (node_x_prev_below ~= nil and is_slider(node_x_prev_below.name))
        ) then
        return "z-"
    end


    if (node_z_prev_below ~= nil and is_slider(node_z_prev_below.name)) and
       (node_x_next ~= nil and is_slider(node_x_next.name)) then
        return "x+"
    end

    if (node_x_prev ~= nil and is_slider(node_x_prev.name)) and
       (node_z_next_below ~= nil and is_slider(node_z_next_below.name)) then
        return "z-"
    end

--    print("xnext: " .. node_x_next.name .. " " ..
--          "xprev: " .. node_x_prev.name .. " " ..
--          "znext: " .. node_z_next.name .. " " ..
--          "zprev: " .. node_z_prev.name .. " " ..
--          "zbnext " .. node_z_next_below.name .. " " ..
--          "zbprev " .. node_z_prev_below.name .. " " ..
--         "xbnext " .. node_x_next_below.name .. " " ..
--          "xbprev " .. node_x_prev_below.name .. " ")

    if (node_x_next ~= nil and is_slider(node_x_next.name)) and (
       (node_z_next ~= nil and is_slider(node_z_next.name)) or
       (node_z_next_below ~= nil and is_slider(node_z_next_below.name))
        ) then
        return "z+"
    end
    return nil
end

-------------------------------------------------------------------------------
-- name: switch_enabled(pos)
--
--! @brief check if switch on some pos is enabled
--! @param pos position to check
--
--! @return true/false
-------------------------------------------------------------------------------
function switch_enabled(pos)
    local node = minetest.env:get_node(vector.round(pos))

    if node == nil then
        --print("no switch found around " .. printpos(vector.round(pos)) .. " -->false")
        return false
    else
	    if node.name == "monorail:switch_on" then
	        return true
	    end

	    if node.name == "monorail:switch_on" then
	        return true
	    end
	end
end

-------------------------------------------------------------------------------
-- name: ontrack(pos)
--
--! @brief check if on straight track
--! @param pos position to check
--
--! @return direction of track or invalid
-------------------------------------------------------------------------------
function ontrack(pos)
    local current_node =  minetest.env:get_node(pos)
    if is_slider(current_node.name) then
        if vector.round(pos).x == pos.x then
            print("ontrack : z")
            return "z"
        end

        if vector.round(pos).z == pos.z then
            print("ontrack : x")
            return "x"
        end
    end

    return "inv"
end

-------------------------------------------------------------------------------
-- name: mesecon_detector(pos,node_x_prev,node_x_next,node_z_prev,node_z_next)
--
--! @brief handle mesecon detector
--! @param pos current position
--! @param node_x_prev previous node in x direction
--! @param node_x_next next node in x direction
--! @param node_z_prev previous node in z direction
--! @param node_z_next next node in z direction
--
-------------------------------------------------------------------------------
function mesecon_detector(pos,node_x_prev,node_x_next,node_z_prev,node_z_next)
	local newpos = nil

	if node_x_prev ~= nil and node_x_prev.name == "monorail:cart_detector_off" then
		newpos = {x=pos.x-1,y=pos.y,z=pos.z}
	end

	if node_x_next ~= nil and node_x_next.name == "monorail:cart_detector_off" then
		newpos = {x=pos.x+1,y=pos.y,z=pos.z}
	end

	if node_z_prev ~= nil and node_z_prev.name == "monorail:cart_detector_off" then
		newpos = {x=pos.x,y=pos.y,z=pos.z-1}
	end

	if node_z_next ~= nil and node_z_next.name == "monorail:cart_detector_off" then
		newpos = {x=pos.x,y=pos.y,z=pos.z+1}
	end

	if newpos ~= nil then
		minetest.env:add_node(newpos,{name="monorail:cart_detector_on"})
		mesecon:receptor_on(newpos, mesecon.rules.default)
		pb_debug_lvl2("enabling mesecon detector at: " .. printpos(newpos))
	end
end