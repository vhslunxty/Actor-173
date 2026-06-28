--==============================================--
-- By VHS						   					--
-- Discord: vhs_lunxty								--
-- https://steamcommunity.com/profiles/VHS_Lunxty/  --
-- Addons de la communauté: Nebula - 173 Actor  --
--==============================================-- 

local rs = game:GetService("RunService")
local hook = require(script.Parent.Hook)
local timer = require(script.Parent.Timer)
local ENT = require(script.Parent.ENT)

local ent = ENT.new(script.Parent)

hook.Add("SCP173:Blink", "log", function(e, tgt) print("[SCP-173] Blink -> " .. tgt.Name) end)
hook.Add("SCP173:Removed", "log", function() print("[SCP-173] Remove OK") end)
hook.Add("SCP173:Think", "log", function() end)

timer.Create("SCP173_Blink", ent.cfg and ent.cfg.blinkt or 6, 0, function()
	ent:Blink()
end)

hook.Run("SCP173:Spawned", ent)
print("[SCP-173] Initialisé")

rs.Heartbeat:Connect(function()
	ent:Think()
end)

script.Parent.AncestryChanged:Connect(function(_, parent)
	if not parent then ent:OnRemove() end
end)