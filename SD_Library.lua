--[[
========================================================================
| SD INTERNAL - BIBLIOTECA (READY FOR GITHUB)                          |
========================================================================
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local SD_Lib = {}
local Internal = { 
    CurrentTab = nil,
    WindowVisible = true 
}

local function CreateInstance(cls, props)
    local inst = Instance.new(cls)
    for k, v in pairs(props) do
        if k ~= "Parent" then inst[k] = v end
    end
    if props.Parent then inst.Parent = props.Parent end
    return inst
end

local function ApplyDrag(dragFrame, moveFrame)
    local dragging, dragInput, dragStart, startPos
    dragFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = moveFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    dragFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            moveFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function SD_Lib:CreateMain(config)
    local panelTitle = (config and config.Title) or "SD"

    local ScreenGui = CreateInstance("ScreenGui", {
        Name = "SD_Internal_Screen",
        Parent = PlayerGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    if PlayerGui:FindFirstChild("SD_Internal_Screen") and PlayerGui:FindFirstChild("SD_Internal_Screen") ~= ScreenGui then
        PlayerGui:FindFirstChild("SD_Internal_Screen"):Destroy()
    end

    local MainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.fromOffset(520, 360),
        Visible = Internal.WindowVisible
    })
    CreateInstance("UICorner", { Parent = MainFrame, CornerRadius = UDim.new(0, 10) })

    local ToggleButton = CreateInstance("TextButton", {
        Name = "ToggleFloatingButton",
        Parent = ScreenGui,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 20, 0, 20),
        Size = UDim2.fromOffset(45, 45),
        Font = Enum.Font.GothamBold,
        Text = "S",
        TextColor3 = Color3.fromRGB(15, 15, 15),
        TextSize = 22,
        ZIndex = 10
    })
    CreateInstance("UICorner", { Parent = ToggleButton, CornerRadius = UDim.new(1, 0) })
    ApplyDrag(ToggleButton, ToggleButton)

    ToggleButton.MouseButton1Click:Connect(function()
        Internal.WindowVisible = not Internal.WindowVisible
        MainFrame.Visible = Internal.WindowVisible
    end)

    local Header = CreateInstance("Frame", {
        Name = "Header",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 55),
    })
    ApplyDrag(Header, MainFrame)

    local LogoIcon = CreateInstance("Frame", {
        Name = "LogoIcon",
        Parent = Header,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Position = UDim2.new(0, 15, 0, 12),
        Size = UDim2.fromOffset(30, 30),
    })
    CreateInstance("UICorner", { Parent = LogoIcon, CornerRadius = UDim.new(0, 6) })
    CreateInstance("TextLabel", {
        Parent = LogoIcon,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "s",
        TextColor3 = Color3.fromRGB(15, 15, 15),
        TextSize = 18,
    })

    CreateInstance("TextLabel", {
        Name = "MainTitle",
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 55, 0, 10),
        Size = UDim2.fromOffset(200, 18),
        Font = Enum.Font.GothamBold,
        Text = panelTitle,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    CreateInstance("TextLabel", {
        Name = "SubTitle",
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 55, 0, 26),
        Size = UDim2.fromOffset(100, 14),
        Font = Enum.Font.GothamBold,
        Text = "INTERNAL",
        TextColor3 = Color3.fromRGB(120, 120, 120),
        TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local RightDot = CreateInstance("Frame", {
        Name = "RightDot",
        Parent = Header,
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Position = UDim2.new(1, -20, 0, 27),
        Size = UDim2.fromOffset(6, 6),
    })
    CreateInstance("UICorner", { Parent = RightDot, CornerRadius = UDim.new(1, 0) })

    CreateInstance("Frame", {
        Name = "Separator",
        Parent = MainFrame,
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 55),
        Size = UDim2.new(1, 0, 0, 1),
    })

    local Container = CreateInstance("Frame", {
        Name = "Container",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 56),
        Size = UDim2.new(1, 0, 1, -56),
    })

    local TabBar = CreateInstance("Frame", {
        Name = "TabBar",
        Parent = Container,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 140, 1, 0),
    })
    local TabHolder = CreateInstance("Frame", {
        Name = "TabHolder",
        Parent = TabBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, -10)
    })
    CreateInstance("UIListLayout", { Parent = TabHolder, Padding = UDim.new(0, 4), FillDirection = Enum.FillDirection.Vertical })
    CreateInstance("UIPadding", { Parent = TabHolder, PaddingTop = UDim.new(0, 8), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12) })

    local ContentFrame = CreateInstance("ScrollingFrame", {
        Name = "ContentFrame",
        Parent = Container,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 140, 0, 0),
        Size = UDim2.new(1, -140, 1, 0),
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
    })
    CreateInstance("UIListLayout", { Parent = ContentFrame, Padding = UDim.new(0, 8), HorizontalAlignment = Enum.HorizontalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder })
    CreateInstance("UIPadding", { Parent = ContentFrame, PaddingTop = UDim.new(0, 10), PaddingRight = UDim.new(0, 15) })

    local interface = {}

    function interface:AddTab(name, activeByDefault)
        local TabButton = CreateInstance("TextButton", {
            Name = name .. "Btn",
            Parent = TabHolder,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 34),
            Font = Enum.Font.GothamBold,
            Text = name,
            TextColor3 = Color3.fromRGB(140, 140, 140),
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        CreateInstance("UICorner", { Parent = TabButton, CornerRadius = UDim.new(0, 6) })
        CreateInstance("UIPadding", { Parent = TabButton, PaddingLeft = UDim.new(0, 12) })

        local PageFrame = CreateInstance("Frame", {
            Name = name .. "Page",
            Parent = ContentFrame,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
        })
        local PageList = CreateInstance("UIListLayout", { Parent = PageFrame, Padding = UDim.new(0, 8), HorizontalAlignment = Enum.HorizontalAlignment.Center })

        local currentTabStruct = { Button = TabButton, Page = PageFrame }

        local function SwitchToThisTab()
            if Internal.CurrentTab then
                Internal.CurrentTab.Page.Visible = false
                Internal.CurrentTab.Button.BackgroundTransparency = 1
                Internal.CurrentTab.Button.TextColor3 = Color3.fromRGB(140, 140, 140)
            end
            PageFrame.Visible = true
            TabButton.BackgroundTransparency = 0
            TabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TabButton.TextColor3 = Color3.fromRGB(0, 0, 0)
            Internal.CurrentTab = currentTabStruct
            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 20)
        end

        TabButton.MouseButton1Click:Connect(SwitchToThisTab)

        if activeByDefault then
            task.defer(SwitchToThisTab)
        end

        local page = {}

        function page:AddToggle(title, default, callback)
            local state = default or false
            local Element = CreateInstance("Frame", {
                Parent = PageFrame,
                BackgroundColor3 = Color3.fromRGB(22, 22, 22),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 44),
            })
            CreateInstance("UICorner", { Parent = Element, CornerRadius = UDim.new(0, 6) })
            CreateInstance("TextLabel", {
                Parent = Element,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 0),
                Size = UDim2.new(1, -60, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = title,
                TextColor3 = Color3.fromRGB(180, 180, 180),
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            local Switch = CreateInstance("Frame", {
                Parent = Element,
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                Position = UDim2.new(1, -14, 0.5, 0),
                Size = UDim2.fromOffset(36, 18),
            })
            CreateInstance("UICorner", { Parent = Switch, CornerRadius = UDim.new(1, 0) })
            local Knob = CreateInstance("Frame", {
                Parent = Switch,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Position = UDim2.new(0, 2, 0, 2),
                Size = UDim2.fromOffset(14, 14),
            })
            CreateInstance("UICorner", { Parent = Knob, CornerRadius = UDim.new(1, 0) })

            local function update(newSt)
                state = newSt
                if state then
                    Switch.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Knob.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                    Knob.Position = UDim2.new(1, -16, 0, 2)
                else
                    Switch.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Knob.Position = UDim2.new(0, 2, 0, 2)
                end
                if callback then task.spawn(callback, state) end
            end
            CreateInstance("TextButton", { Parent = Element, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = "" }).MouseButton1Click:Connect(function()
                update(not state)
            end)
            update(state)
        end

        function page:AddSlider(title, min, max, default, suffix, callback)
            local Element = CreateInstance("Frame", {
                Parent = PageFrame,
                BackgroundColor3 = Color3.fromRGB(22, 22, 22),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 52),
            })
            CreateInstance("UICorner", { Parent = Element, CornerRadius = UDim.new(0, 6) })
            CreateInstance("TextLabel", {
                Parent = Element,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 6),
                Size = UDim2.new(1, -28, 0, 16),
                Font = Enum.Font.GothamMedium,
                Text = title,
                TextColor3 = Color3.fromRGB(180, 180, 180),
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            local ValLabel = CreateInstance("TextLabel", {
                Parent = Element,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 6),
                Size = UDim2.new(1, -28, 0, 16),
                Font = Enum.Font.GothamBold,
                Text = default .. " " .. suffix,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Right,
            })
            local Bar = CreateInstance("Frame", {
                Parent = Element,
                AnchorPoint = Vector2.new(0.5, 1),
                BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                BorderSizePixel = 0,
                Position = UDim2.new(0.5, 0, 1, -12),
                Size = UDim2.new(1, -28, 0, 4),
            })
            CreateInstance("UICorner", { Parent = Bar, CornerRadius = UDim.new(1, 0) })
            local Fill = CreateInstance("Frame", { Parent = Bar, BackgroundColor3 = Color3.fromRGB(255, 255, 255), Size = UDim2.new(0, 0, 1, 0) })
            CreateInstance("UICorner", { Parent = Fill, CornerRadius = UDim.new(1, 0) })
            local Knob = CreateInstance("Frame", { Parent = Bar, AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.fromRGB(255, 255, 255), Size = UDim2.fromOffset(10, 10) })
            CreateInstance("UICorner", { Parent = Knob, CornerRadius = UDim.new(1, 0) })

            local function updateSlider()
                local pct = math.clamp((UserInputService:GetMouseLocation().X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + ((max - min) * pct))
                Fill.Size = UDim2.new(pct, 0, 1, 0)
                Knob.Position = UDim2.new(pct, 0, 0.5, 0)
                ValLabel.Text = val .. " " .. suffix
                if callback then task.spawn(callback, val) end
            end

            local sliding = false
            CreateInstance("TextButton", { Parent = Bar, AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(1, 20, 0, 20), Text = "" }).MouseButton1Down:Connect(function()
                sliding = true
                updateSlider()
            end)
            UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end end)
            UserInputService.InputChanged:Connect(function(input) if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then updateSlider() end end)

            local initPct = (default - min) / (max - min)
            Fill.Size = UDim2.new(initPct, 0, 1, 0)
            Knob.Position = UDim2.new(initPct, 0, 0.5, 0)
        end

        return page
    end

    return interface
end

return SD_Lib
        function page:AddDropdown(title, list, callback)
            local Element = CreateInstance("Frame", {
                Parent = PageFrame,
                BackgroundColor3 = Color3.fromRGB(22, 22, 22),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 40),
                ClipsDescendants = true
            })
            CreateInstance("UICorner", { Parent = Element, CornerRadius = UDim.new(0, 6) })
            
            local TextLabel = CreateInstance("TextLabel", {
                Parent = Element,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 0),
                Size = UDim2.new(1, -40, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = title,
                TextColor3 = Color3.fromRGB(180, 180, 180),
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
            })

            -- Aqui você pode criar a lógica de clique para abrir a lista
            -- Para simplicidade agora, você pode apenas expandir o frame ou criar botões internos.
            -- Quer que eu monte a lógica completa de expansão para você?
        end

