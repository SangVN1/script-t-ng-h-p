--[[
    TỔNG HỢP SCRIPT - SANG HUB V4.2
    Author: Sang
    Library: Fluent UI
    Update: 
    - REORDER: Sắp xếp lại vị trí Tab theo độ phổ biến (Game nhiều người chơi lên đầu)
    - ADDED: Thêm Emergency Hamburg (No Key)
    - UPGRADED: Hệ thống Anti-Cheat Siêu Cấp / Spoofing (Chạy ngầm tự động)
    - Giữ nguyên toàn bộ phân loại Key/No Key
]]

-- =========================================================
-- >>>>> UPGRADED AUTO ANTI-CHEAT (CHẠY NGẦM) <<<<<
-- =========================================================
task.spawn(function()
    if getrawmetatable then
        pcall(function()
            local mt = getrawmetatable(game)
            local oldNamecall = mt.__namecall
            local oldIndex = mt.__index
            setreadonly(mt, false)
            
            -- Danh sách các luồng dữ liệu nguy hiểm cần chặn gửi về server
            local BadRemotes = {"ban", "kick", "crash", "anticheat", "log", "report", "detect", "cheat"}

            -- 1. Đánh lừa lệnh Namecall (Chặn Kick & Chặn Remote Báo Cáo)
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                
                if not checkcaller() then
                    -- Chặn thẳng lệnh đuổi khỏi server
                    if method == "Kick" or method == "kick" then
                        return nil
                    end
                    
                    -- Chặn game gửi thông tin nghi vấn (Report) về Server
                    if method == "FireServer" or method == "InvokeServer" then
                        local remoteName = string.lower(self.Name)
                        for _, keyword in pairs(BadRemotes) do
                            if string.find(remoteName, keyword) then
                                return nil -- Tiêu hủy lệnh gửi đi
                            end
                        end
                    end
                end
                return oldNamecall(self, ...)
            end)

            -- 2. Đánh lừa lệnh Index (Đánh lừa hệ thống quét Speed/Jump)
            mt.__index = newcclosure(function(self, key)
                if not checkcaller() and self:IsA("Humanoid") then
                    if key == "WalkSpeed" then return 16 end -- Game quét sẽ luôn thấy bạn đi bộ bình thường
                    if key == "JumpPower" then return 50 end -- Game quét sẽ luôn thấy bạn nhảy bình thường
                end
                return oldIndex(self, key)
            end)

            setreadonly(mt, true)

            -- 3. Ngắt hệ thống LogService (Chặn game phát hiện lỗi do script gây ra)
            if getconnections then
                for _, conn in pairs(getconnections(game:GetService("ScriptContext").Error)) do conn:Disable() end
                for _, conn in pairs(getconnections(game:GetService("LogService").MessageOut)) do conn:Disable() end
            end
        end)
    end
end)

-- 1. DỌN DẸP UI CŨ
if not game:IsLoaded() then game.Loaded:Wait() end
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "TongHopMobileToggle" or (v.Name == "ScreenGui" and v:FindFirstChild("Frame") and v.Frame:FindFirstChild("Title")) then
        if v.Frame.Title:FindFirstChild("Text") and (string.find(v.Frame.Title.Text.Text, "Sang") or string.find(v.Frame.Title.Text.Text, "Tổng Hợp")) then
            v:Destroy()
        end
    end
end

-- 2. TẢI THƯ VIỆN FLUENT
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- 3. CẤU HÌNH CỬA SỔ
local Window = Fluent:CreateWindow({
    Title = "Tổng Hợp Script",
    SubTitle = "By Sang | Version 4.2",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, 
    Theme = "Dark", 
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- =========================================================
-- >>>>> ANIMATION: OPENING EFFECT <<<<<
-- =========================================================
task.spawn(function()
    local TweenService = game:GetService("TweenService")
    local CoreGui = game:GetService("CoreGui")
    local TargetFrame = nil

    task.wait(0.5) 

    for _, gui in pairs(CoreGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui:FindFirstChild("Frame") then
            local f = gui.Frame
            if f:FindFirstChild("Title") and f.Title:FindFirstChild("Text") then
                if string.find(f.Title.Text.Text, "Tổng Hợp") then
                    TargetFrame = f
                    break
                end
            end
        end
    end

    if TargetFrame then
        TargetFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        TargetFrame.Size = UDim2.new(0, 0, 0, 0)
        TargetFrame.BackgroundTransparency = 1
        
        local TweenInfoAnim = TweenInfo.new(1, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
        local TweenPlay = TweenService:Create(TargetFrame, TweenInfoAnim, {
            Size = UDim2.fromOffset(580, 460),
            BackgroundTransparency = 0.01
        })
        TweenPlay:Play()
    end
end)

-- 4. TẠO TAB (ĐÃ SẮP XẾP LẠI THEO ĐỘ PHỔ BIẾN)
local Tabs = {
    Search    = Window:AddTab({ Title = "Tìm kiếm Script", Icon = "search" }),
    Updates   = Window:AddTab({ Title = "Full Update Log", Icon = "history" }),
    
    -- === GAME HOT (NHIỀU NGƯỜI CHƠI NHẤT) ===
    BloxFruit = Window:AddTab({ Title = "Blox Fruits", Icon = "swords" }), -- Top 1
    Doors     = Window:AddTab({ Title = "Doors", Icon = "eye" }),          -- Top 2
    MM2       = Window:AddTab({ Title = "Murder Mystery 2", Icon = "skull" }), -- Top 3
    BladeBall = Window:AddTab({ Title = "Blade Ball", Icon = "shield" }),  -- Top 4
    King      = Window:AddTab({ Title = "King Legacy", Icon = "crown" }),  -- Top 5
    BSS       = Window:AddTab({ Title = "Bee Swarm", Icon = "bug" }),      -- Top 6
    Jailbreak = Window:AddTab({ Title = "Jailbreak", Icon = "car" }),      -- Top 7
    
    -- === GAME KHÁC ===
    Hamburg   = Window:AddTab({ Title = "Emergency Hamburg", Icon = "car" }),
    Midnight  = Window:AddTab({ Title = "Midnight Chasers", Icon = "ghost" }),
    Main      = Window:AddTab({ Title = "Escape Tsunami", Icon = "waves" }), 
    Nights    = Window:AddTab({ Title = "99 Nights", Icon = "moon" }), 
    
    -- === HỆ THỐNG ===
    Misc      = Window:AddTab({ Title = "Tiện ích", Icon = "wrench" }),
    Settings  = Window:AddTab({ Title = "Cài đặt UI", Icon = "settings" })
}

-- =========================================================
-- [TAB 1] HỆ THỐNG TÌM KIẾM (PHÂN LOẠI KEY/NO KEY)
-- =========================================================
Tabs.Search:AddSection("🔍 Nhập tên game để tìm")

local GameDatabase = {
    {Name = "Doors (Luarmor)", IsKey = false, Keywords = "doors door seek floor 2", Url = "https://api.luarmor.net/files/v4/loaders/54d82324acf9fa4aa85f1dd9b842b09f.lua"},
    {Name = "Blox Fruits (Luarmor)", IsKey = true, Keywords = "blox fruit bf piece vip", Url = "https://api.luarmor.net/files/v3/loaders/2529a5f9dfddd5523ca4e22f21cceffa.lua"},
    {Name = "Blox Fruits (Beta)", IsKey = false, Keywords = "blox fruit bf beta farm", Url = "https://raw.githubusercontent.com/Anniecreate86/BloxFruits/refs/heads/main/BetaHub-BF"},
    {Name = "Blade Ball (Argon)", IsKey = false, Keywords = "blade ball parry", Url = "http://astrx.cc/ArgonHubX.lua"},
    {Name = "Murder Mystery 2 (Renard)", IsKey = false, Keywords = "mm2 murder mystery 2", Url = "https://raw.githubusercontent.com/renardofficiel/game/refs/heads/main/loader.lua"},
    {Name = "King Legacy (Zee)", IsKey = false, Keywords = "king legacy piece", Url = "https://zuwz.me/Ls-Zee-Hub-KL"},
    {Name = "Emergency Hamburg (Atlas)", IsKey = false, Keywords = "emergency hamburg atlas auto rob", Url = "https://raw.githubusercontent.com/not4tlas/atlas/refs/heads/main/AutoRob.lua"},
    {Name = "Midnight Chasers (Iceware)", IsKey = true, Keywords = "midnight chasers ice", Url = "https://raw.githubusercontent.com/Iceware-RBLX/Roblox/refs/heads/main/loader.lua"},
    {Name = "Bee Swarm (Atlas)", IsKey = false, Keywords = "bee swarm bss", Url = "https://raw.githubusercontent.com/Chris12089/atlasbss/main/script.lua"},
    {Name = "Jailbreak (Auto Rob)", IsKey = true, Keywords = "jailbreak rob", Url = "https://scripts.projectauto.xyz/AutoRobV6"},
    {Name = "Escape Tsunami (Luminon)", IsKey = true, Keywords = "escape tsunami", Url = "http://luminon.top/loader.lua"},
    {Name = "99 Nights", IsKey = false, Keywords = "99 nights night", Url = "https://api.jnkie.com/api/v1/luascripts/public/4be96abffb614245d1e3a9f7051e9d94abed95f49cf135ad8e1ce2d80fff20b1/download"},
}

local ResultDropdown = nil
local CurrentScriptUrl = ""

Tabs.Search:AddInput("SearchBox", {
    Title = "Từ khóa",
    Default = "",
    Placeholder = "VD: blox, mid, doo...",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        if not ResultDropdown then return end

        local InputText = string.lower(Value)
        local FoundList = {}
        
        CurrentScriptUrl = ""

        if InputText == "" then
            ResultDropdown:SetValues({"Hãy nhập tên game..."})
            ResultDropdown:SetValue("Hãy nhập tên game...")
            return
        end

        for _, data in ipairs(GameDatabase) do
            if string.find(string.lower(data.Name), InputText) or string.find(data.Keywords, InputText) then
                local Prefix = data.IsKey and "🔴 [KEY] " or "🟢 [FREE] "
                table.insert(FoundList, Prefix .. data.Name)
            end
        end

        if #FoundList > 0 then
            ResultDropdown:SetValues(FoundList)
            ResultDropdown:SetValue(FoundList[1]) 
        else
            ResultDropdown:SetValues({"Không tìm thấy!"})
            ResultDropdown:SetValue("Không tìm thấy!")
        end
    end
})

ResultDropdown = Tabs.Search:AddDropdown("ResultList", {
    Title = "👇 Kết quả (Màu Xanh = No Key)",
    Values = {"Hãy nhập tên game..."},
    Multi = false,
    Default = 1,
    Callback = function(Value)
        for _, data in ipairs(GameDatabase) do
            local CheckName = (data.IsKey and "🔴 [KEY] " or "🟢 [FREE] ") .. data.Name
            if CheckName == Value then
                CurrentScriptUrl = data.Url
                break
            end
        end
    end
})

Tabs.Search:AddButton({
    Title = "▶️ CHẠY SCRIPT NÀY",
    Callback = function()
        if CurrentScriptUrl ~= "" then
            Window:Minimize()
            Fluent:Notify({Title = "Đang tải...", Content = "Script đang được kích hoạt!", Duration = 5})
            pcall(function() loadstring(game:HttpGet(CurrentScriptUrl))() end)
        else
            Fluent:Notify({Title = "Lỗi", Content = "Vui lòng chọn script hợp lệ!", Duration = 3})
        end
    end
})

Tabs.Search:AddParagraph({
    Title = "Chú thích",
    Content = "🟢 [FREE]: Script miễn phí, không cần Key.\n🔴 [KEY]: Script VIP, cần lấy Key để dùng."
})

-- =========================================================
-- [TAB 2] FULL UPDATE LOG
-- =========================================================
Tabs.Updates:AddSection("🔥 Phiên bản hiện tại: v4.2")
Tabs.Updates:AddParagraph({
    Title = "Cập nhật gần nhất",
    Content = "- REORDER: Sắp xếp game theo độ phổ biến.\n- ADDED: Thêm script Auto Rob cho Emergency Hamburg.\n- UPGRADED: Nâng cấp Anti-Cheat (Chặn Kick, Bypass Speed, Anti-Log chạy ngầm)."
})

Tabs.Updates:AddSection("📜 Lịch sử các phiên bản trước")
Tabs.Updates:AddParagraph({ Title = "v3.8", Content = "Phân loại Key/Free." })
Tabs.Updates:AddParagraph({ Title = "v3.6", Content = "Tìm kiếm tự động." })
Tabs.Updates:AddParagraph({ Title = "v1.0 - v3.3", Content = "Phát hành Hub, Mobile Toggle, Midnight Chasers." })

-- =========================================================
-- [TAB 3] BLOX FRUITS (TOP 1)
-- =========================================================
Tabs.BloxFruit:AddSection("Script VIP (Có Key)")
Tabs.BloxFruit:AddButton({
    Title = "⚡ Luarmor Hub (VIP)",
    Description = "Farm siêu tốc, Sea Event",
    Callback = function() Window:Minimize(); loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/2529a5f9dfddd5523ca4e22f21cceffa.lua"))() end
})

Tabs.BloxFruit:AddSection("Script Free (No Key)")
Tabs.BloxFruit:AddButton({
    Title = "🍉 Beta Hub (No Key)",
    Description = "Farm Level, Raid, Quest",
    Callback = function() Window:Minimize(); loadstring(game:HttpGet("https://raw.githubusercontent.com/Anniecreate86/BloxFruits/refs/heads/main/BetaHub-BF"))() end
})

-- =========================================================
-- [TAB 4] DOORS (TOP 2)
-- =========================================================
Tabs.Doors:AddSection("Script Free (No Key)")
Tabs.Doors:AddButton({
    Title = "👁️ Luarmor Doors (No Key)",
    Description = "Bypass cực mạnh | Miễn phí",
    Callback = function() 
        Window:Minimize()
        loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/54d82324acf9fa4aa85f1dd9b842b09f.lua"))() 
    end
})

-- =========================================================
-- [TAB 5] MURDER MYSTERY 2 (TOP 3)
-- =========================================================
Tabs.MM2:AddSection("Script Free (No Key)")
Tabs.MM2:AddButton({
    Title = "🔪 Renard Hub (No Key)",
    Description = "ESP Player, Silent Aim, Gun ESP",
    Callback = function() Window:Minimize(); loadstring(game:HttpGet('https://raw.githubusercontent.com/renardofficiel/game/refs/heads/main/loader.lua', true))() end
})

-- =========================================================
-- [TAB 6] BLADE BALL (TOP 4)
-- =========================================================
Tabs.BladeBall:AddSection("Script Free (No Key)")
Tabs.BladeBall:AddButton({
    Title = "⚔️ Argon Hub X (No Key)",
    Description = "Auto Parry tốt nhất hiện nay",
    Callback = function() Window:Minimize(); loadstring(game:HttpGet('http://astrx.cc/ArgonHubX.lua'))() end
})

-- =========================================================
-- [TAB 7] KING LEGACY (TOP 5)
-- =========================================================
Tabs.King:AddSection("Script Free (No Key)")
Tabs.King:AddButton({
    Title = "👑 Zee Hub (No Key)",
    Description = "Auto Farm, Raid, Sea King",
    Callback = function() Window:Minimize(); loadstring(game:HttpGet('https://zuwz.me/Ls-Zee-Hub-KL'))() end
})

-- =========================================================
-- [TAB 8] BEE SWARM SIMULATOR (TOP 6)
-- =========================================================
Tabs.BSS:AddSection("Script Free (No Key)")
Tabs.BSS:AddButton({
    Title = "🐝 Atlas BSS (No Key)",
    Description = "Auto Farm Mật, Phấn hoa",
    Callback = function() Window:Minimize(); loadstring(game:HttpGet("https://raw.githubusercontent.com/Chris12089/atlasbss/main/script.lua"))() end
})

-- =========================================================
-- [TAB 9] JAILBREAK (TOP 7)
-- =========================================================
Tabs.Jailbreak:AddSection("Script VIP (Có Key)")
Tabs.Jailbreak:AddButton({
    Title = "💰 Auto Rob V6 (VIP)",
    Description = "Tự động cướp tiền",
    Callback = function() Window:Minimize(); loadstring(game:HttpGet('https://scripts.projectauto.xyz/AutoRobV6'))() end
})
Tabs.Jailbreak:AddButton({
    Title = "👮 Auto Arrest V4 (VIP)",
    Description = "Tự động bắt tội phạm",
    Callback = function() Window:Minimize(); loadstring(game:HttpGet('https://scripts.projectauto.xyz/AutoArrestV4'))() end
})

-- =========================================================
-- [TAB 10] EMERGENCY HAMBURG (GAME KHÁC)
-- =========================================================
Tabs.Hamburg:AddSection("Script Free (No Key)")
Tabs.Hamburg:AddButton({
    Title = "🚓 Atlas Auto Rob (No Key)",
    Description = "Tự động cướp, farm tiền nhanh",
    Callback = function() 
        Window:Minimize() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/not4tlas/atlas/refs/heads/main/AutoRob.lua"))() 
    end
})

-- =========================================================
-- [TAB 11] MIDNIGHT CHASERS (GAME KHÁC)
-- =========================================================
Tabs.Midnight:AddSection("Script VIP (Có Key)")
Tabs.Midnight:AddButton({
    Title = "👻 Iceware Hub (VIP)",
    Description = "Script bá đạo nhất | Full chức năng VIP",
    Callback = function() 
        Window:Minimize()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Iceware-RBLX/Roblox/refs/heads/main/loader.lua",true))() 
    end
})

-- =========================================================
-- [TAB 12] ESCAPE TSUNAMI (GAME KHÁC)
-- =========================================================
Tabs.Main:AddSection("Script VIP (Có Key)")
Tabs.Main:AddButton({
    Title = "🌟 Luminon Hub (VIP)",
    Description = "Auto Farm Coins & Survive",
    Callback = function() Window:Minimize(); task.spawn(function() loadstring(game:HttpGet("http://luminon.top/loader.lua"))() end) end
})

-- =========================================================
-- [TAB 13] 99 NIGHTS (GAME KHÁC)
-- =========================================================
Tabs.Nights:AddSection("Script Free (No Key)")
Tabs.Nights:AddButton({
    Title = "🌲 99 Nights Script (No Key)",
    Description = "Full Bright, ESP, Tools",
    Callback = function() Window:Minimize(); loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/4be96abffb614245d1e3a9f7051e9d94abed95f49cf135ad8e1ce2d80fff20b1/download"))() end
})

-- =========================================================
-- [TAB 14] TIỆN ÍCH
-- =========================================================
Tabs.Misc:AddSection("Cộng đồng")
Tabs.Misc:AddButton({
    Title = "👾 Copy Link Discord",
    Callback = function()
        setclipboard("https://discord.gg/t7QewgFFr6")
        Fluent:Notify({Title = "Thành công", Content = "Đã Copy link Discord!", Duration = 3})
    end
})

Tabs.Misc:AddSection("Hệ thống")
Tabs.Misc:AddButton({
    Title = "🚀 Giảm Lag (Smooth)",
    Description = "Xóa Texture để tăng FPS",
    Callback = function()
        task.spawn(function()
            for i,v in pairs(game.Workspace:GetDescendants()) do
                if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
                    v.Material = Enum.Material.Plastic; v.Reflectance = 0
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    v:Destroy()
                end
            end
        end)
        Fluent:Notify({Title = "Thành công", Content = "Đã tối ưu hóa đồ họa!", Duration = 3})
    end
})

-- 5. NÚT MOBILE
local UserInputService = game:GetService("UserInputService")
if UserInputService.TouchEnabled then
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TongHopMobileToggle"
    ScreenGui.Parent = game.CoreGui
    
    local ToggleBtn = Instance.new("ImageButton")
    local UICorner = Instance.new("UICorner")
    
    ToggleBtn.Parent = ScreenGui
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(155, 89, 182)
    ToggleBtn.Position = UDim2.new(0.9, -50, 0.5, 0)
    ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
    ToggleBtn.Image = "rbxassetid://10057361026"
    ToggleBtn.Draggable = true
    ToggleBtn.Active = true
    ToggleBtn.BackgroundTransparency = 0.2
    
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = ToggleBtn
    
    ToggleBtn.MouseButton1Click:Connect(function()
        local vim = game:GetService("VirtualInputManager")
        vim:SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
        task.wait()
        vim:SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
    end)
end

-- 6. SETTINGS & NOTIFY
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

task.spawn(function()
    task.wait(0.2) 
    if Fluent.Options.AccentColor then
        Fluent.Options.AccentColor:SetValue(Color3.fromRGB(155, 89, 182))
    end
    
    Fluent:Notify({
        Title = "Sang Hub v4.2",
        Content = "Hub đã tải | Anti-Cheat đang bảo vệ tài khoản của bạn!",
        Duration = 5
    })
end)
