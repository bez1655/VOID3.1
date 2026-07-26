-- ===================================================================
-- 👑 SUPER ULTRA MEGA LUXURY PREMIUM HYPER HUB v5.0 👑
-- Combined Architecture: VOIDx + VOID-X + VOID-Xs + Ultra-X-Hub 3.0
-- ===================================================================

local HYPER_HUB = {
    Name = "HYPER HUB ULTRA LUXURY",
    Version = "5.0.0-PREMIUM",
    Connections = {},
    Modules = {},
    UI = {},
    Config = {
        Aimbot = false,
        ESP = false,
        Speed = 16,
        JumpPower = 50,
        Theme = "VoidLuxury"
    }
}

-- Services
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

-- ===================================================================
-- 1. MEMORY & CONNECTION MANAGER (Cleanup / Janitor System)
-- ===================================================================
function HYPER_HUB:AddConnection(conn)
    table.insert(self.Connections, conn)
    return conn
end

function HYPER_HUB:Unload()
    for _, conn in ipairs(self.Connections) do
        if conn and conn.Disconnect then
            pcall(function() conn:Disconnect() end)
        end
    end
    table.clear(self.Connections)
    
    if self.UI.MainScreen then
        self.UI.MainScreen:Destroy()
    end
    
    print("ScreenUnload: [HYPER HUB] Successfully cleaned up all resources!")
end

-- ===================================================================
-- 2. CONFIGURATION SYSTEM (JSON File System)
-- ===================================================================
local CONFIG_FILE = "HyperHub_PremiumConfig.json"

function HYPER_HUB:SaveConfig()
    if writefile then
        local success, err = pcall(function()
            writefile(CONFIG_FILE, HttpService:JSONEncode(self.Config))
        end)
        if success then
            self:Notify("Config", "Settings saved successfully!", 2)
        end
    end
end

function HYPER_HUB:LoadConfig()
    if readfile and isfile and isfile(CONFIG_FILE) then
        local success, result = pcall(function()
            return HttpService:JSONDecode(readfile(CONFIG_FILE))
        end)
        if success and type(result) == "table" then
            for k, v in pairs(result) do
                self.Config[k] = v
            end
        end
    end
end

-- ===================================================================
-- 3. LUXURY UI ENGINE & NOTIFICATION SYSTEM
-- ===================================================================
function HYPER_HUB:Notify(title, text, duration)
    duration = duration or 3
    print(string.format("[%s] %s: %s", self.Name, title, text))
    
    if not self.UI.Container then return end
    
    local Toast = Instance.new("Frame")
    Toast.Size = UDim2.new(0, 220, 0, 50)
    Toast.Position = UDim2.new(1, 10, 0.8, -#self.UI.Container:GetChildren() * 55)
    Toast.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Toast.BorderSizePixel = 0
    Toast.Parent = self.UI.Container
    
    local Corner = Instance.new("UICorner", Toast)
    Corner.CornerRadius = UDim.new(0, 8)
    
    local Stroke = Instance.new("UIStroke", Toast)
    Stroke.Color = Color3.fromRGB(138, 43, 226) -- Void Accent
    Stroke.Thickness = 1.5

    local TitleLbl = Instance.new("TextLabel", Toast)
    TitleLbl.Size = UDim2.new(1, -10, 0, 20)
    TitleLbl.Position = UDim2.new(0, 10, 0, 5)
    TitleLbl.Text = title
    TitleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 13
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.BackgroundTransparency = 1

    local TextLbl = Instance.new("TextLabel", Toast)
    TextLbl.Size = UDim2.new(1, -10, 0, 20)
    TextLbl.Position = UDim2.new(0, 10, 0, 25)
    TextLbl.Text = text
    TextLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
    TextLbl.Font = Enum.Font.Gotham
    TextLbl.TextSize = 11
    TextLbl.TextXAlignment = Enum.TextXAlignment.Left
    TextLbl.BackgroundTransparency = 1

    TweenService:Create(Toast, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -230, 0.8, -#self.UI.Container:GetChildren() * 55)
    }):Play()

    task.delay(duration, function()
        local tweenOut = TweenService:Create(Toast, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 10, Toast.Position.Y.Scale, Toast.Position.Y.Offset)
        })
        tweenOut:Play()
        tweenOut.Completed:Connect(function() Toast:Destroy() end)
    end)
end

function HYPER_HUB:BuildUI()
    -- Main Screen
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "HYPER_HUB_GUI"
    ScreenGui.ResetOnSpawn = false
    
    pcall(function()
        ScreenGui.Parent = CoreGui
    end)
    if not ScreenGui.Parent then
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    
    self.UI.MainScreen = ScreenGui

    -- Toast Container
    local ToastFrame = Instance.new("Frame", ScreenGui)
    ToastFrame.Size = UDim2.new(1, 0, 1, 0)
    ToastFrame.BackgroundTransparency = 1
    self.UI.Container = ToastFrame

    -- Window Frame
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 520, 0, 340)
    MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true

    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = Color3.fromRGB(110, 0, 255)
    MainStroke.Thickness = 2

    -- Top Header
    local Header = Instance.new("TextLabel", MainFrame)
    Header.Size = UDim2.new(1, -20, 0, 40)
    Header.Position = UDim2.new(0, 15, 0, 5)
    Header.Text = "⚡ HYPER HUB ULTRA LUXURY v5.0"
    Header.Font = Enum.Font.GothamBold
    Header.TextSize = 16
    Header.TextColor3 = Color3.fromRGB(240, 240, 255)
    Header.TextXAlignment = Enum.TextXAlignment.Left
    Header.BackgroundTransparency = 1

    -- Control Panel (Buttons)
    local Content = Instance.new("Frame", MainFrame)
    Content.Size = UDim2.new(1, -30, 1, -60)
    Content.Position = UDim2.new(0, 15, 0, 50)
    Content.BackgroundTransparency = 1

    local UIList = Instance.new("UIListLayout", Content)
    UIList.Padding = UDim.new(0, 10)
    UIList.SortOrder = Enum.SortOrder.LayoutOrder

    -- Helper to create buttons
    local function CreateButton(name, callback)
        local Btn = Instance.new("TextButton", Content)
        Btn.Size = UDim2.new(1, 0, 0, 38)
        Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        Btn.Text = name
        Btn.Font = Enum.Font.GothamMedium
        Btn.TextColor3 = Color3.fromRGB(220, 220, 220)
        Btn.TextSize = 13
        Btn.AutoButtonColor = false
        
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
        local Stroke = Instance.new("UIStroke", Btn)
        Stroke.Color = Color3.fromRGB(45, 45, 60)

        Btn.MouseButton1Click:Connect(function()
            callback(Btn)
        end)

        Btn.MouseEnter:Connect(function()
            TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play()
        end)
        Btn.MouseLeave:Connect(function()
            TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 35)}):Play()
        end)
    end

    -- Feature Toggles
    CreateButton("Toggle Speed Boost (WalkSpeed: 50)", function(btn)
        HYPER_HUB.Config.Speed = HYPER_HUB.Config.Speed == 16 and 50 or 16
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = HYPER_HUB.Config.Speed
        end
        HYPER_HUB:Notify("Speed", "WalkSpeed set to: " .. tostring(HYPER_HUB.Config.Speed))
    end)

    CreateButton("Toggle ESP Mode (Highlight Players)", function(btn)
        HYPER_HUB.Config.ESP = not HYPER_HUB.Config.ESP
        HYPER_HUB:Notify("ESP", "ESP state: " .. tostring(HYPER_HUB.Config.ESP))
    end)

    CreateButton("💾 Save Configuration", function()
        HYPER_HUB:SaveConfig()
    end)

    CreateButton("❌ Unload & Destroy Hub", function()
        HYPER_HUB:Unload()
    end)
end

-- ===================================================================
-- 4. CORE ENGINE & LOOPS
-- ===================================================================
function HYPER_HUB:Init()
    self:LoadConfig()
    self:BuildUI()

    -- Continuous loop for features (ESP, Player modifications)
    self:AddConnection(RunService.Stepped:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            if LocalPlayer.Character.Humanoid.WalkSpeed ~= self.Config.Speed and self.Config.Speed ~= 16 then
                LocalPlayer.Character.Humanoid.WalkSpeed = self.Config.Speed
            end
        end
    end))

    self:Notify("System", "HYPER HUB Super Luxury Loaded Successfully!", 4)
end

-- Launch the Hub
HYPER_HUB:Init()