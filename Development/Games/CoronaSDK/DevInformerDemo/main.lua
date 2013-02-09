display.setStatusBar( display.HiddenStatusBar )

local function Main()
	local DevInformer_Lib = require("DevInformer.DevInformer_Lib")
	local DevInformer = DevInformer_Lib.New()
	
	local DeviceInfo = DevInformer:GetDeviceInfo()
	DevInformer:PrintDeviceInfo()
	
	DevInformer:ShowBounds()
	
	-- This will show memory and texture usage
	-- as well as garbage collect
	--DevInformer:StartUpMemCleaner(2000, true)
	
end
Main()