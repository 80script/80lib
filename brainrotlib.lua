--[[
USE GUIDE
Rebirth:fireserver() | idk if i type it right idc
collect(slot) | example collect("10")
BuySpeed(Speed) | example BuySpeed(4) | from 1 to 4
ToggleSpeed:FireServer() | self explain
upgrade(slot) | example upgrade("9")
]]
local CollectEarnEvent = game:GetService("ReplicatedStorage").SharedModules.Network.Remotes["Collect Earnings"] -- 
local Rebirth = game:GetService("ReplicatedStorage").SharedModules.Network.Remotes.Rebirth 
local BuySpeedEvent = game:GetService("ReplicatedStorage").SharedModules.Network.Remotes["Buy Speed Upgrade"]
local ToggleSpeed = game:GetService("ReplicatedStorage").SharedModules.Network.Remotes["Toggle Speed Setting"]
local UpgradeSlot = game:GetService("ReplicatedStorage").SharedModules.Network.Remotes["Upgrade Friend"]
local function upgrade(slot)
    UpgradeSlot:FireServer(slot)
end
local function collect(slot)
    CollectEarnEvent:FireServer(slot)
end
local function BuySpeed(speed)
 BuySpeedEvent:FireServer(4)
end
