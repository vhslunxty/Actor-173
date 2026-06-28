--==============================================--
-- By VHS						   					--
-- Discord: vhs_lunxty								--
-- https://steamcommunity.com/profiles/VHS_Lunxty/  --
-- Addons de la communauté: Nebula - 173 Actor  --
--==============================================-- 

local timer = {}

function timer.Simple(t, fn) task.delay(t, fn) end
function timer.Create(id, t, rep, fn)
	task.spawn(function()
		local i = 0
		repeat task.wait(t) fn() i += 1
		until rep ~= 0 and i >= rep
	end)
end
function timer.Remove(id) end

return timer