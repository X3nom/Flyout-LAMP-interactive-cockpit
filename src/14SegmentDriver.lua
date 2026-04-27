-- parts

-- derived from the InteractiveCockpit.lua, not included there because of huge size of the display driver

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

local anti_clip_offset = 0.001

-- adds function to run every update. Returning true from the function will cause it to be removed and not run anymore
function AddOnUpdateCallback(cb)
    OnUpdateCallbacks[#OnUpdateCallbacks + 1] = cb
end

---@param parts part[]
---@param name string
local function getPartByName(parts, name)
    for _, p in pairs(parts) do
        -- log(p.name)
        if p.name == name then return p end
    end
    return nil
end

function split(str, sep)
    local result = {}
    local pattern = '([^' .. sep .. ']+)'
    for match in str:gmatch(pattern) do
        result[#result + 1] = match
    end
    return result
end

-- let's hope that claude knows his shit about 14 segment display characters :D
local charset_14_seg = {
    -- Digits
    ['0'] = 'a b c d e f h m',
    ['1'] = 'b c j',
    ['2'] = 'a b g1 g2 e d',
    ['3'] = 'a b c d g1 g2',
    ['4'] = 'f g1 g2 b c',
    ['5'] = 'a f g1 g2 c d',
    ['6'] = 'a f g1 g2 c d e',
    ['7'] = 'a b c',
    ['8'] = 'a b c d e f g1 g2',
    ['9'] = 'a b c d f g1 g2',

    -- Uppercase letters
    ['A'] = 'a b c e f g1 g2',
    ['B'] = 'a b c d f g2 i l',
    ['C'] = 'a d e f',
    ['D'] = 'a b c d i l',
    ['E'] = 'a d e f g1 g2',
    ['F'] = 'a e f g1 g2',
    ['G'] = 'a c d e f g2',
    ['H'] = 'b c e f g1 g2',
    ['I'] = 'a d i l',
    ['J'] = 'b c d e',
    ['K'] = 'e f g1 j m',
    ['L'] = 'd e f',
    ['M'] = 'b c e f h j',
    ['N'] = 'b c e f h m',
    ['O'] = 'a b c d e f',
    ['P'] = 'a b e f g1 g2',
    ['Q'] = 'a b c d e f m',
    ['R'] = 'a b e f g1 g2 m',
    ['S'] = 'a c d f g1 g2',
    ['T'] = 'a i l',
    ['U'] = 'b c d e f',
    ['V'] = 'e f j k',
    ['W'] = 'b c e f k m',
    ['X'] = 'h j k m',
    ['Y'] = 'h j l',
    ['Z'] = 'a d j k',

    -- Lowercase (where meaningfully distinct from uppercase)
    ['a'] = 'a b c d e g1 g2',
    ['b'] = 'd e f g1 g2 c',
    ['c'] = 'd e g1 g2',
    ['d'] = 'b c d e g2 g1',
    ['e'] = 'a b d e f g1 g2',
    ['f'] = 'e f a g1',   -- or just uppercase F
    ['g'] = 'a b c d f g1 g2',
    ['h'] = 'c e f g1 g2',
    ['i'] = 'l',
    ['j'] = 'b c d e',
    ['k'] = 'e f g1 j m',
    ['l'] = 'e f',
    ['m'] = 'c e g1 g2 l',
    ['n'] = 'c e g1 g2',
    ['o'] = 'c d e g1 g2',
    ['p'] = 'a e f g1 g2 b',
    ['q'] = 'g1 g2 e d c m',
    ['r'] = 'e g1 g2',
    ['s'] = 'a c d f g1 g2',
    ['t'] = 'l g1 g2',
    ['u'] = 'c d e',
    ['v'] = 'e k',
    ['w'] = 'c d e l',
    ['x'] = 'h j k m',
    ['y'] = 'b c d f g1 g2',
    ['z'] = 'a d j k',

    -- Special characters
    [' '] = '',
    ['-'] = 'g1 g2',
    ['_'] = 'd',
    ['+'] = 'g1 g2 i l',
    ['='] = 'd g1 g2',
    ['<'] = 'j m',
    ['>'] = 'h k',
    ['/'] = 'j k',
    ['\\'] = 'h m',
    ['|'] = 'i l',
    ['('] = 'j m',           -- same as < on 14-seg
    [')'] = 'h k',           -- same as > on 14-seg
    ['"'] = 'f i',
    ["'"] = 'i',             -- or 'f' depending on preference
    ['`'] = 'h',
    ['!'] = 'b c dp',
    ['?'] = 'a b g2 l',
    ['@'] = 'a b d e f g2 i',
    ['#'] = 'b c g1 g2 i l',
    ['*'] = 'g1 g2 h i j k l m',
    ['^'] = 'h j',
    ['&'] = 'a d e f g1 h m',
    ['%'] = 'h j k m',      -- approximation
    ['~'] = 'g1 g2 h j',    -- approximation
    ['.'] = 'dp' -- has special handling in the code
}

-- possibly O(1) lookup (idk how lua actually interprets tables internaly)
local charset_lookup = {}
for chr, segs in pairs(charset_14_seg) do
    charset_lookup[chr] = {}
    for _, s in pairs(split(segs, ' ')) do
        charset_lookup[chr][s] = true
    end
end


---@param char_part part
---@param char string
---@param do_cleanup boolean
local function setChar(char_part, char, do_cleanup)
    local segments = charset_lookup[char]
    if segments == nil then setChar(char_part, '?', true) return end
    llog(L_DBG ,"setchar: "..char)
    for _, child in pairs(char_part.children) do
        if segments[child.name] ~= nil then
            if #child.inputs >= 1 then
                child.inputs[1].default = 1
                child.pos.z = -anti_clip_offset
            end
        else
            if #child.inputs >= 1 and do_cleanup == true then
                child.inputs[1].default = 0
                child.pos.z = 0
            end
        end
    end
end

---@param line_parts part[]
---@param str string
local function setLine(line_parts, str)
    -- llog(L_DBG, "setLine ("..tostring(#line_parts).."): '"..str.."'")
    local str_i = 1
    for i, p in ipairs(line_parts) do
        if str_i <= #str then
            setChar(p, string.sub(str, str_i, str_i), true)
            str_i = str_i + 1

            -- special dp handling - drawn onto same part without clearing it
            if string.sub(str, str_i, str_i) == "." then
                setChar(p, string.sub(str, str_i, str_i), false)
                str_i = str_i + 1
            end

        else setChar(p, ' ', true) end
    end
end

---@param part part
---@param params any[]
local function displayHandler(params, part)
    local id, input_name = table.unpack(params, 1, params["n"])
    if input_name == nil then return end

    local characters = {}
    ---@type part|nil
    local curr_part = part
    while curr_part ~= nil do
        characters[#characters+1] = curr_part
        curr_part = getPartByName(curr_part.children, "14SegmentChar")
    end

    local input_exists = controls[input_name] ~= nil

    local prev_val = nil
    AddOnUpdateCallback(function ()
        if input_exists then
            if controls[input_name] ~= prev_val then
                setLine(characters, tostring(controls[input_name]))
                prev_val = controls[input_name]
            end
        else
            if shared[input_name] ~= prev_val then
                if type(shared[input_name]) == "string" then setLine(characters, shared[input_name]) end
                prev_val = shared[input_name]
            end
        end
    end)
end


-- Rule handler dispatch table
local rule_handlers = {
    ["14SegmentDisplay"] = displayHandler
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
local function parseName(str, p)
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
            rule_handlers[rule_id](params, p)
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

    for _, part in pairs(parts) do
        if part and part.name then
            if hasValidRuleId(part.name) then
                found[#found + 1] = part
            end
        end
    end

    return found
end

local interactives = getAllRuleParts()
llog(L_INF, tostring(#interactives) .. " display parts found")

for k, p in pairs(interactives) do
    parseName(p.name, p)
end



return function()
    for i = #OnUpdateCallbacks, 1, -1 do
        OnUpdateCallbacks[i]()
    end
end