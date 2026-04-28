-- parts location ui
--------------------------------------------------------
--            Interactive Cockpit by x3nom            --
--------------------------------------------------------

-- GitHub: https://github.com/X3nom/Flyout-LAMP-interactive-cockpit
-- Version: 1.1.0

-- Docs can be found on the GitHub link in README.md

--header-end--

require("core")

require("handlers.inputs")
require("14SegmentDriver")


local interactives = GetAllRuleParts()
llog(L_INF, tostring(#interactives) .. " interactive parts found")

for k, p in pairs(interactives) do
    ParseNameAndInit(p)
end

return function()
    for i = #OnTickCallbacks, 1, -1 do
        if OnTickCallbacks[i]() == true then
            table.remove(OnTickCallbacks, i)
        end
    end
end
