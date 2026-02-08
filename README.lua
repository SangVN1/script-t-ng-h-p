--[[
    REDYN HUB - MASTER COLLECTION
    Author: Sang
    Library: Fluent UI
    Support: PC & Mobile
    Update: Added Luminon Hub
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
    SubTitle = "Added Luminon Hub",
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

-- 5. TẠO TAB & CHỨC NĂNG
local Tabs = {
    BSS = Window:AddTab({ Title = "Bee Swarm", Icon = "bug" }),            
    BloxFruit = Window:AddTab({ Title = "Blox Fruits", Icon = "swords" }),
    Misc = Window:AddTab({ Title = "Tiện ích & Hub", Icon = "wrench" }), 
    Settings = Window:AddTab({ Title = "Cài đặt", Icon = "settings" })
}

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
    Description = "Script tổng hợp đa năng (Mới thêm)",
    Callback = function()
        Window:Minimize() -- Ẩn menu Redyn để tránh vướng
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
    Content = "Script by Sang đã khởi động thành công!",
    Duration = 5
})
