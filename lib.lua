local lib = {}
local pages = {}
local sections = {}

local utility = {}

local players = game:GetService("Players")
local cre = game:GetService("RunService"):IsStudio() and players.LocalPlayer.PlayerGui or game:GetService("CoreGui") 
local UserInputService = game:GetService("UserInputService")
local isMobile = UserInputService.TouchEnabled

utility.mobilenumber = function(num)
	return isMobile and num/2.5 or num
end
utility.mobilesize = function(vec)
	return isMobile and vec/2.5 or vec
end
utility.mobilefontsize = function(num)
	return isMobile and num/2.4 or num
end
utility.round = function(n,d)
	return tonumber(string.format("%."..(d or 0).."f",n))
end
utility.find = function(t,s)
	for i,v in pairs(t) do
		if v == s then
			return i
		end
	end
	return
end
utility.from_hex = function(h)
	local r,g,b = string.match(h,"^#?(%w%w)(%w%w)(%w%w)$")
	return Color3.fromRGB(tonumber(r,16), tonumber(g,16), tonumber(b,16))
end
utility.fixtable = function(t)
	local tf = {}
	for i,v in pairs(t) do
		if v == true then
			table.insert(tf,i)
			continue
		end
		table.insert(tf,v)
	end
	return tf
end

lib.__index = lib
pages.__index = pages
sections.__index = sections

function lib:new(props)
	local color = props.color or Color3.new(1,0,0)
	local size = props.size or Vector2.new(716,520)
	local name = props.name or "new ui"
	local font = props.font or Enum.Font.Ubuntu
	local textsize = props.textsize or 14
	local icon = props.icon or ""
	
	size = utility.mobilesize(size)
	textsize = utility.mobilefontsize(textsize)
	
	local window = {["size"] = size,["key"] = Enum.KeyCode.RightShift}
	
	local screen = Instance.new("ScreenGui",cre)
	screen.Name = tostring(math.random(0,999999))..tostring(math.random(0,999999))
	screen.ResetOnSpawn = false
	screen.DisplayOrder = 100
	screen.ZIndexBehavior = Enum.ZIndexBehavior.Global

	UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == window.key then
			screen.Enabled = not screen.Enabled
		end
	end)
	
	local screennotification = Instance.new("ScreenGui",cre)
	screennotification.Name = tostring(math.random(0,999999))..tostring(math.random(0,999999))
	screennotification.ResetOnSpawn = false
	screennotification.DisplayOrder = 101
	screennotification.ZIndexBehavior = Enum.ZIndexBehavior.Global
	
	local notificationframe = Instance.new("Frame",screennotification)
	notificationframe.BackgroundTransparency = 1
	notificationframe.AnchorPoint = Vector2.new(1, 1)
	notificationframe.BorderSizePixel = 0
	notificationframe.Position = UDim2.new(1, 0, 1, 0)
	notificationframe.Size = UDim2.new(0, utility.mobilenumber(200), 0, 1)
	
	local UIListLayout = Instance.new("UIListLayout",notificationframe)
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	UIListLayout.Padding = UDim.new(6, 0)
	
	local outline = Instance.new("Frame",screen)
	outline.AnchorPoint = Vector2.new(0.5, 0.5)
	outline.BackgroundColor3 = color
	outline.BorderSizePixel = 0
	outline.Position = UDim2.new(0, screen.AbsoluteSize.X/2, 0, screen.AbsoluteSize.Y/2)
	outline.Size = UDim2.new(0,size.X,0,size.Y)
	
	local UICorner = Instance.new("UICorner",outline)
	local UIStroke = Instance.new("UIStroke",outline)
	
	UICorner.CornerRadius = UDim.new(0.02, 0)
	UIStroke.Transparency = 0.8
	UIStroke.Thickness = 2
	UIStroke.Color = color
	
	local title = Instance.new("Frame",outline)
	title.BackgroundTransparency = 1
	title.BorderSizePixel = 0
	title.Size = UDim2.new(1, 0, 0.132692307, 0)
	
	local dragging = false
	local dragStart
	local startPos

	title.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then

			dragging = true
			dragStart = input.Position
			startPos = outline.Position
		end
	end)

	title.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then

			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if not dragging then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then

			local delta = input.Position - dragStart

			outline.Position = UDim2.new(
				math.clamp(startPos.X.Scale,0,1),
				math.clamp(startPos.X.Offset + delta.X,outline.Size.X.Offset/2,screen.AbsoluteSize.X-(outline.Size.X.Offset/2)),
				math.clamp(startPos.Y.Scale,0,1),
				math.clamp(startPos.Y.Offset + delta.Y,outline.Size.Y.Offset/2,screen.AbsoluteSize.Y-(outline.Size.Y.Offset/2))
			)
		end
	end)
	
	local ImageLabel = Instance.new("ImageLabel",title)
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.BorderSizePixel = 0
	ImageLabel.Position = UDim2.new(0.0139664803, 0, 0.144927531, 0)
	ImageLabel.Size = UDim2.new(0.0684357509, 0, 0.710144937, 0)
	ImageLabel.Image = icon
	
	local TextLabel = Instance.new("TextLabel",title)
	TextLabel.BackgroundTransparency = 1
	TextLabel.BorderSizePixel = 0
	TextLabel.Position = UDim2.new(0.0963687152, 0, 0.144927531, 0)
	TextLabel.Size = UDim2.new(0.888268173, 0, 0.710144937, 0)
	TextLabel.Font = font
	TextLabel.Text = name
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.TextSize = textsize
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	
	local tabs = Instance.new("Frame",outline)
	local tabslist = Instance.new("ScrollingFrame",tabs)
	local UIListLayout = Instance.new("UIListLayout",tabslist)
	local UIPadding = Instance.new("UIPadding",tabslist)

	tabs.BackgroundTransparency = 1
	tabs.BorderSizePixel = 0
	tabs.Position = UDim2.new(0, 0, 0.132692307, 0)
	tabs.Size = UDim2.new(0.0963687152, 0, 0.867307663, 0)

	tabslist.Active = true
	tabslist.BackgroundTransparency = 1
	tabslist.BorderSizePixel = 0
	tabslist.Size = UDim2.new(1, 0, 1, 0)
	tabslist.AutomaticCanvasSize = Enum.AutomaticSize.Y
	tabslist.ScrollingDirection = Enum.ScrollingDirection.Y
	tabslist.CanvasSize = UDim2.new(0, 0, 0, 0)
	tabslist.ScrollBarThickness = 6
	
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.Padding = UDim.new(0.02, 0)
	UIPadding.PaddingTop = UDim.new(0.02, 0)
	
	local content = Instance.new("Frame",outline)
	content.BackgroundTransparency = 1
	content.BorderSizePixel = 0
	content.Position = UDim2.new(0.0963687152, 0, 0.132692277, 0)
	content.Size = UDim2.new(0.90363127, 0, 0.867307663, 0)
	
	local mobilescreen = nil
	if isMobile then
		mobilescreen = Instance.new("ScreenGui",cre)
		mobilescreen.Name = tostring(math.random(0,999999))..tostring(math.random(0,999999))
		mobilescreen.ResetOnSpawn = false
		mobilescreen.IgnoreGuiInset = true
		mobilescreen.DisplayOrder = 102
		mobilescreen.ZIndexBehavior = Enum.ZIndexBehavior.Global
		local ImageButton = Instance.new("ImageButton",mobilescreen)
		local UICorner = Instance.new("UICorner",ImageButton)
		local UIStroke = Instance.new("UIStroke",ImageButton)
		ImageButton.AnchorPoint = Vector2.new(0.5, 0)
		ImageButton.BackgroundColor3 = color
		ImageButton.BorderSizePixel = 0
		ImageButton.AutoButtonColor = false
		ImageButton.BackgroundTransparency = 0.2
		ImageButton.Position = UDim2.new(0.5, 0, 0, 5)
		ImageButton.Size = UDim2.new(0, 30, 0, 30)
		ImageButton.Image = icon
		UICorner.CornerRadius = UDim.new(0.075, 0)
		UIStroke.Transparency = 0.9
		UIStroke.Thickness = 2
		UIStroke.Color = color
		ImageButton.MouseButton1Click:Connect(function()
			if screen then
				screen.Enabled = not screen.Enabled
			end
		end)
	end
	
	window = {
		["screen"] = screen,
		["outline"] = outline,
		["tabs"] = tabslist,
		["mobilescreen"] = mobilescreen,
		["textsize"] = textsize,
		["color"] = color,
		["notifications"] = notificationframe,
		["content"] = content,
		["size"] = size,
		["key"] = Enum.KeyCode.RightShift,
		["name"] = name,
		["block"] = {},
		["font"] = font,
		["icon"] = icon,
		["tabslist"] = {}
	}
	
	setmetatable(window, lib)
	return window
end

function lib:setsize(size,ingrovemobile)
	ingrovemobile = ingrovemobile ~= nil and ingrovemobile or false
	local window = self
	if window and window.outline and size then
		local setsize = ingrovemobile and size or utility.mobilesize(size)
		window.size = setsize
		window.outline.Size = UDim2.new(0,setsize.X,0,setsize.Y)
	end
end
function lib:setfont(font)
	local window = self
	if window and window.screen and font then
		window.font = font
		for i,v in pairs(window.screen:GetDescendants()) do
			if v:IsA("TextLabel") then
				v.Font = font
			end
		end
	end
end
function lib:settextsize(num,ingrovemobile)
	ingrovemobile = ingrovemobile ~= nil and ingrovemobile or false
	local window = self
	local setsize = ingrovemobile and num or utility.mobilefontsize(num)
	if window and window.outline and num then
		window.textsize = setsize
		for i,v in pairs(window.outline:GetDescendants()) do
			if v:IsA("TextLabel") then
				v.TextSize = setsize
			end
		end
	end
end
function lib:settheme(color)
	local window = self
	if window and window.screen and color then
		window.color = color
		if window.mobilescreen then
			window.mobilescreen.ImageButton.BackgroundColor3 = color
			window.mobilescreen.ImageButton.UIStroke.Color = color
		end
		for _, v in pairs(window.screen:GetDescendants()) do
			if (v:IsA("Frame") or v:IsA("TextLabel") or v:IsA("TextButton")) and not window.block[v] then
				if v.BackgroundTransparency < 1 then
					v.BackgroundColor3 = color
				end
			end
			if v:IsA("UIStroke") and not window.block[v] then
				v.Color = color
			end
		end
	end
end
function lib:delete()
	local window = self
	if window and window.screen then
		window.screen:Destroy()
		if window.mobilescreen then
			window.mobilescreen:Destroy()
		end
	end
end
function lib:notification(props)
	props = props or {}
	local window = self
	local text = props.text or "Text"
	local timeout = props.time or 3
	--local side = props.side and props.side:lower() or "right"
	
	local Frame = Instance.new("Frame",window.notifications)
	local content = Instance.new("Frame",Frame)
	local TextLabel = Instance.new("TextLabel",content)
	local UICorner = Instance.new("UICorner",content)

	Frame.AnchorPoint = Vector2.new(0, 1)
	Frame.BackgroundTransparency = 1
	Frame.BorderSizePixel = 0
	Frame.Size = UDim2.new(1, 0, utility.mobilenumber(50.8330002), 0)

	content.BackgroundColor3 = window.color
	content.BorderSizePixel = 0
	content.Position = UDim2.new(1, 0, 0, 0)
	content.Size = UDim2.new(1, 0, 1, 0)

	TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	TextLabel.BackgroundTransparency = 1.000
	TextLabel.BorderSizePixel = 0
	TextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
	TextLabel.Size = UDim2.new(0.949999988, 0, 0.899999976, 0)
	TextLabel.Font = window.font
	TextLabel.Text = text
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.TextScaled = true
	TextLabel.TextWrapped = true
	TextLabel.TextXAlignment = Enum.TextXAlignment.Right
	TextLabel.TextYAlignment = Enum.TextYAlignment.Top

	UICorner.CornerRadius = UDim.new(0.1, 0)
	
	content:TweenPosition(UDim2.new(0, 0, 0, 0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.3)
	task.spawn(function()
		task.wait(timeout+0.3)
		content:TweenPosition(UDim2.new(1, 0, 0, 0),Enum.EasingDirection.In,Enum.EasingStyle.Quad,0.3)
		task.wait(0.3)
		Frame:Destroy()
	end)
end
function lib:page(props)
	local window = self
	local icon = props.icon or ""
	
	local page = {}
	
	local ImageButton = Instance.new("ImageButton",window.tabs)
	local UICorner = Instance.new("UICorner",ImageButton)

	ImageButton.BackgroundTransparency = 0.9
	ImageButton.BackgroundColor3 = Color3.new(0,0,0)
	ImageButton.AutoButtonColor = false
	ImageButton.BorderSizePixel = 0
	ImageButton.Size = UDim2.new(0.507246375, 0, 0.077605322, 0)
	ImageButton.Image = icon

	window.block[ImageButton] = true

	UICorner.CornerRadius = UDim.new(0.075000003, 0)
	UICorner.Parent = ImageButton
	
	local content = Instance.new("Frame",window.content)
	content.Visible = false
	content.BackgroundTransparency = 1
	content.BorderSizePixel = 0
	content.Size = UDim2.new(1, 0, 1, 0)
	
	local left = Instance.new("ScrollingFrame",content)
	left.BackgroundTransparency = 1
	left.BorderSizePixel = 0
	left.Size = UDim2.new(0.5, 0, 1, 0)
	left.CanvasSize = UDim2.new(0, 0, 0, 0)
	left.AutomaticCanvasSize = Enum.AutomaticSize.Y
	left.ScrollingDirection = Enum.ScrollingDirection.Y
	left.ScrollBarThickness = 6
	left.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left

	Instance.new("UIListLayout",left)
	
	local right = Instance.new("ScrollingFrame",content)
	right.BackgroundTransparency = 1
	right.BorderSizePixel = 0
	right.Position = UDim2.new(0.5, 0, 0, 0)
	right.Size = UDim2.new(0.5, 0, 1, 0)
	right.CanvasSize = UDim2.new(0, 0, 0, 0)
	right.AutomaticCanvasSize = Enum.AutomaticSize.Y
	right.ScrollingDirection = Enum.ScrollingDirection.Y
	right.ScrollBarThickness = 6
	
	Instance.new("UIListLayout",right)
	
	page = {
		["button"] = ImageButton,
		["content"] = content,
		["left"] = left,
		["right"] = right,
		["lib"] = lib,
		["window"] = window,
		["icon"] = icon
	}
	setmetatable(page,pages)
	
	ImageButton.MouseButton1Click:Connect(function()
		page:openpage()
	end)
	
	return page
end
function pages:openpage()
	local page = self
	if page and page.content and page.window.content then
		for i,v in pairs(page.window.content:GetChildren()) do
			pcall(function()
				v.Visible = false
			end)
		end
		page.content.Visible = true
	end
end
function pages:section(props)
	local page = self
	local name = props.name or "new ui"
	local side = props.side or "left"
	
	local sidecontent = page[side]
	
	local section = {}
	
	local Frame = Instance.new("Frame",sidecontent)
	local UICorner = Instance.new("UICorner",Frame)
	local TextLabel = Instance.new("TextLabel",Frame)
	local content = Instance.new("Frame",Frame)
	local UIListLayout = Instance.new("UIListLayout",content)

	page.window.block[Frame] = true
	page.window.block[content] = true
	page.window.block[TextLabel] = true

	Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Frame.BackgroundTransparency = 0.800
	Frame.BorderSizePixel = 0
	Frame.Size = UDim2.new(1, 0, 0.1, 0)

	UICorner.CornerRadius = UDim.new(0, utility.mobilenumber(10))

	TextLabel.BackgroundTransparency = 1.000
	TextLabel.BorderSizePixel = 0
	TextLabel.Position = UDim2.new(0, 10, 0, 0)
	TextLabel.Size = UDim2.new(1, -20, 0, utility.mobilenumber(33))
	TextLabel.Font = page.window.font
	TextLabel.Text = name
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.TextSize = page.window.textsize
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left

	content.BackgroundTransparency = 1
	content.BorderSizePixel = 0
	content.Position = UDim2.new(0, 10, 0, utility.mobilenumber(33))
	content.Size = UDim2.new(1, -20, 0, 1)
	
	section = {
		["name"] = name,
		["side"] = side,
		["content"] = content,
		["holder"] = Frame,
		["lib"] = page.lib,
		["window"] = page.window
	}
	setmetatable(section,sections)
	return section
end
function sections:updatesize()
	local section = self
	local content = section.content
	local holder = section.holder
	if content and holder then
		local y = utility.mobilenumber(33)
		for i,v in pairs(content:GetChildren()) do
			pcall(function()
				y += v.Size.Y.Offset
			end)
		end
		y += utility.mobilenumber(10)
		holder.Size = UDim2.new(1, 0, 0, y)
	end
end
function sections:button(props)
	local section = self
	local name = props.name or "new ui"
	local callback = props.callback or function()end
	
	local button = {}
	function button:click()
		pcall(function()
			callback()
		end)
	end
	
	local Frame = Instance.new("Frame",section.content)
	local TextButton = Instance.new("TextButton",Frame)
	local UICorner = Instance.new("UICorner",TextButton)
	
	section.window.block[Frame] = true
	section.window.block[TextButton] = true

	Frame.BackgroundTransparency = 1
	Frame.BorderSizePixel = 0
	Frame.Size = UDim2.new(1, 0, 0, utility.mobilenumber(25))

	TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
	TextButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	TextButton.BackgroundTransparency = 0.800
	TextButton.BorderSizePixel = 0
	TextButton.Position = UDim2.new(0.5, 0, 0.5, 0)
	TextButton.Size = UDim2.new(1, -10, 1, -5)
	TextButton.AutoButtonColor = false
	TextButton.Font = section.window.font
	TextButton.Text = name
	TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextButton.TextSize = section.window.textsize

	UICorner.CornerRadius = UDim.new(0.1, 0)
	
	TextButton.MouseButton1Click:Connect(function()
		pcall(function()
			callback()
		end)
	end)
	
	section:updatesize()
	
	button = {
		["lib"] = section.lib,
		["window"] = section.window
	}
	
	return button
end
function sections:toggle(props)
	local section = self
	
	local callback = props.callback or function()end
	local name = props.name or "new ui"
	local def = props.def or false
	
	local x = def
	
	if def == true then
		pcall(function()
			callback(x)
		end)
	end
	
	local toggle = {}
	
	local Frame = Instance.new("Frame",section.content)
	local button = Instance.new("ImageButton",Frame)
	local UICorner = Instance.new("UICorner",button)
	local TextLabel = Instance.new("TextLabel",Frame)
	
	section.window.block[Frame] = true
	section.window.block[button] = not x
	section.window.block[TextLabel] = true
	
	Frame.BackgroundTransparency = 1
	Frame.BorderSizePixel = 0
	Frame.Size = UDim2.new(1, 0, 0, utility.mobilenumber(25))

	button.AnchorPoint = Vector2.new(0, 0.5)
	button.BackgroundColor3 = x and section.window.color or Color3.fromRGB(40,40,40)
	button.BackgroundTransparency = 0.200
	button.BorderSizePixel = 0
	button.Position = UDim2.new(0.030911902, 0, 0.5, 0)
	button.Size = UDim2.new(0.0463678502, 0, 0.600000024, 0)
	button.AutoButtonColor = false

	UICorner.CornerRadius = UDim.new(0.100000001, 0)

	TextLabel.BackgroundTransparency = 1
	TextLabel.BorderSizePixel = 0
	TextLabel.Position = UDim2.new(0.0924559534, 0, 0.200000003, 0)
	TextLabel.Size = UDim2.new(0.890262723, 0, 0.600000024, 0)
	TextLabel.Font = section.window.font
	TextLabel.Text = name
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.TextSize = section.window.textsize
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	
	button.MouseButton1Click:Connect(function()
		x = not x
		section.window.block[button] = not x
		button.BackgroundColor3 = x and section.window.color or Color3.fromRGB(40,40,40)
		pcall(function()
			callback(x)
		end)
	end)
	
	section:updatesize()
	
	toggle = {
		["lib"] = section.lib,
		["window"] = section.window
	}
	function toggle:set(value)
		x = value
		section.window.block[button] = not x
		button.BackgroundColor3 = x and section.window.color or Color3.fromRGB(40,40,40)
		pcall(function()
			callback(x)
		end)
	end
	return toggle
end
function sections:slider(props)
	local section = self
	
	local callback = props.callback or function()end
	local name = props.name or "new ui"
	local min = props.min or 0
	local max = props.max or 1
	local def = props.def or 0.5
	local rounding = props.rounding or props.Rounding or props.round or props.Round or props.decimals or props.Decimals or false
	
	local x = def
	local last = x
	
	local slider = {}
	
	local Frame = Instance.new("Frame",section.content)
	local TextLabel = Instance.new("TextLabel",Frame)
	local Frame_2 = Instance.new("Frame",Frame)
	local TextLabel_2 = Instance.new("TextLabel",Frame_2)
	local UICorner = Instance.new("UICorner",Frame_2)
	local Frame_3 = Instance.new("Frame",Frame_2)
	
	section.window.block[Frame] = true
	section.window.block[TextLabel] = true
	section.window.block[Frame_2] = true
	section.window.block[TextLabel_2] = true

	Frame.BackgroundTransparency = 1
	Frame.BorderSizePixel = 0
	Frame.Size = UDim2.new(1, 0, 0, utility.mobilenumber(35))

	TextLabel.BackgroundTransparency = 1.000
	TextLabel.BorderSizePixel = 0
	TextLabel.Position = UDim2.new(0.0309597515, 0, 0.0571428575, 0)
	TextLabel.Size = UDim2.new(0.969040275, 0, 0.45714286, 0)
	TextLabel.Font = section.window.font
	TextLabel.Text = name
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.TextSize = section.window.textsize
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left

	Frame_2.Parent = Frame
	Frame_2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Frame_2.BorderSizePixel = 0
	Frame_2.Position = UDim2.new(0.0309597515, 0, 0.514285743, 0)
	Frame_2.Size = UDim2.new(0.93808049, 0, 0.285714298, 0)
	
	TextLabel_2.BackgroundTransparency = 1.000
	TextLabel_2.BorderSizePixel = 0
	TextLabel_2.Size = UDim2.new(1, 0, 1, 0)
	TextLabel_2.Font = section.window.font
	TextLabel_2.Text = tostring(x) .. "/" .. tostring(max)
	TextLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel_2.TextSize = section.window.textsize
	TextLabel_2.ZIndex = 2

	UICorner.CornerRadius = UDim.new(0.2, 0)

	Frame_3.BackgroundColor3 = section.window.color
	Frame_3.BorderSizePixel = 0
	Frame_3.Size = UDim2.new(math.clamp((x - min) / (max - min),0,1), 0, 1, 0)
	
	local dragging = false

	Frame_2.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if not dragging then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then
			local size = math.clamp(
				input.Position.X - Frame_2.AbsolutePosition.X,
				0,
				Frame_2.AbsoluteSize.X
			)

			x = ((max - min) / Frame_2.AbsoluteSize.X) * size + min
			x = rounding and math.floor(x) or x
			Frame_3.Size = UDim2.new(math.clamp((x - min) / (max - min),0,1), 0, 1, 0)
			TextLabel_2.Text = (rounding and x or utility.round(x,2)) .. "/" .. tostring(max)
			if last ~= x then
				pcall(function()
					callback(x)
				end)
				last = x
			end
		end
	end)
	slider = {
		["lib"] = section.lib,
		["window"] = section.window
	}
	function slider:set(v)
		if v then
			x = math.clamp(v,min,max)
			last = x
			TextLabel_2.Text = tostring(x) .. "/" .. tostring(max)
			Frame_3.Size = UDim2.new(math.clamp((x - min) / (max - min),0,1), 0, 1, 0)
			pcall(function()
				callback(x)
			end)
		end
	end
	section:updatesize()
	
	return slider
end
function sections:dropdown(props)
	local section = self
	
	local name = props.name or props.Name or props.page or props.Page or props.pagename or props.Pagename or props.PageName or props.pageName or "new ui"
	local def = props.def or props.Def or props.default or props.Default or ""
	local max = props.max or props.Max or props.maximum or props.Maximum or 4
	local options = props.options or props.Options or props.Settings or props.settings or {}
	local callback = props.callback or props.callBack or props.CallBack or props.Callback or function()end

	options = utility.fixtable(options)

	local dropdown = {}

	local Frame = Instance.new("Frame",section.content)
	local TextButton = Instance.new("TextButton",Frame)
	local TextLabel = Instance.new("TextLabel",TextButton)
	local UICorner = Instance.new("UICorner",TextButton)
	local TextLabel_2 = Instance.new("TextLabel",Frame)

	section.window.block[Frame] = true
	section.window.block[TextButton] = true
	section.window.block[TextLabel] = true
	section.window.block[TextLabel_2] = true

	Frame.BackgroundTransparency = 1
	Frame.BorderSizePixel = 0
	Frame.Size = UDim2.new(1, 0, 0, utility.mobilenumber(45))

	TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
	TextButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	TextButton.BackgroundTransparency = 0.800
	TextButton.BorderSizePixel = 0
	TextButton.Position = UDim2.new(0.498452008, 0, 0.666666687, 0)
	TextButton.Size = UDim2.new(0.969040275, 0, 0.444444448, 0)
	TextButton.Font = section.window.font
	TextButton.Text = def
	TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextButton.TextSize = section.window.textsize
	TextButton.TextXAlignment = Enum.TextXAlignment.Left
	TextButton.AutoButtonColor = false

	TextLabel.AnchorPoint = Vector2.new(1, 0.5)
	TextLabel.BackgroundTransparency = 1.000
	TextLabel.BorderSizePixel = 0
	TextLabel.Position = UDim2.new(0.984025538, 0, 0.5, 0)
	TextLabel.Size = UDim2.new(0.0319488831, 0, 0.5, 0)
	TextLabel.Font = section.window.font
	TextLabel.Text = "+"
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.TextSize = section.window.textsize

	UICorner.CornerRadius = UDim.new(0.100000001, 0)
	UICorner.Parent = TextButton

	TextLabel_2.Parent = Frame
	TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel_2.BackgroundTransparency = 1.000
	TextLabel_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel_2.BorderSizePixel = 0
	TextLabel_2.Position = UDim2.new(0.0154798757, 0, 0, 0)
	TextLabel_2.Size = UDim2.new(0.962848306, 0, 0.444444448, 0)
	TextLabel_2.Font = section.window.font
	TextLabel_2.Text = name
	TextLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel_2.TextSize = section.window.textsize
	TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left
	
	local OverFrame = Instance.new("Frame",section.window.screen)
	local OverScrollingFrame = Instance.new("ScrollingFrame",OverFrame)
	local OverUIListLayout = Instance.new("UIListLayout",OverScrollingFrame)
	
	TextButton.MouseButton1Click:Connect(function()
		OverFrame.Position = UDim2.new(0,TextButton.AbsolutePosition.X,0,TextButton.AbsolutePosition.Y+TextButton.AbsoluteSize.Y)
		OverFrame.Size = UDim2.new(0, TextButton.AbsoluteSize.X, 0, utility.mobilenumber(20+(20*max)))
		OverFrame.Visible = not OverFrame.Visible
		TextLabel.Text = OverFrame.Visible and "-" or "+"
	end)
	
	section.window.block[OverFrame] = true
	section.window.block[OverScrollingFrame] = true
	
	OverFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	OverFrame.BackgroundTransparency = 0.800
	OverFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	OverFrame.BorderSizePixel = 0
	OverFrame.Visible = false
	OverFrame.Position = UDim2.new(0,TextButton.AbsolutePosition.X,0,TextButton.AbsolutePosition.Y+TextButton.AbsoluteSize.Y)
	OverFrame.Size = UDim2.new(0, TextButton.AbsoluteSize.X, 0, utility.mobilenumber(20+(20*max)))

	OverScrollingFrame.Active = true
	OverScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	OverScrollingFrame.BackgroundTransparency = 1.000
	OverScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	OverScrollingFrame.BorderSizePixel = 0
	OverScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
	OverScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	OverScrollingFrame.ScrollBarThickness = 6
	OverScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	OverScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y

	OverUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right

	game:GetService("RunService").RenderStepped:Connect(function()
		if OverFrame and OverFrame.Visible then
			OverFrame.Position = UDim2.new(0,TextButton.AbsolutePosition.X,0,TextButton.AbsolutePosition.Y+TextButton.AbsoluteSize.Y)
			OverFrame.Size = UDim2.new(0, TextButton.AbsoluteSize.X, 0, utility.mobilenumber(20+(20*max)))
		end
	end)

	for i,v in options do
		local OverTextButton = Instance.new("TextButton",OverScrollingFrame)
		OverTextButton.BackgroundTransparency = 1.000
		OverTextButton.BorderSizePixel = 0
		OverTextButton.Size = UDim2.new(0.983974338, 0, 0, utility.mobilenumber(20))
		OverTextButton.Font = section.window.font
		OverTextButton.Text = v
		OverTextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		OverTextButton.TextSize = section.window.textsize
		OverTextButton.TextXAlignment = Enum.TextXAlignment.Left
		OverTextButton.MouseButton1Click:Connect(function()
			OverFrame.Visible = false
			TextLabel.Text = OverFrame.Visible and "-" or "+"
			TextButton.Text = v
			pcall(function()
				callback(v)
			end)
		end)
	end
	
	section:updatesize()
	
	dropdown = {
		["lib"] = section.lib,
		["window"] = section.window,
	}
	function dropdown:set(v)
		if v then
			TextButton.Text = v
			pcall(function()
				callback(v)
			end)
		end
	end
	return dropdown
end

function sections:multibox(props)
	local section = self

	local name = props.name or props.Name or props.page or props.Page or props.pagename or props.Pagename or props.PageName or props.pageName or "new ui"
	local def = props.def or props.Def or props.default or props.Default or {}
	local max = props.max or props.Max or props.maximum or props.Maximum or 4
	local options = props.options or props.Options or props.Settings or props.settings or {}
	local callback = props.callback or props.callBack or props.CallBack or props.Callback or function()end

	def = utility.fixtable(def)
	options = utility.fixtable(options)

	local multibox = {}

	local x = def
	
	local xxx = {}

	local Frame = Instance.new("Frame",section.content)
	local TextButton = Instance.new("TextButton",Frame)
	local TextLabel = Instance.new("TextLabel",TextButton)
	local UICorner = Instance.new("UICorner",TextButton)
	local TextLabel_2 = Instance.new("TextLabel",Frame)

	local function updatethetext()
		local text = ""
		for i,v in pairs(x) do
			if i < 5 then
				text = text..v..", "
			end
			if i == 5 then
				text = text.."..."
			end
		end
		TextButton.Text = text
	end
	updatethetext()

	section.window.block[Frame] = true
	section.window.block[TextButton] = true
	section.window.block[TextLabel] = true
	section.window.block[TextLabel_2] = true

	Frame.BackgroundTransparency = 1
	Frame.BorderSizePixel = 0
	Frame.Size = UDim2.new(1, 0, 0, utility.mobilenumber(45))

	TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
	TextButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	TextButton.BackgroundTransparency = 0.800
	TextButton.BorderSizePixel = 0
	TextButton.Position = UDim2.new(0.498452008, 0, 0.666666687, 0)
	TextButton.Size = UDim2.new(0.969040275, 0, 0.444444448, 0)
	TextButton.Font = section.window.font
	TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextButton.TextSize = section.window.textsize
	TextButton.TextXAlignment = Enum.TextXAlignment.Left
	TextButton.AutoButtonColor = false

	TextLabel.AnchorPoint = Vector2.new(1, 0.5)
	TextLabel.BackgroundTransparency = 1.000
	TextLabel.BorderSizePixel = 0
	TextLabel.Position = UDim2.new(0.984025538, 0, 0.5, 0)
	TextLabel.Size = UDim2.new(0.0319488831, 0, 0.5, 0)
	TextLabel.Font = section.window.font
	TextLabel.Text = "+"
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.TextSize = section.window.textsize

	UICorner.CornerRadius = UDim.new(0.100000001, 0)
	UICorner.Parent = TextButton

	TextLabel_2.Parent = Frame
	TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel_2.BackgroundTransparency = 1.000
	TextLabel_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel_2.BorderSizePixel = 0
	TextLabel_2.Position = UDim2.new(0.0154798757, 0, 0, 0)
	TextLabel_2.Size = UDim2.new(0.962848306, 0, 0.444444448, 0)
	TextLabel_2.Font = section.window.font
	TextLabel_2.Text = name
	TextLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel_2.TextSize = section.window.textsize
	TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left

	local OverFrame = Instance.new("Frame",section.window.screen)
	local OverScrollingFrame = Instance.new("ScrollingFrame",OverFrame)
	local OverUIListLayout = Instance.new("UIListLayout",OverScrollingFrame)

	TextButton.MouseButton1Click:Connect(function()
		OverFrame.Position = UDim2.new(0,TextButton.AbsolutePosition.X,0,TextButton.AbsolutePosition.Y+TextButton.AbsoluteSize.Y)
		OverFrame.Size = UDim2.new(0, TextButton.AbsoluteSize.X, 0, utility.mobilenumber(20+(20*max)))
		OverFrame.Visible = not OverFrame.Visible
		TextLabel.Text = OverFrame.Visible and "-" or "+"
	end)

	section.window.block[OverFrame] = true
	section.window.block[OverScrollingFrame] = true

	OverFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	OverFrame.BackgroundTransparency = 0.800
	OverFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	OverFrame.BorderSizePixel = 0
	OverFrame.Visible = false
	OverFrame.Position = UDim2.new(0,TextButton.AbsolutePosition.X,0,TextButton.AbsolutePosition.Y+TextButton.AbsoluteSize.Y)
	OverFrame.Size = UDim2.new(0, TextButton.AbsoluteSize.X, 0, utility.mobilenumber(20+(20*max)))

	OverScrollingFrame.Active = true
	OverScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	OverScrollingFrame.BackgroundTransparency = 1.000
	OverScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	OverScrollingFrame.BorderSizePixel = 0
	OverScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
	OverScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	OverScrollingFrame.ScrollBarThickness = 6
	OverScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	OverScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y

	OverUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right

	game:GetService("RunService").RenderStepped:Connect(function()
		if OverFrame and OverFrame.Visible then
			OverFrame.Position = UDim2.new(0,TextButton.AbsolutePosition.X,0,TextButton.AbsolutePosition.Y+TextButton.AbsoluteSize.Y)
			OverFrame.Size = UDim2.new(0, TextButton.AbsoluteSize.X, 0, utility.mobilenumber(20+(20*max)))
		end
	end)

	for i,v in options do
		xxx[v] = utility.find(x,v) and true or false
		local OverTextButton = Instance.new("TextButton",OverScrollingFrame)
		OverTextButton.BackgroundTransparency = 1.000
		OverTextButton.BorderSizePixel = 0
		OverTextButton.Size = UDim2.new(0.983974338, 0, 0, utility.mobilenumber(20))
		OverTextButton.Font = section.window.font
		OverTextButton.Text = v
		OverTextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		OverTextButton.TextSize = section.window.textsize
		OverTextButton.TextXAlignment = Enum.TextXAlignment.Left
		OverTextButton.MouseButton1Click:Connect(function()
			TextLabel.Text = OverFrame.Visible and "-" or "+"
			xxx[v] = not xxx[v]
			local add = {}
			for i2,v2 in options do
				if xxx[v2] then
					table.insert(add,v2)
				end
			end
			x = add
			updatethetext()
			pcall(function()
				callback(x)
			end)
		end)
	end

	section:updatesize()

	multibox = {
		["lib"] = section.lib,
		["window"] = section.window
	}
	function multibox:set(v)
		if v then
			x = utility.fixtable(v)
			for i,v2 in options do
				xxx[v2] = utility.find(x,v2) and true or false
			end
			updatethetext()
			pcall(function()
				callback(x)
			end)
		end
	end
	return multibox
end

function sections:colorpicker(props)
	local section = self
	local name = props.name or "new ui"
	local callback = props.callback or function()end
	local def = props.def or Color3.fromRGB(255,0,0)
	
	local x = def
	
	local h,s,v = x:ToHSV()
	
	local hsv = {h,s,v}
	
	local Frame = Instance.new("Frame",section.content)
	local TextLabel = Instance.new("TextLabel",Frame)
	local ImageButton = Instance.new("ImageButton",Frame)
	local UICorner = Instance.new("UICorner",ImageButton)
	
	section.window.block[Frame] = true
	section.window.block[TextLabel] = true
	section.window.block[ImageButton] = true
	
	local colorpicker = {}

	UICorner.CornerRadius = UDim.new(0.1,0)

	Frame.BackgroundTransparency = 1
	Frame.BorderSizePixel = 0
	Frame.Size = UDim2.new(1, 0, 0, utility.mobilenumber(25))

	TextLabel.BackgroundTransparency = 1.000
	TextLabel.BorderSizePixel = 0
	TextLabel.Position = UDim2.new(0.0309597515, 0, 0, 0)
	TextLabel.Size = UDim2.new(0.969, 0, 1, 0)
	TextLabel.Font = section.window.font
	TextLabel.Text = name
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.TextSize = section.window.textsize
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left

	ImageButton.BackgroundColor3 = x
	ImageButton.BorderSizePixel = 0
	ImageButton.Position = UDim2.new(0.842000008, 7, 0.119999997, 0)
	ImageButton.Size = UDim2.new(0.127, 0, 0.76, 0)
	ImageButton.AutoButtonColor = false
	
	local OverFrame = Instance.new("Frame",section.window.screen)
	local OverFrame_2 = Instance.new("Frame",OverFrame)
	local OverImageLabel = Instance.new("ImageLabel",OverFrame_2)
	local OverImageLabel_2 = Instance.new("ImageLabel",OverImageLabel)
	local OverTextBox = Instance.new("TextBox",OverFrame)
	local OverImageButton = Instance.new("ImageButton",OverFrame)
	local OverUIGradient = Instance.new("UIGradient",OverImageButton)
	local OverFrame_3 = Instance.new("Frame",OverImageButton)
	OverFrame_2.BackgroundColor3 = Color3.fromHSV(hsv[1],1,1)
	OverImageLabel_2.Position = UDim2.new(s,0,v,0)
	OverFrame_3.Position = UDim2.new(0.5,0,h,0)
	
	section.window.block[OverFrame] = true
	section.window.block[OverFrame_2] = true
	section.window.block[OverTextBox] = true
	section.window.block[OverImageButton] = true
	section.window.block[OverFrame_3] = true

	OverFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	OverFrame.BackgroundTransparency = 0.800
	OverFrame.BorderSizePixel = 0
	OverFrame.Visible = false
	OverFrame.Position = UDim2.new(0,Frame.AbsolutePosition.X,0,Frame.AbsolutePosition.Y+Frame.AbsoluteSize.Y)
	OverFrame.Size = UDim2.new(0, Frame.AbsoluteSize.X, 0, utility.mobilenumber(170))
	
	game:GetService("RunService").RenderStepped:Connect(function()
		if OverFrame.Visible then
			OverFrame.Position = UDim2.new(0,Frame.AbsolutePosition.X,0,Frame.AbsolutePosition.Y+Frame.AbsoluteSize.Y)
			OverFrame.Size = UDim2.new(0, Frame.AbsoluteSize.X, 0, utility.mobilenumber(170))
		end
	end)

	OverFrame_2.BackgroundColor3 = x
	OverFrame_2.BorderSizePixel = 0
	OverFrame_2.Position = UDim2.new(0.021671826, 0, 0.0562499985, 0)
	OverFrame_2.Size = UDim2.new(0.90402478, 0, 0.78125, 0)

	OverImageLabel.BackgroundTransparency = 1.000
	OverImageLabel.BorderSizePixel = 0
	OverImageLabel.Position = UDim2.new(1.12610991e-07, 0, 0, 0)
	OverImageLabel.Size = UDim2.new(1.0035646, 0, 1, 0)
	OverImageLabel.Image = "rbxassetid://7074305282"

	OverImageLabel_2.AnchorPoint = Vector2.new(0.5, 0.5)
	OverImageLabel_2.BackgroundTransparency = 1.000
	OverImageLabel_2.BorderSizePixel = 0
	OverImageLabel_2.Size = UDim2.new(0.0170624666, 0, 0.0399999991, 0)
	OverImageLabel_2.Image = "rbxassetid://7074391319"

	OverTextBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	OverTextBox.BackgroundTransparency = 0.800
	OverTextBox.BorderSizePixel = 0
	OverTextBox.Position = UDim2.new(0.0154798757, 0, 0.874750018, 0)
	OverTextBox.Size = UDim2.new(0.969040275, 0, 0.09375, 0)
	OverTextBox.ClearTextOnFocus = false
	OverTextBox.Font = section.window.font
	OverTextBox.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
	OverTextBox.PlaceholderText = "#ffffff"
	OverTextBox.Text = ""
	OverTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	OverTextBox.TextSize = section.window.textsize

	OverImageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	OverImageButton.BorderSizePixel = 0
	OverImageButton.Position = UDim2.new(0.950464368, 0, 0.0625, 0)
	OverImageButton.Size = UDim2.new(0.0340557285, 0, 0.774999976, 0)
	OverImageButton.Image = ""
	OverImageButton.AutoButtonColor = false

	OverUIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 4)), ColorSequenceKeypoint.new(0.10, Color3.fromRGB(255, 153, 0)), ColorSequenceKeypoint.new(0.20, Color3.fromRGB(209, 255, 0)), ColorSequenceKeypoint.new(0.30, Color3.fromRGB(55, 255, 0)), ColorSequenceKeypoint.new(0.40, Color3.fromRGB(0, 255, 102)), ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 102, 255)), ColorSequenceKeypoint.new(0.70, Color3.fromRGB(51, 0, 255)), ColorSequenceKeypoint.new(0.80, Color3.fromRGB(204, 0, 255)), ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 0, 153)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 4))}
	OverUIGradient.Rotation = 90

	OverFrame_3.AnchorPoint = Vector2.new(0.5, 0.5)
	OverFrame_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	OverFrame_3.BorderSizePixel = 0
	OverFrame_3.Position = UDim2.new(0.5, 0, 0, 0)
	OverFrame_3.Size = UDim2.new(1.10000002, 0, 0.0199999996, 0)

	local function movehue(GetMouse)
		local posy = math.clamp(GetMouse.Y-OverFrame_2.AbsolutePosition.Y,0,OverFrame_2.AbsoluteSize.Y)
		local resy = (1/OverFrame_2.AbsoluteSize.Y)*posy
		OverFrame_2.BackgroundColor3 = Color3.fromHSV(resy,1,1)
		hsv[1] = resy
		x = Color3.fromHSV(hsv[1],hsv[2],hsv[3])
		OverFrame_2.BackgroundColor3 = Color3.fromHSV(hsv[1],1,1)
		callback(x)
		OverFrame_3.Position = UDim2.new(0.5,0,resy,0)
	end

	local function movecp(GetMouse)
		local posx,posy = math.clamp(GetMouse.X-OverFrame_2.AbsolutePosition.X,0,OverFrame_2.AbsoluteSize.X),math.clamp(GetMouse.Y-OverFrame_2.AbsolutePosition.Y,0,OverFrame_2.AbsoluteSize.Y)
		local resx,resy = (1/OverFrame_2.AbsoluteSize.X)*posx,(1/OverFrame_2.AbsoluteSize.Y)*posy
		hsv[2] = resx
		hsv[3] = 1-resy
		x = Color3.fromHSV(hsv[1],hsv[2],hsv[3])
		OverFrame_2.BackgroundColor3 = Color3.fromHSV(hsv[1],1,1)
		callback(x)
		OverImageLabel_2.Position = UDim2.new(resx,0,resy,0)
	end
	
	local draggingColor = false
	local draggingHue = false

	OverFrame_2.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			draggingColor = true
			movecp(input.Position)
		end
	end)

	OverImageButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			draggingHue = true
			movehue(input.Position)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			draggingColor = false
			draggingHue = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then

			if draggingColor then
				movecp(input.Position)
			end

			if draggingHue then
				movehue(input.Position)
			end
			if draggingHue or draggingColor then
				ImageButton.BackgroundColor3 = x
				pcall(function()
					callback(x)
				end)
			end
		end
	end)
	
	ImageButton.MouseButton1Click:Connect(function()
		OverFrame.Position = UDim2.new(0,Frame.AbsolutePosition.X,0,Frame.AbsolutePosition.Y+Frame.AbsoluteSize.Y)
		OverFrame.Size = UDim2.new(0, Frame.AbsoluteSize.X, 0, utility.mobilenumber(170))
		OverFrame.Visible = not OverFrame.Visible
	end)
	
	OverTextBox.FocusLost:Connect(function()
		local saved = OverTextBox.Text
		x = utility.from_hex(saved)
		local h,s,v2 = x:ToHSV()
		hsv = {h,s,v2}
		OverFrame_2.BackgroundColor3 = Color3.fromHSV(hsv[1],1,1)
		ImageButton.BackgroundColor3 = x
		OverImageLabel_2.Position = UDim2.new(s,0,1-v2,0)
		OverFrame_3.Position = UDim2.new(0.5,0,h,0)
		OverTextBox.Text = ""
	end)
	
	section:updatesize()
	
	colorpicker = {
		["lib"] = self.lib,
		["button"] = ImageButton
	}
	function colorpicker:set(v)
		x = v
		ImageButton.BackgroundColor3 = v
		local h,s,v2 = x:ToHSV()
		hsv = {h,s,v2}
		OverFrame_2.BackgroundColor3 = Color3.fromHSV(hsv[1],1,1)
		OverImageLabel_2.Position = UDim2.new(s,0,1-v2,0)
		OverFrame_3.Position = UDim2.new(0.5,0,h,0)
		pcall(function()
			callback(x)
		end)
	end
	return colorpicker
end

function sections:textbox(props)
	local section = self
	local name = props.name or props.Name or props.page or props.Page or props.pagename or props.Pagename or props.PageName or props.pageName or "new ui"
	local def = props.def or props.Def or props.default or props.Default or ""
	local placeholder = props.placeholder or props.Placeholder or props.placeHolder or props.PlaceHolder or props.placeholdertext or props.PlaceHolderText or props.PlaceHoldertext or props.placeHolderText or props.placeHoldertext or props.Placeholdertext or props.PlaceholderText or props.placeholderText or ""
	local callback = props.callback or props.callBack or props.CallBack or props.Callback or function()end
	
	local textbox = {}
	
	local Frame = Instance.new("Frame",section.content)
	local TextLabel = Instance.new("TextLabel",Frame)
	local TextBox = Instance.new("TextBox",Frame)
	local UICorner = Instance.new("UICorner",TextBox)

	section.window.block[Frame] = true
	section.window.block[TextBox] = true
	section.window.block[TextLabel] = true

	Frame.BackgroundTransparency = 1
	Frame.BorderSizePixel = 0
	Frame.Size = UDim2.new(1, 0, 0, utility.mobilenumber(35))

	TextLabel.BackgroundTransparency = 1.000
	TextLabel.BorderSizePixel = 0
	TextLabel.Size = UDim2.new(1, 0, 0.54285717, 0)
	TextLabel.Font = section.window.font
	TextLabel.Text = name
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.TextSize = section.window.textsize
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left

	TextBox.BackgroundColor3 = Color3.fromRGB(0,0,0)
	TextBox.BackgroundTransparency = 0.8
	TextBox.BorderSizePixel = 0
	TextBox.Position = UDim2.new(0, 0, 0.54285717, 0)
	TextBox.Size = UDim2.new(1, 0, 0.45714286, 0)
	TextBox.Font = Enum.Font.SourceSans
	TextBox.Text = def
	TextBox.PlaceholderText = placeholder
	TextBox.PlaceholderColor3 = Color3.fromRGB(200,200,200)
	TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextBox.TextSize = 14.000
	TextBox.FocusLost:Connect(function()
		pcall(function()
			callback(TextBox.Text)
		end)
	end)

	UICorner.CornerRadius = UDim.new(0.1, 0)
	
	textbox = {
		["lib"] = section.lib,
		["window"] = section.window
	}
	section:updatesize()
	function textbox:set(v)
		TextBox.Text = v
		pcall(function()
			callback(v)
		end)
	end
	return textbox
end

function sections:custom(props)
	local size = props.Size or props.size or 50
	
	local custom = {}
	
	local customholder = Instance.new("Frame",self.content)
	customholder.Size = UDim2.new(1,0,0,utility.mobilenumber(size))
	customholder.BackgroundTransparency = 1
	customholder.BorderSizePixel = 0
	
	self.window.block[customholder] = true

	custom = {
		["lib"] = self.lib,
		["holder"] = customholder,
		["size"] = size,
		["window"] = self.window
	}
	
	self:updatesize()
	
	return custom
end


return lib
