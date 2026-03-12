local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "야기분조타",
    Icon = 0,
    LoadingTitle = "6️⃣7️⃣",
    LoadingSubtitle = "내가안만들었어니가만들었겠지뭐하냐제발",
    ConfigurationSaving = {Enabled = true, Folder = "HeadsUp_Config"},
    KeySystem = false,
    Theme = {
        TextColor = Color3.fromRGB(255, 255, 255),
        Background = Color3.fromRGB(15, 15, 15),
        Topbar = Color3.fromRGB(20, 20, 20),
        Shadow = Color3.fromRGB(0, 0, 0),
        Accent = Color3.fromRGB(0, 255, 170),
        ElementBackground = Color3.fromRGB(25, 25, 25),
        ElementBorder = Color3.fromRGB(35, 35, 35),
        ElementTextColor = Color3.fromRGB(220, 220, 220),
        SelectedElementBackground = Color3.fromRGB(0, 255, 170),
        SelectedElementTextColor = Color3.fromRGB(0, 0, 0)
    }
})

local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Settings = {
    AimEnabled = false, HumanMethod = "Normal", HumanSpeed = 16, HumanRange = 18,
    ShowRange = false, ADSRange = false, Range = 100, Speed = 5,
    SilentEnabled = false, VisRotation = false, Invert = false, SilentShowRange = false, SilentADSRange = false,
    HitChance = 100, VerticalOffset = 0.3, SilentRange = 100, OriginScan = false,
    TargetOffsetY = 0, OriginOffsetY = 0, OriginOffsetZ = 0, OriginScanRange = 5,
    TriggerEnabled = false, TriggerDelay = 50, TriggerRange = 5,
    VisibleCheck = false, Prediction = false, Multiplier = 2, Hitpart = "Head", TargetTracer = false,
    BoxESP = false, NameESP = false, DistanceESP = false, HealthESP = false, Chams = false, ESPVisCheck = false,
    ArmChams = false, WeaponChams = false, NoSleeves = false,
    ArmMat = "ForceField", WeaponMat = "ForceField", ViewmodelType = "Default",
    PosChanger = false, PosX = 2, PosY = 2, PosZ = 2,
    ForceFOV = false, FOVValue = 10, BulletTracers = false, EnemyTracers = false, TracerLife = 2,
    Hitmarkers = false, HitmarkerLife = 2, ColorCorr = false, Saturation = 2, Contrast = 2,
    AmbientMod = false, ClockMod = false, ClockTime = 2,
    Crosshair = false, Outline = false, OnEnemy = false, Spin = false, SpinSpeed = 5, CrossSize = 8, CrossGap = 8,
    Hitsounds = false, HitNotif = false, HitsoundType = "Osu", Volume = 1,
    BunnyHop = false, WalkSpeedEnabled = false, SpeedValue = 50
}

task.spawn(function()
    while task.wait(0.45) do
        local ParticlePart = Instance.new("Part")
        ParticlePart.Name = "UI_Particle"
        ParticlePart.Parent = workspace.CurrentCamera
        ParticlePart.Transparency = 1
        ParticlePart.CanCollide = false
        ParticlePart.Anchored = true
        local CameraCFrame = workspace.CurrentCamera.CFrame
        local RandomPos = CameraCFrame * CFrame.new(math.random(-20, 20), 15, -math.random(10, 30))
        ParticlePart.CFrame = RandomPos
        local Attachment = Instance.new("Attachment", ParticlePart)
        local Particle = Instance.new("ParticleEmitter", Attachment)
        Particle.Texture = "rbxassetid://242138210"
        Particle.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
        Particle.Size = NumberSequence.new(0.1, 0.3)
        Particle.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.2, 0), NumberSequenceKeypoint.new(0.8, 0), NumberSequenceKeypoint.new(1, 1)})
        Particle.Lifetime = NumberRange.new(2, 4)
        Particle.Speed = NumberRange.new(5, 10)
        Particle.EmissionDirection = Enum.NormalId.Bottom
        task.delay(5, function() ParticlePart:Destroy() end)
    end
end)

local CombatTab = Window:CreateTab("컴뱃", nil)
CombatTab:CreateSection("Aim Assist")
CombatTab:CreateToggle({Name = "활성화", CurrentValue = false, Callback = function(v) Settings.AimEnabled = v end})
CombatTab:CreateDropdown({Name = "인간화 방법", Options = {"Normal", "Smooth", "Legit"}, CurrentOption = "Normal", Callback = function(v) Settings.HumanMethod = v end})
CombatTab:CreateSlider({Name = "인간화 속도", Range = {1, 30}, Increment = 1, CurrentValue = 16, Callback = function(v) Settings.HumanSpeed = v end})
CombatTab:CreateSlider({Name = "인간화 범위", Range = {1, 30}, Increment = 1, CurrentValue = 18, Callback = function(v) Settings.HumanRange = v end})
CombatTab:CreateToggle({Name = "범위 표시", CurrentValue = false, Callback = function(v) Settings.ShowRange = v end})
CombatTab:CreateToggle({Name = "ADS 범위", CurrentValue = false, Callback = function(v) Settings.ADSRange = v end})
CombatTab:CreateSlider({Name = "범위", Range = {1, 1000}, Increment = 10, CurrentValue = 100, Callback = function(v) Settings.Range = v end})
CombatTab:CreateSlider({Name = "속도", Range = {1, 50}, Increment = 1, CurrentValue = 5, Callback = function(v) Settings.Speed = v end})
CombatTab:CreateSection("Silent Aim")
CombatTab:CreateToggle({Name = "활성화", CurrentValue = false, Callback = function(v) Settings.SilentEnabled = v end})
CombatTab:CreateToggle({Name = "회전 시각화", CurrentValue = false, Callback = function(v) Settings.VisRotation = v end})
CombatTab:CreateToggle({Name = "반전", CurrentValue = false, Callback = function(v) Settings.Invert = v end})
CombatTab:CreateToggle({Name = "범위 표시", CurrentValue = false, Callback = function(v) Settings.SilentShowRange = v end})
CombatTab:CreateSlider({Name = "명중률", Range = {0, 100}, Increment = 1, CurrentValue = 100, Callback = function(v) Settings.HitChance = v end})
CombatTab:CreateSlider({Name = "수직 오프셋", Range = {0, 10}, Increment = 0.1, CurrentValue = 0.3, Callback = function(v) Settings.VerticalOffset = v end})
CombatTab:CreateSlider({Name = "범위", Range = {1, 1000}, Increment = 10, CurrentValue = 100, Callback = function(v) Settings.SilentRange = v end})
CombatTab:CreateToggle({Name = "오리진 스캔", CurrentValue = false, Callback = function(v) Settings.OriginScan = v end})
CombatTab:CreateSlider({Name = "타겟 오프셋 Y", Range = {0, 10}, Increment = 1, CurrentValue = 0, Callback = function(v) Settings.TargetOffsetY = v end})
CombatTab:CreateSlider({Name = "오리진 오프셋 Y", Range = {0, 10}, Increment = 1, CurrentValue = 0, Callback = function(v) Settings.OriginOffsetY = v end})
CombatTab:CreateSlider({Name = "오리진 오프셋 Z", Range = {0, 10}, Increment = 1, CurrentValue = 0, Callback = function(v) Settings.OriginOffsetZ = v end})
CombatTab:CreateSlider({Name = "오리진 스캔 범위", Range = {1, 10}, Increment = 1, CurrentValue = 5, Callback = function(v) Settings.OriginScanRange = v end})
CombatTab:CreateSection("Other")
CombatTab:CreateToggle({Name = "가시성 체크", CurrentValue = false, Callback = function(v) Settings.VisibleCheck = v end})
CombatTab:CreateToggle({Name = "예측 (Prediction)", CurrentValue = false, Callback = function(v) Settings.Prediction = v end})
CombatTab:CreateSlider({Name = "배율 (Multiplier)", Range = {1, 10}, Increment = 1, CurrentValue = 2, Callback = function(v) Settings.Multiplier = v end})
CombatTab:CreateDropdown({Name = "타겟 부위", Options = {"Head", "Torso", "Random"}, CurrentOption = "Head", Callback = function(v) Settings.Hitpart = v end})
CombatTab:CreateToggle({Name = "타겟 트레이서", CurrentValue = false, Callback = function(v) Settings.TargetTracer = v end})
CombatTab:CreateSection("Triggerbot")
CombatTab:CreateToggle({Name = "활성화", CurrentValue = false, Callback = function(v) Settings.TriggerEnabled = v end})
CombatTab:CreateSlider({Name = "지연 시간", Range = {0, 200}, Increment = 1, CurrentValue = 50, Callback = function(v) Settings.TriggerDelay = v end})
CombatTab:CreateSlider({Name = "범위", Range = {1, 30}, Increment = 1, CurrentValue = 5, Callback = function(v) Settings.TriggerRange = v end})

local VisualsTab = Window:CreateTab("비주얼", nil)
VisualsTab:CreateSection("Players")
VisualsTab:CreateToggle({Name = "박스 ESP", CurrentValue = false, Callback = function(v) Settings.BoxESP = v end})
VisualsTab:CreateToggle({Name = "이름 ESP", CurrentValue = false, Callback = function(v) Settings.NameESP = v end})
VisualsTab:CreateToggle({Name = "거리 ESP", CurrentValue = false, Callback = function(v) Settings.DistanceESP = v end})
VisualsTab:CreateToggle({Name = "체력 ESP", CurrentValue = false, Callback = function(v) Settings.HealthESP = v end})
VisualsTab:CreateToggle({Name = "챔스 (Chams)", CurrentValue = false, Callback = function(v) Settings.Chams = v end})
VisualsTab:CreateToggle({Name = "가시성 체크", CurrentValue = false, Callback = function(v) Settings.ESPVisCheck = v end})
VisualsTab:CreateSection("Viewmodel")
VisualsTab:CreateToggle({Name = "팔 챔스", CurrentValue = false, Callback = function(v) Settings.ArmChams = v end})
VisualsTab:CreateToggle({Name = "무기 챔스", CurrentValue = false, Callback = function(v) Settings.WeaponChams = v end})
VisualsTab:CreateToggle({Name = "소매 제거", CurrentValue = false, Callback = function(v) Settings.NoSleeves = v end})
VisualsTab:CreateDropdown({Name = "팔 재질", Options = {"ForceField", "Neon", "Plastic", "Glass"}, CurrentOption = "ForceField", Callback = function(v) Settings.ArmMat = v end})
VisualsTab:CreateDropdown({Name = "무기 재질", Options = {"ForceField", "Neon", "Plastic", "Glass"}, CurrentOption = "ForceField", Callback = function(v) Settings.WeaponMat = v end})
VisualsTab:CreateToggle({Name = "위치 변경기", CurrentValue = false, Callback = function(v) Settings.PosChanger = v end})
VisualsTab:CreateSlider({Name = "X", Range = {0, 10}, Increment = 1, CurrentValue = 2, Callback = function(v) Settings.PosX = v end})
VisualsTab:CreateSlider({Name = "Y", Range = {0, 10}, Increment = 1, CurrentValue = 2, Callback = function(v) Settings.PosY = v end})
VisualsTab:CreateSlider({Name = "Z", Range = {0, 10}, Increment = 1, CurrentValue = 2, Callback = function(v) Settings.PosZ = v end})
VisualsTab:CreateSection("World")
VisualsTab:CreateToggle({Name = "FOV 강제 고정", CurrentValue = false, Callback = function(v) Settings.ForceFOV = v end})
VisualsTab:CreateSlider({Name = "FOV 값", Range = {1, 120}, Increment = 1, CurrentValue = 10, Callback = function(v) Settings.FOVValue = v end})
VisualsTab:CreateToggle({Name = "탄궤적 표시", CurrentValue = false, Callback = function(v) Settings.BulletTracers = v end})
VisualsTab:CreateSlider({Name = "지속 시간", Range = {1, 10}, Increment = 1, CurrentValue = 2, Callback = function(v) Settings.TracerLife = v end})
VisualsTab:CreateToggle({Name = "히트마커", CurrentValue = false, Callback = function(v) Settings.Hitmarkers = v end})
VisualsTab:CreateToggle({Name = "색상 보정", CurrentValue = false, Callback = function(v) Settings.ColorCorr = v end})
VisualsTab:CreateSlider({Name = "채도", Range = {0, 10}, Increment = 1, CurrentValue = 2, Callback = function(v) Settings.Saturation = v end})
VisualsTab:CreateSlider({Name = "대비", Range = {0, 14}, Increment = 1, CurrentValue = 2, Callback = function(v) Settings.Contrast = v end})
VisualsTab:CreateToggle({Name = "시간 변조", CurrentValue = false, Callback = function(v) Settings.ClockMod = v end})
VisualsTab:CreateSlider({Name = "시간", Range = {0, 14}, Increment = 1, CurrentValue = 2, Callback = function(v) Settings.ClockTime = v end})
VisualsTab:CreateSection("Crosshair")
VisualsTab:CreateToggle({Name = "조준점 표시", CurrentValue = false, Callback = function(v) Settings.Crosshair = v end})
VisualsTab:CreateToggle({Name = "외곽선", CurrentValue = false, Callback = function(v) Settings.Outline = v end})
VisualsTab:CreateToggle({Name = "회전 조준점", CurrentValue = false, Callback = function(v) Settings.Spin = v end})
VisualsTab:CreateSlider({Name = "크기", Range = {1, 20}, Increment = 1, CurrentValue = 8, Callback = function(v) Settings.CrossSize = v end})
VisualsTab:CreateSlider({Name = "간격", Range = {1, 30}, Increment = 1, CurrentValue = 8, Callback = function(v) Settings.CrossGap = v end})
VisualsTab:CreateSection("Hitsounds")
VisualsTab:CreateToggle({Name = "히트사운드", CurrentValue = false, Callback = function(v) Settings.Hitsounds = v end})
VisualsTab:CreateDropdown({Name = "사운드 선택", Options = {"Osu", "Rust", "Call of Duty"}, CurrentOption = "Osu", Callback = function(v) Settings.HitsoundType = v end})
VisualsTab:CreateSlider({Name = "음량", Range = {0, 10}, Increment = 1, CurrentValue = 1, Callback = function(v) Settings.Volume = v end})

local PlayerTab = Window:CreateTab("플레이어", nil)
PlayerTab:CreateSection("Character")
PlayerTab:CreateToggle({Name = "버니합", CurrentValue = false, Callback = function(v) Settings.BunnyHop = v end})
PlayerTab:CreateToggle({Name = "이동속도 활성화", CurrentValue = false, Callback = function(v) Settings.WalkSpeedEnabled = v end})
PlayerTab:CreateSlider({Name = "속도", Range = {1, 50}, Increment = 1, CurrentValue = 50, Callback = function(v) Settings.SpeedValue = v end})

local ConfigTab = Window:CreateTab("설정", nil)
ConfigTab:CreateSection("Menu")
ConfigTab:CreateToggle({Name = "워터마크 표시", CurrentValue = false, Callback = function(v) end})
ConfigTab:CreateToggle({Name = "키바인드 표시", CurrentValue = true, Callback = function(v) end})
ConfigTab:CreateKeybind({Name = "메뉴 단축키", CurrentKeybind = "End", HoldToInteract = false, Callback = function() Rayfield:Toggle() end})
ConfigTab:CreateButton({Name = "언로드 (Unload)", Callback = function() Rayfield:Destroy() end})
ConfigTab:CreateSection("Configuration")
ConfigTab:CreateInput({Name = "설정 이름", PlaceholderText = "이름 입력", Callback = function(t) end})
ConfigTab:CreateButton({Name = "설정 생성", Callback = function() Rayfield:SaveConfiguration() end})

RunService.RenderStepped:Connect(function()
    if Settings.ForceFOV then Camera.FieldOfView = Settings.FOVValue end
    if Settings.WalkSpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Settings.SpeedValue
    end
    if Settings.BunnyHop and UIS:IsKeyDown(Enum.KeyCode.Space) and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.Jump = true
    end
end)

Rayfield:LoadConfiguration()
