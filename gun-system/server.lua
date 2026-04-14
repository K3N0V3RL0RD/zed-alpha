local tool = script.Parent
local fireEvent = tool.FireGun

local MAX_DISTANCE = 500
local DAMAGE_AMOUNT = 23

--visual ray for debugging
local function visualizeRay(origin, direction)
	local length = direction.Magnitude
	local midpoint = origin + direction * 0.5

	local rayPart = Instance.new("Part")
	rayPart.Anchored = true
	rayPart.CanCollide = false
	rayPart.CanQuery = false
	rayPart.Material = Enum.Material.Neon
	rayPart.Color = Color3.fromRGB(255, 170, 0)

	-- Scale and orient the part to match the ray
	rayPart.Size = Vector3.new(0.1, 0.1, length)
	rayPart.CFrame = CFrame.new(midpoint, origin + direction)

	rayPart.Parent = workspace
	game:GetService("Debris"):AddItem(rayPart, 0.1)
end

-- Handles firing logic from the client
fireEvent.OnServerEvent:Connect(function(player, origin, targetPosition)
	-- Calculate direction from origin to target
	local direction = (targetPosition - origin).Unit * MAX_DISTANCE

	-- Ignore the shooter's own character
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {player.Character}
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude

	local result = workspace:Raycast(origin, direction, raycastParams)

	--visualizing for debugging
	visualizeRay(origin, direction)

	if result then
		print("Hit:", result.Instance)

		-- Traverse up the hierarchy to find a Humanoid
		local current = result.Instance
		while current do
			local humanoid = current:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid:TakeDamage(DAMAGE_AMOUNT)
				break
			end
			current = current.Parent
		end
	else
		print("No hit detected")
	end
end)
