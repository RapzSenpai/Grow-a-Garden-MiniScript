local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
 
-- ===== [1] INFINITE JUMP =====
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
 
UserInputService.JumpRequest:Connect(function()
    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end)
 
-- ===== [2] ANTI-AFK SYSTEM =====
local function antiAFK()
    while task.wait(300) do 
        VirtualInputManager:SendKeyEvent(true, "Left", false, nil)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, "Left", false, nil)
        
      
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(0.5), 0)
        end
    end
end
spawn(antiAFK) -- Runs in background
 
-- ===== [3] ORIGINAL WORKING AUTO-BUY =====
local GameEvents = ReplicatedStorage:WaitForChild("GameEvents")
 
local seedList = {
    "Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Tomato", "Corn", "Daffodil",
    "Watermelon", "Pumpkin", "Apple", "Bamboo", "Coconut", "Cactus", "Dragon Fruit",
    "Mango", "Grape", "Mushroom", "Pepper", "Cacao", "Beanstalk", "Ember Lily",
    "Sugar Apple", "Burning Bud", "Giant Pinecone", "Elder Strawberry"
}
 
local gearList = {
    "Watering Can", "Trowel", "Recall Wrench", "Basic Sprinkler", "Advanced Sprinkler",
    "Godly Sprinkler", "Magnifying Glass", "Tanning Mirror", "Master Sprinkler",
    "Cleaning Spray", "Favorite Tool", "Harvest Tool", "Friendship Pot",
    "Medium Toy", "Medium Treat", "Level Up Lollipop"
}
 
local function buyItem(event, itemName)
    pcall(function()
        event:FireServer(itemName)
        if GameEvents.SaveSlotService then
            GameEvents.SaveSlotService.RememberUnlockage:FireServer()
        end
    end)
end
 

_G.AutoBuy = true
spawn(function()
    while _G.AutoBuy do
        -- Buy all seeds
        for _, seed in ipairs(seedList) do
            if not _G.AutoBuy then break end
            buyItem(GameEvents.BuySeedStock, seed)
            task.wait(0.15)
        end
        
        -- Buy all gear
        for _, gear in ipairs(gearList) do
            if not _G.AutoBuy then break end
            buyItem(GameEvents.BuyGearStock, gear)
            task.wait(0.15)
        end
        
        task.wait(0.15)
    end
end)
