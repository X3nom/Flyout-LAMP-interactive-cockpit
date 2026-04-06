-- parts location ui

--[[
=========== Interactive Cockpit by x3nom ===============
Github: https://github.com/X3nom/Flyout-LAMP-interactive-cockpit
]]


---@return number
local function dot(a, b)
    return a.x*b.x + a.y*b.y + a.z*b.z
end
-- math that is kinda already implemented in flyout and annotations.lua :(
-- for now I'll keep it here as a reminder that I should sometimes actually read docs
local function getRaySphereIntersectionDist(a, b, c, r)
    local d = b.copy - a.copy        -- direction vector
    local f = a - c        -- vector from center to line start

    local A = dot(d, d)
    local B = 2 * dot(f, d)
    local C = dot(f, f) - r * r

    local discriminant = B * B - 4 * A * C

    if discriminant < 0 then
        return nil -- no intersection
    end

    discriminant = math.sqrt(discriminant)

    local t1 = (0-B - discriminant) / (2 * A)
    local t2 = (0-B + discriminant) / (2 * A)

    -- on Ray
    if t1 >= 0 or t2 >= 0 then
        return math.min(t1, t2)
    end

    return nil
end

local name_match_pattern =
-- "\\I([T+%-PNS])\\([^\\]+)\\(\\[^\\]*)?\\(\\[^\\]*)?\\(\\[^\\]*)?\\!"
"\\I([T+%-PNS])\\([^\\]+)(\\[^\\]*)?(\\[^\\]*)?(\\[^\\]*)?\\!"
--   mode     name     sensitivity  min         max

-- used mainly for stripping leading backslash captured in optional pattern parameters
local function stripFirst(str)
    if str == nil then return nil end
    return string.sub(str, 2)
end

local function parseAndHandleSingleInteractive(str, is_trigger)
    for typ, input_name, sens_or_val, minv, maxv in string.gmatch(str, name_match_pattern) do
        sens_or_val = stripFirst(sens_or_val)
        minv = tonumber(stripFirst(minv)) or nil
        maxv = tonumber(stripFirst(maxv)) or nil
        
        -- log("found: " .. typ .." ".. input_name .." ".. tostring(sens_or_val))

        if is_trigger and typ == "T" then
            local t = type(controls[input_name])
            if t == "number" then
                controls[input_name] = 1 - controls[input_name]
            elseif t == "boolean" then
                controls[input_name] = not controls[input_name]
            end

        elseif is_trigger and typ == "S" and sens_or_val ~= nil then
            local val = tonumber(sens_or_val) or sens_or_val
            if val ~= nil then
                controls[input_name] = val
            end
        
        elseif is_trigger and (typ == "+" or typ == "-") then
            local sens = tonumber(sens_or_val) or 1
            local newval = 0
            if(typ == "+") then
                newval = controls[input_name] + sens
            else
                newval = controls[input_name] - sens
            end
            if minv ~= nil then newval = math.max(newval, minv) end
            if maxv ~= nil then newval = math.min(newval, maxv) end
            controls[input_name] = newval
        end
    end
end

local function parseAndHandleInteractives(str, is_trigger)
    local pos = 1
    while true do
        local ss, se = string.find(str, '\\I', pos)
        local es, ee = string.find(str, '\\!', pos)
        if ss == nil or ee == nil then break end

        parseAndHandleSingleInteractive(string.sub(str, ss, ee), is_trigger)

        pos = ee+1
    end
end



local function validateInteractivesName(name)
    for _ in string.gmatch(name, name_match_pattern) do
        return true
    end
    return false
end

---@return part[]
local function getAllInteractives()
    local found = {}

    for _, part in ipairs(parts) do
        if part and part.name then
            if validateInteractivesName(part.name) then
                found[#found + 1] = part
            end
        end
    end

    return found
end

local interactives = getAllInteractives()
log(tostring(#interactives) .. " interactive parts found")

for k, p in pairs(interactives) do
    p:onLeftClick(
        function ()
            parseAndHandleInteractives(p.name, true)
        end
    )
end

