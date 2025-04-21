local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Maestria Hub - Mobile",
    LoadingTitle = "Carregando...",
    ConfigurationSaving = {
        Enabled = false
    }
})

local Toggles = {
    AutoEquipFruit = false,
    AutoFarm = false
}

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

function EquipFruit()
    for i, v in pairs(Player.Backpack:GetChildren()) do
        if v:IsA("Tool") and v:FindFirstChild("RemoteFunction_Skill1") then
            v.Parent = Character
            break
        end
    end
end

function AttackWithFruit()
    local tool = Character:FindFirstChildWhichIsA("Tool")
    if tool then
        tool:Activate()
    end
end

function GetNearestEnemy()
    local closest = nil
    local shortest = math.huge

    for i, v in pairs(workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            local distance = (v.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude
            if distance < shortest then
                shortest = distance
                closest = v
            end
        end
    end

    return closest
end

-- UI: Toggles
local Tab = Window:CreateTab("Maestria", 4483362458)

Tab:CreateToggle({
    Name = "Auto Equipar Fruta",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.AutoEquipFruit = Value
    end,
})

Tab:CreateToggle({
    Name = "Auto Farm de Maestria",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.AutoFarm = Value
    end,
})

-- Loop principal
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            Character = Player.Character or Player.CharacterAdded:Wait()

            if Toggles.AutoEquipFruit and not Character:FindFirstChildWhichIsA("Tool") then
                EquipFruit()
            end

            if Toggles.AutoFarm then
                local enemy = GetNearestEnemy()
                if enemy then
                    repeat
                        Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 25, 0)
                        AttackWithFruit()
                        task.wait(1)
                    until enemy.Humanoid.Health <= 0 or not enemy.Parent
                end
            end
        end)
    end
end)
