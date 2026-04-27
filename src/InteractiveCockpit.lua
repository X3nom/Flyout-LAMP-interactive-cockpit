-- parts location ui

--[[
=========== Interactive Cockpit by x3nom ===============
Github: https://github.com/X3nom/Flyout-LAMP-interactive-cockpit
]]


local L_DBG = 2 -- debug info
local L_INF = 1 -- general info
local L_ERR = 0 -- errors / severe warnings only
------------------------
local LOG_LEVEL = L_INF
------------------------
---@param level integer
---@param msg   string
local function llog(level, msg)
    if LOG_LEVEL >= level then log(msg) end
end


local OnUpdateCallbacks = {}

-- adds function to run every update. Returning true from the function will cause it to be removed and not run anymore
function AddOnUpdateCallback(cb)
    OnUpdateCallbacks[#OnUpdateCallbacks + 1] = cb
end


---@param params any[]
function ToggleHandler(params)
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
function SetHandler(params)
    local id, input_name, val = table.unpack(params, 1, params["n"])

    local val = tonumber(val) or val
    if val ~= nil then
        controls[input_name] = val
    end
end

---@param params any[]
function StepHandler(params)
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
function SliderHandler(params)
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


-- Rule handler dispatch table
local rule_handlers = {
    ["T"] = ToggleHandler,
    ["Toggle"] = ToggleHandler,

    ["="] = SetHandler,
    ["Set"] = SetHandler,

    ["+"] = StepHandler,
    ["-"] = StepHandler,

    ["S"] = SliderHandler,
    ["Slider"] = SliderHandler
}


--- string.split basically 
---@param str string
---@return string[]
local function slashSeparatedToParams(str)
    llog(L_DBG, "split: '"..tostring(str).."'")
    local result = { n = 0 }
    for part in string.gmatch(str, "([^\\]*)\\?") do
        result.n = result.n + 1
        if part == "" then
            result[result.n] = nil -- skipped parameter (p1\\p3) -> set to nil to make handling look a bit nicer
        else
            result[result.n] = part
        end
    end
    return result
end

---@param str string
local function parseName(str)
    local pos = 1
    while true do
        local ss, se = string.find(str, '\\', pos)
        local es, ee = string.find(str, '\\!', pos)
        if ss == nil or se == nil or ee == nil then break end
        if ss ~= 1 and str[ss-1] ~= ' ' then goto skip end

        -- split the rule into fields. (only the inner part is passed, slashSeparatedToParams never sees the start \ or the end tag \!)
        local params = slashSeparatedToParams(str.sub(str, se+1, es-1))

        local rule_id = params[1]
        
        llog(L_DBG, "dispatch rule id: " .. tostring(rule_id))
        if rule_id ~= nil and rule_handlers[rule_id] ~= nil then
            rule_handlers[rule_id](params)
        end

        ::skip::
        pos = ee+1
    end
end


local function hasValidRuleId(str)
    local pos = 1
    while true do
        local ss, se = string.find(str, '\\', pos)
        local es, ee = string.find(str, '\\!', pos)
        if ss == nil or se == nil or ee == nil then break end
        if ss ~= 1 and str[ss-1] ~= ' ' then goto skip end
        local params = slashSeparatedToParams(str.sub(str, se+1, es-1))
        local rule_id = params[1]
        if rule_handlers[rule_id] ~= nil then
            return true
        end
        ::skip::
        pos = ee+1
    end
    return false
end

---@return part[]
local function getAllRuleParts()
    local found = {}

    for _, part in ipairs(parts) do
        if part and part.name then
            if hasValidRuleId(part.name) then
                found[#found + 1] = part
            end
        end
    end

    return found
end

local interactives = getAllRuleParts()
llog(L_INF, tostring(#interactives) .. " interactive parts found")

for k, p in pairs(interactives) do
    p:onLeftClick(
        function ()
            parseName(p.name)
        end
    )
end

return function()
    for i = #OnUpdateCallbacks, 1, -1 do
        if OnUpdateCallbacks[i]() == true then
            table.remove(OnUpdateCallbacks, i)
        end
    end
end