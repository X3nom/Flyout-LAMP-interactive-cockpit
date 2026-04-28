
---@param parts part[]
---@param name string
function GetPartByName(parts, name)
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