require("core")

---@param params any[]
function ToggleHandler(params, part)
    local id, input_name = table.unpack(params, 1, params["n"])
    llog(L_DBG, "ToggleHandler")

    local t = type(controls[input_name])
    if t == "number" then
        controls[input_name] = 1 - controls[input_name]
    elseif t == "boolean" then
        controls[input_name] = not controls[input_name]
    end
end

---@param params any[]
function SetHandler(params, part)
    local id, input_name, val = table.unpack(params, 1, params["n"])

    local val = tonumber(val) or val
    if val ~= nil then
        controls[input_name] = val
    end
end

---@param params any[]
function StepHandler(params, part)
    local id, input_name, sens, minv, maxv = table.unpack(params, 1, params["n"])

    minv = tonumber(minv) or nil
    maxv = tonumber(maxv) or nil
    sens = tonumber(sens) or 1

    local newval = 0
    if(id == "+") then
        newval = controls[input_name] + sens
    else
        newval = controls[input_name] - sens
    end
    if minv ~= nil then newval = math.max(newval, minv) end
    if maxv ~= nil then newval = math.min(newval, maxv) end
    controls[input_name] = newval
end


---@param params any[]
function SliderHandler(params, part)
    local id, input_name, sens, screen_step, minv, maxv = table.unpack(params, 1, params["n"])

    minv = tonumber(minv) or nil
    maxv = tonumber(maxv) or nil
    screen_step = tonumber(screen_step) or nil
    sens = tonumber(sens) or 1

    local start_mouse_pos = controls.mousePos.copy

    -- this is needed bc of wtf behavior on win 11 (for me at least)
    local start_mouse_pos_y_corrected = start_mouse_pos.copy

    controls.mousePos = start_mouse_pos_y_corrected
    if controls.mousePos ~= start_mouse_pos_y_corrected then
        start_mouse_pos_y_corrected.y = controls.mouseBounds_Y - start_mouse_pos.y
        controls.mousePos = start_mouse_pos_y_corrected
    end
    -- end of the wtf thing

    local delta_y_prev = 0
    local step_unit = 0
    if screen_step ~= nil then
        step_unit = math.ceil(screen_step * controls.mouseBounds_Y / 100)
    end

    local cb = function ()
        if not controls.lmbPressed then
            return true
        end

        local delta_y_px = start_mouse_pos.y - controls.mousePos_Y
        controls.mousePos = start_mouse_pos_y_corrected
        -- delta_y normalized based on screen height
        local delta_y = delta_y_px / controls.mouseBounds_Y

        local newval = 0
        if screen_step == nil or screen_step == 0 then
            newval = controls[input_name] + delta_y * sens
        else
            delta_y_prev = delta_y_prev + delta_y_px
            local step_count = math.floor(delta_y_prev / step_unit)
            delta_y_prev = delta_y_prev % step_unit

            newval = controls[input_name] + step_count * sens
        end

        if minv ~= nil then newval = math.max(newval, minv) end
        if maxv ~= nil then newval = math.min(newval, maxv) end

        controls[input_name] = newval
        
    end

    AddOnUpdateCallback(cb)

end


RegisterOnClickRuleHandler("T", ToggleHandler)
RegisterOnClickRuleHandler("Toggle", ToggleHandler)

RegisterOnClickRuleHandler("=", SetHandler)
RegisterOnClickRuleHandler("Set", SetHandler)

RegisterOnClickRuleHandler("+", StepHandler)
RegisterOnClickRuleHandler("-", StepHandler)

RegisterOnClickRuleHandler("S", SliderHandler)
RegisterOnClickRuleHandler("Slider", SliderHandler)
