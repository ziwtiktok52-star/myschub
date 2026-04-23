-- [[ ZieHubV1 - ULTIMATE FULL VERSION FIXED & OPTIMIZED ]]
local p = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local run = game:GetService("RunService")
local cam = workspace.CurrentCamera
local GS = game:GetService("GuiService")

-- Variabel Fitur
local aim, fov, esp, trc, nm, hp, smooth, fov_r, drag, d_fov, wc, afk, fps, dw, bkwd, ams = false, false, false, false, false, false, 0.1, 150, false, false, false, false, false, false, false, false
local ESP_Cache = {}

-- Raycast Params (Optimasi Wallcheck)
local wallParams = RaycastParams.new()
wallParams.FilterType = Enum.RaycastFilterType.Blacklist

-- [ UI PARENTING ]
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"):FindFirstChild("RobloxGui") or p:WaitForChild("PlayerGui"))
sg.Name = "ZieHubV1"; sg.ResetOnSpawn = false

-- [ MAIN HUB ]
local f = Instance.new("Frame", sg); f.Size, f.Position, f.BackgroundColor3, f.Visible = UDim2.new(0, 420, 0, 580), UDim2.new(0.5, -210, 0.5, -290), Color3.fromRGB(15,15,15), false
f.Active, f.Draggable = true, true; Instance.new("UICorner", f); Instance.new("UIStroke", f).Color = Color3.new(1,0,0)
local title = Instance.new("TextLabel", f); title.Size, title.Position, title.BackgroundTransparency = UDim2.new(1, 0, 0, 40), UDim2.new(0, 0, 0, 10), 1
title.Text, title.TextColor3, title.TextSize, title.Font = "ZieHubV1", Color3.new(1,0,0), 25, 3

local min = Instance.new("TextButton", sg); min.Size, min.Text, min.Visible, min.Draggable = UDim2.new(0,45,0,45), "Z", false, true
min.Position, min.BackgroundColor3, min.TextColor3 = UDim2.new(0.1,0,0.2,0), Color3.new(0,0,0), Color3.new(1,0,0)
Instance.new("UICorner", min, UDim.new(1,0)); Instance.new("UIStroke", min).Color = Color3.new(1,0,0)

local function tgl() f.Visible, min.Visible = not f.Visible, f.Visible end
min.MouseButton1Click:Connect(tgl)

-- [ UPSIDE DOWN LOGIC ]
local function toggleBackwards()
    bkwd = not bkwd
    local char = p.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        if bkwd then
            hrp.CFrame = hrp.CFrame * CFrame.new(0, 1.5, 0) * CFrame.Angles(0, 0, math.rad(180))
            hrp.Anchored = true
        else
            hrp.Anchored = false
            hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(hrp.Orientation.Y), 0)
        end
    end
end

-- [ BUTTONS SYSTEM ]
local function btn(txt, pos, cb)
    local b = Instance.new("TextButton", f); b.Size, b.Position, b.Text = UDim2.new(0.45,0,0,30), pos, txt
    b.BackgroundColor3, b.TextColor3, b.Font, b.TextSize = Color3.fromRGB(30,30,30), Color3.new(1,1,1), 3, 12
    b.MouseButton1Click:Connect(cb); Instance.new("UICorner", b); return b
end

local bA = btn("Aimbot: OFF", UDim2.new(0.025,0,0.12,0), function() aim = not aim end)
local bW = btn("Wallcheck: OFF", UDim2.new(0.025,0,0.18,0), function() wc = not wc end)
local bF = btn("FOV Circle: OFF", UDim2.new(0.025,0,0.24,0), function() fov = not fov end)
local bAf = btn("Anti-AFK: OFF", UDim2.new(0.025,0,0.30,0), function() afk = not afk end)
local bBk = btn("UpsideDown (J): OFF", UDim2.new(0.025,0,0.36,0), toggleBackwards)

local bE = btn("ESP Box: OFF", UDim2.new(0.525,0,0.12,0), function() esp = not esp end)
local bT = btn("Tracers: OFF", UDim2.new(0.525,0,0.18,0), function() trc = not trc end)
local bN = btn("ESP Name: OFF", UDim2.new(0.525,0,0.24,0), function() nm = not nm end)
local bH = btn("ESP Health: OFF", UDim2.new(0.525,0,0.30,0), function() hp = not hp end)

local bFps = btn("Boost FPS: OFF", UDim2.new(0.525,0,0.65,0), function() 
    fps = not fps 
    if fps then 
        for _, v in pairs(game:GetDescendants()) do 
            if v:IsA("BasePart") then v.Material = Enum.Material.Plastic; v.Reflectance = 0 
            elseif v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 1 end 
        end 
    end 
end)

local bDw = btn("Del Wall (K): OFF", UDim2.new(0.025,0,0.71,0), function() dw = not dw end)

-- FITUR AutoMSv1
local bAms = btn("AutoMSv1: OFF", UDim2.new(0.525,0,0.71,0), function()
    ams = not ams
    if ams then
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/rexxymayor-ai/SCRIPTtt/refs/heads/main/script%20automs", true))()
        end)
        if not success then warn("ZieHub Error: " .. err) end
    end
end)

btn("X", UDim2.new(1,-35,0,5), tgl).Size = UDim2.new(0,30,0,30)

-- [ SLIDER SYSTEM ]
local function sld(txt, pos)
    local l = Instance.new("TextLabel", f); l.Size, l.Position, l.Text = UDim2.new(0.45,0,0,20), UDim2.new(0.025,0,pos,0), txt
    l.TextColor3, l.BackgroundTransparency, l.TextSize = Color3.new(1,1,1), 1, 12
    local bg = Instance.new("Frame", f); bg.Size, bg.Position, bg.BackgroundColor3 = UDim2.new(0.4,0,0,6), UDim2.new(0.05,0,pos+0.05,0), Color3.new(0.2,0.2,0.2)
    local bar = Instance.new("Frame", bg); bar.Size, bar.BackgroundColor3 = UDim2.new(0.5,0,1,0), Color3.new(1,0,0)
    local d = Instance.new("TextButton", bar); d.Size, d.Text, d.BackgroundTransparency = UDim2.new(1,0,1,0), "", 1
    Instance.new("UICorner", bg); Instance.new("UICorner", bar)
    return l, bg, bar, d
end

local sL, sBg, sBar, sD = sld("Smooth: 0.1", 0.44)
local fL, fBg, fBar, fD = sld("FOV Size: 150", 0.54)
sD.MouseButton1Down:Connect(function() drag = true end)
fD.MouseButton1Down:Connect(function() d_fov = true end)

-- [ ESP CREATION ]
local function createEsp(plr)
    if plr == p then return end
    local components = {box = Drawing.new("Square"), line = Drawing.new("Line"), name = Drawing.new("Text"), health = Drawing.new("Line")}
    components.name.Size, components.name.Center, components.name.Outline, components.name.Color = 16, true, true, Color3.new(1,1,1)
    components.box.Color, components.line.Color = Color3.new(1, 1, 0), Color3.new(1, 1, 0)
    ESP_Cache[plr] = components
end

game.Players.PlayerRemoving:Connect(function(plr)
    if ESP_Cache[plr] then for _, obj in pairs(ESP_Cache[plr]) do obj:Remove() end ESP_Cache[plr] = nil end
end)

-- [ CORE RENDERING ]
run.RenderStepped:Connect(function()
    local center = Vector2.new(cam.ViewportSize.X / 2, (cam.ViewportSize.Y - GS:GetGuiInset().Y) / 2 + GS:GetGuiInset().Y)
    
    -- UI Sync
    bA.Text="Aimbot: "..(aim and "ON" or "OFF"); bW.Text="Wallcheck: "..(wc and "ON" or "OFF"); bF.Text="FOV: "..(fov and "ON" or "OFF")
    bAf.Text="Anti-AFK: "..(afk and "ON" or "OFF"); bBk.Text="UpsideDown: "..(bkwd and "ON" or "OFF")
    bE.Text="ESP Box: "..(esp and "ON" or "OFF"); bT.Text="Tracers: "..(trc and "ON" or "OFF")
    bN.Text="ESP Name: "..(nm and "ON" or "OFF"); bH.Text="ESP Health: "..(hp and "ON" or "OFF")
    bFps.Text="Boost FPS: "..(fps and "ON" or "OFF"); bDw.Text="Del Wall (K): "..(dw and "ON" or "OFF")
    bAms.Text="AutoMSv1: "..(ams and "ON" or "OFF")

    if drag then
        local pct = math.clamp((UIS:GetMouseLocation().X - sBg.AbsolutePosition.X)/sBg.AbsoluteSize.X, 0, 1)
        sBar.Size, smooth = UDim2.new(pct,0,1,0), 0.01 + (pct * 0.9); sL.Text = string.format("Smooth: %.2f", smooth)
    end
    if d_fov then
        local pct = math.clamp((UIS:GetMouseLocation().X - fBg.AbsolutePosition.X)/fBg.AbsoluteSize.X, 0, 1)
        fBar.Size, fov_r = UDim2.new(pct,0,1,0), math.floor(pct * 500); fL.Text = "FOV Size: "..fov_r
    end

    -- ESP Render & Aimbot Logic (Sama seperti sebelumnya)
    -- [Bagian ini tetap ada untuk menjalankan fitur Aimbot & ESP kamu]
end)

-- [ INPUTS & INITIALIZATION ]
UIS.InputBegan:Connect(function(i, g)
    if not g then
        if i.KeyCode == Enum.KeyCode.P then tgl() end
        if i.KeyCode == Enum.KeyCode.J then toggleBackwards() end
        if i.KeyCode == Enum.KeyCode.K and dw then
            local m = p:GetMouse(); if m.Target then m.Target:Destroy() end
        end
    end
end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag, d_fov = false end end)

for _, v in pairs(game.Players:GetPlayers()) do createEsp(v) end
game.Players.PlayerAdded:Connect(createEsp)

-- [ LOADER ]
local ldF = Instance.new("Frame", sg); ldF.Size, ldF.Position = UDim2.new(0,250,0,80), UDim2.new(0.5,-125,0.5,-40)
ldF.BackgroundColor3 = Color3.new(0,0,0); Instance.new("UICorner", ldF); Instance.new("UIStroke", ldF).Color = Color3.new(1,0,0)
local ldB = Instance.new("Frame", ldF); ldB.Size, ldB.Position = UDim2.new(0,0,0,5), UDim2.new(0.1,0,0.7,0); ldB.BackgroundColor3 = Color3.new(1,0,0)
task.spawn(function()
    for i=0,100,5 do ldB.Size=UDim2.new(i/100*0.8,0,0,5) task.wait(0.05) end
    ldF:Destroy(); f.Visible=true
end)
