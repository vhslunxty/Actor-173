--==============================================--
-- By VHS						   					--
-- Discord: vhs_lunxty								--
-- https://steamcommunity.com/profiles/VHS_Lunxty/  --
-- Addons de la communauté: Nebula - 173 Actor  --
--==============================================-- 

local hook = {}
hook.list = {}

function hook.Add(n, id, fn) hook.list[n] = hook.list[n] or {} hook.list[n][id] = fn end
function hook.Run(n, ...) local r for _, fn in pairs(hook.list[n] or {}) do r = fn(...) end return r end
function hook.Remove(n, id) if hook.list[n] then hook.list[n][id] = nil end end

return hook