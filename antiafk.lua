-- Anti-AFK by jigi1337
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/jigi1337/Anti-AFK/main/antiafk.lua"))()

local ok, err = pcall(function()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local startTime = tick()

-- ═══════════════════════════════════════
--           NOTIFY FUNKTION
-- ═══════════════════════════════════════

local function notify(title, text, duration)
    duration = duration or 5
    -- Solara notify
    if syn and syn.toast_notification then
        pcall(function()
            syn.toast_notification({
                Type = "info",
                Title = title,
                Content = text,
                Duration = duration,
            })
        end)
    end
    -- Roblox Notification (Fallback, funktioniert immer)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration,
            Icon = "rbxassetid://7733960981",
        })
    end)
end

-- ═══════════════════════════════════════
--           DUPLIKAT ENTFERNEN
-- ═══════════════════════════════════════

local old = game:GetService("CoreGui"):FindFirstChild("AntiAFK_GUI")
    or player.PlayerGui:FindFirstChild("AntiAFK_GUI")
if old then old:Destroy() end

-- ═══════════════════════════════════════
--           GUI
-- ═══════════════════════════════════════

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AntiAFK_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999

local coreOk = pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not coreOk then
    ScreenGui.Parent = player.PlayerGui
end

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 240, 0, 115)
MainFrame.Position = UDim2.new(0, 20, 0, 20)
MainFrame.BackgroundColor3 = Color3.fromRGB(13, 13, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(0, 210, 100)
Stroke.Thickness = 1.5

-- Titelbar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 32)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Active = true
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 8)

-- Grüner Dot
local Dot = Instance.new("Frame", TitleBar)
Dot.Size = UDim2.new(0, 8, 0, 8)
Dot.Position = UDim2.new(0, 10, 0.5, -4)
Dot.BackgroundColor3 = Color3.fromRGB(0, 220, 100)
Dot.BorderSizePixel = 0
Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

-- Titel
local TitleLabel = Instance.new("TextLabel", TitleBar)
TitleLabel.Size = UDim2.new(0, 75, 1, 0)
TitleLabel.Position = UDim2.new(0, 24, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Anti-AFK"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- by jigi1337
local ByLabel = Instance.new("TextLabel", TitleBar)
ByLabel.Size = UDim2.new(0, 80, 1, 0)
ByLabel.Position = UDim2.new(0, 98, 0, 0)
ByLabel.BackgroundTransparency = 1
ByLabel.Text = "by jigi1337"
ByLabel.TextColor3 = Color3.fromRGB(90, 90, 120)
ByLabel.TextSize = 10
ByLabel.Font = Enum.Font.Gotham
ByLabel.TextXAlignment = Enum.TextXAlignment.Left

-- X Button
local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(1, -29, 0.5, -12)
CloseBtn.BackgroundColor3 = Color3.fromRGB(190, 45, 45)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 11
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)

CloseBtn.MouseEnter:Connect(function()
    CloseBtn.BackgroundColor3 = Color3.fromRGB(240, 65, 65)
end)
CloseBtn.MouseLeave:Connect(function()
    CloseBtn.BackgroundColor3 = Color3.fromRGB(190, 45, 45)
end)

-- ═══════════════════════════════════════
--           STATS (PING / FPS / TIME)
-- ═══════════════════════════════════════

local StatsFrame = Instance.new("Frame", MainFrame)
StatsFrame.Size = UDim2.new(1, -20, 0, 55)
StatsFrame.Position = UDim2.new(0, 10, 0, 36)
StatsFrame.BackgroundTransparency = 1

local cols = {{"PING","ping"}, {"FPS","fps"}, {"TIME","time"}}
local vals = {}

for i, col in ipairs(cols) do
    local f = Instance.new("Frame", StatsFrame)
    f.Size = UDim2.new(0.333, 0, 1, 0)
    f.Position = UDim2.new(0.333 * (i - 1), 0, 0, 0)
    f.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(1, 0, 0, 18)
    lbl.BackgroundTransparency = 1
    lbl.Text = col[1]
    lbl.TextColor3 = Color3.fromRGB(90, 90, 115)
    lbl.TextSize = 9
    lbl.Font = Enum.Font.GothamBold

    local val = Instance.new("TextLabel", f)
    val.Size = UDim2.new(1, 0, 0, 30)
    val.Position = UDim2.new(0, 0, 0, 18)
    val.BackgroundTransparency = 1
    val.Text = "0"
    val.TextColor3 = Color3.fromRGB(240, 240, 240)
    val.TextSize = 20
    val.Font = Enum.Font.GothamBold

    vals[col[2]] = val
end

-- Trennlinie
local Div = Instance.new("Frame", MainFrame)
Div.Size = UDim2.new(1, -20, 0, 1)
Div.Position = UDim2.new(0, 10, 0, 94)
Div.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
Div.BorderSizePixel = 0

-- Footer
local Footer = Instance.new("TextLabel", MainFrame)
Footer.Size = UDim2.new(1, -10, 0, 18)
Footer.Position = UDim2.new(0, 8, 1, -20)
Footer.BackgroundTransparency = 1
Footer.Text = "● Anti-AFK aktiv"
Footer.TextColor3 = Color3.fromRGB(0, 200, 100)
Footer.TextSize = 10
Footer.Font = Enum.Font.Gotham
Footer.TextXAlignment = Enum.TextXAlignment.Left

-- ═══════════════════════════════════════
--           DRAGGING
-- ═══════════════════════════════════════

local dragging = false
local dragInput, dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and dragInput and input == dragInput then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- ═══════════════════════════════════════
--           CLOSE BUTTON
-- ═══════════════════════════════════════

CloseBtn.MouseButton1Click:Connect(function()
    notify("Anti-AFK", "Script gestoppt.", 3)
    task.wait(0.3)
    ScreenGui:Destroy()
end)

-- ═══════════════════════════════════════
--           ANTI-AFK LOGIK
-- ═══════════════════════════════════════

-- Wenn Roblox dich als idle erkennt
player.Idled:Connect(function()
    pcall(function()
        VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end)
end)

-- Alle 110 Sekunden präventiv klicken
task.spawn(function()
    while ScreenGui and ScreenGui.Parent do
        task.wait(110)
        if ScreenGui and ScreenGui.Parent then
            pcall(function()
                VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                task.wait(0.5)
                VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            end)
        end
    end
end)

-- ═══════════════════════════════════════
--           UPDATE LOOP
-- ═══════════════════════════════════════

RunService.RenderStepped:Connect(function(dt)
    if not ScreenGui or not ScreenGui.Parent then return end
    pcall(function()
        -- FPS
        vals["fps"].Text = tostring(math.clamp(math.floor(1 / dt), 0, 999))

        -- Ping
        local ping = math.max(0, math.floor(player:GetNetworkPing() * 1000))
        vals["ping"].Text = tostring(ping)

        -- Zeit
        local e = math.floor(tick() - startTime)
        vals["time"].Text = string.format("%d:%02d:%02d",
            math.floor(e / 3600),
            math.floor((e % 3600) / 60),
            e % 60
        )
    end)
end)

-- ═══════════════════════════════════════
--           ERFOLG NOTIFY
-- ═══════════════════════════════════════

notify("Anti-AFK", "Erfolgreich geladen! by jigi1337", 5)

end) -- Ende pcall

-- ═══════════════════════════════════════
--           ERROR HANDLING
-- ═══════════════════════════════════════

if not ok then
    warn("[Anti-AFK ERROR]: " .. tostring(err))
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "❌ Anti-AFK ERROR",
            Text = tostring(err),
            Duration = 10,
        })
    end)
end
