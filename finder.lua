local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local module = loadstring(game:HttpGet"https://raw.githubusercontent.com/LeoKholYt/roblox/main/lk_serverhop.lua")()


-- Wait until 'request' exists
repeat task.wait() until request

local jobId = game.JobId
local serverLink = "https://www.roblox.com/games/" .. game.PlaceId .. "?jobId=" .. jobId
local webhook = "https://discord.com/api/webhooks/1444053515319382047/RYAldvNQtuTobZqHCRK3tCGGMQBevQa0B9kbHmm3ugNZYdj2lqToq8to_C8kGoslKv6E"
local lookFor = {
	"Sigma Boy",
	"Meowl",
	"Strawberry Elephant",
	"Tim Cheese",
	"Burguro And Fryuro",
	"La Secret Combinasion",
	"Money Money Puggy",
	"Dragon Cannelloni",
	"Tralaledon",
	"Garama and Madundung"
}

local foundBrainrots = {}
local detected = false

--- Sends embed to Discord webhook safely
local function SendMessageEMBED(url, embed)
	local data = {
		embeds = { embed }
	}
	local success, err = pcall(function()
		-- thanks guy
		request({
			Url = url,
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json" },
			Body = HttpService:JSONEncode(data)
		})
	end)
	if not success then
		warn("Failed to send webhook:", err)
	else
		print("Webhook sent successfully!")
	end
end

local function isInBrainrotsFolder(item)
	local parent = item.Parent
	while parent do
		if parent.Name == "Brainrots" then
			return true
		end
		parent = parent.Parent
	end
	return false
end

--- Check each item in workspace
local function checkItem(item)
	if not item:IsA("Model") then return end
	if item:FindFirstChild("_BrainrotDetected") then return end
	if isInBrainrotsFolder(item) then return end  -- Skip if parented under 'Brainrots'

	for _, name in ipairs(lookFor) do
		if item.Name == name then
			local tag = Instance.new("BoolValue")
			tag.Name = "_BrainrotDetected"
			tag.Value = true
			tag.Parent = item

			table.insert(foundBrainrots, item.Name)
			detected = true
		end
	end
end

--- Run detection
task.wait(1)
for _, item in ipairs(Workspace:GetDescendants()) do
	checkItem(item)
end
task.wait(0.5)

--- Send webhook if any found
if detected and #foundBrainrots > 0 then
	local fields = {}
	for _, name in ipairs(foundBrainrots) do
		table.insert(fields, {
			name = "🧠 " .. name,
			value = "Info coming soon...",
			inline = false
		})
	end

	local embed = {
		title = "🧠 Brainrot Items Found",
		description = "[Click to Join](" .. serverLink .. ")",
		color = 16776960, -- Yellow
		fields = fields
	}

	SendMessageEMBED(webhook, embed)
	while true do
		task.wait(.5)
		module:Teleport(game.PlaceId)
	end
end
