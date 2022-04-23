--[=[
	@client
	@class CircularProgressBar
    Based off this Source: https://devforum.roblox.com/t/circularradial-progress/454443
    Changed it to be a module script to allow direct access and configuration within code.
    Also changed it to be event driven, instead of updating every frame.
    
    Github repo: https://github.com/leoyulee/CircularProgressBar
]=]
local CircularProgressBar:CircularProgressBar = {
	ExistingObjects = {}
}
CircularProgressBar.__index = CircularProgressBar
local Template = script:FindFirstChild("CircularProgressBar") do
	if Template == nil then
		Template = Instance.new("Frame") do
			Template.AnchorPoint = Vector2.new(0.5,0.5)
			Template.BackgroundTransparency = 1
			Template.BorderColor3 = Color3.new(0,0,0)
			Template.BorderSizePixel = 0
			Template.Name = "CircularProgressBar"
			Template.Position = UDim2.new(0.5,0,0.5,0)
			Template.Size = UDim2.new(1,0,1,0)
			Template.SizeConstraint = Enum.SizeConstraint.RelativeYY
			Template.Parent = script
			local LeftFrame = Instance.new("Frame") do
				LeftFrame.AnchorPoint = Vector2.new(0,0)
				LeftFrame.BackgroundTransparency = 1
				LeftFrame.BorderColor3 = Color3.new(0,0,0)
				LeftFrame.BorderSizePixel = 0
				LeftFrame.Name = "LeftFrame"
				LeftFrame.Position = UDim2.new(0,0,0,0)
				LeftFrame.Size = UDim2.new(0.5,0,1,0)
				LeftFrame.SizeConstraint = Enum.SizeConstraint.RelativeXY
				LeftFrame.Parent = Template
				local ImageLabel = Instance.new("ImageLabel") do
					ImageLabel.BackgroundTransparency = 1
					ImageLabel.BorderColor3 = Color3.new(0,0,0)
					ImageLabel.BorderSizePixel = 0
					ImageLabel.Size = UDim2.new(2,0,1,0)
					ImageLabel.ImageTransparency = 0.5
					ImageLabel.Parent = LeftFrame
					local UIGradient = Instance.new("UIGradient") do
						UIGradient.Rotation = 360
						UIGradient.Transparency = NumberSequence.new({
							NumberSequenceKeypoint.new(0, 0, 0);
							NumberSequenceKeypoint.new(0.5, 0, 0);
							NumberSequenceKeypoint.new(0.501, 1, 0);
							NumberSequenceKeypoint.new(1, 1, 0);
						})
						UIGradient.Parent = ImageLabel
					end
				end
			end
			local RightFrame = Instance.new("Frame") do
				RightFrame.AnchorPoint = Vector2.new(1,0)
				RightFrame.BackgroundTransparency = 1
				RightFrame.BorderColor3 = Color3.new(0,0,0)
				RightFrame.BorderSizePixel = 0
				RightFrame.Name = "RightFrame"
				RightFrame.Position = UDim2.new(1,0,0,0)
				RightFrame.Size = UDim2.new(0.5,0,1,0)
				RightFrame.SizeConstraint = Enum.SizeConstraint.RelativeXY
				RightFrame.Parent = Template
				local ImageLabel = Instance.new("ImageLabel") do
					ImageLabel.BackgroundTransparency = 1
					ImageLabel.BorderColor3 = Color3.new(0,0,0)
					ImageLabel.BorderSizePixel = 0
					ImageLabel.Position = UDim2.new(-1,0,0,0)
					ImageLabel.Size = UDim2.new(2,0,1,0)
					ImageLabel.ImageTransparency = 0.5
					ImageLabel.Parent = LeftFrame
					local UIGradient = Instance.new("UIGradient") do
						UIGradient.Rotation = 180
						UIGradient.Transparency = NumberSequence.new({
							NumberSequenceKeypoint.new(0, 0, 0);
							NumberSequenceKeypoint.new(0.5, 0, 0);
							NumberSequenceKeypoint.new(0.501, 1, 0);
							NumberSequenceKeypoint.new(1, 1, 0);
						})
						UIGradient.Parent = ImageLabel
					end
				end
			end
		end
		
	end
end
type HalfProgressBarInstance = Frame & {ImageLabel: ImageLabel & {UIGradient: UIGradient}};
type CircularProgressBarInstance = Frame & {
	LeftFrame: HalfProgressBarInstance;
	RightFrame: HalfProgressBarInstance;
};
type CircularProgressBarObject = {
	Object: CircularProgressBarInstance;
	ProgressDirection: number;
	StartingAngle: number;
	CurrentPercent: number;
	FilledColor: Color3;
	EmptyColor: Color3;
	FilledTransparency: number;
	EmptyTransparency: number;
	BaseImage: string;
	Connections: Dictionary<RBXScriptConnection>;
}
export type CircularProgressBar = CircularProgressBarObject & typeof(CircularProgressBar)
--[=[
	Creates a new CircularLoadingBar with an object and code. If there is one that has been initialized and exists under the parent with the same name already, it will return that instead.

	@param Parent -- The parent of the UI to load into. Required.
	@param Name -- The name of the UI. Required.
	@param CurrentPercent -- The starting percentage of the UI. Default = 100
	@param StartingAngle -- The starting degrees of the UI. Default = 0
	@param ProgressDirection -- The direction of which the percentage will be displayed. Either 1 or -1. Default = 1
	@param FilledColor -- The color of the Filled section. Default = Color3.new(1,1,1) or Color3.fromRGB(255,255,255)
	@param EmptyColor -- The color of the Empty section. Defalut = Color3.new(1,1,1) or Color3.fromRGB(255,255,255)
	@param FilledTransparency -- The transparency of the Filled section. Default = 0
	@param EmptyTransparency -- The transparency of the Empty section. Default = 1
	@param BaseImage -- The AssetID of the image, normally in the format of "rbxassetid://[IDNUMBERHERE]". Default = "rbxassetid://3587367081"

	@return CircularProgressBar -- A new CircularProgressBar object
]=]
function CircularProgressBar.new(Parent: GuiBase, Name: string, CurrentPercent: number, StartingAngle: number, ProgressDirection: number, FilledColor: Color3, EmptyColor: Color3, FilledTransparency: number, EmptyTransparency: number, BaseImage: string): CircularProgressBar
	assert(Parent ~= nil, debug.traceback("Inputted Parent is nil! Debug:"))
	assert(Name ~= nil, debug.traceback("Inputted Name is nil! Debug:"))
	CurrentPercent = CurrentPercent or 100
	StartingAngle = StartingAngle or 0
	ProgressDirection = ProgressDirection or 1
	FilledColor = FilledColor or Color3.new(1,1,1)
	EmptyColor = EmptyColor or Color3.new(1,1,1)
	FilledTransparency = FilledTransparency or 0
	EmptyTransparency = EmptyTransparency or 1
	BaseImage = BaseImage or "rbxassetid://3587367081"
	local Object = Parent:FindFirstChild(Name) do
		if Object then
			local InitializedObject = CircularProgressBar.ExistingObjects[Object]
			if InitializedObject then
				return InitializedObject
			end
		else
			Object = Template:Clone()
			Object.Parent = Parent
			Object.Name = Name
		end
	end
	local NewProgressBar = setmetatable({
		Object = Object;
		ProgressDirection = ProgressDirection;
		StartingAngle = StartingAngle;
		CurrentPercent = CurrentPercent;
		FilledColor = FilledColor;
		EmptyColor = EmptyColor;
		FilledTransparency = FilledTransparency;
		EmptyTransparency = EmptyTransparency;
		BaseImage = BaseImage or "rbxassetid://3587367081";
		Connections = {};
	},CircularProgressBar)
	CircularProgressBar.ExistingObjects[Object] = NewProgressBar
	NewProgressBar.Connections["Destroyed"] = Object.AncestryChanged:Connect(function(_child,parent)
		if parent == nil then
			NewProgressBar:Destroy()
		end
	end)
	NewProgressBar:Init()
	return NewProgressBar
end
--[=[
	A wrapper to allow a dictionary to be passed in as an argument, where each key is a parameter for [CircularProgressBar.new].

	@param Input Dictionary
	@return CircularProgressBar -- A new CircularProgressBar object
]=]
function CircularProgressBar.NewFromTable(Input: {Parent: GuiBase, Name: string, CurrentPercent: number, StartingAngle: number, ProgressDirection: number, FilledColor: Color3, EmptyColor: Color3, FilledTransparency: number, EmptyTransparency: number, BaseImage: string}): CircularProgressBar
	return CircularProgressBar.new(Input.Parent, Input.Name, Input.CurrentPercent, Input.StartingAngle, Input.ProgressDirection, Input.FilledColor, Input.EmptyColor, Input.FilledTransparency, Input.EmptyTransparency, Input.BaseImage)
end
function CircularProgressBar:Destroy()
	--Destroy the current object to free up memory when this isn't used anymore.
	local Connections = self.Connections
	for ConnectionKey,Connection in next,Connections do
		Connection:Disconnect()
		Connections[ConnectionKey] = nil
	end
	Connections = nil
	self.Object:Destroy()
	self.Object = nil
	for PropertyName,_PropertyData in next,self do
		_PropertyData = nil
		self[PropertyName] = nil
	end
end
--[=[
	@private
	Syncs the object's virtual properties to the displayed UI. Only really used in .new()
]=]
function CircularProgressBar:Init()
	self:ApplyBaseImage()
	self:ApplyCurrentPercent()
	self:ApplyColor()
	self:ApplyTransparency()
end
do --BaseImage
	--[=[
		@private
		A helper function that syncs [CircularProgressBar.BaseImage] to the displayed UI ([CircularProgressBar.Object]).
		Is called when [CircularProgressBar:SetBaseImage] is called.
	]=]
	function CircularProgressBar:ApplyBaseImage()
		local BaseImage:string = self.BaseImage
		local MainGui = self.Object
		local LeftFrame:ImageLabel = MainGui.LeftFrame.ImageLabel
		local RightFrame:ImageLabel = MainGui.RightFrame.ImageLabel
		LeftFrame.Image = BaseImage
		RightFrame.Image = BaseImage
	end
	--[=[
		Used to set/change the image of the UI.

		@param NewAssetId string -- The AssetID of the image, normally in the format of "rbxassetid://[IDNUMBERHERE]".
		@return string -- Returns the input
	]=]
	function CircularProgressBar:SetBaseImage(NewAssetId: string): string
		self.BaseImage = NewAssetId
		self:ApplyBaseImage()
		return NewAssetId
	end
end
do --Coloring
	--[=[
		@private
		A helper function that syncs the Colors ([CircularProgressBar.FilledColor] and [CircularProgressBar.EmptyColor]) to the displayed UI ([CircularProgressBar.Object]).
		Is called when SetEmptyColor or SetFilledColor is called.
	]=]
	function CircularProgressBar:ApplyColor()
		local FilledColor = self.FilledColor
		local EmptyColor = self.EmptyColor
		local MainGui = self.Object
		local LeftGradient:UIGradient = MainGui.LeftFrame.ImageLabel.UIGradient
		local RightGradient:UIGradient = MainGui.RightFrame.ImageLabel.UIGradient
		local ActualColor = ColorSequence.new(
			{
				ColorSequenceKeypoint.new(0,FilledColor),
				ColorSequenceKeypoint.new(0.5,FilledColor),
				ColorSequenceKeypoint.new(0.501,EmptyColor),
				ColorSequenceKeypoint.new(1,EmptyColor)
			}
		)
		LeftGradient.Color = ActualColor
		RightGradient.Color = ActualColor
	end
	--[=[
		Used to set/change the empty color of the UI.
		@param NewColor Color3 -- The desired color.
		@return Color3 -- The new value of [CircularProgressBar.EmptyColor]
	]=]
	function CircularProgressBar:SetEmptyColor(NewColor: Color3): Color3
		self.EmptyColor = NewColor
		self:ApplyColor()
		return self.EmptyColor
	end
	--[=[
		Used to set/change the filled color of the UI.
		@param NewColor Color3 -- The desired color.
		@return Color3 -- The new value of [CircularProgressBar.EmptyColor]
	]=]
	function CircularProgressBar:SetFilledColor(NewColor: Color3): Color3
		self.FilledColor = NewColor
		self:ApplyColor()
		return self.FilledColor
	end
end
do --Transparency
	function CircularProgressBar:ApplyTransparency(Offset:number)
		Offset = Offset or 0
		local FilledTransparency:number = self.FilledTransparency
		local EmptyTransparency:number = self.EmptyTransparency
		local MainGui:Frame = self.Object
		local LeftGradient:UIGradient = MainGui.LeftFrame.ImageLabel.UIGradient
		local RightGradient:UIGradient = MainGui.RightFrame.ImageLabel.UIGradient
		local ActualTransparnecy = NumberSequence.new(
			{
				NumberSequenceKeypoint.new(0,FilledTransparency),
				NumberSequenceKeypoint.new(0.5+Offset,FilledTransparency),
				NumberSequenceKeypoint.new(0.501+Offset,EmptyTransparency),
				NumberSequenceKeypoint.new(1,EmptyTransparency)
			}
		)
		LeftGradient.Transparency = ActualTransparnecy
		RightGradient.Transparency = ActualTransparnecy
	end
	function CircularProgressBar:SetEmptyTransparency(NewTransparency: number): number
		self.EmptyTransparency = NewTransparency
		self:ApplyTransparency()
		return self.EmptyTransparency
	end
	function CircularProgressBar:SetFilledTransparency(NewTransparency: number): number
		self.FilledTransparency = NewTransparency
		self:ApplyTransparency()
		return self.FilledTransparency
	end
end
do --Percentage Display
	function CircularProgressBar:ApplyCurrentPercent()
		local MainGui:Frame = self.Object
		local LeftFrame:Frame = MainGui.LeftFrame
		local LeftGradient:UIGradient = LeftFrame.ImageLabel.UIGradient
		local RightFrame:Frame = MainGui.RightFrame
		local RightGradient:UIGradient = RightFrame.ImageLabel.UIGradient
		local ProgressDirection:number = self.ProgressDirection
		local CurrentPercent:number = self.CurrentPercent
		local StartingAngle = self.StartingAngle
		local DegreesFilled = math.clamp(CurrentPercent * 3.6,0,360)
		local ActualAngle = (DegreesFilled + StartingAngle)*ProgressDirection
		local IsEmpty = ActualAngle == 0
		local IsBeyondHalf = math.floor(math.abs(ActualAngle / 180)) > 0
		local IsFull = math.floor(math.abs(ActualAngle / 360)) > 0
		--[[local IsEmpty = CurrentPercent == 0
		local IsBeyondHalf = CurrentPercent > 50
		local IsFull = CurrentPercent == 100]]
		--[[if IsEmpty then
			LeftFrame.Visible = IsEmpty == false
			RightFrame.Visible = IsEmpty == false
		end]]
		if ProgressDirection > 0 then
			RightGradient.Rotation = math.clamp(DegreesFilled,0,180)
			RightFrame.Visible = IsEmpty == false
			LeftFrame.Visible = true--IsBeyondHalf --Hacky stuff
			if IsBeyondHalf then
				self:ApplyColor()--Hacky stuff
				LeftGradient.Rotation = math.clamp(DegreesFilled,180,360)
				local TransOffset = 0.001
				if IsFull then
					TransOffset = 0
				end
				self:ApplyTransparency(TransOffset)
			else --Hacky stuff
				LeftGradient.Color = ColorSequence.new(self.EmptyColor)
			end
		else
			LeftGradient.Rotation = 180 - math.clamp(DegreesFilled,0,180)
			LeftFrame.Visible = IsEmpty == false
			RightFrame.Visible = IsBeyondHalf
			if IsBeyondHalf then
				RightGradient.Rotation = 180 - math.clamp(DegreesFilled,180,360)
				local TransOffset = 0.001
				if IsFull then
					TransOffset = 0
				end
				self:ApplyTransparency(TransOffset)
			end
		end
	end
	function CircularProgressBar:SetStartingAngle(NewDegrees: number): number
		self.StartingAngle = NewDegrees
		self:ApplyCurrentPercent()
		return self.StartingAngle
	end
	function CircularProgressBar:SetCurrentPercent(NewPercent: number): number
		self.CurrentPercent = NewPercent
		self:ApplyCurrentPercent()
		return self.CurrentPercent
	end
	function CircularProgressBar:SetProgressDirection(ProgressDirection: number)
		ProgressDirection = ProgressDirection or 1
		if tonumber(ProgressDirection) == nil or tonumber(ProgressDirection) == 0 then
			ProgressDirection = 1
		end
		self.ProgressDirection = math.sign(ProgressDirection)
		self:ApplyCurrentPercent()
		return self.ProgressDirection
	end
end
return CircularProgressBar