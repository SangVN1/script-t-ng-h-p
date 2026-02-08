--[[
    REDYN HUB - PHIÊN BẢN CHUẨN (SCRIPT BY SANG)
    Full Features: Beta Hub, Zephyr V2, Atlas BSS
    Support: Mobile (Nút bật tắt), PC, Xeno
]]

-- 1. CHUẨN BỊ & DỌN DẸP GIAO DIỆN CŨ
if not game:IsLoaded() then game.Loaded:Wait() end

for i,v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "RedynMobileToggle" or (v.Name == "ScreenGui" and v:FindFirstChild("Frame")) then
        v:Destroy()
    end
end

-- 2. TẢI THƯ VIỆN GIAO DIỆN (FLUENT UI)
local Fluent = nil
local success, err = pcall(function()
    Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

if not success or not Fluent then
    game.StarterGui:SetCore("SendNotification", {Title = "Lỗi Mạng", Text = "Vui lòng kiểm tra kết nối internet!", Duration = 5})
    return
end

local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- 3. CẤU HÌNH CỬA SỔ MENU
local Window = Fluent:CreateWindow({
    Title = "Redyn Hub | Master Collection",
    SubTitle = "Script by Sang", -- >> TÊN CỦA BẠN <<
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, -- Tắt mờ nền để Mobile/Xeno chạy mượt nhất
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- 4. TẠO NÚT TRÒN BẬT/TẮT CHO ĐIỆN THOẠI (MOBILE TOGGLE)
local UserInputService = game:GetService("UserInputService")
if UserInputService.TouchEnabled then
    local ScreenGui = Instance.new("ScreenGui")
    local ToggleBtn = Instance.new("ImageButton")
    local UICorner = Instance.new("UICorner")
    
    ScreenGui.Name = "RedynMobileToggle"
    ScreenGui.Parent = game.CoreGui
    
    ToggleBtn.Name = "ToggleBtn"
    ToggleBtn.Parent = ScreenGui
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ToggleBtn.Position = UDim2.new(0.9, -50, 0.5, 0) -- Vị trí nút (bên phải)
    ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
    ToggleBtn.Image = "rbxassetid://10057361026" -- Icon Redyn
    ToggleBtn.Draggable = true -- Có thể kéo nút đi chỗ khác
    ToggleBtn.Active = true
    
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = ToggleBtn
    
    -- Chức năng: Giả lập phím Ctrl để bật tắt menu
    ToggleBtn.MouseButton1Click:Connect(function()
        local vim = game:GetService("VirtualInputManager")
        vim:SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
        task.wait()
        vim:SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
    end)
end

-- 5. TẠO CÁC TAB CHỨC NĂNG
local Tabs = {
    Doors = Window:AddTab({ Title = "DOORS", Icon = "door-open" }),       
    BSS = Window:AddTab({ Title = "Bee Swarm", Icon = "bug" }),           
    BloxFruit = Window:AddTab({ Title = "Blox Fruits", Icon = "swords" }),
    Misc = Window:AddTab({ Title = "Tiện ích", Icon = "wrench" }), 
    Settings = Window:AddTab({ Title = "Cài đặt", Icon = "settings" })
}

-- >> TAB: DOORS
Tabs.Doors:AddButton({
    Title = "Chạy Zephyr V2",
    Description = "Hack Doors: ESP, Entity Spawner...",
    Callback = function()
        Window:Minimize()
        task.spawn(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/TheRealAvrwm/Zephyr-V2/refs/heads/main/script.lua", true))()
        end)
    end
})

-- >> TAB: BEE SWARM SIMULATOR
Tabs.BSS:AddButton({
    Title = "Chạy Atlas BSS",
    Description = "Auto Farm Ong, Auto Quest",
    Callback = function()
        Window:Minimize()
        task.spawn(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Chris12089/atlasbss/main/script.lua"))()
        end)
    end
})

-- >> TAB: BLOX FRUITS (BETA HUB)
Tabs.BloxFruit:AddButton({
    Title = "🍉 Chạy Beta Hub",
    Description = "Auto Farm + Auto Team Pirates",
    Callback = function()
        Fluent:Notify({Title = "Script by Sang", Content = "Đang tải Beta Hub...", Duration = 3})
        Window:Minimize()
        
        task.spawn(function()
            -- 1. Chờ game load xong
            repeat task.wait() until game:IsLoaded()
            -- 2. Chọn Team Hải Tặc
            pcall(function() getgenv().team = "Pirates" end)
            -- 3. Chạy Beta Hub
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Anniecreate86/BloxFruits/refs/heads/main/BetaHub-BF"))()
        end)
    end
})

-- >> TAB: TIỆN ÍCH CHUNG
Tabs.Misc:AddButton({
    Title = "🚀 Giảm Lag (Anti-Crash)",
    Description = "Xóa texture giúp máy yếu chơi mượt",
    Callback = function()
        task.spawn(function()
            for i,v in pairs(game.Workspace:GetDescendants()) do
                if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
                    v.Material = Enum.Material.Plastic
                    v.Reflectance = 0
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    v:Destroy()
                end
            end
        end)
        Fluent:Notify({Title = "Xong!", Content = "Đã tối ưu hóa.", Duration = 3})
    end
})

-- 6. HOÀN TẤT & LƯU CẤU HÌNH
pcall(function()
    SaveManager:SetLibrary(Fluent)
    InterfaceManager:SetLibrary(Fluent)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({})
    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
    Window:SelectTab(1)
end)

Fluent:Notify({
    Title = "Chào mừng!",
    Content = "Script by Sang đã khởi động thành công.",
    Duration = 5
})
