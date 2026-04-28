
L_DBG = 2 -- debug info
L_INF = 1 -- general info
L_ERR = 0 -- errors / severe warnings only
------------------------
local LOG_LEVEL = L_INF
------------------------
---@param level integer
---@param msg   string
function llog(level, msg)
    if LOG_LEVEL >= level then log(msg) end
end





OnClick_rule_handlers = {}
OnTick_rule_handlers = {}

function RegisterOnClickRuleHandler(rule_id, fn)
    OnClick_rule_handlers[rule_id] = fn
end
function RegisterOnTickRuleHandler(rule_id, fn)
    OnTick_rule_handlers[rule_id] = fn
end

OnTickCallbacks = {}

-- adds function to run every update. Returning true from the function will cause it to be removed and not run anymore
function AddOnUpdateCallback(cb)
    OnTickCallbacks[#OnTickCallbacks + 1] = cb
end



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


--- parses interactive part name and inicializes everything
--- @param p part
function ParseNameAndInit(p)
    local name = p.name
    local pos = 1
    local curr_part_onclick_handlers = {}
    while true do
        local ss, se = string.find(name, '\\', pos)
        local es, ee = string.find(name, '\\!', pos)
        if ss == nil or se == nil or ee == nil then break end
        if ss ~= 1 and name[ss-1] ~= ' ' then goto skip end

        -- split the rule into fields. (only the inner part is passed, slashSeparatedToParams never sees the start \ or the end tag \!)
        local params = slashSeparatedToParams(name.sub(name, se+1, es-1))

        local rule_id = params[1]
        
        llog(L_DBG, "resolve rule id: " .. tostring(rule_id))
        if rule_id == nil then -- do nothing (skip)
        
        elseif OnClick_rule_handlers[rule_id] ~= nil then
            curr_part_onclick_handlers[#curr_part_onclick_handlers+1] = function ()
                OnClick_rule_handlers[rule_id](params, p)
            end

        elseif OnTick_rule_handlers[rule_id] ~= nil then
            AddOnUpdateCallback(function ()
                OnTick_rule_handlers[rule_id](params, p)
            end)

        end

        ::skip::
        pos = ee+1
    end
    
    -- if any on-clicks, set onLeftClick to execute them.
    if #curr_part_onclick_handlers > 0 then
        p:onLeftClick(function ()
            for i, h in curr_part_onclick_handlers do
                h()
            end
        end)
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
        if  OnClick_rule_handlers[rule_id] ~= nil or
            OnTick_rule_handlers[rule_id] ~= nil then
            return true
        end
        ::skip::
        pos = ee+1
    end
    return false
end

---@return part[]
function GetAllRuleParts()
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
