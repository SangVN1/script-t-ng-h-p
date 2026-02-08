--[[
    REDYN HUB - PHIÊN BẢN FIX (ĐÃ THÊM TSUNAMI)
    Update: Đưa Tab Tsunami lên đầu, Fix lỗi hiển thị
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
    Title = "Redyn Hub | Escape Tsunami",
    SubTitle = "Script by Sang",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- 3. NÚT MOBILE
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

-- 4. TẠO TAB (ĐƯA TSUNAMI LÊN ĐẦU)
local Tabs = {
    Tsunami = Window:AddTab({ Title = "🌊 Escape Tsunami", Icon = "waves" }), -- Tab này hiện đầu tiên
    BSS = Window:AddTab({ Title = "Bee Swarm", Icon = "bug" }),
    BloxFruit = Window:AddTab({ Title = "Blox Fruits", Icon = "swords" }),
    Misc = Window:AddTab({ Title = "Tiện ích & Hub", Icon = "wrench" }),
}

--Options = Fluent.Options -- Khai báo Options để dùng cho Toggle

-- >>>>>>> CODE CHO ESCAPE TSUNAMI FOR BRAINROTS <<<<<<<

Tabs.Tsunami:AddParagraph({
    Title = "Chức năng Game Brainrots",
    Content = "Bật Auto bên dưới để tự động gom tiền/vật phẩm."
})

local AutoFarm = false
Tabs.Tsunami:AddToggle("AutoCollect", {
    Title = "Auto Farm (Brainrots/Coins)",
    Description = "Tự động bay đến nhặt đồ",
    Default = false,
    Callback = function(Value)
        AutoFarm = Value
        if Value then
            task.spawn(function()
                while AutoFarm do
                    task.wait()
                    pcall(function()
                        local lp = game.Players.LocalPlayer
                        local char = lp.Character
                        if not char or not char:FindFirstChild("HumanoidRootPart") then return end

                        -- Tìm vật phẩm (Handle, Coin, hoặc Brainrot)
                        for _, v in pairs(workspace:GetDescendants()) do
                            if not AutoFarm then break end
                            -- Logic: Vật phẩm thường có TouchInterest hoặc tên chứa Coin/Brain
                            if (v.Name:lower():find("coin") or v.Name:lower():find("brain") or v:FindFirstChild("TouchInterest")) and v:IsA("BasePart") then
                                if v.Transparency < 1 then -- Chỉ nhặt vật phẩm đang hiện
                                    char.HumanoidRootPart.CFrame = v.CFrame
                                    task.wait(0.15) -- Dừng lại xíu để game nhận diện đã nhặt
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
    Title = "🛡️ Chế độ Bất Tử (God Mode)",
    Description = "Xóa nước để không bị chết đuối (Client)",
    Callback = function()
        pcall(function()
            if workspace:FindFirstChild("Water") then
                workspace.Water:Destroy()
            end
            Fluent:Notify({Title = "Đã xóa nước", Content = "Bạn sẽ không bị nước đẩy nữa!", Duration = 3})
        end)
    end
})

Tabs.Tsunami:AddButton({
    Title = "🛸 Bay lên vùng an toàn (Safe Zone)",
    Description = "Teleport lên cao 200m",
    Callback = function()
        pcall(function()
            local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
            hrp.CFrame = hrp.CFrame + Vector3.new(0, 200, 0)
            
            -- Tạo cái sàn để đứng
            local part = Instance.new("Part", workspace)
            part.Size = Vector3.new(20, 1, 20)
            part.Position = hrp.Position - Vector3.new(0, 3, 0)
            part.Anchored = true
        end)
    end
})

Tabs.Tsunami:AddSlider("SpeedHack", {
    Title = "Tốc độ chạy",
    Description = "Chỉnh tốc độ nhân vật",
    Default = 16,
    Min = 16,
    Max = 300,
    Rounding = 0,
    Callback = function(Value)
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end)
    end
})

-- >>>>>>> CÁC TAB KHÁC GIỮ NGUYÊN <<<<<<<

-- BSS
Tabs.BSS:AddButton({
    Title = "Chạy Atlas BSS",
    Callback = function()
        Window:Minimize()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Chris12089/atlasbss/main/script.lua"))()
    end
})

-- Blox Fruits
Tabs.BloxFruit:AddButton({
    Title = "🍉 Chạy Beta Hub",
    Callback = function()
        Window:Minimize()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Anniecreate86/BloxFruits/refs/heads/main/BetaHub-BF"))()
    end
})

-- Misc & Luminon
Tabs.Misc:AddButton({
    Title = "🌟 Chạy Luminon Hub",
    Callback = function()
        Window:Minimize()
        loadstring(game:HttpGet("http://luminon.top/loader.lua"))()
    end
})

Tabs.Misc:AddButton({
    Title = "🚀 Giảm Lag (Smooth)",
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
        Fluent:Notify({Title = "Xong", Content = "Đã giảm lag thành công", Duration = 3})
    end
})

-- Kết thúc
Window:SelectTab(1) -- Tự động chọn Tab đầu tiên (Tsunami)
