-- parts location ui

--[[
=========== Interactive Cockpit by x3nom ===============
Github: https://github.com/X3nom/Flyout-LAMP-interactive-cockpit
]]


---@return number
local function dot(a, b)
    return a.x*b.x + a.y*b.y + a.z*b.z
end


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
        
        log("found: " .. typ .." ".. input_name .." ".. tostring(sens_or_val))

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
log(#interactives)

return function ()

    if not controls.lmbPressed or not controls.lmbTriggered then
        return -- no interaction computations needed - early exit
    end
    -- log("trigger")

    -- we get 2 positions between camera and cursor at different distances
    -- these positins are later used to define a ray (line)
    local m1 = location.underMouse(0.01)
    local m2 = location.underMouse(0.02)

    local closest_intersect_dist = nil
    local interacted_part = nil

    for k, p in pairs(interactives) do
        local global_pos = p.globalPos
        -- radius of the clickable sphere is derived from x scale of the object
        local interactive_radius = p.scale.x / 2.0

        local intersection_dist = getRaySphereIntersectionDist(m1.xyz.copy, m2.xyz.copy, global_pos.copy, interactive_radius)

        if intersection_dist ~= nil then
            -- log("hit")
            if closest_intersect_dist == nil or intersection_dist < closest_intersect_dist then
                closest_intersect_dist = intersection_dist
                interacted_part = p
            end
        end
    end

    if interacted_part == nil then
        return -- no interacted part, exit
    end
    
    local partname = interacted_part.name
    log("hit: '" .. partname .. "'")
    parseAndHandleInteractives(partname, controls.lmbTriggered)

end