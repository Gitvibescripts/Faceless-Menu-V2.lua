local ScreenGui = Instance.new("ScreenGui")
local MenuFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local TransportButton = Instance.new("TextButton")
local PhysicsButton = Instance.new("TextButton")
local FlyButton = Instance.new("TextButton")
local TransportFrame = Instance.new("Frame")
local UsernameBar = Instance.new("TextBox")
local TpButton = Instance.new("TextButton")
local PhysicsFrame = Instance.new("Frame")
local PhysicsUsernameBar = Instance.new("TextBox")
local PhysicsToggleButton = Instance.new("TextButton")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

MenuFrame.Parent = ScreenGui
MenuFrame.Size = UDim2.new(0, 400, 0, 300)
MenuFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MenuFrame.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
MenuFrame.BackgroundTransparency = 0.3

Title.Parent = MenuFrame
Title.Size = UDim2.new(1, 0, 0.2, 0)
Title.Text = "The Faceless Hacker Menu"
Title.TextScaled = true
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)

TransportButton.Parent = MenuFrame
TransportButton.Size = UDim2.new(0.5, 0, 0.2, 0)
TransportButton.Position = UDim2.new(0, 0, 0.2, 0)
TransportButton.Text = "Teleport"
TransportButton.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
TransportButton.TextColor3 = Color3.fromRGB(255, 255, 255)

PhysicsButton.Parent = MenuFrame
PhysicsButton.Size = UDim2.new(0.5, 0, 0.2, 0)
PhysicsButton.Position = UDim2.new(0.5, 0, 0.2, 0)
PhysicsButton.Text = "Physics"
PhysicsButton.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
PhysicsButton.TextColor3 = Color3.fromRGB(255, 255, 255)

FlyButton.Parent = MenuFrame
FlyButton.Size = UDim2.new(1, 0, 0.2, 0)
FlyButton.Position = UDim2.new(0, 0, 0.4, 0)
FlyButton.Text = "Fly"
FlyButton.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)

TransportFrame.Parent = MenuFrame
TransportFrame.Size = UDim2.new(1, 0, 0.7, 0)
TransportFrame.Position = UDim2.new(0, 0, 0.3, 0)
UsernameBar.Parent = TransportFrame
UsernameBar.Size = UDim2.new(0.6, -10, 0.2, 0)
UsernameBar.PlaceholderText = "Enter Username"
UsernameBar.TextColor3 = Color3.fromRGB(0, 0, 0)
UsernameBar.BackgroundColor3 = Color3.fromRGB(200, 200, 200)

TpButton.Parent = TransportFrame
TpButton.Size = UDim2.new(0.3, 0, 0.2, 0)
TpButton.Position = UDim2.new(0.7, 5, 0.1, 0)
TpButton.Text = "TP"
TpButton.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
TpButton.TextColor3 = Color3.fromRGB(255, 255, 255)

PhysicsFrame.Parent = MenuFrame
PhysicsFrame.Size = UDim2.new(1, 0, 0.7, 0)
PhysicsFrame.Position = UDim2.new(0, 0, 0.3, 0)
PhysicsFrame.Visible = false
PhysicsUsernameBar.Parent = PhysicsFrame
PhysicsUsernameBar.Size = UDim2.new(0.6, -10, 0.2, 0)
PhysicsUsernameBar.PlaceholderText = "Enter Username"
PhysicsUsernameBar.TextColor3 = Color3.fromRGB(0, 0, 0)
PhysicsUsernameBar.BackgroundColor3 = Color3.fromRGB(200, 200, 200)

PhysicsToggleButton.Parent = PhysicsFrame
PhysicsToggleButton.Size = UDim2.new(0.3, 0, 0.2, 0)
PhysicsToggleButton.Position = UDim2.new(0.7, 5, 0.1, 0)
PhysicsToggleButton.Text = "OFF"
PhysicsToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

local isFlying = false
local flyingSpeed = 50
local bodyGyro, bodyVelocity

TransportButton.MouseButton1Click:Connect(function()
    TransportFrame.Visible = true
    PhysicsFrame.Visible = false
end)

PhysicsButton.MouseButton1Click:Connect(function()
    TransportFrame.Visible = false
    PhysicsFrame.Visible = true
end)

TpButton.MouseButton1Click:Connect(function()
    local targetName = UsernameBar.Text
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name == targetName then
            LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
            break
        end
    end
end)

local PhysicsActive = false
PhysicsToggleButton.MouseButton1Click:Connect(function()
    PhysicsActive = not PhysicsActive
    PhysicsToggleButton.Text = PhysicsActive and "ON" or "OFF"
    PhysicsToggleButton.BackgroundColor3 = PhysicsActive and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)

    local targetName = PhysicsUsernameBar.Text
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name == targetName then
            while PhysicsActive do
                local targetChar = player.Character
                if targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
                    local targetPosition = targetChar.HumanoidRootPart.Position
                    for _, part in pairs(workspace:GetDescendants()) do
                        if part:IsA("BasePart") and not part.Anchored then
                            part.Position = targetPosition
                        end
                    end
                end
                wait(0.1)
            end
            break
        end
    end
end)

FlyButton.MouseButton1Click:Connect(function()
    isFlying = not isFlying
    if isFlying then
        FlyButton.Text = "Stop Fly"
        bodyGyro = Instance.new("BodyGyro")
        bodyVelocity = Instance.new("BodyVelocity")
        
        bodyGyro.Parent = LocalPlayer.Character.HumanoidRootPart
        bodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
        
        bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
        bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
        bodyVelocity.Velocity = Vector3.new(0, flyingSpeed, 0)
        bodyGyro.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
    else
        FlyButton.Text = "Fly"
        if bodyGyro then bodyGyro:Destroy() end
        if bodyVelocity then bodyVelocity:Destroy() end
    end
end)
