local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local CollectEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("CollectCurrencyPickup")
local CurrencyHolder = Workspace:WaitForChild("Gameplay"):WaitForChild("CurrencyPickup"):WaitForChild("CurrencyHolder")
local UserInputService = game:GetService("UserInputService")

local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")

local Window = Rayfield:CreateWindow({
    Name = "Menyanety hub | check in pornhub",
    LoadingTitle = "Menyanety HUB",
     LoadingSubtitle = "by Menyanety",
     ConfigurationSaving = {
       Enabled = true,
       FolderName = nil, 
       FileName = "MenyanetyHub"
    },
    Discord = {
       Enabled = true,
       Invite = "gbVWxRFtqt", 
       RememberJoins = true 
    },
    KeySystem = false, 
    KeySettings = {
       Title = "Menyanety hub | pornhub ",
       Subtitle = "Link In Discord Server",
       Note = "https://discord.gg/gbVWxRFtqt",
       FileName = "menyanetyhubkey", 
       SaveKey = true, 
       GrabKeyFromSite = true, 
       Key = {"https://pastebin.com/raw/d8raPyFG"} 
    }
})

local MainTab = Window:CreateTab("🌍 pornhub", 4483362458)
local Section = MainTab:CreateSection("🌍")

local animations = {
    ReplicatedStorage.Animations.Slash3,
    ReplicatedStorage.Animations.Slash2,
    ReplicatedStorage.Animations.Slash1,
    ReplicatedStorage.Animations.Dual3,
    ReplicatedStorage.Animations.Dual2,
    ReplicatedStorage.Animations.Dual1,
}

local Toggle = MainTab:CreateToggle({
    Name = "🖌️ Auto Swing",
    CurrentValue = false,
    Flag = "DualAttackToggle",
    Save = true,
    Callback = function(Value)
        _G.DualAttackEnabled = Value

        if Value then
            spawn(function()
                local player = Players.LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                local humanoid = character:WaitForChild("Humanoid")

                local animator = humanoid:FindFirstChildOfClass("Animator")
                if not animator then
                    animator = Instance.new("Animator")
                    animator.Parent = humanoid
                end

                while _G.DualAttackEnabled do
                    pcall(function()
                        local anim = animations[math.random(1, #animations)]
                        local track = animator:LoadAnimation(anim)
                        track:Play()

                        for _, tool in pairs(character:GetChildren()) do
                            if tool:IsA("Tool") and tool:FindFirstChild("RemoteClick") then
                                tool.RemoteClick:FireServer()
                            end
                        end

                        ReplicatedStorage.Events.SwingSaber:FireServer()

                        task.wait(track.Length or 0.75)
                    end)
                end
            end)
        end
    end,
})

local mobileSettings = {
    Cooldown = 0.1, -- Увеличенный интервал для стабильности
    MaxPerCycle = 50, -- Лимит объектов за цикл
    UseSimplifiedMethod = true -- Упрощенный метод для телефонов
}

local function mobileCollect()
    local collected = 0
    local currencyHolder = workspace:FindFirstChild("Gameplay", true)
                             and workspace.Gameplay:FindFirstChild("CurrencyPickup", true)
                             and workspace.Gameplay.CurrencyPickup:FindFirstChild("CurrencyHolder", true)
    
    if not currencyHolder then 
        warn("CurrencyHolder не найден!")
        return false
    end

    local character = game.Players.LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then 
        warn("Персонаж не готов")
        return false
    end

    local root = character.HumanoidRootPart

    for _, obj in ipairs(currencyHolder:GetChildren()) do
        if not _G.MobileCollecting then break end
        if collected >= mobileSettings.MaxPerCycle then break end

        if obj.Name:lower():find("firework") then
            -- Упрощенный метод для телефонов
            if mobileSettings.UseSimplifiedMethod then
                pcall(function()
                    obj.CFrame = root.CFrame -- Телепорт к игроку
                    game:GetService("ReplicatedStorage").Events.CollectCurrencyPickup:FireServer({obj})
                end)
            else
                -- Стандартный метод (если упрощенный не работает)
                firetouchinterest(root, obj, 0)
                task.wait(0.05)
                firetouchinterest(root, obj, 1)
            end
            collected = collected + 1
        end
    end
    
    return true
end

local AutoFireworkMOBILEToggle = MainTab:CreateToggle({
    Name = "📱 Auto Firework FOR MOBILE",
    CurrentValue = false,
    Save = true,
    Flag = "AutoFireworkMOBILEToggle",
    Callback = function(Value)
        _G.MobileCollecting = Value
        
        spawn(function()
            while _G.MobileCollecting do
                local success = pcall(mobileCollect)
                if not success then
                    warn("Ошибка в цикле сбора")
                    _G.MobileCollecting = false
                    CollectToggle:Set(false)
                    break
                end
                task.wait(mobileSettings.Cooldown)
            end
        end)
    end
})

local AntiAFKConnection
local MovementLoop
local JumpLoop
 
local AntiAFKToggle = MainTab:CreateToggle({
	Name = "🛡️ Anti-AFK",
	CurrentValue = false,
    Save = true,
	Flag = "AntiAFK",
	Callback = function(Value)
		if Value then
			-- VirtualUser
			AntiAFKConnection = Player.Idled:Connect(function()
				VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
				task.wait(0.5)
				VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
			end)

			MovementLoop = RunService.RenderStepped:Connect(function()
				if HRP and Humanoid and Humanoid.MoveDirection.Magnitude == 0 then
					local offset = Vector3.new(0, 0, math.sin(tick()) * 0.001)
					HRP.CFrame = HRP.CFrame + offset
				end
			end)

			JumpLoop = task.spawn(function()
				while true do
					task.wait(100)
					if Humanoid then
						Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
					end
				end
			end)

		else
			if AntiAFKConnection then
				AntiAFKConnection:Disconnect()
				AntiAFKConnection = nil
			end
			if MovementLoop then
				MovementLoop:Disconnect()
				MovementLoop = nil
			end
			if JumpLoop then
				task.cancel(JumpLoop)
				JumpLoop = nil
			end
		end
	end,
})

local AutoHitMasterFireGolemToggle = MainTab:CreateToggle({
    Name = "🖱️ Auto Hit Master Fire Golem",
    CurrentValue = false,
    Save = true,
    Flag = "AutoHitMasterFireGolemToggle",
    Callback = function(Value)
        _G.AutoPowerSwing = Value

        while _G.AutoPowerSwing and task.wait(0.01) do
            pcall(function()
                local character = game:GetService("Players").LocalPlayer.Character
                local swordsModule = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("ItemInfo"):WaitForChild("Swords"))
				local boss5 = workspace:WaitForChild("Gameplay"):WaitForChild("RegionsLoaded"):WaitForChild("MasterFireArea"):WaitForChild("Important"):WaitForChild("Fire"):WaitForChild("Fire Golem")

                -- RemoteClick для каждого меча
                for swordName, _ in pairs(swordsModule) do
                    local tool = character:FindFirstChild(swordName)
                    if tool and tool:IsA("Tool") and tool:FindFirstChild("RemoteClick") then
                        local args = {
                            { boss5 }
                        }
                        tool.RemoteClick:FireServer(unpack(args))
                    end
                end

                -- SwingSaber
                
            end)
        end
    end,
})
--[[
local AutoHitMasterFireBossToggle = MainTab:CreateToggle({
    Name = "👆 Auto Hit Master Fire Boss",
    CurrentValue = false,
    Flag = "AutoHitMasterFireBossToggle",
    Save = true,
    Callback = function(Value)
        _G.AutoPowerSwing = Value

        while _G.AutoPowerSwing and task.wait(0.01) do
            pcall(function()
                local character = game:GetService("Players").LocalPlayer.Character
                local swordsModule = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("ItemInfo"):WaitForChild("Swords"))
				local boss6 = workspace:WaitForChild("Gameplay"):WaitForChild("RegionsLoaded"):WaitForChild("MasterFireArea"):WaitForChild("Important"):WaitForChild("Fire"):WaitForChild("Master Fire Boss")

                -- RemoteClick для каждого меча
                for swordName, _ in pairs(swordsModule) do
                    local tool = character:FindFirstChild(swordName)
                    if tool and tool:IsA("Tool") and tool:FindFirstChild("RemoteClick") then
                        local args = {
                            { boss6 }
                        }
                        tool.RemoteClick:FireServer(unpack(args))
                    end
                end

                -- SwingSaber
                
            end)
        end
    end,
})
--]]
local AutoHitMasterFireBossToggle = MainTab:CreateToggle({
    Name = "👆 Auto Hit Master Fire Boss",
    CurrentValue = false,
    Flag = "AutoHitMasterFireBossToggle",
    Save = true,
    Callback = function(Value)
        _G.AutoHitBoss = Value

        task.spawn(function()
            while _G.AutoHitBoss and task.wait(0.01) do
                pcall(function()
                    local character = game:GetService("Players").LocalPlayer.Character
                    local swordsModule = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("ItemInfo"):WaitForChild("Swords"))
                    local boss6 = workspace:WaitForChild("Gameplay"):WaitForChild("RegionsLoaded"):WaitForChild("MasterFireArea"):WaitForChild("Important"):WaitForChild("Fire"):WaitForChild("Master Fire Boss")

                    for swordName, _ in pairs(swordsModule) do
                        local tool = character:FindFirstChild(swordName)
                        if tool and tool:IsA("Tool") and tool:FindFirstChild("RemoteClick") then
                            tool.RemoteClick:FireServer({ boss6 })
                        end
                    end
                end)
            end
        end)
    end,
})

task.delay(1, function()
    local flags = Rayfield.Flags

    if flags.AutoHitMasterFireGolemToggle then
        AutoHitMasterFireGolemToggle:Set(true)
    end

    if flags.AutoHitMasterFireBossToggle then
        AutoHitMasterFireBossToggle:Set(true)
    end

    if flags.AutoFireworkMOBILEToggle then
        AutoFireworkMOBILEToggle:Set(true)
    end

    if flags.DualAttackToggle then
        DualAttackToggle:Set(true)
    end
end)

Rayfield:LoadConfiguration()
