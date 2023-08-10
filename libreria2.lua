--เปลี่ยน logo ได้ที่ บรรทัด 140
if game.CoreGui:FindFirstChild("UICopied") then
    game.CoreGui:FindFirstChild("UICopied"):Destroy()
end

function dragify(Frame)
dragToggle = nil
dragSpeed = .25 -- You can edit this.
dragInput = nil
dragStart = nil
dragPos = nil

function updateInput(input)
Delta = input.Position - dragStart
Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
game:GetService("TweenService"):Create(Frame, TweenInfo.new(.25), {Position = Position}):Play()
end

Frame.InputBegan:Connect(function(input)
if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
dragToggle = true
dragStart = input.Position
startPos = Frame.Position
input.Changed:Connect(function()
if (input.UserInputState == Enum.UserInputState.End) then
dragToggle = false
end
end)
end
end)

Frame.InputChanged:Connect(function(input)
if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
dragInput = input
end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
if (input == dragInput and dragToggle) then
updateInput(input)
end
end)
end

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local library = {}

function library:new(txt,desc)
local UICopied = Instance.new("ScreenGui")
local Background = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local TabList = Instance.new("Frame")
local UICorner_2 = Instance.new("UICorner")
local Banner = Instance.new("Frame")
local Text = Instance.new("TextLabel")
local Desc = Instance.new("TextLabel")
local Imagelogo = Instance.new("ImageButton")
local Tabl = Instance.new("ScrollingFrame")
local FrameAll = Instance.new("Folder")

UICopied.Name = "UICopied"
UICopied.Parent = game.CoreGui
UICopied.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Background.Name = "Background"
Background.Parent = UICopied
Background.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Background.Position = UDim2.new(0, 676, 0, 266)
Background.Size = UDim2.new(0, 567, 0, 310)
local toggledui = false
		UserInputService.InputBegan:Connect(function(input)
			pcall(function()
				if input.KeyCode == Enum.KeyCode.VControl then
					if toggledui == false then
						toggledui = true
						UICopied.Enabled = false
					else
						toggledui = false
						UICopied.Enabled = true
					end
				end
			end)
		end)
		
		
dragify(Background)

UICorner.Parent = Background

FrameAll.Name = "FrameAll"
FrameAll.Parent = Background

TabList.Name = "TabList"
TabList.Parent = Background
TabList.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TabList.Size = UDim2.new(0, 128, 0, 310)

UICorner_2.Parent = TabList

Banner.Name = "Banner"
Banner.Parent = TabList
Banner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Banner.BackgroundTransparency = 1.000
Banner.Position = UDim2.new(0, 0, 0, 7)
Banner.Size = UDim2.new(0, 128, 0, 56)

Text.Name = "Text"
Text.Parent = Banner
Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Text.BackgroundTransparency = 1.000
Text.Position = UDim2.new(0, 39, 0, 0)
Text.Size = UDim2.new(0, 78, 0, 26)
Text.Font = Enum.Font.SourceSansBold
Text.Text = txt
Text.TextColor3 = Color3.fromRGB(181, 16, 68)
Text.TextSize = 16.000
Text.TextXAlignment = Enum.TextXAlignment.Left

Desc.Name = "Desc"
Desc.Parent = Banner
Desc.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Desc.BackgroundTransparency = 1.000
Desc.Position = UDim2.new(0, 39, 0, 19)
Desc.Size = UDim2.new(0, 78, 0, 24)
Desc.Font = Enum.Font.SourceSansBold
Desc.Text = desc
Desc.TextColor3 = Color3.fromRGB(132, 132, 132)
Desc.TextSize = 13.000
Desc.TextWrapped = true
Desc.TextXAlignment = Enum.TextXAlignment.Left

Imagelogo.Name = "Imagelogo"
Imagelogo.Parent = Banner
Imagelogo.BackgroundTransparency = 1.000
Imagelogo.Position = UDim2.new(0, 8, 0, 9)
Imagelogo.Size = UDim2.new(0, 25, 0, 25)
Imagelogo.ZIndex = 2
Imagelogo.Image = "rbxassetid://8324568288" --เปลี่ยนรูป Logo ตรงนี้
Imagelogo.ImageRectOffset = Vector2.new(50, 800)
Imagelogo.ImageRectSize = Vector2.new(50, 50)

Tabl.Name = "Tabl"
Tabl.Parent = TabList
Tabl.Active = true
Tabl.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Tabl.BackgroundTransparency = 1.000
Tabl.Position = UDim2.new(0, 0, 0, 51)
Tabl.Size = UDim2.new(0, 128, 0, 259)
Tabl.CanvasSize = UDim2.new(0, 0, 0, 0)
Tabl.ScrollBarThickness = 0
Tabl.AutomaticCanvasSize = Enum.AutomaticSize.Y

local UIListLayout = Instance.new("UIListLayout")
local UIPadding_2 = Instance.new("UIPadding")

UIListLayout.Parent = Tabl
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 15)

UIPadding_2.Parent = Tabl
UIPadding_2.PaddingTop = UDim.new(0, 7)

    local Tab = {}
    
    function Tab:Tap(txt)
    local TabButton = Instance.new("TextButton")
    local UIPaddingqw = Instance.new("UIPadding")
    local FrameAlle = Instance.new("ScrollingFrame")
    local UIListLayout_2 = Instance.new("UIListLayout")
    local UIPadding_3 = Instance.new("UIPadding")
    
    TabButton.Name = "TabButton"
    TabButton.Parent = Tabl
    TabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.BackgroundTransparency = 1.000
    TabButton.Position = UDim2.new(0, 0, 0, 12)
    TabButton.Size = UDim2.new(0, 128, 0, 18)
    TabButton.Font = Enum.Font.SourceSansBold
    TabButton.Text = txt
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.TextSize = 16.000
    TabButton.TextWrapped = true
    TabButton.TextXAlignment = Enum.TextXAlignment.Left
    TabButton.TextTransparency = 0.5
    
    UIPaddingqw.Parent = TabButton
    UIPaddingqw.PaddingLeft = UDim.new(0, 15)
    
    FrameAlle.Name = "FrameAlle"
    FrameAlle.Parent = FrameAll
    FrameAlle.Active = true
    FrameAlle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    FrameAlle.BackgroundTransparency = 1.000
    FrameAlle.Position = UDim2.new(0.225749552, 0, 0, 0)
    FrameAlle.Size = UDim2.new(0, 439, 0, 310)
    FrameAlle.ScrollBarThickness = 6
    FrameAlle.Visible = false
    
    UIListLayout_2.Parent = FrameAlle
    UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout_2.Padding = UDim.new(0, 3)
    
    UIPadding_3.Parent = FrameAlle
    UIPadding_3.PaddingTop = UDim.new(0, 10)
    TabButton.MouseButton1Click:Connect(function()
        for i,v in pairs(Tabl:GetChildren()) do
           if v:IsA"TextButton" then
               v.TextTransparency = 0.5
           end
        end
        TabButton.TextTransparency = 0
        for i,v in pairs(FrameAll:GetChildren()) do
            if v:IsA"ScrollingFrame" then
                v.Visible = false
            end
        end
        FrameAlle.Visible = true
    end)
    
    local all = {}

    function all:Button(txt,callback)
    local Button = Instance.new("Frame")
    local ButtonFrame = Instance.new("Frame")
    local UICorner_3 = Instance.new("UICorner")
    local Buttontap = Instance.new("TextButton")
    local UICorner_4 = Instance.new("UICorner")
    Button.Name = "Button"
    Button.Parent = FrameAlle
    Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Button.BackgroundTransparency = 1.000
    Button.Size = UDim2.new(0, 432, 0, 32)
    
    ButtonFrame.Name = "ButtonFrame"
    ButtonFrame.Parent = Button
    ButtonFrame.BackgroundColor3 = Color3.fromRGB(153, 27, 69)
    ButtonFrame.Position = UDim2.new(0, 81, 0, 6)
    ButtonFrame.Size = UDim2.new(0, 251, 0, 25)
    
    UICorner_3.CornerRadius = UDim.new(0, 5)
    UICorner_3.Parent = ButtonFrame
    
    Buttontap.Name = "Buttontap"
    Buttontap.Parent = ButtonFrame
    Buttontap.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Buttontap.Position = UDim2.new(0, 2, 0, 1)
    Buttontap.Size = UDim2.new(0, 246, 0, 22)
    Buttontap.Font = Enum.Font.SourceSansBold
    Buttontap.TextColor3 = Color3.fromRGB(156, 18, 62)
    Buttontap.TextSize = 15.000
    Buttontap.Text = txt
    
    UICorner_4.CornerRadius = UDim.new(0, 5)
    UICorner_4.Parent = Buttontap
    
    Buttontap.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
    end

    function all:Label(txt)
    local Label = Instance.new("Frame")
    local LabelText = Instance.new("TextLabel")
    Label.Name = txt
    Label.Parent = FrameAlle
    Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Label.BackgroundTransparency = 1.000
    Label.Position = UDim2.new(0, 0, 0.13333334, 0)
    Label.Size = UDim2.new(0, 432, 0, 26)
    
    LabelText.Name = "LabelText"
    LabelText.Parent = Label
    LabelText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    LabelText.BackgroundTransparency = 1.000
    LabelText.Position = UDim2.new(0.194444448, 0, 0.15625, 0)
    LabelText.Size = UDim2.new(0, 247, 0, 26)
    LabelText.Font = Enum.Font.SourceSansBold
    LabelText.TextColor3 = Color3.fromRGB(153, 27, 69)
    LabelText.TextSize = 15.000
    end
    
    function all:Toggle(txt,bol,togglecallback)
        local Toggle = Instance.new("Frame")
        local ToggleFrame = Instance.new("Frame")
        local UICorner = Instance.new("UICorner")
        local check = Instance.new("ImageButton")
        local UICorner_2 = Instance.new("UICorner")
        local ToggleText = Instance.new("TextLabel")
        
        Toggle.Name = "Toggle"
        Toggle.Parent = FrameAlle
        Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Toggle.BackgroundTransparency = 1.000
        Toggle.Size = UDim2.new(0, 432, 0, 32)
        
        ToggleFrame.Name = "ToggleFrame"
        ToggleFrame.Parent = Toggle
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(153, 27, 69)
        ToggleFrame.Position = UDim2.new(0, 46, 0, 2)
        ToggleFrame.Size = UDim2.new(0, 27, 0, 26)
        
        UICorner.Parent = ToggleFrame
        
        check.Name = "check"
        check.Parent = ToggleFrame
        check.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        check.LayoutOrder = 1
        check.Position = UDim2.new(0, 1, 0, 1)
        check.Size = UDim2.new(0, 25, 0, 24)
        check.ZIndex = 2
        check.Image = "rbxassetid://3926305904"
        check.ImageColor3 = Color3.fromRGB(120, 20, 52)
        check.ImageRectOffset = Vector2.new(312, 4)
        check.ImageRectSize = Vector2.new(24, 24)
        check.ImageTransparency = 1
        
        UICorner_2.Parent = check
        
        
        ToggleText.Name = "ToggleText"
        ToggleText.Parent = ToggleFrame
        ToggleText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ToggleText.BackgroundTransparency = 1.000
        ToggleText.Position = UDim2.new(1.33333337, 0, 0, 0)
        ToggleText.Size = UDim2.new(0, 344, 0, 26)
        ToggleText.Font = Enum.Font.SourceSansBold
        ToggleText.Text = txt
        ToggleText.TextColor3 = Color3.fromRGB(153, 27, 69)
        ToggleText.TextSize = 16.000
        ToggleText.TextXAlignment = Enum.TextXAlignment.Left
        check.MouseButton1Click:Connect(function()
            if toggled then
                 TweenService:Create(check, TweenInfo.new(0.12, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {ImageTransparency = 1}):Play()
                 toggled = false
                togglecallback(toggled)
                else
               TweenService:Create(check, TweenInfo.new(0.12, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {ImageTransparency = 0}):Play()
                 toggled = true
                togglecallback(toggled)
            end
        end)
    end
    function all:Line()
        local Line = Instance.new("Frame")
        local LineE = Instance.new("Frame")
        
        Line.Name = "Line"
        Line.Parent = FrameAlle
        Line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Line.BackgroundTransparency = 1.000
        Line.Size = UDim2.new(0, 432, 0, 32)
        
        LineE.Name = "LineE"
        LineE.Parent = Line
        LineE.BackgroundColor3 = Color3.fromRGB(153, 27, 69)
        LineE.Position = UDim2.new(0.0370370373, 0, 0.375, 0)
        LineE.Size = UDim2.new(0, 408, 0, 3)
    end
    function all:Dropdown(txte,list,dropdowncallback)
        local Dropdown = Instance.new("Frame")
        local DropdownFrame = Instance.new("Frame")
        local UICorner = Instance.new("UICorner")
        local DropdownText = Instance.new("TextLabel")
        local click = Instance.new("ImageButton")
        
        Dropdown.Name = "Dropdown"
        Dropdown.Parent = FrameAlle
        Dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Dropdown.BackgroundTransparency = 1.000
        Dropdown.Size = UDim2.new(0, 432, 0, 32)
        Dropdown.AutomaticSize = Enum.AutomaticSize.Y
        DropdownFrame.Name = "DropdownFrame"
        DropdownFrame.Parent = Dropdown
        DropdownFrame.BackgroundColor3 = Color3.fromRGB(153, 27, 69)
        DropdownFrame.Position = UDim2.new(0.0717592612, 0, 0.15625, 0)
        DropdownFrame.Size = UDim2.new(0, 361, 0, 23)
        
        UICorner.Parent = DropdownFrame
        
        DropdownText.Name = "DropdownText"
        DropdownText.Parent = DropdownFrame
        DropdownText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        DropdownText.BackgroundTransparency = 1.000
        DropdownText.Position = UDim2.new(0.0664819926, 0, 0, 0)
        DropdownText.Size = UDim2.new(0, 306, 0, 22)
        DropdownText.Font = Enum.Font.SourceSansBold
        DropdownText.Text = txte
        DropdownText.TextColor3 = Color3.fromRGB(255, 255, 255)
        DropdownText.TextSize = 16.000
        DropdownText.TextXAlignment = Enum.TextXAlignment.Left
        
        click.Name = "click"
        click.Parent = DropdownFrame
        click.BackgroundTransparency = 1.000
        click.LayoutOrder = 11
        click.Position = UDim2.new(0.89612186, 0, -0.0217391308, 0)
        click.Rotation = 90.000
        click.Size = UDim2.new(0, 25, 0, 25)
        click.ZIndex = 2
        click.Image = "rbxassetid://3926305904"
        click.ImageRectOffset = Vector2.new(564, 284)
        click.ImageRectSize = Vector2.new(36, 36)
        
       local DropdownList = Instance.new("Frame")
        local UICorner = Instance.new("UICorner")
        local TabButton = Instance.new("TextButton")
        local UIListLayout = Instance.new("UIListLayout")
        local UIPaddingee = Instance.new("UIPadding")

        DropdownList.Name = "DropdownList"
        DropdownList.Parent = FrameAlle
        DropdownList.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
        DropdownList.BackgroundTransparency = 1.000
        DropdownList.Position = UDim2.new(0, 0, 0, 182)
        DropdownList.Size = UDim2.new(0, 433, 0, 35)
        DropdownList.Visible = false
        DropdownList.AutomaticSize = Enum.AutomaticSize.Y
        
        UICorner.CornerRadius = UDim.new(0, 3)
        UICorner.Parent = DropdownList
        
        
        UIListLayout.Parent = DropdownList
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Padding = UDim.new(0, 4)
        
        UIPaddingee.Parent = DropdownList
        UIPaddingee.PaddingBottom = UDim.new(0, 10)
        UIPaddingee.PaddingLeft = UDim.new(0, 40)
        UIPaddingee.PaddingTop = UDim.new(0, 10)
        
        click.MouseButton1Click:Connect(function()
            if DropdownList.Visible == false then
                DropdownList.Visible = true
             click.Rotation = 360
            else
            DropdownList.Visible = false
            click.Rotation = 90
            end
        end)
    
        local dropdown = {}
        function dropdown:Add(txt)
            for i,v in next, txt do
                local TabButton = Instance.new("TextButton")
                 local UICorner_2 = Instance.new("UICorner")
        TabButton.Name = "TabButton"
        TabButton.Parent = DropdownList
        TabButton.BackgroundColor3 = Color3.fromRGB(186, 32, 84)
        TabButton.Position = UDim2.new(0.0920096859, 0, 0, 0)
        TabButton.Size = UDim2.new(0, 343, 0, 24)
        TabButton.Font = Enum.Font.SourceSansBold
        TabButton.Text = v
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.TextSize = 15.000
        
        UICorner_2.CornerRadius = UDim.new(0, 5)
        UICorner_2.Parent = TabButton
        TabButton.MouseButton1Click:Connect(function()
            DropdownList.Visible = false
            click.Rotation = 90
            DropdownText.Text = txte.." : "..TabButton.Text
            dropdowncallback(TabButton.Text)
            end)
            end
        end
        
        dropdown:Add(list)
        
        return dropdown
    end
    function all:TextBox(txt,callback)
        local TextBox = Instance.new("Frame")
        local TextBoxF = Instance.new("Frame")
        local UICorner = Instance.new("UICorner")
        local TextBox_2 = Instance.new("TextBox")
        local UICorner_2 = Instance.new("UICorner")
        
        --Properties:
        
        TextBox.Name = "TextBox"
        TextBox.Parent = FrameAlle
        TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TextBox.BackgroundTransparency = 1.000
        TextBox.Size = UDim2.new(0, 432, 0, 32)
        
        TextBoxF.Name = "TextBoxF"
        TextBoxF.Parent = TextBox
        TextBoxF.BackgroundColor3 = Color3.fromRGB(153, 27, 69)
        TextBoxF.Position = UDim2.new(0, 81, 0, 6)
        TextBoxF.Size = UDim2.new(0, 251, 0, 25)
        
        UICorner.CornerRadius = UDim.new(0, 5)
        UICorner.Parent = TextBoxF
        
        TextBox_2.Parent = TextBoxF
        TextBox_2.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        TextBox_2.Position = UDim2.new(0, 2, 0, 1)
        TextBox_2.Size = UDim2.new(0, 246, 0, 22)
        TextBox_2.Font = Enum.Font.SourceSansBold
        TextBox_2.TextColor3 = Color3.fromRGB(116, 20, 51)
        TextBox_2.TextSize = 14.000
        TextBox_2.Text = txt
        
        UICorner_2.CornerRadius = UDim.new(0, 5)
        UICorner_2.Parent = TextBox_2
        
        TextBox_2.FocusLost:Connect(function()
            if #TextBox_2.Text > 0 then
                pcall(callback,TextBox_2.Text)
                else
               TextBox_2.Text = txt     
            end
        end)
    end
    
function all:Slider(txt,minvalue,maxvalue,default,callback)
	-----Values-----
	minvalue = minvalue or 0
	maxvalue = maxvalue or 100


	-----Callback-----
	callback = callback or function() end


	-----Variables-----
	local mouse = game.Players.LocalPlayer:GetMouse()
	local uis = game:GetService("UserInputService")
	local Value;

local Slider = Instance.new("Frame")
local TextSlider = Instance.new("TextLabel")
local BoxFrmae = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local SliderBox = Instance.new("TextBox")
local UICorner_2 = Instance.new("UICorner")
local rotation = Instance.new("ImageButton")
local remove = Instance.new("ImageButton")
local add = Instance.new("ImageButton")
local sliderz = Instance.new("TextButton")
local UICorner_3 = Instance.new("UICorner")
local SliderInner = Instance.new("Frame")
local UICorner_4 = Instance.new("UICorner")

--Properties:

Slider.Name = "Slider"
Slider.Parent = FrameAlle
Slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Slider.BackgroundTransparency = 1.000
Slider.Position = UDim2.new(0, 0, 0.696666658, 0)
Slider.Size = UDim2.new(0, 432, 0, 37)

TextSlider.Name = "TextSlider"
TextSlider.Parent = Slider
TextSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextSlider.BackgroundTransparency = 1.000
TextSlider.Position = UDim2.new(0.0578703694, 0, 0.0625, 0)
TextSlider.Size = UDim2.new(0, 223, 0, 14)
TextSlider.Font = Enum.Font.SourceSansBold
TextSlider.Text = txt
TextSlider.TextColor3 = Color3.fromRGB(153, 27, 69)
TextSlider.TextSize = 14.000
TextSlider.TextXAlignment = Enum.TextXAlignment.Left

BoxFrmae.Name = "BoxFrmae"
BoxFrmae.Parent = Slider
BoxFrmae.BackgroundColor3 = Color3.fromRGB(153, 27, 69)
BoxFrmae.Position = UDim2.new(0, 28, 0, 22)
BoxFrmae.Size = UDim2.new(0, 22, 0, 12)

UICorner.CornerRadius = UDim.new(0, 2)
UICorner.Parent = BoxFrmae

SliderBox.Name = "SliderBox"
SliderBox.Parent = BoxFrmae
SliderBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SliderBox.Position = UDim2.new(0, 1, 0, 1)
SliderBox.Size = UDim2.new(0, 19, 0, 10)
SliderBox.Font = Enum.Font.SourceSansBold
SliderBox.Text = ""
SliderBox.TextColor3 = Color3.fromRGB(116, 20, 51)
SliderBox.TextScaled = true
SliderBox.TextSize = 14.000
SliderBox.TextWrapped = true

UICorner_2.CornerRadius = UDim.new(0, 2)
UICorner_2.Parent = SliderBox

rotation.Name = "rotation"
rotation.Parent = Slider
rotation.BackgroundTransparency = 1.000
rotation.LayoutOrder = 3
rotation.Position = UDim2.new(0.129629627, 0, 0.581081092, 0)
rotation.Size = UDim2.new(0, 12, 0, 12)
rotation.ZIndex = 2
rotation.Image = "rbxassetid://3926305904"
rotation.ImageColor3 = Color3.fromRGB(181, 32, 81)
rotation.ImageRectOffset = Vector2.new(244, 684)
rotation.ImageRectSize = Vector2.new(36, 36)

remove.Name = "remove"
remove.Parent = Slider
remove.BackgroundTransparency = 1.000
remove.LayoutOrder = 4
remove.Position = UDim2.new(0.164351851, 0, 0.5, 0)
remove.Size = UDim2.new(0, 15, 0, 17)
remove.ZIndex = 2
remove.Image = "rbxassetid://3926307971"
remove.ImageColor3 = Color3.fromRGB(153, 27, 69)
remove.ImageRectOffset = Vector2.new(884, 284)
remove.ImageRectSize = Vector2.new(36, 36)

add.Name = "add"
add.Parent = Slider
add.BackgroundTransparency = 1.000
add.LayoutOrder = 4
add.Position = UDim2.new(0.206018522, 0, 0.472972959, 0)
add.Size = UDim2.new(0, 19, 0, 19)
add.ZIndex = 2
add.Image = "rbxassetid://3926307971"
add.ImageColor3 = Color3.fromRGB(153, 27, 69)
add.ImageRectOffset = Vector2.new(324, 364)
add.ImageRectSize = Vector2.new(36, 36)

sliderz.Name = "sliderz"
sliderz.Parent = Slider
sliderz.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderz.BackgroundTransparency = 1.000
sliderz.Position = UDim2.new(0.268518507, 0, 0.702702701, 0)
sliderz.Size = UDim2.new(0, 296, 0, 6)
sliderz.Font = Enum.Font.SourceSans
sliderz.Text = ""
sliderz.TextColor3 = Color3.fromRGB(0, 0, 0)
sliderz.TextSize = 14.000

UICorner_3.Parent = sliderz

SliderInner.Name = "SliderInner"
SliderInner.Parent = sliderz
SliderInner.BackgroundColor3 = Color3.fromRGB(153, 27, 69)
SliderInner.Position = UDim2.new(0, 0, -0.400000006, 0)
SliderInner.Size = UDim2.new(0, 296, 0, 6)

UICorner_4.Parent = SliderInner
	-----Main Code-----

	sliderz.MouseButton1Down:Connect(function()
		Value = math.floor((((tonumber(maxvalue) - tonumber(minvalue)) / 296) *SliderInner.AbsoluteSize.X) + tonumber(minvalue)) or 0
		pcall(function()
			callback(Value)
		end)
		SliderInner.Size = UDim2.new(0, math.clamp(mouse.X - SliderInner.AbsolutePosition.X, 0, 296), 0, 6)
		moveconnection = mouse.Move:Connect(function()
			SliderBox.Text = Value
			Value = math.floor((((tonumber(maxvalue) - tonumber(minvalue)) / 296) * SliderInner.AbsoluteSize.X) + tonumber(minvalue))
			pcall(function()
				callback(Value)
			end)
			SliderInner.Size = UDim2.new(0, math.clamp(mouse.X - SliderInner.AbsolutePosition.X, 0, 296), 0, 6)
		end)
		releaseconnection = uis.InputEnded:Connect(function(Mouse)
			if Mouse.UserInputType == Enum.UserInputType.MouseButton1 then
				Value = math.floor((((tonumber(maxvalue) - tonumber(minvalue)) / 296) * SliderInner.AbsoluteSize.X) + tonumber(minvalue))
				pcall(function()
					callback(Value)
				end)
				SliderInner.Size = UDim2.new(0, math.clamp(mouse.X - SliderInner.AbsolutePosition.X, 0, 296), 0, 6)
				moveconnection:Disconnect()
				releaseconnection:Disconnect()
			end
		end)
	end)
	if default then
    SliderInner.Size = UDim2.new(default / maxvalue, 0, 0, 6)
    SliderBox.Text = default

    pcall(function()
        callback(default)
    end)
end
add.MouseButton1Click:Connect(function()
    Value = math.clamp(Value + 10, 0, maxvalue)
    SliderInner.Size = UDim2.new(Value / maxvalue, 0, 0, 6)
    SliderBox.Text = Value
    pcall(function()
        callback(Value)
    end)
end)

remove.MouseButton1Click:Connect(function()
    Value = math.clamp(Value - 10, minvalue, maxvalue)
    SliderInner.Size = UDim2.new(Value / maxvalue, 0, 0, 6)
    SliderBox.Text = Value
    pcall(function()
        callback(Value)
    end)
end)
rotation.MouseButton1Click:Connect(function()
    SliderInner.Size = UDim2.new(default / maxvalue, 0, 0, 6)
    SliderBox.Text = default
    pcall(function()
        callback(default)
    end)
end)
end
return all
end
return Tab
end
return library
