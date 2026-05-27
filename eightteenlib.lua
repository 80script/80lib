local uiLib = {}

-- // Theme Colors //
local themes = {
    preset = {
        outline = Color3.fromRGB(32, 32, 38),
        inline = Color3.fromRGB(60, 55, 75),
        accent = Color3.fromRGB(155, 125, 175),
        high_contrast = Color3.fromRGB(41, 41, 55),
        low_contrast = Color3.fromRGB(35, 35, 47),
        text = Color3.fromRGB(180, 180, 180),
        text_outline = Color3.fromRGB(0, 0, 0),
        glow = Color3.fromRGB(155, 125, 175),
    },
}

local keys = {
    [Enum.KeyCode.LeftShift] = "LS", [Enum.KeyCode.RightShift] = "RS",
    [Enum.KeyCode.LeftControl] = "LC", [Enum.KeyCode.RightControl] = "RC",
    [Enum.KeyCode.Insert] = "INS", [Enum.KeyCode.Backspace] = "BS",
    [Enum.KeyCode.Return] = "Ent", [Enum.KeyCode.Space] = "SPC",
    [Enum.KeyCode.Escape] = "ESC", [Enum.UserInputType.MouseButton1] = "MB1",
    [Enum.UserInputType.MouseButton2] = "MB2", [Enum.UserInputType.MouseButton3] = "MB3",
}

local function parentUI(gui)
    pcall(function()
        if gethui then gui.Parent = gethui()
        elseif syn and syn.protect_gui then syn.protect_gui(gui) gui.Parent = game:GetService("CoreGui")
        else gui.Parent = game:GetService("CoreGui") end
    end)
end

function uiLib:Window(config)
    config = config or {}
    local sgui = Instance.new("ScreenGui")
    parentUI(sgui)
    
    local main = Instance.new("Frame")
    main.Size = config.size or UDim2.new(0, 600, 0, 500)
    main.Position = config.position or UDim2.new(0.5, -300, 0.5, -250)
    main.BackgroundColor3 = themes.preset.outline
    main.BorderSizePixel = 0
    main.Parent = sgui
    
    -- draggable
    local drag = false, dragStart, startPos
    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    main.InputEnded:Connect(function() drag = false end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if drag and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    local inline = Instance.new("Frame")
    inline.Size = UDim2.new(1, -2, 1, -2)
    inline.Position = UDim2.new(0, 1, 0, 1)
    inline.BackgroundColor3 = themes.preset.inline
    inline.BorderSizePixel = 0
    inline.Parent = main
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, -2, 1, -2)
    bg.Position = UDim2.new(0, 1, 0, 1)
    bg.BackgroundColor3 = themes.preset.low_contrast
    bg.BorderSizePixel = 0
    bg.Parent = inline
    
    local title = Instance.new("TextLabel")
    title.Text = config.name or "Window"
    title.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
    title.TextSize = 14
    title.TextColor3 = themes.preset.text
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 5, 0, 5)
    title.Parent = bg
    
    local tabsBar = Instance.new("Frame")
    tabsBar.Size = UDim2.new(1, 0, 0, 25)
    tabsBar.Position = UDim2.new(0, 0, 0, 25)
    tabsBar.BackgroundTransparency = 1
    tabsBar.Parent = bg
    
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -10, 1, -40)
    content.Position = UDim2.new(0, 5, 0, 35)
    content.BackgroundTransparency = 1
    content.Parent = bg
    
    local self = {sgui = sgui, tabs = {}, currentTab = nil, content = content, tabsBar = tabsBar}
    
    function self:Tab(name)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 80, 1, -4)
        btn.Position = UDim2.new(0, 5 + (#self.tabs * 85), 0, 2)
        btn.Text = name
        btn.TextColor3 = themes.preset.text
        btn.BackgroundColor3 = themes.preset.inline
        btn.BorderSizePixel = 0
        btn.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
        btn.TextSize = 12
        btn.Parent = self.tabsBar
        
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.ScrollBarThickness = 4
        tabContent.Visible = false
        tabContent.Parent = self.content
        
        local list = Instance.new("UIListLayout")
        list.Padding = UDim.new(0, 5)
        list.Parent = tabContent
        
        local tab = {content = tabContent, button = btn, elements = {}}
        table.insert(self.tabs, tab)
        
        btn.MouseButton1Click:Connect(function()
            for _, t in ipairs(self.tabs) do
                t.content.Visible = false
                t.button.BackgroundColor3 = themes.preset.inline
            end
            tabContent.Visible = true
            btn.BackgroundColor3 = themes.preset.accent
            self.currentTab = tab
        end)
        
        if #self.tabs == 1 then btn.MouseButton1Click:Fire() end
        
        function tab:Section(name)
            local section = Instance.new("Frame")
            section.Size = UDim2.new(1, -10, 0, 0)
            section.BackgroundColor3 = themes.preset.outline
            section.BorderSizePixel = 0
            section.Parent = list
            
            local sectionInline = Instance.new("Frame")
            sectionInline.Size = UDim2.new(1, -2, 1, -2)
            sectionInline.Position = UDim2.new(0, 1, 0, 1)
            sectionInline.BackgroundColor3 = themes.preset.inline
            sectionInline.BorderSizePixel = 0
            sectionInline.Parent = section
            
            local sectionBg = Instance.new("Frame")
            sectionBg.Size = UDim2.new(1, -2, 1, -2)
            sectionBg.Position = UDim2.new(0, 1, 0, 1)
            sectionBg.BackgroundColor3 = themes.preset.low_contrast
            sectionBg.BorderSizePixel = 0
            sectionBg.Parent = sectionInline
            
            local titleLabel = Instance.new("TextLabel")
            titleLabel.Text = name or "Section"
            titleLabel.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
            titleLabel.TextSize = 12
            titleLabel.TextColor3 = themes.preset.text
            titleLabel.BackgroundTransparency = 1
            titleLabel.Position = UDim2.new(0, 5, 0, 3)
            titleLabel.Size = UDim2.new(1, -10, 0, 16)
            titleLabel.Parent = sectionBg
            
            local sectionList = Instance.new("UIListLayout")
            sectionList.Padding = UDim.new(0, 4)
            sectionList.Parent = sectionBg
            sectionList.VerticalAlignment = Enum.VerticalAlignment.Top
            
            local sectionContent = Instance.new("Frame")
            sectionContent.Size = UDim2.new(1, 0, 0, 0)
            sectionContent.BackgroundTransparency = 1
            sectionContent.Position = UDim2.new(0, 0, 0, 20)
            sectionContent.AutomaticSize = Enum.AutomaticSize.Y
            sectionContent.Parent = sectionBg
            
            local contentList = Instance.new("UIListLayout")
            contentList.Padding = UDim.new(0, 5)
            contentList.Parent = sectionContent
            
            local sectionObj = {holder = sectionContent, layout = contentList}
            
            function sectionObj:Toggle(config)
                config = config or {}
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, -10, 0, 25)
                frame.BackgroundTransparency = 1
                frame.Parent = contentList
                
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(0, 18, 0, 18)
                btn.Position = UDim2.new(0, 5, 0, 3)
                btn.BackgroundColor3 = themes.preset.outline
                btn.BorderSizePixel = 0
                btn.Text = ""
                btn.Parent = frame
                
                local check = Instance.new("Frame")
                check.Size = UDim2.new(1, -4, 1, -4)
                check.Position = UDim2.new(0, 2, 0, 2)
                check.BackgroundColor3 = themes.preset.accent
                check.BorderSizePixel = 0
                check.Parent = btn
                check.Visible = config.default or false
                
                local label = Instance.new("TextLabel")
                label.Text = config.name or "Toggle"
                label.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
                label.TextSize = 12
                label.TextColor3 = themes.preset.text
                label.BackgroundTransparency = 1
                label.Position = UDim2.new(0, 28, 0, 5)
                label.Size = UDim2.new(1, -40, 0, 16)
                label.Parent = frame
                
                local toggled = config.default or false
                local toggleObj = {}
                
                btn.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    check.Visible = toggled
                    if config.callback then config.callback(toggled) end
                end)
                
                return toggleObj
            end
            
            function sectionObj:Slider(config)
                config = config or {}
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, -10, 0, 40)
                frame.BackgroundTransparency = 1
                frame.Parent = contentList
                
                local label = Instance.new("TextLabel")
                label.Text = config.name or "Slider"
                label.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
                label.TextSize = 12
                label.TextColor3 = themes.preset.text
                label.BackgroundTransparency = 1
                label.Size = UDim2.new(1, 0, 0, 16)
                label.Parent = frame
                
                local bar = Instance.new("Frame")
                bar.Size = UDim2.new(1, -10, 0, 6)
                bar.Position = UDim2.new(0, 5, 0, 22)
                bar.BackgroundColor3 = themes.preset.outline
                bar.BorderSizePixel = 0
                bar.Parent = frame
                
                local fill = Instance.new("Frame")
                fill.Size = UDim2.new(0.5, 0, 1, 0)
                fill.BackgroundColor3 = themes.preset.accent
                fill.BorderSizePixel = 0
                fill.Parent = bar
                
                local valueLabel = Instance.new("TextLabel")
                valueLabel.Text = tostring(config.default or 0)
                valueLabel.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
                valueLabel.TextSize = 10
                valueLabel.TextColor3 = themes.preset.text
                valueLabel.BackgroundTransparency = 1
                valueLabel.Position = UDim2.new(1, -30, 0, 0)
                valueLabel.Size = UDim2.new(0, 25, 0, 16)
                valueLabel.Parent = frame
                
                local min = config.min or 0
                local max = config.max or 100
                local val = config.default or min
                
                local function update(pos)
                    local pct = math.clamp((pos.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                    val = min + (max - min) * pct
                    if config.interval then val = math.floor(val / config.interval) * config.interval end
                    fill.Size = UDim2.new(pct, 0, 1, 0)
                    valueLabel.Text = tostring(math.floor(val * 100) / 100)
                    if config.callback then config.callback(val) end
                end
                
                local dragging = false
                bar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        update(input.Position)
                    end
                end)
                bar.InputEnded:Connect(function() dragging = false end)
                game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        update(input.Position)
                    end
                end)
                
                return {setValue = function(v) update(UDim2.new((v - min)/(max - min), 0).X) end}
            end
            
            function sectionObj:Button(config)
                config = config or {}
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, -10, 0, 25)
                btn.Text = config.name or "Button"
                btn.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
                btn.TextSize = 12
                btn.TextColor3 = themes.preset.text
                btn.BackgroundColor3 = themes.preset.inline
                btn.BorderSizePixel = 0
                btn.Parent = contentList
                
                btn.MouseButton1Click:Connect(function()
                    if config.callback then config.callback() end
                end)
                
                return {}
            end
            
            function sectionObj:Dropdown(config)
                config = config or {}
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, -10, 0, 30)
                frame.BackgroundTransparency = 1
                frame.Parent = contentList
                
                local label = Instance.new("TextLabel")
                label.Text = config.name or "Dropdown"
                label.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
                label.TextSize = 12
                label.TextColor3 = themes.preset.text
                label.BackgroundTransparency = 1
                label.Size = UDim2.new(1, 0, 0, 16)
                label.Parent = frame
                
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, -10, 0, 20)
                btn.Position = UDim2.new(0, 5, 0, 18)
                btn.Text = config.default or "Select"
                btn.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
                btn.TextSize = 11
                btn.TextColor3 = themes.preset.text
                btn.BackgroundColor3 = themes.preset.outline
                btn.BorderSizePixel = 0
                btn.Parent = frame
                
                local dropdownFrame = Instance.new("Frame")
                dropdownFrame.Size = UDim2.new(1, -10, 0, 0)
                dropdownFrame.Position = UDim2.new(0, 5, 0, 38)
                dropdownFrame.BackgroundColor3 = themes.preset.outline
                dropdownFrame.BorderSizePixel = 0
                dropdownFrame.Visible = false
                dropdownFrame.AutomaticSize = Enum.AutomaticSize.Y
                dropdownFrame.Parent = frame
                
                local dropdownList = Instance.new("UIListLayout")
                dropdownList.Padding = UDim.new(0, 1)
                dropdownList.Parent = dropdownFrame
                
                local selected = config.default or config.items[1]
                
                for _, item in ipairs(config.items or {}) do
                    local itemBtn = Instance.new("TextButton")
                    itemBtn.Size = UDim2.new(1, -10, 0, 20)
                    itemBtn.Position = UDim2.new(0, 5, 0, 0)
                    itemBtn.Text = item
                    itemBtn.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
                    itemBtn.TextSize = 11
                    itemBtn.TextColor3 = themes.preset.text
                    itemBtn.BackgroundColor3 = themes.preset.inline
                    itemBtn.BorderSizePixel = 0
                    itemBtn.Parent = dropdownFrame
                    
                    itemBtn.MouseButton1Click:Connect(function()
                        selected = item
                        btn.Text = item
                        dropdownFrame.Visible = false
                        if config.callback then config.callback(item) end
                    end)
                end
                
                btn.MouseButton1Click:Connect(function()
                    dropdownFrame.Visible = not dropdownFrame.Visible
                end)
                
                return {setValue = function(v) btn.Text = v end}
            end
            
            function sectionObj:Keybind(config)
                config = config or {}
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, -10, 0, 30)
                frame.BackgroundTransparency = 1
                frame.Parent = contentList
                
                local label = Instance.new("TextLabel")
                label.Text = config.name or "Keybind"
                label.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
                label.TextSize = 12
                label.TextColor3 = themes.preset.text
                label.BackgroundTransparency = 1
                label.Size = UDim2.new(1, 0, 0, 16)
                label.Parent = frame
                
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(0, 60, 0, 20)
                btn.Position = UDim2.new(1, -65, 0, 18)
                btn.Text = keys[config.key] or "None"
                btn.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
                btn.TextSize = 11
                btn.TextColor3 = themes.preset.text
                btn.BackgroundColor3 = themes.preset.outline
                btn.BorderSizePixel = 0
                btn.Parent = frame
                
                local binding = false
                local currentKey = config.key
                
                btn.MouseButton1Click:Connect(function()
                    binding = true
                    btn.Text = "..."
                    local con
                    con = game:GetService("UserInputService").InputBegan:Connect(function(input)
                        if binding and input.UserInputType == Enum.UserInputType.Keyboard then
                            currentKey = input.KeyCode
                            btn.Text = keys[currentKey] or tostring(currentKey):gsub("Enum.KeyCode.", "")
                            binding = false
                            con:Disconnect()
                            if config.callback then config.callback(currentKey) end
                        end
                    end)
                end)
                
                return {setKey = function(k) currentKey = k; btn.Text = keys[k] or "None" end}
            end
            
            function sectionObj:Colorpicker(config)
                config = config or {}
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, -10, 0, 30)
                frame.BackgroundTransparency = 1
                frame.Parent = contentList
                
                local label = Instance.new("TextLabel")
                label.Text = config.name or "Color"
                label.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
                label.TextSize = 12
                label.TextColor3 = themes.preset.text
                label.BackgroundTransparency = 1
                label.Size = UDim2.new(1, 0, 0, 16)
                label.Parent = frame
                
                local colorBtn = Instance.new("Frame")
                colorBtn.Size = UDim2.new(0, 20, 0, 20)
                colorBtn.Position = UDim2.new(1, -25, 0, 18)
                colorBtn.BackgroundColor3 = config.default or Color3.fromRGB(255, 255, 255)
                colorBtn.BorderSizePixel = 1
                colorBtn.Parent = frame
                
                return {setColor = function(c) colorBtn.BackgroundColor3 = c end}
            end
            
            function sectionObj:Label(config)
                local lbl = Instance.new("TextLabel")
                lbl.Text = config.name or "Label"
                lbl.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
                lbl.TextSize = 11
                lbl.TextColor3 = themes.preset.text
                lbl.BackgroundTransparency = 1
                lbl.Size = UDim2.new(1, -10, 0, 16)
                lbl.Parent = contentList
                return {setText = function(t) lbl.Text = t end}
            end
            
            return sectionObj
        end
        
        return tab
    end
    
    function self:Close()
        self.sgui:Destroy()
    end
    
    return self
end

return uiLib
