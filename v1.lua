-- สร้าง GUI สำหรับ Dropdown
local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- สร้าง ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui

-- สร้างปุ่ม Toggle
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 200, 0, 50)
toggleButton.Position = UDim2.new(0, 20, 0, 20) -- ย้ายไปด้านซ้ายบน
toggleButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180) -- สีฟ้า
toggleButton.Text = "Open Dropdown"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextScaled = true
toggleButton.Parent = screenGui

-- เพิ่ม Corner Radius ให้ปุ่ม
local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 10) -- ความโค้ง 10 หน่วย
toggleCorner.Parent = toggleButton

-- สร้าง Dropdown Frame (เริ่มต้นซ่อนอยู่)
local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(0, 200, 0, 300)
dropdownFrame.Position = UDim2.new(0, 20, 0, 80) -- ใต้ปุ่ม Toggle
dropdownFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- สีเทาเข้ม
dropdownFrame.Visible = false
dropdownFrame.Parent = screenGui

-- เพิ่ม Corner Radius ให้ Dropdown Frame
local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 10)
frameCorner.Parent = dropdownFrame

-- สร้างปุ่มใน Dropdown
local waypoints = {
  {name = "Sit 1", position = Vector3.new(-12591.451171875, 335.9563903808594, -7544.7568359375)},
  {name = "Sit 2", position = Vector3.new(-12601.828125, 335.9563903808594, -7544.7568359375)},
  {name = "Sit 3", position = Vector3.new(-12591.451171875, 335.9563903808594, -7556.7568359375)},
  {name = "Sit 4", position = Vector3.new(-12601.828125, 335.9563903808594, -7556.7568359375)},
  {name = "Sit 5", position = Vector3.new(-12591.451171875, 335.9563903808594, -7568.7568359375)},
  {name = "Sit 6", position = Vector3.new(-12601.828125, 335.9563903808594, -7568.7568359375)},
}

-- สร้างปุ่มสำหรับจุดแต่ละจุดใน Dropdown
for i, point in ipairs(waypoints) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 40)
    button.Position = UDim2.new(0, 5, 0, 10 + (i - 1) * 50)
    button.BackgroundColor3 = Color3.fromRGB(100, 149, 237) -- สีฟ้าอ่อน
    button.Text = point.name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SourceSansBold
    button.TextScaled = true
    button.Parent = dropdownFrame

    -- เพิ่ม Corner Radius ให้ปุ่ม
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = button

    -- ผูกฟังก์ชัน Tweento กับปุ่ม
    button.MouseButton1Click:Connect(function()
      Tweento(point.position, 325) -- ไปยังจุดที่เลือกด้วยความเร็ว 400
        dropdownFrame.Visible = false -- ปิด Dropdown หลังจากเลือก
        toggleButton.Text = "Open Dropdown"
    end)
end

-- ฟังก์ชันเปิด/ปิด Dropdown
toggleButton.MouseButton1Click:Connect(function()
    dropdownFrame.Visible = not dropdownFrame.Visible
    toggleButton.Text = dropdownFrame.Visible and "Close Dropdown" or "Open Dropdown"
end)

-- ฟังก์ชัน Tweento (เวอร์ชันที่เคยปรับปรุง)
function Tweento(targetPos, speed)
    pcall(function()
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChild("Humanoid")

        if not (targetPos and humanoidRootPart and humanoid and humanoid.Health > 0) then
            warn("Invalid target or character not ready.")
            return
        end

        speed = speed or 325
        local distance = (targetPos - humanoidRootPart.Position).Magnitude
        local duration = distance / speed

        local tweenService = game:GetService("TweenService")
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
        local tween = tweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPos)})
        tween:Play()
        tween.Completed:Wait()
    end)
end
