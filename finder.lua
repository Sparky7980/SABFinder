local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local module = loadstring(game:HttpGet("https://raw.githubusercontent.com/LeoKholYt/roblox/main/lk_serverhop.lua"))()
local Players = game:GetService("Players")
-- Wait until 'request' exists
repeat task.wait() until request

local player = Players.LocalPlayer
repeat task.wait() until player and player.Character and player.Character:FindFirstChild("HumanoidRootPart")

local jobId = game.JobId
local serverLink = "https://www.roblox.com/games/" .. game.PlaceId .. "?jobId=" .. jobId

local NormalWebhook = "https://discord.com/api/webhooks/1444461136115138680/Ub7fdE0BHgg7FSf1LGvRZHzKQhKA5HEcmQcDgOoICy7hLXz5aeB28YVwsDUEAv6obPbL"
local PremiumWebhook = "https://discord.com/api/webhooks/1444053515319382047/RYAldvNQtuTobZqHCRK3tCGGMQBevQa0B9kbHmm3ugNZYdj2lqToq8to_C8kGoslKv6E"

local normalLookFor = {
	"Los Matteos", "La Vacca Saturno Saturnita", "Torrtuginni Dragonfrutini", "1x1x1x1",
	"La Cucaracha", "Los Tralaleritos", "Karkerkar Kurkur", "Los Spyderinis", "Las Tralaleritas",
	"Job Job Job Sahur", "Noo my examine", "Blackhole Goat", "Las Vaquitas Saturnitas",
	"Graipuss Medussi", "To to to Sahur", "Extinct Tralalero", "Extinct Matteo",
	"Los Spyderrinis", "Perrito Burrito", "Pot Hotspot", "Chicleteira Bicicleteira",
	"Chicleteirina Bicicleteirina", "Pumpkini Spiderini","Quesadilla Crocodila","Los Tortus","Boatito Auratito",
    "Guerriro Digitale","Giftini Spyderini","Dul Dul Dul","Los Cucarachas",
}

local PremiumLookFor = {
	"Money Money Puggy", "Los Chicleteiras", "La Grande Combinasion", "Tang Tang Keletang",
	"Swag Soda", "Los Hotspotsitos", "67", "Los Noo My Hotspotsitos", "Celularcini Viciosini",
	"La Sahur Combination", "Nuclearo Dinossauro", "Esok Sekolah", "Meowl", "Strawberry Elephant",
	"Burguro And Fryuro", "Las Sis", "La Secret Combinasion", "Ketupat Kepat", "Tictac Sahur",
	"Nooo My Hotspot", "Los Tacoritas", "La Extinct Grande", "Chillin Chili", "Tacorita Bicicleta",
	"La Supreme Combinasion", "Ketchuru and Musturu", "Los Primos", "Los Bros", "Guest 666",
	"Mariachi Corazoni", "Los Combinasionas", "Headless Horseman", "Spaghetti Tualetti",
	"Capitano Moby", "Burguro And Fryuro", "Secret Lucky Block", "Dragon Cannelloni",
	"Tralaledon", "Garama and Madundung", "Tung Tung Tung Sahur","Horegini Boom","Orcaledon","Los Puggies",
	"Los Spaghettis","Fragrama and Chocrama","Cooki and Milki","La Casa Boo","Los Hotspotcitos","Coffin Tung Tung Tung Sahur",
}

local function SendMessageEMBED(url, embed)
	local data = { embeds = { embed } }
	local success, err = pcall(function()
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

-- Collect all brainrots first
local normalFound = {}
local premiumFound = {}

for _, item in ipairs(Workspace:GetDescendants()) do
	if item:IsA("Model") and not item:FindFirstChild("_BrainrotDetected") and not isInBrainrotsFolder(item) then
		if table.find(normalLookFor, item.Name) then
			table.insert(normalFound, item.Name)
			local tag = Instance.new("BoolValue")
			tag.Name = "_BrainrotDetected"
			tag.Value = true
			tag.Parent = item
		elseif table.find(PremiumLookFor, item.Name) then
			table.insert(premiumFound, item.Name)
			local tag = Instance.new("BoolValue")
			tag.Name = "_BrainrotDetected"
			tag.Value = true
			tag.Parent = item
		end
	end
end

-- Function to build and send a single embed for a category
local function SendBrainrotWebhook(foundList, webhook)
	if #foundList == 0 then return end
	local fields = {}
	for _, name in ipairs(foundList) do
		table.insert(fields, {
			name = "🧠 " .. name,
			value = "Info coming soon...",
			inline = false
		})
	end
	local embed = {
		title = "🧠 Brainrot Items Found",
		description = "[Click to Join](" .. serverLink .. ")",
		color = 16776960,
		fields = fields
	}
	SendMessageEMBED(webhook, embed)
end

-- Send webhooks once for each category
SendBrainrotWebhook(normalFound, NormalWebhook)
SendBrainrotWebhook(premiumFound, PremiumWebhook)

