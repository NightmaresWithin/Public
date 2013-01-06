local DevInformerLib = {}
local DevInformerLib_mt = { __index = DevInformerLib }

local _lib_path = "DevInformer/"

function DevInformerLib.New()
	local devLib = {}
	
	devLib.devinfo = nil
	devLib.memCleaner = nil
	
	return setmetatable(devLib, DevInformerLib_mt)
end

function DevInformerLib:Destroy()
	self = nil
end

function DevInformerLib:GetDeviceInfo()
	print("DevInformerLib: Getting Device Info...")
	self.devinfo = {}
	local devinfo = self.devinfo
	
	devinfo.isSimulator = false
	devinfo.isiDevice = false
	devinfo.isiPhone = false
	devinfo.isiPhone5 = false
	devinfo.isiPad = false
	devinfo.isTall = false
	
	devinfo.isAndroid = false
	devinfo.isGoogle = false
	devinfo.isKindleFire = false
	devinfo.isNook = false
	

	--Device Name or Computer name
	devinfo.name = system.getInfo("name")
	--iPad, iPhone, iPod touch
	devinfo.model = system.getInfo("model")
	
	if(system.getInfo("environment") == "simulator")then
		devinfo.isSimulator = true
	end
	
	if (string.sub(devinfo.model, 1, 2) == "iP") then 
		devinfo.isiDevice = true
	   if (string.sub(devinfo.model, 1, 4) == "iPad") then
		  devinfo.isiPad = true
	   end 
	else
	   devinfo.isAndroid = true
	   devinfo.isGoogle = true
	 
	   -- The Kindles start with "K", but Corona builds before #976 returned
	   -- "WFJWI" instead of "KFJWI" (will handle both)
	   if (devinfo.model == "Kindle Fire" or devinfo.model == "WFJWI" or string.sub(devinfo.model, 1, 2) == "KF") then
		  devinfo.isKindleFire = true
		  devinfo.isGoogle = false
	   end
	 
	   if((string.sub(devinfo.model, 1 ,4) == "Nook") or (string.sub(devinfo.model, 1, 4) == "BNRV")) then
		  devinfo.isNook = true
		  devinfo.isGoogle = false 
	   end 
	end

	if ( (display.pixelHeight/display.pixelWidth) > 1.5 ) then
	   devinfo.isTall = true
	   if(devinfo.isiDevice)then
			devinfo.isiPhone5 = true
	   end
	end

	devinfo.platform = system.getInfo("platformName")
	devinfo.platformVersion = system.getInfo("platformVersion")
	devinfo.maxTextureSize = system.getInfo("maxTextureSize")
	devinfo.description = system.getInfo("architectureInfo")
	
	devinfo.screenW = display.contentWidth
	devinfo.screenH = display.contentHeight
	devinfo.screenHW = display.contentWidth / 2
	devinfo.screenHH = display.contentHeight / 2
	devinfo.pixelWidth = display.pixelWidth
	devinfo.pixelHeight = display.pixelHeight
	devinfo.ratio = devinfo.pixelWidth / devinfo.pixelHeight
	devinfo.deviceWidth = (display.contentWidth - (display.screenOriginX * 2)) / display.contentScaleX
	devinfo.deviceHeight = (display.contentHeight - (display.screenOriginY * 2)) / display.contentScaleY
	devinfo.scaleFactor = math.floor(devinfo.deviceWidth / display.contentWidth)
	
	--Reports whats in config.lua
	devinfo.viewableContentWidth = display.viewableContentWidth
	devinfo.viewableContentHeight = display.viewableContentHeight

	--Landscape(4:3 or 0.75)
	devinfo.bgWidth = devinfo.screenW --960
	devinfo.bgHeight = devinfo.screenH --720
	
	devinfo.devLeft = display.screenOriginX
	devinfo.devRight = display.contentWidth - display.screenOriginX
	devinfo.devTop = display.screenOriginY
	devinfo.devBottom =  display.contentHeight - display.screenOriginY
	
	--Landscape(16:9 or 0.56..)
	if(devinfo.ratio < 0.70)then
		--devinfo.bgWidth = 1136
		devinfo.bgHeight = 852
	end
	
	return self.devinfo
end

function DevInformerLib:PrintDeviceInfo()
	if(not self.devinfo)then
		self:GetDeviceInfo()
	end
	print("DEVICE INFO:")
	for k,v in pairs(self.devinfo) do
		print("  "..tostring(k) .. " : " ..tostring(v))
	end
end

function DevInformerLib:ShowBounds()
	print("DevInformerLib: Showing Bounds...")
	if(not self.devinfo)then
		self:GetDeviceInfo()
	end
	local devinfo = self.devinfo
	
	local UL = display.newCircle(devinfo.devLeft, devinfo.devTop, 4)
	local UR = display.newCircle(devinfo.devRight, devinfo.devTop, 4)
	local LL = display.newCircle(devinfo.devLeft, devinfo.devBottom, 4)
	local LR = display.newCircle(devinfo.devRight, devinfo.devBottom, 4)
	local CC = display.newCircle(devinfo.screenHW, devinfo.screenHH, 4)
end

function DevInformerLib:StartUpMemCleaner(cycleTime, isVerbose)
	print("DevInformerLib: Starting MemCleaner...")
	local gcVerbose = function()
		collectgarbage()
		print("Mem: "..tostring(collectgarbage("count")).."  Tex: "..system.getInfo("textureMemoryUsed") / 1000000)
	end
	
	local gc = function()
		collectgarbage()
	end
	
	if(isVerbose)then
		self.memCleaner = timer.performWithDelay(cycleTime, function() gcVerbose() end, 0)
	else
		self.memCleaner = timer.performWithDelay(cycleTime, function() gc() end, 0)
	end
end

function DevInformerLib:StopMemCleaner(cycleTime, isVerbose)
	print("DevInformerLib: Stopping MemCleaner...")
	if(self.memCleaner)then
		timer.cancel(self.memCleaner)
		self.memCleaner = nil
	end
end

return DevInformerLib