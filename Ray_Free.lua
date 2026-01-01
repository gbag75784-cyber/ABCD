local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "커짐머리",
    Icon = 0, 
    LoadingTitle = "로딩 중...",
    LoadingSubtitle = "by 나",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false
})

local MainTab = Window:CreateTab("🌎메인 탭🌏", nil)
local CombatTab = Window:CreateTab("✨컴뱃 설정✨", nil)
local VisualsTab = Window:CreateTab("🌊visuals", nil)
local PlayerTab = Window:CreateTab("👨‍🦲플레이어", nil)

local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Mouse = LocalPlayer:GetMouse()

local Settings = {
    ClickExplosion = false,
    ExplosionRadius = 15,
    ExplosionDamage = 100,
    Aimbot = false,
    TeamCheck = false,
    ShowFOV = false,
    FOVSize = 500,
    Smoothness = 1,
    FOVColor = Color3.fromRGB(255, 0, 0),
    BoxESP = false,
    NameESP = false,
    DistanceESP = false,
    HealthESP = false,
    ESPTextSize = 16,
    ESPColor = Color3.fromRGB(255, 0, 0),
    WalkSpeedEnabled = false,
    WalkSpeedValue = 16,
    FlyEnabled = false,
    FlySpeedValue = 50,
    InfJump = false,
    HoldJump = false,
    Noclip = false
}

-- [ ESP 기능 구현 ]
local ESP_Objects = {}
local function CreateESP(Player)
    if Player == LocalPlayer then return end
    local Box = Drawing.new("Square")
    Box.Thickness = 1
    Box.Visible = false
    local Text = Drawing.new("Text")
    Text.Center = true
    Text.Outline = true
    Text.Visible = false
    ESP_Objects[Player] = {Box = Box, Text = Text}
end

for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(CreateESP)
Players.PlayerRemoving:Connect(function(p)
    if ESP_Objects[p] then
        ESP_Objects[p].Box:Remove()
        ESP_Objects[p].Text:Remove()
        ESP_Objects[p] = nil
    end
end)

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.NumSides = 60
FOVCircle.Visible = false

local function GetClosestPlayer()
    local Target = nil
    local Dist = Settings.FOVSize
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
            if Settings.TeamCheck and v.Team == LocalPlayer.Team then continue end
            local Pos, OnScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if OnScreen then
                local MouseDist = (Vector2.new(UIS:GetMouseLocation().X, UIS:GetMouseLocation().Y) - Vector2.new(Pos.X, Pos.Y)).Magnitude
                if MouseDist < Dist then
                    Dist = MouseDist
                    Target = v
                end
            end
        end
    end
    return Target
end

RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = Settings.ShowFOV
    FOVCircle.Radius = Settings.FOVSize
    FOVCircle.Color = Settings.FOVColor
    FOVCircle.Position = UIS:GetMouseLocation()

    if Settings.Aimbot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local Target = GetClosestPlayer()
        if Target then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, Target.Character.Head.Position), 1/Settings.Smoothness)
        end
    end

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local Hum = LocalPlayer.Character.Humanoid
        local Root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        Hum.WalkSpeed = Settings.WalkSpeedEnabled and Settings.WalkSpeedValue or 16
        if Settings.HoldJump and UIS:IsKeyDown(Enum.KeyCode.Space) then Hum.Jump = true end
        if Settings.Noclip then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
        if Settings.FlyEnabled and Root then
            local Velocity = Vector3.new(0, 0.1, 0)
            if UIS:IsKeyDown(Enum.KeyCode.W) then Velocity = Velocity + (Camera.CFrame.LookVector * Settings.FlySpeedValue) end
            if UIS:IsKeyDown(Enum.KeyCode.S) then Velocity = Velocity - (Camera.CFrame.LookVector * Settings.FlySpeedValue) end
            if UIS:IsKeyDown(Enum.KeyCode.A) then Velocity = Velocity - (Camera.CFrame.RightVector * Settings.FlySpeedValue) end
            if UIS:IsKeyDown(Enum.KeyCode.D) then Velocity = Velocity + (Camera.CFrame.RightVector * Settings.FlySpeedValue) end
            Root.Velocity = Velocity
        end
    end

    for player, obj in pairs(ESP_Objects) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.Humanoid.Health > 0 then
            local HRP = player.Character.HumanoidRootPart
            local Pos, OnScreen = Camera:WorldToViewportPoint(HRP.Position)
            if OnScreen then
                if Settings.BoxESP then
                    obj.Box.Size = Vector2.new(1500/Pos.Z, 2000/Pos.Z)
                    obj.Box.Position = Vector2.new(Pos.X - obj.Box.Size.X/2, Pos.Y - obj.Box.Size.Y/2)
                    obj.Box.Color = Settings.ESPColor
                    obj.Box.Visible = true
                else obj.Box.Visible = false end

                local Info = ""
                if Settings.NameESP then Info = Info .. player.Name .. "\n" end
                if Settings.DistanceESP then Info = Info .. math.floor((HRP.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude) .. "m\n" end
                if Settings.HealthESP then Info = Info .. "HP: " .. math.floor(player.Character.Humanoid.Health) end
                
                if Info ~= "" then
                    obj.Text.Text = Info
                    obj.Text.Position = Vector2.new(Pos.X, Pos.Y + (obj.Box.Size.Y/2))
                    obj.Text.Color = Settings.ESPColor
                    obj.Text.Size = Settings.ESPTextSize
                    obj.Text.Visible = true
                else obj.Text.Visible = false end
            else obj.Box.Visible = false obj.Text.Visible = false end
        else obj.Box.Visible = false obj.Text.Visible = false end
    end
end)

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Space and Settings.InfJump then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
    if input.UserInputType == Enum.UserInputType.MouseButton1 and Settings.ClickExplosion then
        local pos = Mouse.Hit.p
        local ex = Instance.new("Explosion")
        ex.Position = pos
        ex.BlastRadius = Settings.ExplosionRadius
        ex.BlastPressure = 1000000 
        ex.Parent = workspace
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") then
                local d = (v.Character.HumanoidRootPart.Position - pos).Magnitude
                if d <= Settings.ExplosionRadius then
                    v.Character.Humanoid.Health -= Settings.ExplosionDamage
                end
            end
        end
    end
end)

MainTab:CreateButton({Name = "어드민 스크립트⚒", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end})
MainTab:CreateButton({Name = "Argon Hub x🎃", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/AgentX771/ArgonHubX/main/Loader.lua"))() end})
MainTab:CreateButton({Name = "99 나이트 인 더 포레스트🎄", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/H4xScripts/Loader/refs/heads/main/loader.lua", true))() end})
MainTab:CreateButton({Name = "브레인롯 훔치기🎁", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Ninja10908/S4/refs/heads/main/Kurdhub"))() end})
MainTab:CreateButton({Name = "아스널 스크립트✨", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/andrewdarkyyofficial/thunderclient/main/main.lua'))() end})
MainTab:CreateButton({Name = "라이벌 스크립트🧨", Callback = function() loadstring(game:HttpGet('https://exploit.plus/Loader'))() end})
MainTab:CreateButton({Name = "부대게임 테러 스크립트🎇", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/pudong8452/test_case_h/main/Ray_Free'))() 

CombatTab:CreateToggle({Name = "에임봇 (우클릭 고정)", CurrentValue = false, Flag = "AB", Callback = function(v) Settings.Aimbot = v end})
CombatTab:CreateToggle({Name = "에임봇 팀 체크 (아군 제외)", CurrentValue = false, Flag = "TC", Callback = function(v) Settings.TeamCheck = v end})
CombatTab:CreateToggle({Name = "에임봇 FOV 표시", CurrentValue = false, Flag = "SF", Callback = function(v) Settings.ShowFOV = v end})
CombatTab:CreateSlider({Name = "FOV 크기", Range = {0, 1000}, Increment = 10, CurrentValue = 500, Flag = "FZ", Callback = function(v) Settings.FOVSize = v end})
CombatTab:CreateSlider({Name = "에임 부드러움", Range = {1, 20}, Increment = 1, CurrentValue = 1, Flag = "AS", Callback = function(v) Settings.Smoothness = v end})
CombatTab:CreateColorPicker({Name = "FOV 색상", Color = Color3.fromRGB(255, 0, 0), Flag = "FC", Callback = function(v) Settings.FOVColor = v end})
CombatTab:CreateToggle({Name = "클릭 시 폭발", CurrentValue = false, Flag = "CE", Callback = function(v) Settings.ClickExplosion = v end})
CombatTab:CreateSlider({Name = "폭발 범위", Range = {0, 100}, Increment = 1, CurrentValue = 15, Flag = "ER", Callback = function(v) Settings.ExplosionRadius = v end})
CombatTab:CreateSlider({Name = "폭발 데미지", Range = {0, 100}, Increment = 1, CurrentValue = 100, Flag = "ED", Callback = function(v) Settings.ExplosionDamage = v end})

VisualsTab:CreateToggle({Name = "박스 ESP", CurrentValue = false, Flag = "VB", Callback = function(v) Settings.BoxESP = v end})
VisualsTab:CreateToggle({Name = "이름 ESP", CurrentValue = false, Flag = "VN", Callback = function(v) Settings.NameESP = v end})
VisualsTab:CreateToggle({Name = "거리 ESP", CurrentValue = false, Flag = "VD", Callback = function(v) Settings.DistanceESP = v end})
VisualsTab:CreateToggle({Name = "체력 ESP", CurrentValue = false, Flag = "VH", Callback = function(v) Settings.HealthESP = v end})
VisualsTab:CreateSlider({Name = "텍스트 크기", Range = {10, 30}, Increment = 1, CurrentValue = 16, Flag = "VS", Callback = function(v) Settings.ESPTextSize = v end})
VisualsTab:CreateColorPicker({Name = "ESP 색상", Color = Color3.fromRGB(255, 0, 0), Flag = "VC", Callback = function(v) Settings.ESPColor = v end})

PlayerTab:CreateToggle({Name = "이동속도 활성화", CurrentValue = false, Flag = "WSE", Callback = function(v) Settings.WalkSpeedEnabled = v end})
PlayerTab:CreateSlider({Name = "속도 값", Range = {16, 500}, Increment = 1, CurrentValue = 50, Flag = "WSV", Callback = function(v) Settings.WalkSpeedValue = v end})
PlayerTab:CreateToggle({Name = "플라이 (Fly)", CurrentValue = false, Flag = "FE", Callback = function(v) Settings.FlyEnabled = v end})
PlayerTab:CreateSlider({Name = "비행 속도", Range = {0, 500}, Increment = 1, CurrentValue = 54, Flag = "FSV", Callback = function(v) Settings.FlySpeedValue = v end})
PlayerTab:CreateToggle({Name = "무한 점프", CurrentValue = false, Flag = "IJ", Callback = function(v) Settings.InfJump = v end})
PlayerTab:CreateToggle({Name = "점프 유지 (Hold Space)", CurrentValue = false, Flag = "HJ", Callback = function(v) Settings.HoldJump = v end})
PlayerTab:CreateToggle({Name = "벽 뚫기 (Noclip)", CurrentValue = false, Flag = "NC", Callback = function(v) Settings.Noclip = v end})

Rayfield:LoadConfiguration()
