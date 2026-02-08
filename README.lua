--[[
    REDYN HUB - MASTER COLLECTION
    Author: Sang
    Library: Fluent UI
    Support: PC & Mobile
    Update: Added "Escape Tsunami For Brainrots"
]]

-- 1. KHỞI TẠO & DỌN DẸP
if not game:IsLoaded() then game.Loaded:Wait() end

-- Xóa các GUI cũ
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "RedynMobileToggle" or (v.Name == "ScreenGui" and v:FindFirstChild("Frame")) then
        v:Destroy()
    end
end

-- 2. TẢI THƯ VIỆN FLUENT UI
local Fluent = nil
local success, err = pcall(function()
    Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

if not success or not Fluent then
    game.StarterGui:SetCore("SendNotification", {
        Title = "Redyn Hub Lỗi",
        Text = "Không thể tải thư viện UI. Kiểm tra mạng!",
        Duration = 5
    })
    return
end

local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- 3. CẤU HÌNH CỬA SỔ MENU
local Window = Fluent:CreateWindow({
    Title = "Redyn Hub | Script by Sang",
    SubTitle = "Escape Tsunami Added",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- 4. TẠO NÚT BẬT/TẮT CHO MOBILE
local UserInputService = game:GetService("UserInputService")
if UserInputService.TouchEnabled then
    local ScreenGui = Instance.new("ScreenGui")
    local ToggleBtn = Instance.new("ImageButton")
    local UICorner = Instance.new("UICorner")
    
    ScreenGui.Name = "RedynMobileToggle"
    ScreenGui.Parent = game.CoreGui
    
    ToggleBtn.Name = "ToggleBtn"
    ToggleBtn.Parent = ScreenGui
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToggleBtn.Position = UDim2.new(0.9, -50, 0.5, 0)
    ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
    ToggleBtn.Image = "rbxassetid://10057361026"
    ToggleBtn.Draggable = true
    ToggleBtn.Active = true
    
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = ToggleBtn
    
    ToggleBtn.MouseButton1Click:Connect(function()
        local vim = game:GetService("VirtualInputManager")
        vim:SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
        task.wait()
        vim:SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
    end)
end

-- 5. TẠO CÁC TAB
local Tabs = {
    Tsunami = Window:AddTab({ Title = "Escape Tsunami", Icon = "waves" }), -- Tab Mới
    BSS = Window:AddTab({ Title = "Bee Swarm", Icon = "bug" }),            
    BloxFruit = Window:AddTab({ Title = "Blox Fruits", Icon = "swords" }),
    Misc = Window:AddTab({ Title = "Tiện ích & Hub", Icon = "wrench" }), 
    Settings = Window:AddTab({ Title = "Cài đặt", Icon = "settings" })
}

-- >> TAB: ESCAPE TSUNAMI FOR BRAINROTS (MỚI)
Tabs.Tsunami:AddParagraph({
    Title = "Lưu ý",
    Content = "Chức năng Auto Farm sẽ tự động tìm và nhặt các Brainrots/Coins trên bản đồ."
})

local AutoFarmTsunami = false
Tabs.Tsunami:AddToggle("AutoFarmBrainrots", {
    Title = "Auto Collect (Brainrots/Coins)",
    Description = "Tự động bay đi nhặt đồ",
    Default = false,
    Callback = function(Value)
        AutoFarmTsunami = Value
        if Value then
            task.spawn(function()
                while AutoFarmTsunami do
                    task.wait(0.1)
                    pcall(function()
                        local player = game.Players.LocalPlayer
                        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
                        
                        -- Tìm các vật phẩm có thể nhặt (TouchInterest hoặc tên Coin/Brainrot)
                        for _, v in pairs(workspace:GetDescendants()) do
                            if not AutoFarmTsunami then break end
                            if v:IsA("Part") or v:IsA("MeshPart") then
                                if (v.Name:lower():find("coin") or v.Name:lower():find("brainrot") or v:FindFirstChild("TouchInterest")) and v.Transparency < 1 then
                                    player.Character.HumanoidRootPart.CFrame = v.CFrame
                                    task.wait(0.1) -- Đợi xíu để nhặt
                                end
                            end
                        end
                    end)
                end
            end)
        end
    end
})

Tabs.Tsunami:AddButton({
    Title = "🌊 Né Sóng Thần (Bay lên cao)",
    Description = "Teleport lên trời để an toàn",
    Callback = function()
        pcall(function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 100, 0)
            -- Tạo platform để đứng
            local p = Instance.new("Part", workspace)
            p.Size = Vector3.new(10, 1, 10)
            p.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame - Vector3.new(0, 3, 0)
            p.Anchored = true
        end)
    end
})

Tabs.Tsunami:AddSlider("WalkSpeedTsunami", {
    Title = "Tốc độ chạy (WalkSpeed)",
    Description = "Chỉnh tốc độ để chạy nhanh hơn sóng",
    Default = 16,
    Min = 16,
    Max = 200,
    Rounding = 0,
    Callback = function(Value)
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end)
    end
})

Tabs.Tsunami:AddSlider("JumpPowerTsunami", {
    Title = "Sức bật nhảy (JumpPower)",
    Description = "Nhảy cao hơn",
    Default = 50,
    Min = 50,
    Max = 300,
    Rounding = 0,
    Callback = function(Value)
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
        end)
    end
})

Tabs.Tsunami:AddButton({
    Title = "Tải Script Rời (Solix Hub / Pastebin)",
    Description = "Thử tải script hack full tính năng từ mạng (Nếu có)",
    Callback = function()
        -- Script phổ biến cho dòng game này (Thường là Solix hoặc tương tự)
        -- Lưu ý: Link này có thể thay đổi tùy tác giả
        loadstring(game:HttpGet("https://raw.githubusercontent.com/REDzHUB/BloxFruits/main/redz9999"))() 
        -- (Dùng tạm Redz Hub vì nó hỗ trợ nhiều game, hoặc bạn có thể paste link khác vào đây)
        Fluent:Notify({Title = "Thông báo", Content = "Đang thử tải Script ngoài...", Duration = 3})
    end
})


-- >> TAB: BEE SWARM
Tabs.BSS:AddButton({
    Title = "Chạy Atlas BSS",
    Description = "Auto Farm Mật, Auto Quest, Kill Vicious",
    Callback = function()
        Window:Minimize()
        task.spawn(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Chris12089/atlasbss/main/script.lua"))()
        end)
    end
})

-- >> TAB: BLOX FRUITS
Tabs.BloxFruit:AddButton({
    Title = "🍉 Chạy Beta Hub",
    Description = "Auto Farm Level, Auto Raid, Auto Pirates",
    Callback = function()
        Fluent:Notify({Title = "Redyn Hub", Content = "Đang tải Beta Hub...", Duration = 3})
        Window:Minimize()
        
        task.spawn(function()
            if not game:IsLoaded() then game.Loaded:Wait() end
            pcall(function() 
                local Button = game:GetService("Players").LocalPlayer.PlayerGui.Main.ChooseTeam.Container.Pirates.Frame.TextButton
                if Button then 
                    for i,v in pairs(getconnections(Button.MouseButton1Click)) do
                        v:Fire()
                    end
                end
            end)
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Anniecreate86/BloxFruits/refs/heads/main/BetaHub-BF"))()
        end)
    end
})

-- >> TAB: TIỆN ÍCH & LUMINON
Tabs.Misc:AddButton({
    Title = "🌟 Chạy Luminon Hub",
    Description = "Script tổng hợp đa năng",
    Callback = function()
        Window:Minimize() 
        task.spawn(function()
            loadstring(game:HttpGet("http://luminon.top/loader.lua"))()
        end)
    end
})

Tabs.Misc:AddButton({
    Title = "🚀 FPS Boost (Giảm Lag)",
    Description = "Xóa Texture, làm mượt đồ họa",
    Callback = function()
        task.spawn(function()
            local Terrain = workspace:FindFirstChildOfClass('Terrain')
            if Terrain then 
                Terrain.WaterWaveSize = 0
                Terrain.WaterWaveSpeed = 0
                Terrain.WaterReflectance = 0
                Terrain.WaterTransparency = 0
            end
            lighting = game:GetService("Lighting")
            lighting.GlobalShadows = false
            lighting.FogEnd = 9e9
            for i,v in pairs(game.Workspace:GetDescendants()) do
                if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
                    v.Material = Enum.Material.Plastic
                    v.Reflectance = 0
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    v:Destroy()
                end
            end
        end)
        Fluent:Notify({Title = "Thành công", Content = "Đã tối ưu hóa đồ họa!", Duration = 3})
    end
})

-- 6. HOÀN TẤT
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
Window:SelectTab(1)

Fluent:Notify({
    Title = "Redyn Hub",
    Content = "Cập nhật thành công: Escape Tsunami!",
    Duration = 5
})
