local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Cleanup
if CoreGui:FindFirstChild("NexusHub") then CoreGui.NexusHub:Destroy() end

local NexusHub = Instance.new("ScreenGui", CoreGui)
NexusHub.Name = "NexusHub"

-- Main Window
local Main = Instance.new("Frame", NexusHub)
Main.Size = UDim2.new(0, 450, 0, 250)
Main.Position = UDim2.new(0.5, -225, 0.5, -125)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

-- Header
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Color3.fromRGB(10, 10, 15)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -110, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "NEXUS HUB | STATS LOCKER"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.TextXAlignment = "Left"

-- Minimize & Close
local Minimized = false
local MinBtn = Instance.new("TextButton", Header)
MinBtn.Size = UDim2.new(0, 35, 0, 35)
MinBtn.Position = UDim2.new(1, -75, 0, 0)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
MinBtn.TextColor3 = Color3.new(1, 1, 1)

local Close = Instance.new("TextButton", Header)
Close.Size = UDim2.new(0, 35, 0, 35)
Close.Position = UDim2.new(1, -35, 0, 0)
Close.Text = "X"
Close.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
Close.TextColor3 = Color3.new(1, 1, 1)

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -20, 1, -45)
Scroll.Position = UDim2.new(0, 10, 0, 40)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 1, 0)
Scroll.ScrollBarThickness = 3

local List = Instance.new("UIListLayout", Scroll)
List.Padding = UDim.new(0, 10)
List.HorizontalAlignment = "Center"

-----------------------------------------------------------
-- STAT LOCKER LOGIC (Optimized for image_47845b.png)
-----------------------------------------------------------
local Options = { LockAll = false }

local function CreateBtn(text, var)
    local b = Instance.new("TextButton", Scroll)
    b.Size = UDim2.new(1, -10, 0, 50)
    b.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    b.Text = text .. ": OFF"
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = "Gotham"
    
    b.MouseButton1Click:Connect(function()
        Options[var] = not Options[var]
        b.Text = text .. (Options[var] and ": ON" or ": OFF")
        b.BackgroundColor3 = Options[var] and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(45, 45, 50)
    end)
end

CreateBtn("Lock All Stats (Fix Hunger/Water)", "LockAll")

MinBtn.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    Scroll.Visible = not Minimized
    Main:TweenSize(Minimized and UDim2.new(0, 450, 0, 35) or UDim2.new(0, 450, 0, 250), "Out", "Quart", 0.3, true)
end)

Close.MouseButton1Click:Connect(function() NexusHub:Destroy() end)

RunService.Heartbeat:Connect(function()
    local Char = LocalPlayer.Character
    if not Char or not Options.LockAll then return end

    pcall(function()
        -- 1. Lock Character Attributes
        local targetStats = {"Stamina", "Hunger", "Thirst", "Water", "Food"}
        for _, stat in pairs(targetStats) do
            Char:SetAttribute(stat, 100)
        end
        
        -- 2. Target internal Data folder if it exists
        local Data = LocalPlayer:FindFirstChild("Data") or Char:FindFirstChild("Data")
        if Data then
            for _, v in pairs(Data:GetChildren()) do
                if v:IsA("ValueBase") then
                    v.Value = 100
                end
            end
        end

        -- 3. Force UI sync for icons in image_47845b.png
        local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
        for _, v in pairs(PlayerGui:GetDescendants()) do
            if v:IsA("ValueBase") then
                local n = v.Name:lower()
                if n == "stamina" or n == "hunger" or n == "thirst" or n == "food" or n == "water" then
                    v.Value = 100
                end
            end
        end
    end)
end)
