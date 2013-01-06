-- 2012 Nightmares Within
-- http://www.nightmareswithin.com
-- @NightmaresWithn
-- http://www.facebook.com/NightmaresWithin
-- Distribution without authorization is strictly prohibited
-- Version 1.1
-- =========================================================
local HUDsonLib = {}
local HUDsonLib_mt = { __index = HUDsonLib }

local _lib_path = "HUDson/"

local Random = math.random

function HUDsonLib.New()
	local hudLib = {}
	
	hudLib.numbers = {}
	hudLib.numbers[1] = {
		[string.byte("0")] = _lib_path.."0.png",
		[string.byte("1")] = _lib_path.."1.png",
		[string.byte("2")] = _lib_path.."2.png",
		[string.byte("3")] = _lib_path.."3.png",
		[string.byte("4")] = _lib_path.."4.png",
		[string.byte("5")] = _lib_path.."5.png",
		[string.byte("6")] = _lib_path.."6.png",
		[string.byte("7")] = _lib_path.."7.png",
		[string.byte("8")] = _lib_path.."8.png",
		[string.byte("9")] = _lib_path.."9.png",
		[string.byte(" ")] = _lib_path.."space.png",
		[string.byte("%")] = _lib_path.."percent.png",
		[string.byte(".")] = _lib_path.."..png",
		[string.byte(",")] = _lib_path..",.png"
	}
	
	hudLib.numbers[2] = { 
		[string.byte("0")] = _lib_path.."0_2.png",
		[string.byte("1")] = _lib_path.."1_2.png",
		[string.byte("2")] = _lib_path.."2_2.png",
		[string.byte("3")] = _lib_path.."3_2.png",
		[string.byte("4")] = _lib_path.."4_2.png",
		[string.byte("5")] = _lib_path.."5_2.png",
		[string.byte("6")] = _lib_path.."6_2.png",
		[string.byte("7")] = _lib_path.."7_2.png",
		[string.byte("8")] = _lib_path.."8_2.png",
		[string.byte("9")] = _lib_path.."9_2.png",
		[string.byte(" ")] = _lib_path.."space_2.png",
		[string.byte("%")] = _lib_path.."percent_2.png",
		[string.byte(".")] = _lib_path.."._2.png",
		[string.byte(",")] = _lib_path..",_2.png"
	}
	
	-- hudLib.score = 0
	-- hudLib.scoreGroup = nil
	-- hudLib.numbersGroup = nil
	-- hudLib.background = nil
	
	return setmetatable(hudLib, HUDsonLib_mt)
end

function HUDsonLib:Destroy()
	self.numbers = nil
	self.numbers2 = nil
	self = nil
end

function HUDsonLib:NewPowerMeter(inGFXGroup, inProps)	
	local powerMeterGroup = display.newGroup()
	inGFXGroup:insert(powerMeterGroup)

	local cc = inProps.casingOuterColor
	local cf = inProps.casingOuterFlashColor
	local ci = inProps.casingInnerColor
	local bc = inProps.barColor
	
	powerMeterGroup.powerOuterCasing = display.newRect(powerMeterGroup, inProps.x, inProps.y, inProps.width, inProps.height)
	if(inProps.casingOuterIsGradient)then
		powerMeterGroup.powerOuterCasing:setFillColor(cc)
	else
		powerMeterGroup.powerOuterCasing:setFillColor(cc[1],cc[2],cc[3],cc[4])
	end
	powerMeterGroup.powerOuterCasingFlasher = display.newRect(powerMeterGroup, inProps.x, inProps.y, inProps.width, inProps.height)
	powerMeterGroup.powerOuterCasingFlasher:setFillColor(cf[1],cf[2],cf[3],cf[4])
	powerMeterGroup.powerOuterCasingFlasher.alpha = 0
	powerMeterGroup.powerInnerCasing = display.newRect(powerMeterGroup, inProps.x + 4, inProps.y + 4, inProps.width - 8, inProps.height - 8)
	if(inProps.casingInnerIsGradient)then
		powerMeterGroup.powerInnerCasing:setFillColor(ci)
	else
		powerMeterGroup.powerInnerCasing:setFillColor(ci[1],ci[2],ci[3],ci[4])
	end
	powerMeterGroup.powerBar = display.newRect(powerMeterGroup, inProps.x + 4, inProps.y + 4, inProps.width - 8, inProps.height - 8)
	powerMeterGroup.powerBar:setFillColor(bc[1],bc[2],bc[3],bc[4])
	if(inProps.orientation == "horizontal")then
		powerMeterGroup.powerBar.xReference = -(inProps.width - 8) / 2
	else
		powerMeterGroup.powerBar.yReference = (inProps.height - 8) / 2
	end
	powerMeterGroup.totalPower = inProps.totalPower
	powerMeterGroup.power = inProps.totalPower
	powerMeterGroup.regainSpeed = inProps.regainSpeed
	powerMeterGroup.regainAmount = inProps.regainAmount
	powerMeterGroup.regainTimer = nil
	powerMeterGroup.orientation = inProps.orientation
	
	function powerMeterGroup:UpdateMeter()
		if(self.power <= 0)then
			self.powerBar.alpha = 0
		else
			self.powerBar.alpha = 1
			local p = self.power / self.totalPower
			
			if(self.orientation == "horizontal")then
				self.powerBar.xScale = p -- self.powerBar.xScale - (1 / inAmount)
			else
				self.powerBar.yScale = p
			end
		end	
	end
	
	function powerMeterGroup:SubtractMeter(inAmount)
		self.power = self.power - inAmount	
		self:UpdateMeter()

		return self.power
	end

	function powerMeterGroup:AddMeter(inAmount)
		self.power = self.power + inAmount
		
		if(self.power > self.totalPower)then
			self.power = self.totalPower
		end
		self:UpdateMeter()
		
		return self.power
	end
	
	function powerMeterGroup:Activate()
		if(self.regainAmount > 0)then
			powerMeterGroup.regainTimer = timer.performWithDelay(self.regainSpeed,
				function()
					self.power = self.power + self.regainAmount
					if(self.power > self.totalPower)then
						self.power = self.totalPower					
					end
					self:UpdateMeter()
				end, 0
			)
		end
	end
	
	function powerMeterGroup:Deactivate()
		if(self.regainTimer)then
			timer.cancel(self.regainTimer)
		end
	end
	
	function powerMeterGroup:Pulse()
		self.powerOuterCasingFlasher.alpha = 1
		transition.to(self.powerOuterCasingFlasher, {time=1000, alpha = 0})
	end
	
	function powerMeterGroup:Destroy()
		for i=self.numChildren,1,-1 do
			display.remove(self[i])
			self[i] = nil
		end
		
		display.remove(self)
		self = nil	
	end
	
	return powerMeterGroup
end

function HUDsonLib:NewLivesIndicator(inGFXGroup, inProps)
	local livesIndicator = {}
	
	livesIndicator.gfxGroup = inGFXGroup
	livesIndicator.lives = inProps.lives or 3
	livesIndicator.imagename = inProps.imagename
	livesIndicator.width = inProps.width
	livesIndicator.height = inProps.height
	livesIndicator.startX = inProps.x
	livesIndicator.startY = inProps.y
	livesIndicator.seperation = inProps.seperation or 10
	livesIndicator.lifeIcons = {}
	
	function livesIndicator:Draw()
		local curx = self.startX
		local cury = self.startY
		for i=1,#livesIndicator.lifeIcons do
			display.remove(livesIndicator.lifeIcons[i])
			livesIndicator.lifeIcons[i] = nil
		end
		
		for i=1,self.lives - 1 do
			livesIndicator.lifeIcons[i] = display.newImageRect(self.gfxGroup, self.imagename, self.width, self.height)
			livesIndicator.lifeIcons[i].x = curx
			livesIndicator.lifeIcons[i].y = cury
			
			curx = curx + self.width + self.seperation
		end
	end
	
	function livesIndicator:RemoveLife()
		local lifeFade = self.lives
		self.lives = self.lives - 1
		transition.to(livesIndicator.lifeIcons[lifeFade], {time=1000, alpha=0})
		return self.lives
	end
	
	function livesIndicator:Destroy()
		for i=#self.lifeIcons,1,-1 do
			display.remove(self.lifeIcons[i])
			self.lifeIcons[i] = nil
		end
		self = nil		
	end
	
	livesIndicator:Draw()
	
	return livesIndicator
end

function HUDsonLib:NewLevelIndicator(inGFXGroup, inProps)
	local levelIndicator = {}
	local c = inProps.fontcolor
	
	levelIndicator.gfxGroup = inGFXGroup
	levelIndicator.level = inProps.level or 1
	levelIndicator.fontname = inProps.fontname or native.systemFontBold
	levelIndicator.fontsize = inProps.fontsize or 24
	levelIndicator.levelPrefix = inProps.levelPrefix or ""
	
	function levelIndicator:Draw()
		if(inProps.levelImage)then
			self.levelTitle = display.newImageRect(self.gfxGroup, _lib_path .. inProps.levelImage, inProps.width, inProps.height)
			self.levelTitle:setReferencePoint(display.CenterLeftReferencePoint)
			self.levelTitle.x = inProps.x
			self.levelTitle.y = inProps.y
			
			self.levelText = display.newText(self.gfxGroup, self.level, 0, 0, self.fontname, self.fontsize)
			self.levelText:setReferencePoint(display.CenterLeftReferencePoint)
			self.levelText.startX = self.levelTitle.x + self.levelTitle.width + 15
			self.levelText.x = self.levelText.startX
			self.levelText.y =inProps.y + 1
			self.levelText:setTextColor(c[1],c[2],c[3],c[4])
		else
			self.levelTitle = display.newText(self.gfxGroup, self.levelPrefix, 0, 0, self.fontname, self.fontsize)
			self.levelTitle:setReferencePoint(display.CenterLeftReferencePoint)
			self.levelTitle.startX = inProps.x
			self.levelTitle.x = inProps.x
			self.levelTitle.y = inProps.y
			self.levelTitle:setTextColor(c[1],c[2],c[3],c[4])
			
			self.levelText = display.newText(self.gfxGroup, self.level, 0, 0, self.fontname, self.fontsize)
			self.levelText:setReferencePoint(display.CenterLeftReferencePoint)
			self.levelText.x = inProps.x + self.levelTitle.width + 15
			self.levelText.y = inProps.y
			self.levelText:setTextColor(c[1],c[2],c[3],c[4])
		end
	end
	
	function levelIndicator:AdvanceLevel(inLevel)
		if(inLevel)then
			self.level = inLevel
		else
			self.level = self.level + 1
		end
		self.levelText.text = self.level
	end
	
	function levelIndicator:Destroy()
		display.remove(self.levelText)
		self.levelText = nil
		self = nil		
	end
	
	levelIndicator:Draw()
	
	return levelIndicator
end

function HUDsonLib:NewScoreBoard(inGFXGroup, inProps)
	-- This was originally Cacho, a joint effort between myself
	-- and the lovely and talented Peach Pellen.
	local scoreBoard = {}
	
	scoreBoard.gfxGroup = inGFXGroup	
	scoreBoard.scoreGroup = display.newGroup()
	scoreBoard.numbersGroup = display.newGroup()
	scoreBoard.backgroundBorder = inProps.backgroundBorder or 10
	scoreBoard.fill = nil
	scoreBoard.numberSet = self.numbers[inProps.numberSet]
	scoreBoard.pad = inProps.pad or false
	scoreBoard.padlen = inProps.padlen or 6
	scoreBoard.theFlash = nil
	
	if(inProps.backgroundImage)then
		scoreBoard.background = display.newImage(scoreBoard.scoreGroup, _lib_path .. inProps.backgroundImage)
		scoreBoard.background.width = inProps.width
		scoreBoard.background.height = inProps.height
		scoreBoard.background:setReferencePoint(display.TopLeftReferencePoint)
		scoreBoard.background.x = 0
		scoreBoard.background.y = 0
	else
		scoreBoard.background = display.newRect(scoreBoard.scoreGroup, 0, 0, inProps.width, inProps.height)
		if(inProps.borderColor1)then
			local c = inProps.borderColor1
			local bs = inProps.borderSize or 2
			
			if(inProps.borderIsGradient)then
				scoreBoard.background:setFillColor(c)
			else		
				scoreBoard.background:setFillColor(c[1],c[2],c[3],c[4])
			end
			
			if(inProps.fillColor1)then
				local tx, ty = scoreBoard.background:localToContent(0,0)
				scoreBoard.fill = display.newRect(bs, bs, inProps.width - (bs*2), inProps.height - (bs*2))

				if(inProps.fillColor1)then
					local f = inProps.fillColor1
					--print("setting fill")
					scoreBoard.fill:setFillColor(f[1],f[2],f[3],f[4])
					scoreBoard.fill:toFront()
				end
			end			
		else
			scoreBoard.background.alpha = 0
		end
	end
	
	if(scoreBoard.fill)then
		scoreBoard.scoreGroup:insert(scoreBoard.fill)
	end
	
	scoreBoard.theFlash = display.newRect(scoreBoard.scoreGroup, -4, -4, inProps.width + 8, inProps.height + 8)
	scoreBoard.scoreGroup:insert(scoreBoard.theFlash)
	scoreBoard.theFlash:toBack()
	scoreBoard.theFlash.alpha = 0

	scoreBoard.scoreGroup:insert(scoreBoard.numbersGroup)
	inGFXGroup:insert(scoreBoard.scoreGroup)
	
	local initScore = inProps.initialValue or 0
	scoreBoard.score = initScore
	scoreBoard.txtscore = tostring(initScore)
	scoreBoard.scoreGroup.x = inProps.x
	scoreBoard.scoreGroup.y = inProps.y
	scoreBoard.numWidth = inProps.numWidth
	scoreBoard.numHeight = inProps.numHeight
	scoreBoard.useComma = inProps.useComma
	
	scoreBoard.suffix = inProps.suffix or ""

	function scoreBoard:GetInfo()
		return {
			x = self.scoreGroup.x,
			y = self.scoreGroup.y,
			xmax = self.scoreGroup.x + self.scoreGroup.contentWidth,
			ymax = self.scoreGroup.y + self.scoreGroup.contentHeight,
			contentWidth = self.scoreGroup.contentWidth,
			contentHeight = self.scoreGroup.contentHeight,
			score = self.score
		}
	end

	function scoreBoard:Flash()
		self.theFlash.alpha = 1
		transition.to(self.theFlash, {time = 500, alpha = 0})
	end
		
	function scoreBoard:AddComma()
		local num = self.score
		local left,num,right = string.match(num,'^([^%d]*%d)(%d*)(.-)$')
		return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
	end
		
	function scoreBoard:Update()
		-- remove old numerals
		for i=self.numbersGroup.numChildren,1,-1 do
			display.remove(self.numbersGroup[i])
			self.numbersGroup[i] = nil
		end

		-- go through the score, right to left
		if(self.useComma)then
			self.txtscore = self:AddComma()
		else
			self.txtscore = self.score
		end
		
		local scoreStr = tostring(self.txtscore .. self.suffix)
		local scoreLen = string.len(scoreStr)
		
		if(self.pad)then
			local padneed = self.padlen - scoreLen
			if(padneed > 0)then
				while padneed > 0 do
					scoreStr = "0"..scoreStr
					padneed = padneed - 1
				end
			end
			scoreLen = self.padlen
		end
		
		local i = scoreLen	

		-- starting location is on the right. notice the digits will be centered on the background
		local x = (self.scoreGroup.contentWidth - self.backgroundBorder) - 2
		local y = (self.scoreGroup.contentHeight / 2) - 3
		
		while i > 0 do
			-- fetch the digit
			local c = string.byte( scoreStr, i )
			local digitPath = self.numberSet[c]
			local w = self.numWidth
			if(c == 43 or c == 44)then
				w = w * .4
			end
			local characterImage = display.newImageRect( digitPath, w, self.numHeight )

			-- put it in the score group
			self.numbersGroup:insert( characterImage )
			
			-- place the digit
			characterImage.x = x - characterImage.width / 2
			characterImage.y = y
			x = x - characterImage.width
			i = i - 1
		end
	end

	function scoreBoard:AddScore(inScoreAdd)
		self.score = self.score + inScoreAdd
		self:Update()
		return self.score
	end

	function scoreBoard:SetScore(inScore)
		self.score = inScore		
		self:Update()
	end
	
	scoreBoard:Update()
		
	return scoreBoard
end

return HUDsonLib