-- \\ COMMANDS SCRIPT // --

local Players = game:GetService("Players")
local ownerUserId = game.CreatorId -- Only the game owner can target others

-- === Command Prefixes ===
local PREFIXES = { "!", "$", "/", ".", "#", ":", ";" }

-- === Commands ===
local COMMANDS = {
	ANCHOR = "anchor",
	UNANCHOR = "unanchor",
	UNSTUCK = "unstuck",
}

-- === Functions ===

-- Respawn player 5 studs above current position
local function respawnPlayer(player)
	local char = player.Character
	if not char or not char.PrimaryPart then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local oldCFrame = hrp.CFrame
	player:LoadCharacter()
	local newHRP = player.Character:WaitForChild("HumanoidRootPart")
	newHRP.CFrame = oldCFrame + Vector3.new(0, 5, 0)
end

-- Anchor or unanchor all BaseParts of a character
local function setAnchored(character, anchored)
	if not character then return end
	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Anchored = anchored
		end
	end
end

-- Check if message starts with a valid prefix
local function hasValidPrefix(message)
	for _, prefix in ipairs(PREFIXES) do
		if string.sub(message, 1, 1) == prefix then
			return true, prefix
		end
	end
	return false
end

-- Remove prefix from message
local function stripPrefix(message, prefix)
	return string.sub(message, #prefix + 1)
end

-- Handle chat commands
local function handleCommand(player, message)
	message = string.lower(message)
	local valid, prefix = hasValidPrefix(message)
	if not valid then return end

	local commandLine = stripPrefix(message, prefix)
	local args = string.split(commandLine, " ")
	local command = args[1]
	local target = args[2]

	if command == COMMANDS.ANCHOR then
		setAnchored(player.Character, true)
	elseif command == COMMANDS.UNANCHOR then
		setAnchored(player.Character, false)
	elseif command == COMMANDS.UNSTUCK then
		-- No target: unstuck self
		if not target then
			respawnPlayer(player)
			return
		end

		-- Only owner can unstuck others
		if player.UserId ~= ownerUserId then
			return -- Do nothing if non-owner tries to affect others
		end

		if target == "all" then
			for _, plr in ipairs(Players:GetPlayers()) do
				respawnPlayer(plr)
			end
		elseif target == "others" then
			for _, plr in ipairs(Players:GetPlayers()) do
				if plr ~= player then
					respawnPlayer(plr)
				end
			end
		else
			for _, plr in ipairs(Players:GetPlayers()) do
				if string.lower(plr.Name) == target then
					respawnPlayer(plr)
				end
			end
		end
	end
end

-- Connect chat listener for each player
Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(msg)
		handleCommand(player, msg)
	end)
end)
