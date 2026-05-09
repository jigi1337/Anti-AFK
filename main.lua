local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local startTime = tick()

-- ═══════════════════════════════════════════
--              GUI ERSTELLEN
-- ═══════════════════════════════════════════

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AntiAFK_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Versuche in CoreGui zu laden (umgeht ResetOnSpawn)
local success = pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not success then
    ScreenGui.Parent = player.PlayerGui
end

-- Hauptframe
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 240, 0, 110)
MainFrame.Position = UDim2.new(0, 20, 0, 20)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Abgerundete Ecken
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = MainFrame

-- Äußerer Rahmen (Glow-Effekt)
local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 200, 100)
Stroke.Thickness = 1.5
Stroke.Parent = MainFrame

-- Titelleiste (für Dragging)
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

-- Grüner Dot
local StatusDot = Instance.new("Frame")
StatusDot.Size = UDim2.new(0, 8, 0, 8)
StatusDot.Position = UDim2.new(0, 10, 0.5, -4)
StatusDot.BackgroundColor3 = Color3.fromRGB(0, 220, 100)
StatusDot.BorderSizePixel = 0
StatusDot.Parent = TitleBar

local DotCorner = Instance.new("UICorner")
DotCorner.CornerRadius = UDim.new(1, 0)
DotCorner.Parent = StatusDot

-- Titel Text
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -60, 1, 0)
TitleLabel.Position = UDim2.new(0, 24, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Anti-AFK"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Untertitel
local SubLabel = Instance.new("TextLabel")
SubLabel.Size = UDim2.new(1, -60, 1, 0)
SubLabel.Position = UDim2.new(0, 24, 0, 0)
SubLabel.BackgroundTransparency = 1
SubLabel.Text = "by Claude"
SubLabel.TextColor3 = Color3.fromRGB(120, 120, 140)
SubLabel.TextSize = 10
SubLabel.Font = Enum.Font.Gotham
SubLabel.TextXAlignment = Enum.TextXAlignment.Left
SubLabel.Parent = TitleBar
-- Position Untertitel weiter rechts neben Titel
SubLabel.Size = UDim2.new(0, 60, 1, 0)
SubLabel.Position = UDim2.new(0, 90, 0, 0)

-- X Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 24, 0, 24)
CloseButton.Position = UDim2.new(1, -28, 0.5, -12)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 11
CloseButton.Font = Enum.Font.GothamBold
CloseButton.BorderSizePixel = 0
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 5)
CloseCorner.Parent = CloseButton

-- Hover-Effekt für X-Button
CloseButton.MouseEnter:Connect(function()
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
end)
CloseButton.MouseLeave:Connect(function()
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
end)

-- ═══════════════════════════════════════════
--              STATS ANZEIGE
-- ═══════════════════════════════════════════

local StatsFrame = Instance.new("Frame")
StatsFrame.Size = UDim2.new(1, -20, 0, 50)
StatsFrame.Position = UDim2.new(0, 10, 0, 38)
StatsFrame.BackgroundTransparency = 1
StatsFrame.Parent = MainFrame

-- 3 Spalten: PING | FPS | TIME
local columns = {
    {label = "PING", valueKey = "ping"},
    {label = "FPS", valueKey = "fps"},
    {label = "TIME", valueKey = "time"},
}

local valueLabels = {}

for i, col in ipairs(columns) do
    local colFrame = Instance.new("Frame")
    colFrame.Size = UDim2.new(0.333, 0, 1, 0)
    colFrame.Position = UDim2.new(0.333 * (i - 1), 0, 0, 0)
    colFrame.BackgroundTransparency = 1
    colFrame.Parent = StatsFrame

    local headerLbl = Instance.new("TextLabel")
    headerLbl.Size = UDim2.new(1, 0, 0.4, 0)
    headerLbl.BackgroundTransparency = 1
    headerLbl.Text = col.label
    headerLbl.TextColor3 = Color3.fromRGB(100, 100, 120)
    headerLbl.TextSize = 9
    headerLbl.Font = Enum.Font.GothamBold
    headerLbl.Parent = colFrame

    local valueLbl = Instance.new("TextLabel")
    valueLbl.Size = UDim2.new(1, 0, 0.6, 0)
    valueLbl.Position = UDim2.new(0, 0, 0.4, 0)
    valueLbl.BackgroundTransparency = 1
    valueLbl.Text = "..."
    valueLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueLbl.TextSize = 18
    valueLbl.Font = Enum.Font.GothamBold
    valueLbl.Parent = colFrame

    valueLabels[col.valueKey] = valueLbl
end

-- Trennlinie
local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(1, -20, 0, 1)
Divider.Position = UDim2.new(0, 10, 0, 92)
Divider.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
Divider.BorderSizePixel = 0
Divider.Parent = MainFrame

-- Footer
local FooterLabel = Instance.new("TextLabel")
FooterLabel.Size = UDim2.new(1, 0, 0, 16)
FooterLabel.Position = UDim2.new(0, 0, 1, -18)
FooterLabel.BackgroundTransparency = 1
FooterLabel.Text = "Anti-AFK läuft ✓"
FooterLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
FooterLabel.TextSize = 10
FooterLabel.Font = Enum.Font.Gotham
FooterLabel.Parent = MainFrame

-- ═══════════════════════════════════════════
--              DRAGGING LOGIK
-- ═══════════════════════════════════════════

local dragging = false
local dragInput, dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
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
    if input.UserInputType == Enum.UserInputType.MouseMovement or
       input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- ═══════════════════════════════════════════
--              CLOSE BUTTON
-- ═══════════════════════════════════════════

CloseButton.MouseButton1Click:Connect(function()
    -- Script sauber beenden
    ScreenGui:Destroy()
    -- Verbindungen werden automatisch getrennt wenn GUI zerstört wird
end)

-- ═══════════════════════════════════════════
--              ANTI-AFK LOGIK
-- ═══════════════════════════════════════════

-- Verhindert AFK-Kick durch simulierte Eingabe
player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- Zusätzliche Methode: Kamera leicht bewegen alle 2 Minuten
local antiAfkConnection
antiAfkConnection = RunService.Heartbeat:Connect(function()
    local elapsed = tick() - startTime
    -- Alle 110 Sekunden kurze Bewegung simulieren
    if elapsed % 110 < 0.1 then
        VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(0.1)
        VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end
end)

-- ═══════════════════════════════════════════
--              STATS UPDATE LOOP
-- ═══════════════════════════════════════════

RunService.RenderStepped:Connect(function()
    if not ScreenGui.Parent then
        antiAfkConnection:Disconnect()
        return
    end

    -- FPS
    local fps = math.floor(1 / RunService.RenderStepped:Wait())
    -- Sicherheitscheck
    fps = math.clamp(fps, 0, 999)
    valueLabels["fps"].Text = tostring(fps)

    -- PING
    local ping = player:GetNetworkPing and math.floor(player:GetNetworkPing() * 1000) or 0
    valueLabels["ping"].Text = tostring(ping)

    -- Zeit formatieren
    local elapsed = math.floor(tick() - startTime)
    local h = math.floor(elapsed / 3600)
    local m = math.floor((elapsed % 3600) / 60)
    local s = elapsed % 60
    valueLabels["time"].Text = string.format("%d:%02d:%02d", h, m, s)
end)

print("[Anti-AFK] Script geladen! GUI ist verschiebbar.")
