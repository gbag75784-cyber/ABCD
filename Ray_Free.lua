local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "야기분조타",
    Icon = 0, 
    LoadingTitle = "로딩 중...",
    LoadingSubtitle = "by 6️⃣7️⃣",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false
})

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
    AutoFire = false, 
    TeamCheck = false,
    WallCheck = true, 
    TargetPart = "Head", 
    ShowFOV = false,
    FOVSize = 500,
    Smoothness = 1,
    FOVColor = Color3.fromRGB(255, 0, 0),
    CameraFOV = 70, 
    BoxESP = false,
    SkeletonESP = false, 
    NameESP = false,
    DistanceESP = false,
    HealthESP = false,
    RainbowESP = false, 
    ESPTextSize = 16,
    ESPColor = Color3.fromRGB(255, 0, 0),
    WalkSpeedEnabled = false,
    WalkSpeedValue = 16,
    FlyEnabled = false,
    FlySpeedValue = 50,
    InfJump = false,
    HoldJump = false,
    Noclip = false,
    SpinBot = false, 
    SpinSpeed = 50, 
    ThirdPerson = false, 
    TPDistance = 10 
}

local MainTab = Window:CreateTab("🌎메인 탭🌏", nil)
local CombatTab = Window:CreateTab("✨컴뱃 설정✨", nil)
local VisualsTab = Window:CreateTab("🌊visuals", nil)
local PlayerTab = Window:CreateTab("👨‍🦲플레이어", nil)

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
    local Skeleton = {
        H = Drawing.new("Line"), T = Drawing.new("Line"), 
        LA = Drawing.new("Line"), RA = Drawing.new("Line"), 
        LL = Drawing.new("Line"), RL = Drawing.new("Line")
    }
    for _, v in pairs(Skeleton) do v.Thickness = 1 v.Visible = false end
    ESP_Objects[Player] = {Box = Box, Text = Text, Skeleton = Skeleton}
end

for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(CreateESP)
Players.PlayerRemoving:Connect(function(p)
    if ESP_Objects[p] then
        ESP_Objects[p].Box:Remove()
        ESP_Objects[p].Text:Remove()
        for _, v in pairs(ESP_Objects[p].Skeleton) do v:Remove() end
        ESP_Objects[p] = nil
    end
end)

local function IsVisible(Part)
    if not Settings.WallCheck then return true end
    local Origin = Camera.CFrame.Position
    local RaycastP = RaycastParams.new()
    RaycastP.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    RaycastP.FilterType = Enum.RaycastFilterType.Blacklist
    local Result = workspace:Raycast(Origin, Part.Position - Origin, RaycastP)
    return Result == nil or Result.Instance:IsDescendantOf(Part.Parent)
end

local function GetTargetPart(Char)
    if Settings.TargetPart == "Random" then
        local p = {"Head", "UpperTorso", "LeftUpperLeg", "RightUpperLeg"}
        return Char:FindFirstChild(p[math.random(1, #p)])
    elseif Settings.TargetPart == "Torso" then
        return Char:FindFirstChild("UpperTorso") or Char:FindFirstChild("Torso")
    elseif Settings.TargetPart == "Legs" then
        return Char:FindFirstChild("LeftUpperLeg") or Char:FindFirstChild("LeftLeg")
    end
    return Char:FindFirstChild("Head")
end

local function GetClosestPlayer()
    local Target, Dist = nil, Settings.FOVSize
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            if Settings.TeamCheck and v.Team == LocalPlayer.Team then continue end
            local Part = GetTargetPart(v.Character)
            if Part then
                local Pos, OnScreen = Camera:WorldToViewportPoint(Part.Position)
                if OnScreen and IsVisible(Part) then
                    local MouseDist = (Vector2.new(UIS:GetMouseLocation().X, UIS:GetMouseLocation().Y) - Vector2.new(Pos.X, Pos.Y)).Magnitude
                    if MouseDist < Dist then Dist = MouseDist Target = v end
                end
            end
        end
    end
    return Target
end

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.NumSides = 60
FOVCircle.Visible = false

RunService.RenderStepped:Connect(function()
    local Rainbow = Color3.fromHSV(tick() % 5 / 5, 1, 1)
    local CurrentColor = Settings.RainbowESP and Rainbow or Settings.ESPColor

    Camera.FieldOfView = Settings.CameraFOV
    if Settings.ThirdPerson then
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
        LocalPlayer.CameraMaxZoomDistance = Settings.TPDistance
        LocalPlayer.CameraMinZoomDistance = Settings.TPDistance
    else
        LocalPlayer.CameraMaxZoomDistance = 128
        LocalPlayer.CameraMinZoomDistance = 0.5
    end

    if Settings.SpinBot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(Settings.SpinSpeed), 0)
    end

    FOVCircle.Visible = Settings.ShowFOV
    FOVCircle.Radius = Settings.FOVSize
    FOVCircle.Color = Settings.FOVColor
    FOVCircle.Position = UIS:GetMouseLocation()

    if Settings.Aimbot or Settings.AutoFire then
        local Target = GetClosestPlayer()
        if Target and Target.Character then
            local Part = GetTargetPart(Target.Character)
            if Settings.Aimbot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, Part.Position), 1/Settings.Smoothness)
            end
            if Settings.AutoFire then mouse1click() end
        end
    end

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local Hum = LocalPlayer.Character.Humanoid
        local Root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        Hum.WalkSpeed = Settings.WalkSpeedEnabled and Settings.WalkSpeedValue or 16
        if Settings.HoldJump and UIS:IsKeyDown(Enum.KeyCode.Space) then Hum.Jump = true end
        if Settings.Noclip then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
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
                    obj.Box.Color = CurrentColor
                    obj.Box.Visible = true
                else obj.Box.Visible = false end

                local Info = ""
                if Settings.NameESP then Info = Info .. player.Name .. "\n" end
                if Settings.DistanceESP then Info = Info .. math.floor((HRP.Position - Camera.CFrame.Position).Magnitude) .. "m\n" end
                if Settings.HealthESP then Info = Info .. "HP: " .. math.floor(player.Character.Humanoid.Health) end
                
                if Info ~= "" then
                    obj.Text.Text = Info
                    obj.Text.Position = Vector2.new(Pos.X, Pos.Y + (obj.Box.Size.Y/2))
                    obj.Text.Color = CurrentColor
                    obj.Text.Size = Settings.ESPTextSize
                    obj.Text.Visible = true
                else obj.Text.Visible = false end

                if Settings.SkeletonESP and player.Character:FindFirstChild("Head") then
                    obj.Skeleton.H.Visible = true -- 시각화 로직
                    for _, v in pairs(obj.Skeleton) do v.Color = CurrentColor end
                else for _, v in pairs(obj.Skeleton) do v.Visible = false end end
            else obj.Box.Visible = false obj.Text.Visible = false for _, v in pairs(obj.Skeleton) do v.Visible = false end end
        else obj.Box.Visible = false obj.Text.Visible = false for _, v in pairs(obj.Skeleton) do v.Visible = false end end
    end
end)

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Q then Settings.SpinBot = not Settings.SpinBot end
    if input.KeyCode == Enum.KeyCode.Space and Settings.InfJump then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
    if input.UserInputType == Enum.UserInputType.MouseButton1 and Settings.ClickExplosion then
        local pos = Mouse.Hit.p
        local ex = Instance.new("Explosion")
        ex.Position = pos
        ex.BlastRadius = Settings.ExplosionRadius
        ex.BlastPressure = 1000000 
        ex.Parent = workspace
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("HumanoidRootPart") then
                local d = (v.Character.HumanoidRootPart.Position - pos).Magnitude
                if d <= Settings.ExplosionRadius then v.Character.Humanoid.Health -= Settings.ExplosionDamage end
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
MainTab:CreateButton({Name = "부대게임 테러 스크립트🎇", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/pudong8452/test_case_h/main/Ray_Free'))() end})

CombatTab:CreateToggle({Name = "에임봇 (우클릭 고정)", CurrentValue = false, Flag = "AB", Callback = function(v) Settings.Aimbot = v end})
CombatTab:CreateToggle({Name = "자동 발사 (Auto Fire)", CurrentValue = false, Flag = "AF", Callback = function(v) Settings.AutoFire = v end})
CombatTab:CreateToggle({Name = "벽 체크 (Visible Only)", CurrentValue = true, Flag = "WC", Callback = function(v) Settings.WallCheck = v end})
CombatTab:CreateDropdown({Name = "타겟 부위", Options = {"Head", "Torso", "Legs", "Random"}, CurrentOption = "Head", Flag = "TP", Callback = function(v) Settings.TargetPart = v end})
CombatTab:CreateSlider({Name = "FOV 크기", Range = {0, 1000}, Increment = 10, CurrentValue = 500, Flag = "FZ", Callback = function(v) Settings.FOVSize = v end})
CombatTab:CreateSlider({Name = "줌 조절 (FOV)", Range = {1, 500}, Increment = 1, CurrentValue = 70, Flag = "CFOV", Callback = function(v) Settings.CameraFOV = v end})
CombatTab:CreateSlider({Name = "스핀 속도 (Q 토글)", Range = {0, 100}, Increment = 1, CurrentValue = 50, Flag = "SS", Callback = function(v) Settings.SpinSpeed = v end})

VisualsTab:CreateToggle({Name = "무지개 ESP", CurrentValue = false, Flag = "RB", Callback = function(v) Settings.RainbowESP = v end})
VisualsTab:CreateToggle({Name = "박스 ESP", CurrentValue = false, Flag = "VB", Callback = function(v) Settings.BoxESP = v end})
VisualsTab:CreateToggle({Name = "스켈레톤 ESP", CurrentValue = false, Flag = "VSE", Callback = function(v) Settings.SkeletonESP = v end})
VisualsTab:CreateToggle({Name = "이름 ESP", CurrentValue = false, Flag = "VN", Callback = function(v) Settings.NameESP = v end})
VisualsTab:CreateToggle({Name = "거리 ESP", CurrentValue = false, Flag = "VD", Callback = function(v) Settings.DistanceESP = v end})
VisualsTab:CreateToggle({Name = "체력 ESP", CurrentValue = false, Flag = "VH", Callback = function(v) Settings.HealthESP = v end})
VisualsTab:CreateColorPicker({Name = "ESP 색상", Color = Color3.fromRGB(255, 0, 0), Flag = "VC", Callback = function(v) Settings.ESPColor = v end})

PlayerTab:CreateToggle({Name = "3인칭 모드", CurrentValue = false, Flag = "TPM", Callback = function(v) Settings.ThirdPerson = v end})
PlayerTab:CreateSlider({Name = "3인칭 거리", Range = {0, 100}, Increment = 1, CurrentValue = 10, Flag = "TPD", Callback = function(v) Settings.TPDistance = v end})
PlayerTab:CreateSlider({Name = "이동 속도", Range = {16, 500}, Increment = 1, CurrentValue = 50, Flag = "WSV", Callback = function(v) Settings.WalkSpeedValue = v end})
PlayerTab:CreateToggle({Name = "무한 점프", CurrentValue = false, Flag = "IJ", Callback = function(v) Settings.InfJump = v end})
PlayerTab:CreateToggle({Name = "벽 뚫기 (Noclip)", CurrentValue = false, Flag = "NC", Callback = function(v) Settings.Noclip = v end})

Rayfield:LoadConfiguration()
