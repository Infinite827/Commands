-- \\ COMMANDS SCRIPT // --

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- Helper function: returns true if the part is inside a player's character
local function isPlayerPart(part)
	if not part or not part.Parent then return false end
	local model = part:FindFirstAncestorWhichIsA("Model")
	if model and model:FindFirstChildOfClass("Humanoid") then
		return true
	end
	return false
end

-- Unanchor all parts except SpawnLocations and player characters, remove welds
local function clearWeldsAndUnanchor(parent)
	for _, obj in ipairs(parent:GetDescendants()) do
		if obj:IsA("BasePart") and not obj:IsA("SpawnLocation") and not isPlayerPart(obj) then
			obj.Anchored = false
		end
		if obj:IsA("WeldConstraint") then
			obj:Destroy()
		end
	end
end

-- Anchor all parts except SpawnLocations and player characters
local function anchorAllParts(parent)
	for _, obj in ipairs(parent:GetDescendants()) do
		if obj:IsA("BasePart") and not obj:IsA("SpawnLocation") and not isPlayerPart(obj) then
			obj.Anchored = true
		end
	end
end

-- Unstick a single player (teleport 3 studs up)
local function unstickPlayer(player)
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = player.Character.HumanoidRootPart
		hrp.CFrame = hrp.CFrame + Vector3.new(0, 3, 0)
	end
end

-- Valid chat prefixes
local validPrefixes = { ":", "$", ";", "/", "!" }

local function hasValidPrefix(msg)
	for _, prefix in ipairs(validPrefixes) do
		if msg:sub(1, #prefix) == prefix then
			return true, prefix
		end
	end
	return false, nil
end

-- Handle player chat commands
local function onPlayerChat(player)
	player.Chatted:Connect(function(message)
		local msg = message:lower()
		local valid, prefix = hasValidPrefix(msg)
		if not valid then return end

		local command = msg:sub(#prefix + 1)

		if command == "unanchor all" then
			clearWeldsAndUnanchor(Workspace)
			print(">> All welds removed and parts unanchored (SpawnLocations and players kept safe)!")
		elseif command == "anchor all" then
			anchorAllParts(Workspace)
			print(">> All parts anchored (SpawnLocations and players kept safe)!")
		elseif command == "unstuck" then
			unstickPlayer(player)
			print(">> Unstuck " .. player.Name .. " (moved up 3 studs)!")
		end
	end)
end

-- Connect chat for existing players
for _, player in ipairs(Players:GetPlayers()) do
	onPlayerChat(player)
end

-- Connect chat for new players
Players.PlayerAdded:Connect(onPlayerChat)
