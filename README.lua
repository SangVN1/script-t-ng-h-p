--[[
    REDYN HUB - PHIÊN BẢN FULL (UPDATE JAILBREAK)
    Author: Sang
    Library: Fluent UI
    Update: Thêm Tab Auto Rob & Auto Arrest
]]

-- 1. DỌN DẸP UI CŨ
if not game:IsLoaded() then game.Loaded:Wait() end
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "RedynMobileToggle" or (v.Name == "ScreenGui" and v:FindFirstChild("Frame")) then
        v:Destroy()
    end
end

-- 2. TẢI THƯ VIỆN FLUENT
local Fluent = nil
local success, err = pcall(function()
    Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

if not success or not Fluent then
    game.StarterGui:SetCore("SendNotification", {Title = "Lỗi", Text = "Kiểm tra lại mạng!", Duration = 5})
    return
end

local Window = Fluent:CreateWindow({
    Title = "Redyn Hub | Script by Sang",
    SubTitle = "Master Collection",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- 3. NÚT MOBILE (BẬT TẮT MENU)
local UserInputService = game:GetService("UserInputService")
if UserInputService.TouchEnabled then
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RedynMobileToggle"
    ScreenGui.Parent = game.CoreGui
    local ToggleBtn = Instance.new("ImageButton")
    local UICorner = Instance.new("UICorner")
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

-- 4. TẠO CÁC TAB
local Tabs = {
    Main = Window:AddTab({ Title = "Escape Tsunami", Icon = "waves" }), 
    Jailbreak = Window:AddTab({ Title = "Jailbreak / Rob", Icon = "car" }), -- >> TAB MỚI
    BSS = Window:AddTab({ Title = "Bee Swarm", Icon = "bug" }),
    BloxFruit = Window:AddTab({ Title = "Blox Fruits", Icon = "swords" }),
    Misc = Window:AddTab({ Title = "Tiện ích", Icon = "wrench" }),
}

-- >>>>>>> TAB 1: ESCAPE TSUNAMI <<<<<<<

Tabs.Main:AddParagraph({
    Title = "Script Chính",
    Content = "Nhấn nút bên dưới để chạy Luminon Hub cho Escape Tsunami."
})

Tabs.Main:AddButton({
    Title = "🌟 Chạy Luminon Hub",
    Description = "Load Script: luminon.top",
    Callback = function()
        Window:Minimize()
        task.spawn(function()
            loadstring(game:HttpGet("http://luminon.top/loader.lua"))()
        end)
    end
})

-- >>>>>>> TAB 2: JAILBREAK / ROB (MỚI THÊM) <<<<<<<

Tabs.Jailbreak:AddParagraph({
    Title = "Hỗ trợ Project Auto",
    Content = "Các Script hỗ trợ tự động cướp tiền hoặc bắt tội phạm (Jailbreak/Mad City)."
})

Tabs.Jailbreak:AddButton({
    Title = "💰 Auto Rob (Tự động cướp)",
    Description = "Chạy Script AutoRob V6",
    Callback = function()
        Window:Minimize()
        loadstring(game:HttpGet('https://scripts.projectauto.xyz/AutoRobV6'))()
    end
})

Tabs.Jailbreak:AddButton({
    Title = "👮 Auto Arrest (Tự động bắt)",
    Description = "Chạy Script AutoArrest V4",
    Callback = function()
        Window:Minimize()
        loadstring(game:HttpGet('https://scripts.projectauto.xyz/AutoArrestV4'))()
    end
})

-- >>>>>>> TAB 3: BEE SWARM SIMULATOR <<<<<<<

Tabs.BSS:AddParagraph({
    Title = "Hỗ trợ Bee Swarm",
    Content = "Script Atlas BSS chuyên dùng để Auto Farm Mật, Phấn hoa và làm nhiệm vụ tự động."
})

Tabs.BSS:AddButton({
    Title = "🐝 Chạy Atlas BSS",
    Description = "Auto Farm tốt nhất hiện nay",
    Callback = function()
        Window:Minimize()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Chris12089/atlasbss/main/script.lua"))()
    end
})

-- >>>>>>> TAB 4: BLOX FRUITS <<<<<<<

Tabs.BloxFruit:AddParagraph({
    Title = "Hỗ trợ Blox Fruits",
    Content = "Script Beta Hub giúp Auto Farm Level, Raid, Dungeon và tự động chọn Team Hải Tặc."
})

Tabs.BloxFruit:AddButton({
    Title = "🍉 Chạy Beta Hub",
    Description = "Auto Farm / Auto Raid / PVP",
    Callback = function()
        Window:Minimize()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Anniecreate86/BloxFruits/refs/heads/main/BetaHub-BF"))()
    end
})

-- >>>>>>> TAB 5: TIỆN ÍCH (MISC) <<<<<<<

Tabs.Misc:AddParagraph({
    Title = "Công cụ hỗ trợ",
    Content = "Các chức năng giúp giảm lag, tối ưu hóa đồ họa cho máy yếu."
})

Tabs.Misc:AddButton({
    Title = "🚀 Giảm Lag (Smooth)",
    Description = "Xóa Texture, làm mượt đồ họa để tăng FPS",
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
        Fluent:Notify({Title = "Thành công", Content = "Đã tối ưu hóa đồ họa!", Duration = 3})
    end
})

-- 5. KẾT THÚC
Window:SelectTab(1)
