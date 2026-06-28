--==============================================--
-- By VHS						   					--
-- Discord: vhs_lunxty								--
-- https://steamcommunity.com/profiles/VHS_Lunxty/  --
-- Addons de la communauté: Nebula - 173 Actor  --
--==============================================-- 


local ps = game:GetService("Players")
local ts = game:GetService("TweenService")
local hook = require(script.Parent.Hook)
local cfg = require(script.Parent.Config)

local ENT = {}
ENT.__index = ENT

function ENT:GetPlayers()
	local t = {}
	for _, p in ipairs(ps:GetPlayers()) do
		if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Head") then
			table.insert(t, p)
		end
	end
	return t
end

function ENT:CanSee(p)
	local cam = p.Character.Head
	local dir = self.root.Position - cam.Position
	local dist = dir.Magnitude
	if dist > cfg.snapr then return false end
	local rp = RaycastParams.new()
	rp.FilterDescendantsInstances = {self.model, p.Character}
	rp.FilterType = Enum.RaycastFilterType.Exclude
	if workspace:Raycast(cam.Position, dir.Unit * dist, rp) then return false end
	return cam.CFrame.LookVector:Dot(dir.Unit) > 0.6
end

function ENT:IsWatched()
	self.watching = {}
	for _, p in ipairs(self:GetPlayers()) do
		if self:CanSee(p) then table.insert(self.watching, p) end
	end
	return #self.watching > 0
end

function ENT:GetTarget()
	local best, bdist = nil, math.huge
	for _, p in ipairs(self:GetPlayers()) do
		local d = (self.root.Position - p.Character.HumanoidRootPart.Position).Magnitude
		if d < bdist then best, bdist = p, d end
	end
	return best, bdist
end

function ENT:Snap(pos)
	ts:Create(self.root, TweenInfo.new(0.05), {CFrame = CFrame.new(pos)}):Play()
end

function ENT:KillNear()
	for _, p in ipairs(self:GetPlayers()) do
		local d = (self.root.Position - p.Character.HumanoidRootPart.Position).Magnitude
		if d <= cfg.killr then
			p.Character.Humanoid:TakeDamage(cfg.dmg)
		end
	end
end

function ENT:Think()
	if self:IsWatched() then
		self.frozen = true
		self.hum.WalkSpeed = 0
		return
	end
	self.frozen = false
	local tgt, dist = self:GetTarget()
	if tgt and dist > cfg.killr then
		self.hum:MoveTo(tgt.Character.HumanoidRootPart.Position)
	end
	self:KillNear()
	hook.Run("SCP173:Think", self)
end

function ENT:Blink()
	if self.frozen then return end
	local tgt = self:GetTarget()
	if not tgt then return end
	local tr = tgt.Character.HumanoidRootPart
	local offsets = {
		tr.CFrame * CFrame.new(0, 0, cfg.killr + 1),
		tr.CFrame * CFrame.new(cfg.killr + 1, 0, 0),
		tr.CFrame * CFrame.new(-cfg.killr - 1, 0, 0),
	}
	for _, cf in ipairs(offsets) do
		local ray = workspace:Raycast(cf.Position + Vector3.new(0,5,0), Vector3.new(0,-10,0))
		if ray then
			self:Snap(ray.Position + Vector3.new(0,3,0))
			hook.Run("SCP173:Blink", self, tgt)
			return
		end
	end
end

function ENT:OnRemove()
	hook.Run("SCP173:Removed", self)
	print("[SCP-173] Retiré")
end

function ENT.new(model)
	local self = setmetatable({}, ENT)
	self.model = model
	self.root = model:WaitForChild("HumanoidRootPart")
	self.hum = model:WaitForChild("Humanoid")
	self.frozen = false
	self.watching = {}
	self.hum.WalkSpeed = cfg.spd
	self.hum.JumpPower = 0
	return self
end

return ENT