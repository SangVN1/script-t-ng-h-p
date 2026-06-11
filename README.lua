-- Khởi tạo Giao diện (GUI) - Bản Tối Thượng V5 cho Delta
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local StatusLabel = Instance.new("TextLabel")
local ResultLabel = Instance.new("TextLabel")
local CopyButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "DeltaUltimateMusicV5"
ScreenGui.Parent = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 25)
MainFrame.Position = UDim2.new(0.1, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 300, 0, 170)
MainFrame.Active = true

local MainCorner = UICorner:Clone()
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(150, 0, 255) -- Màu tím tối thượng
Title.Size = UDim2.new(1, 0, 0, 38)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "🔮 ULTIMATE MUSIC SOLVER V5 🔮"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15

local TitleCorner = UICorner:Clone()
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 12, 0, 48)
StatusLabel.Size = UDim2.new(1, -24, 0, 20)
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.Text = "Trạng thái: Đang quét diện rộng..."
StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
StatusLabel.TextSize = 13
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

ResultLabel.Name = "ResultLabel"
ResultLabel.Parent = MainFrame
ResultLabel.BackgroundColor3 = Color3.fromRGB(10, 8, 15)
ResultLabel.Position = UDim2.new(0, 12, 0, 70)
ResultLabel.Size = UDim2.new(1, -24, 0, 50)
ResultLabel.Font = Enum.Font.SourceSansBold
ResultLabel.Text = "Đợi nhạc lên, tên sẽ tự xuất hiện!"
ResultLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ResultLabel.TextSize = 14
ResultLabel.TextWrapped = true

local ResultCorner = UICorner:Clone()
ResultCorner.CornerRadius = UDim.new(0, 6)
ResultCorner.Parent = ResultLabel

CopyButton.Name = "CopyButton"
CopyButton.Parent = MainFrame
CopyButton.BackgroundColor3 = Color3.fromRGB(255, 60, 100)
CopyButton.Position = UDim2.new(0, 12, 0, 128)
CopyButton.Size = UDim2.new(1, -24, 0, 35)
CopyButton.Font = Enum.Font.SourceSansBold
CopyButton.Text = "📋 CLICK ĐỂ COPY"
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.TextSize = 14

local BtnCorner = UICorner:Clone()
BtnCorner.Parent = CopyButton

---------------------------------------------------------
-- CODE KÉO THẢ TƯƠNG THÍCH MỌI THIẾT BỊ
---------------------------------------------------------
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)

---------------------------------------------------------
-- THUẬT TOÁN QUÉT TẤT CẢ DỊCH VỤ ẨN (ANTI-BYPASS)
---------------------------------------------------------
local MarketplaceService = game:GetService("MarketplaceService")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local lastSoundId = ""
local bai_hat_hien_tai = ""

local function check_va_lay_ten(soundObj)
    if not soundObj.SoundId or soundObj.SoundId == "" then return end
    
    local soundId = string.match(soundObj.SoundId, "%d+")
    if soundId and soundId ~= lastSoundId then
        lastSoundId = soundId
        StatusLabel.Text = "⚡ Đã bắt được ID: " .. soundId
        
        task.spawn(function()
            local success, assetInfo = pcall(function()
                return MarketplaceService:GetProductInfo(tonumber(soundId))
            end)
            
            if success and assetInfo then
                local cleanName = string.gsub(assetInfo.Name, "%[.-%]", "")
                cleanName = string.gsub(cleanName, "%(.-%)", "")
                cleanName = string.trim(cleanName)
                
                bai_hat_hien_tai = cleanName
                ResultLabel.Text = "🎵 " .. cleanName
                StatusLabel.Text = "✅ Tự động nhận diện thành công!"
            else
                ResultLabel.Text = "Bài ẩn/ID: " .. soundId
                bai_hat_hien_tai = soundId
                StatusLabel.Text = "⚠️ Không rõ chữ (Bấm Copy lấy ID)."
            end
        end)
    end
end

-- Vòng lặp quét diện rộng siêu tốc, không bỏ sót bất kỳ ngóc ngách nào
task.spawn(function()
    while true do
        task.wait(0.4) -- Quét liên tục sau mỗi 0.4 giây
        
        -- Khu vực 1: SoundService
        for _, v in pairs(SoundService:GetDescendants()) do
            if v:IsA("Sound") and v.IsPlaying then
                check_va_lay_ten(v)
            end
        end
        
        -- Khu vực 2: ReplicatedStorage (Nơi hay giấu Asset)
        for _, v in pairs(ReplicatedStorage:GetDescendants()) do
            if v:IsA("Sound") and v.IsPlaying then
                check_va_lay_ten(v)
            end
        end
        
        -- Khu vực 3: Workspace (Chia nhỏ để tránh lag Delta)
        local count = 0
        for _, v in pairs(Workspace:GetDescendants()) do
            count = count + 1
            if count % 150 == 0 then task.wait() end
            
            if v:IsA("Sound") and v.IsPlaying then
                check_va_lay_ten(v)
            end
        end
        
        -- Khu vực 4: PlayerGui (Nhạc chạy trực tiếp trên màn hình người chơi)
        local localPlayer = Players.LocalPlayer
        if localPlayer then
            local pGui = localPlayer:FindFirstChild("PlayerGui")
            if pGui then
                for _, v in pairs(pGui:GetDescendants()) do
                    if v:IsA("Sound") and v.IsPlaying then
                        check_va_lay_ten(v)
                    end
                end
            end
        end
    end
end)

-- Nút Copy
CopyButton.MouseButton1Click:Connect(function()
    if bai_hat_hien_tai ~= "" then
        if setclipboard then
            setclipboard(bai_hat_hien_tai)
            StatusLabel.Text = "📋 Đã copy thành công!"
        else
            StatusLabel.Text = "❌ Delta lỗi hàm setclipboard!"
        end
    else
        StatusLabel.Text = "❌ Chưa bắt được bài nào để copy!"
    end
end)
