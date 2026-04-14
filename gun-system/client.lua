local tool = script.Parent
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

local fireEvent = tool:WaitForChild("FireGun")
local muzzle = tool:WaitForChild("Point")

-- Fires the weapon when the tool is activated
tool.Activated:Connect(function()
	local origin = muzzle.Position
	local targetPosition = mouse.Hit.Position

	fireEvent:FireServer(origin, targetPosition)
end)
