--[[
===================================================
                BRAINROT GAME LIBRARY
===================================================
USE GUIDE (после загрузки через loadstring):
lib.rebirth()        - сделать ребирз
lib.collect(slot)    - собрать деньги со слота (число или строка)
lib.buySpeed(speed)  - купить апгрейд скорости (от 1 до 4)
lib.toggleSpeed()    - переключить настройку скорости
lib.upgrade(slot)    - апгрейднуть друга в слоте
===================================================
]]

local BrainrotLib = {}


local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("Network"):WaitForChild("Remotes")

local CollectEarnEvent = Remotes:WaitForChild("Collect Earnings")
local RebirthEvent = Remotes:WaitForChild("Rebirth")
local BuySpeedEvent = Remotes:WaitForChild("Buy Speed Upgrade")
local ToggleSpeedEvent = Remotes:WaitForChild("Toggle Speed Setting")
local UpgradeSlotEvent = Remotes:WaitForChild("Upgrade Friend")

function BrainrotLib.upgrade(slot)
    UpgradeSlotEvent:FireServer(tostring(slot))
end


function BrainrotLib.collect(slot)
    CollectEarnEvent:FireServer(tostring(slot))
end


function BrainrotLib.buySpeed(speed)
    BuySpeedEvent:FireServer(speed)
end


function BrainrotLib.toggleSpeed()
    ToggleSpeedEvent:FireServer()
end

function BrainrotLib.rebirth()
    RebirthEvent:FireServer()
end

-- Обязательно возвращаем таблицу, чтобы loadstring()() мог её прочитать!
return BrainrotLib
