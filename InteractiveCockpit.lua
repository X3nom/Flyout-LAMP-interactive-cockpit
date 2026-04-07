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



---@param params any[]
function ToggleHandler(params)
    local id, input_name = table.unpack(params)
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
    local id, input_name, val = table.unpack(params)

    local val = tonumber(val) or val
    if val ~= nil then
        controls[input_name] = val
    end
end

---@param params any[]
function StepHandler(params)
    local id, input_name, sens, minv, maxv = table.unpack(params)

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


-- Rule handler dispatch table
local rule_handlers = {
    ["T"] = ToggleHandler,
    ["Toggle"] = ToggleHandler,

    ["S"] = SetHandler,
    ["Set"] = SetHandler,

    ["+"] = StepHandler,
    ["-"] = StepHandler
}


--- string.split basically 
---@param str string
---@return string[]
local function slashSeparatedToParams(str)
    llog(L_DBG, "split: '"..tostring(str).."'")
    local result = {}
    for part in string.gmatch(str, "([^\\]*)\\?") do
        if part == "" then
            result[#result + 1] = nil -- skipped parameter (p1\\p3) -> set to nil to make handling look a bit nicer
        else
            result[#result + 1] = part
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



local function hasInteractiveName(name)
    local s, e = string.find(name, '\\!')
    if s == nil or e == nil then return false end
    return true
end

---@return part[]
local function getAllInteractives()
    local found = {}

    for _, part in ipairs(parts) do
        if part and part.name then
            if hasInteractiveName(part.name) then
                found[#found + 1] = part
            end
        end
    end

    return found
end

local interactives = getAllInteractives()
llog(L_INF, tostring(#interactives) .. " interactive parts found")

for k, p in pairs(interactives) do
    p:onLeftClick(
        function ()
            parseName(p.name)
        end
    )
end

