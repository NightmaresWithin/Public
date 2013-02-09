-- 2013 Nightmares Within
-- http://www.nightmareswithin.com
-- @NightmaresWithn
-- http://www.facebook.com/NightmaresWithin
-- You are free to Distribute, just keep my header :)
-- ==================================================
local bubbleMakerLib = {}
local bubbleMakerLib_mt = { __index = bubbleMakerLib }

local Random = math.random

function bubbleMakerLib.New(inGFXGroup, advancePopCounter, gameOverHandler)
	local bubLib = {}
	
	bubLib.blowerPick = nil
	bubLib.blowRoundTimer = nil
	bubLib.blowTimer = nil
	bubLib.bubbleGroup = inGFXGroup
	bubLib.blowSpeed = nil
	bubLib.blowerX = nil
	bubLib.blowerY = nil
	bubLib.advancePopCounter = advancePopCounter
	bubLib.gameOverHandler = gameOverHandler
	
	return setmetatable(bubLib, bubbleMakerLib_mt)
end

function bubbleMakerLib:MakeBlower(inX, inY, bubbleCount, blowSpeed, blowPauseTime)
	self.blowSpeed = blowSpeed
	self.blowerX = inX
	self.blowerY = inY
	self.bubbleCount = bubbleCount
	self.blowSpeed = blowSpeed
	self.blowPauseTime = blowPauseTime
	
	self.blowerPick = display.newImageRect(self.bubbleGroup, "Blower.png", 80, 219)
	self.blowerPick:setReferencePoint(display.BottomLeftReferencePoint)
	self.blowerPick.x = inX - 40
	self.blowerPick.y = inY
	
	local blower = display.newCircle(self.bubbleGroup, inX, inY - 40, 20)
	blower.alpha = 0
end

function bubbleMakerLib:BlowBubbles(inAmount)
	self.blowTimer = timer.performWithDelay(self.blowSpeed, function()
		local bubble = self:NewBubble()
		bubble:setLinearVelocity(Random(-80, 80), Random(1,4))
	end, inAmount)
end

function bubbleMakerLib:StartBlower()	
	self:BlowBubbles(self.bubbleCount)
	
	self.blowRoundTimer = timer.performWithDelay(self.blowPauseTime, function()
		self:BlowBubbles(self.bubbleCount)
	end, 0)
end

function bubbleMakerLib:StopBlower()
	if(self.blowRoundTimer)then
		timer.cancel(self.blowRoundTimer)
	end
	if(self.blowTimer)then
		timer.cancel(self.blowTimer)
	end
	
	for i=self.bubbleGroup.numChildren,1,-1 do
		if(self.bubbleGroup[i].Pop)then
			if(self.bubbleGroup[i].alive)then
				self.bubbleGroup[i]:Pop()
			end
		end
	end
end

function bubbleMakerLib:MakeBubbleCollisionHandler(inSelf)
	local self = inSelf
	
	return function(obj,event)
		if(event.phase == "began")then
			if(event.other.name == "grass")then
				if(obj.alive)then
					obj.alive = false
					timer.performWithDelay(1, function()
						obj:Pop()
					end)		
					timer.performWithDelay(10, function()
						self.gameOverHandler()
					end)
				end
			end
		end	
		return true
	end
end

function bubbleMakerLib:MakeBubbleTouchHandler(inSelf)
	local self = inSelf
	
	return function(obj,event)
		if (event.phase == "began") then
			if(obj.alive)then
				obj.alive = false
				timer.performWithDelay(10, function()
					obj:Pop()
				end)
				self.advancePopCounter()
			end
		end
		return true
	end
end
	
function bubbleMakerLib:NewBubble()
	local bubble = nil
	
	bubbleSize = Random(50, 90)
	
	bubble = display.newImageRect(self.bubbleGroup, "Bubble.png", bubbleSize, bubbleSize)
	bubble.x = self.blowerX
	bubble.y = self.blowerY	
	physics.addBody(bubble, "dynamic", {density=0.2, friction=0.0, bounce=0.5, radius=bubbleSize})
	bubble.alive = true
	bubble.gfxGroup = self.bubbleGroup
	bubble.collision = self:MakeBubbleCollisionHandler(self)
	bubble:addEventListener("collision", bubble)

	bubble.touch = self:MakeBubbleTouchHandler(self)
	bubble:addEventListener("touch", bubble)
	
	function bubble:Pop()
		if(self.collision)then
			self:removeEventListener("collision", self)
		end
		if(self.touch)then
			self:removeEventListener("touch",self)
		end
		
		local bubblePop = display.newImageRect(self.gfxGroup, "BubblePop.png", 250, 250)
		bubblePop.x = self.x
		bubblePop.y = self.y
		bubblePop.xScale = .01
		bubblePop.yScale = .01
		transition.to(bubblePop, {time=150, xScale = 1, yScale = 1, alpha = 0, onComplete = function()
			display.remove(bubblePop)
			bubblePop = nil
		end})
		
		display.remove(self)
		self = nil
	end

	return bubble
end

return bubbleMakerLib