-- [[ ZieHubV1 - CLEAN VERSION (NO AUTO MASAK) ]]
local p = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local run = game:GetService("RunService")
local cam = workspace.CurrentCamera
local GS = game:GetService("GuiService")

-- Bersihkan GUI lama agar tidak tumpang tindih
local oldGui = game:GetService("CoreGui"):FindFirstChild("ZieHubV1")
if oldGui then oldGui:Destroy() end

-- [[ DAFTAR PASSWORD PREMIUM (WHITELIST) ]]
local premiumKeys = {
    ["ziwaganteng"] = true,
    ["pembeli01"] = true,
    ["premium123"] = true
}

-- Variabel Fitur
local aim, fov, esp, trc, nm, hp, smooth, fov_r, drag, d_fov, wc, afk, fps, dw, bkwd = false, false, false, false, false, false, 0.1, 150, false, false, false, false, false, false, false
local ESP_Cache = {}

-- [ UI PARENTING ]
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"):FindFirstChild("RobloxGui") or p:WaitForChild("PlayerGui"))
sg.Name = "ZieHubV1"; sg.ResetOnSpawn = false

-- [ FLOATING DEL BUTTON ]
local delBtn = Instance.new("TextButton", sg)
delBtn.Size, delBtn.Visible, delBtn.Text = UDim2.new(0, 60, 0, 40), false, "DEL"
delBtn.BackgroundColor3, delBtn.TextColor3, delBtn.Font, delBtn.TextSize = Color3.fromRGB(30, 0, 0), Color3.new(1, 0, 0), 3, 18
delBtn.Position = UDim2.new(0.5, -30, 0.7, 0)
delBtn.Active, delBtn.Draggable = true, true
Instance.new("UICorner", delBtn)
local dStroke = Instance.new("UIStroke", delBtn)
dStroke.Color, dStroke.Thickness = Color3.new(1, 0, 0), 2

delBtn.MouseButton1Click:Connect(function()
    if dw then
        local m = p:GetMouse()
        if m.Target then m.Target:Destroy() end
    end
end)

-- [ MAIN HUB ]
local f = Instance.new("Frame", sg); f.Size, f.Position, f.BackgroundColor3, f.Visible = UDim2.new(0, 420, 0, 580), UDim2.new(0.5, -210, 0.5, -290), Color3.fromRGB(15,15,15), false
f.Active, f.Draggable = true, true; Instance.new("UICorner", f); Instance.new("UIStroke", f).Color = Color3.new(1,0,0)

local title = Instance.new("TextLabel", f); title.Size, title.Position, title.BackgroundTransparency = UDim2.new(1, 0, 0, 40), UDim2.new(0, 0, 0, 10), 1
title.Text, title.TextColor3, title.TextSize, title.Font = "ZieHubV1", Color3.new(1,0,0), 25, 3

local cred = Instance.new("TextLabel", f)
cred.Size, cred.Position = UDim2.new(1, 0, 0, 80), UDim2.new(0, 0, 1, -90)
cred.BackgroundTransparency, cred.TextColor3, cred.TextSize, cred.Font = 1, Color3.new(1,0,0), 14, 3
cred.Text = "Credit by ziewio4\nNomor WA: 083121936734\nTiktok: ziewio4"

-- [ KEY SYSTEM UI ]
local keyF = Instance.new("Frame", sg)
keyF.Size, keyF.Position, keyF.BackgroundColor3 = UDim2.new(0, 300, 0, 180), UDim2.new(0.5, -150, 0.5, -90), Color3.fromRGB(20,20,20)
keyF.Visible = false; Instance.new("UICorner", keyF); Instance.new("UIStroke", keyF).Color = Color3.new(1,0,0)

local keyT = Instance.new("TextLabel", keyF)
keyT.Size, keyT.Position, keyT.Text, keyT.TextColor3, keyT.BackgroundTransparency = UDim2.new(1,0,0,40), UDim2.new(0,0,0,10), "ENTER PREMIUM KEY", Color3.new(1,1,1), 1

local box = Instance.new("TextBox", keyF)
box.Size, box.Position, box.Text = UDim2.new(0.8,0,0,35), UDim2.new(0.1,0,0.35,0), ""
box.BackgroundColor3, box.PlaceholderText, box.TextColor3 = Color3.new(0.1,0.1,0.1), "Input Key...", Color3.new(1,1,1)
Instance.new("UICorner", box)

local apply = Instance.new("TextButton", keyF)
apply.Size, apply.Position, apply.Text = UDim2.new(0.8,0,0,35), UDim2.new(0.1,0,0.65,0), "APPLY"
apply.BackgroundColor3, apply.TextColor3 = Color3.new(1,0,0), Color3.new(1,1,1)
Instance.new("UICorner", apply)

apply.MouseButton1Click:Connect(function()
    if premiumKeys[box.Text] then keyF:Destroy(); f.Visible = true else box.Text = ""; box.PlaceholderText = "WRONG / EXPIRED!" task.wait(1) box.PlaceholderText = "Input Key..." end
end)

-- [ TOGGLE SYSTEM ]
local min = Instance.new("TextButton", sg); min.Size, min.Text, min.Visible, min.Draggable = UDim2.new(0,45,0,45), "Z", false, true
min.Position, min.BackgroundColor3, min.TextColor3 = UDim2.new(0.1,0,0.2,0), Color3.new(0,0,0), Color3.new(1,0,0)
Instance.new("UICorner", min, UDim.new(1,0)); Instance.new("UIStroke", min).Color = Color3.new(1,0,0)

local function tgl() 
    if sg:FindFirstChild("Frame") and keyF.Parent then return end 
    f.Visible, min.Visible = not f.Visible, f.Visible 
end
min.MouseButton1Click:Connect(tgl)

-- [ LOGICS ]
local function toggleBackwards()
    bkwd = not bkwd; local char = p.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        if bkwd then hrp.CFrame = hrp.CFrame * CFrame.new(0, 1.5, 0) * CFrame.Angles(0, 0, math.rad(180)); hrp.Anchored = true
        else hrp.Anchored = false; hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(hrp.Orientation.Y), 0) end
    end
end

local function btn(txt, pos, cb)
    local b = Instance.new("TextButton", f); b.Size, b.Position, b.Text = UDim2.new(0.45,0,0,30), pos, txt
    b.BackgroundColor3, b.TextColor3, b.Font, b.TextSize = Color3.fromRGB(30,30,30), Color3.new(1,1,1), 3, 12
    b.MouseButton1Click:Connect(cb); Instance.new("UICorner", b); return b
end

-- Layout Tombol
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

local bDw = btn("Del Wall (K): OFF", UDim2.new(0.025,0,0.71,0), function() 
    dw = not dw 
    delBtn.Visible = dw
end)

-- [[ FITUR BARU AutoMSv1X ]]
local bMSX = btn("AutoMSv1X: EXECUTE", UDim2.new(0.525,0,0.71,0), function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ziwtiktok52-star/ziwhubmssss/refs/heads/main/ggs"))()
    end)
end)
bMSX.BackgroundColor3 = Color3.fromRGB(0, 100, 0) -- Warna Hijau Gelap biar beda

btn("X", UDim2.new(1,-35,0,5), tgl).Size = UDim2.new(0,30,0,30)

-- [ SLIDERS ]
local function sld(txt, pos)
    local l = Instance.new("TextLabel", f); l.Size, l.Position, l.Text = UDim2.new(0.45,0,0,20), UDim2.new(0.025,0,pos,0), txt
    l.TextColor3, l.BackgroundTransparency, l.TextSize = Color3.new(1,1,1), 1, 12
    local bg = Instance.new("Frame", f); bg.Size, bg.Position, bg.BackgroundColor3 = UDim2.new(0.4,0,0,6), UDim2.new(0.05,0,pos+0.05,0), Color3.new(0.2,0.2,0.2)
    local bar = Instance.new("Frame", bg); bar.Size, bar.BackgroundColor3 = UDim2.new(0.5,0,1,0), Color3.new(1,0,0)
    local d = Instance.new("TextButton", bar); d.Size, d.Text, d.BackgroundTransparency = UDim2.new(1,0,1,0), "", 1
    Instance.new("UICorner", bg); Instance.new("UICorner", bar); return l, bg, bar, d
end

local sL, sBg, sBar, sD = sld("Smooth: 0.1", 0.44); local fL, fBg, fBar, fD = sld("FOV Size: 150", 0.54)
sD.MouseButton1Down:Connect(function() drag = true end); fD.MouseButton1Down:Connect(function() d_fov = true end)

-- [ ESP CREATION ]
local function createEsp(plr)
    if plr == p then return end
    local components = {box = Drawing.new("Square"), line = Drawing.new("Line"), name = Drawing.new("Text"), health = Drawing.new("Line")}
    components.name.Size, components.name.Center, components.name.Outline, components.name.Color = 16, true, true, Color3.new(1,1,1)
    components.box.Color, components.line.Color = Color3.new(1, 1, 0), Color3.new(1, 1, 0)
    ESP_Cache[plr] = components
end

-- [ RENDER LOOP ]
local circle = Drawing.new("Circle"); circle.Thickness, circle.NumSides, circle.Color = 1, 100, Color3.new(1,0,0)
run.RenderStepped:Connect(function()
    local center = Vector2.new(cam.ViewportSize.X / 2, (cam.ViewportSize.Y - GS:GetGuiInset().Y) / 2 + GS:GetGuiInset().Y)
    circle.Visible, circle.Position, circle.Radius = fov, center, fov_r
    
    bA.Text="Aimbot: "..(aim and "ON" or "OFF"); bW.Text="Wallcheck: "..(wc and "ON" or "OFF")
    bF.Text="FOV: "..(fov and "ON" or "OFF"); bAf.Text="Anti-AFK: "..(afk and "ON" or "OFF")
    bE.Text="ESP Box: "..(esp and "ON" or "OFF"); bH.Text="ESP Health: "..(hp and "ON" or "OFF")
    bDw.Text="Del Wall (K): "..(dw and "ON" or "OFF")

    if drag then
        local pct = math.clamp((UIS:GetMouseLocation().X - sBg.AbsolutePosition.X)/sBg.AbsoluteSize.X, 0, 1)
        sBar.Size, smooth = UDim2.new(pct,0,1,0), (pct * 0.9) + 0.01; sL.Text = string.format("Smooth: %.2f", smooth)
    end
    if d_fov then
        local pct = math.clamp((UIS:GetMouseLocation().X - fBg.AbsolutePosition.X)/fBg.AbsoluteSize.X, 0, 1)
        fBar.Size, fov_r = UDim2.new(pct,0,1,0), math.floor(pct * 800); fL.Text = "FOV Size: "..fov_r
    end

    for plr, v in pairs(ESP_Cache) do
        local char = plr.Character
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            local pos, vis = cam:WorldToViewportPoint(char.HumanoidRootPart.Position)
            if vis then
                local h, w = 2000 / pos.Z, (2000 / pos.Z) / 1.5
                v.box.Visible, v.box.Size, v.box.Position = esp, Vector2.new(w, h), Vector2.new(pos.X - w/2, pos.Y - h/2)
                v.line.Visible, v.line.From, v.line.To = trc, center, Vector2.new(pos.X, pos.Y)
                v.name.Visible, v.name.Text, v.name.Position = nm, plr.Name, Vector2.new(pos.X, pos.Y - h/2 - 20)
                if hp then
                    v.health.Visible = true; local hpPct = char.Humanoid.Health / char.Humanoid.MaxHealth
                    v.health.From, v.health.To = Vector2.new(pos.X - w/2 - 5, pos.Y + h/2), Vector2.new(pos.X - w/2 - 5, pos.Y + h/2 - (h * hpPct))
                    v.health.Color = Color3.fromHSV(hpPct * 0.3, 1, 1)
                else v.health.Visible = false end
            else v.box.Visible, v.line.Visible, v.name.Visible, v.health.Visible = false, false, false, false end
        else v.box.Visible, v.line.Visible, v.name.Visible, v.health.Visible = false, false, false, false end
    end

    if aim then
        local target, close = nil, (fov and fov_r or 2000)
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= p and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                local part = v.Character:FindFirstChild("Head") or v.Character:FindFirstChild("HumanoidRootPart")
                if part then
                    local pos, vis = cam:WorldToViewportPoint(part.Position)
                    if vis then
                        local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if dist < close then
                            if wc then
                                local ray = cam:GetPartsObscuringTarget({cam.CFrame.Position, part.Position}, {p.Character, v.Character})
                                if #ray > 0 then continue end
                            end
                            target = part; close = dist
                        end
                    end
                end
            end
        end
        if target then
            local targetPos = CFrame.new(cam.CFrame.Position, target.Position)
            cam.CFrame = cam.CFrame:Lerp(targetPos, 1 - smooth) 
        end
    end
end)

-- [ LOADER ]
local ldF = Instance.new("Frame", sg); ldF.Size, ldF.Position = UDim2.new(0,250,0,80), UDim2.new(0.5,-125,0.5,-40); ldF.BackgroundColor3 = Color3.new(0,0,0)
local ldB = Instance.new("Frame", ldF); ldB.Size, ldB.Position = UDim2.new(0,0,0,5), UDim2.new(0.1,0,0.7,0); ldB.BackgroundColor3 = Color3.new(1,0,0)
task.spawn(function()
    for i=0,100,5 do ldB.Size=UDim2.new(i/100*0.8,0,0,5); task.wait(0.05) end
    ldF:Destroy(); keyF.Visible = true
end)

-- [ FINAL INIT ]
UIS.InputBegan:Connect(function(i, g)
    if not g then
        if i.KeyCode == Enum.KeyCode.P then tgl() end
        if i.KeyCode == Enum.KeyCode.J then toggleBackwards() end
        if i.KeyCode == Enum.KeyCode.K and dw then
            local m = p:GetMouse()
            if m.Target then m.Target:Destroy() end
        end
    end
end)

UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag, d_fov = false end end)
for _, v in pairs(game.Players:GetPlayers()) do createEsp(v) end
game.Players.PlayerAdded:Connect(createEsp)
game.Players.PlayerRemoving:Connect(function(plr)
    if ESP_Cache[plr] then for _, o in pairs(ESP_Cache[plr]) do o:Remove() end ESP_Cache[plr] = nil end
end)
