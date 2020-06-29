-- Dolly and Dot are Not My Friends (v1.1 - Updated 2020-06-28)
local DollyAndDotIDs = {
    1998845, 3169894
}
local TrainIDs = {
	-- BLOOD ELF TRAIN
	539203, 539219, 1313588, 1306531, 
	-- DARK IRON TRAIN
	1902030, 1902543,
	-- DRAENEI TRAIN
	539516, 539730,
	-- DWARF TRAIN
	539802, 539881,
	-- GNOME TRAIN
	540271, 540275,
	-- GOBLIN TRAIN
	542017, 541769, 
	-- HIGHMOUNTAIN TRAIN
	1730534, 1730908,
	-- HUMAN TRAIN
	540734, 540535,
	-- KUL TIRAN TRAIN
	2491898, 2531204,
	-- LIGHTFORGED TRAIN
	1731656, 1731282, 
	-- MAGHAR TRAIN
	1951457, 1951458, 
	-- MECHAGNOME TRAIN
	3107182, 3107651, 
	-- NIGHT ELF TRAIN
	540947, 540870, 1316209, 1304872,
	-- NIGHTBORNE TRAIN
	1732405, 1732030,
	-- ORC TRAIN
	541157, 541239,
	-- PANDAREN TRAIN
	636621, 630296, 630298,
	-- TAUREN TRAIN
	542896, 542818,
	-- TROLL TRAIN
	543085, 543093,
	-- UNDEAD TRAIN
	542600, 542526,
	-- VOID ELF TRAIN
	1732785, 1733163,
	-- VULPERA TRAIN
	3106252, 3106717, 
	-- WORGEN/GILNEAN TRAIN
	542206, 542035, 541463, 541601,
	-- ZANDALARI TRAIN
	1903049, 1903522
}

-- TODO: TRACKING THESE IN CASE WOW EVER ADDS SUPPORT FOR DISABLING VIA SOUNDKIT
-- local SoundKitIDs = {
	-- -- DOLLY AND DOT ARE MY BEST FRIENDS
	-- 105996, 143176,
	-- -- BLOOD ELF TRAIN
	-- 9672, 9644, 56584, 57024,
	-- -- DARK IRON TRAIN
	-- 99880, 101903, 100051, 101977, 
	-- -- DRAENEI TRAIN
	-- 9697, 9722, 
	-- -- DWARF TRAIN
	-- 7637, 7636, 
	-- -- GNOME TRAIN
	-- 7640, 7641, 
	-- -- GOBLIN TRAIN
	-- 19147, 19257,
	-- -- HIGHMOUNTAIN TRAIN
	-- 91543, 95560, 95882, 91732, 
	-- -- HUMAN TRAIN
	-- 7634, 7635, 
	-- -- KUL TIRAN TRAIN
	-- 124869, 127053, 124149, 127147, 
	-- -- LIGHTFORGED TRAIN
	-- 91921, 96196, 92108, 96264, 
	-- -- MAGHAR TRAIN
	-- 102483, 110340, 102484, 110415, 
	-- -- MECHAGNOME TRAIN
	-- 141367, 144291, 141212, 143908,
	-- -- NIGHT ELF TRAIN
	-- 7642, 7643, 56285, 57202, 
	-- -- NIGHTBORNE TRAIN
	-- 92296, 96332, 96400, 92483, 
	-- -- ORC TRAIN
	-- 7638, 7638, 
	-- -- PANDAREN TRAIN
	-- 29826, 28932,
	-- -- TAUREN TRAIN
	-- 7647, 7646, 
	-- -- TROLL TRAIN 
	-- 7649, 7648, 
	-- -- UNDEAD TRAIN
	-- 7645, 7644, 
	-- -- VOID ELF TRAIN
	-- 95888, 92672, 95682, 92861, 
	-- -- VUPLERA TRAIN
	-- 140902, 144035, 141057, 144127, 
	-- -- WORGEN/GILNEAN TRAIN
	-- 19357, 23323, 19445, 23318, 19030, 18780,
	-- -- ZANDALARI TRAIN
	-- 100215, 126960, 100346, 127334 
-- }

local myName = "DollyAndDotAreNotMyFriends"
local myVersion = "v1.1"

local function PrintToFrame(text, isError, frame)
	if frame == nil then
		frame = DEFAULT_CHAT_FRAME
	end
	if isError then
		frame:AddMessage(myName.." "..tostring(text), 1, 0.2, 0.2)
	else
		frame:AddMessage(myName.." "..tostring(text), 0.6, 1, 0.8);
	end
end

local function SimpleFindArrayIndex (array, value) 
	for index, existingValue in pairs(array) do
		if (existingValue == value) then
			return index
		end
	end
	return 0
end

local function MuteAllSounds()
   count = 0
   if DollyAndDotCustomSounds ~= nil then
      for _, fileDataId in pairs (DollyAndDotCustomSounds) do
         MuteSoundFile(fileDataId)
         count = count + 1
      end
   end
   return count
end

local function RestoreDefaultSoundList()
	PrintToFrame("set mute list to defaults")
	DollyAndDotCustomSounds = {}
	for _, fileDataId in pairs (DollyAndDotIDs) do
		table.insert(DollyAndDotCustomSounds, fileDataId)
	end
	for _, fileDataId in pairs (TrainIDs) do
		table.insert(DollyAndDotCustomSounds, fileDataId)
	end
end

SLASH_DADMUTE1 = "/dadmute"
SLASH_DADMUTE2 = "/dollymute"
SLASH_DADMUTE3 = "/mute"
SlashCmdList.DADMUTE = function(command, editBox)
	if command == "default" then
		if DollyAndDotCustomSounds ~= nil then
			for _, id in pairs (DollyAndDotCustomSounds) do
				UnmuteSoundFile(id)
			end
		end
		RestoreDefaultSoundList()
		local count = MuteAllSounds()
		PrintToFrame("muted "..count.." total sounds. :)")
		return
	elseif command == "meerah" then
		for _, id in pairs (DollyAndDotIDs) do
			if SimpleFindArrayIndex(DollyAndDotCustomSounds, id) == 0 then
				table.insert(DollyAndDotCustomSounds, id)
				MuteSoundFile(id)
			end
		end
		PrintToFrame("added Dolly and Dot sounds to mute list")
		return
	elseif command == "train" then
		for _, id in pairs (TrainIDs) do
			if SimpleFindArrayIndex(DollyAndDotCustomSounds, id) == 0 then
				table.insert(DollyAndDotCustomSounds, id)
				MuteSoundFile(id)
			end
		end
		PrintToFrame("added Train sounds to mute list")
		return
	end
	
	local fileDataId = tonumber(command)
	if fileDataId == nil then
		PrintToFrame("file data id must be a number", true)
		return
	end

	if DollyAndDotCustomSounds == nil then
		DollyAndDotCustomSounds = {}
	end
	
	local index = SimpleFindArrayIndex(DollyAndDotCustomSounds, tonumber(fileDataId))
	
	if index > 0 then
		PrintToFrame("file data id "..fileDataId.." is already muted!")
	else
		table.insert(DollyAndDotCustomSounds, tonumber(fileDataId))
		MuteSoundFile(fileDataId)
		PrintToFrame("muted file data id "..fileDataId)
	end
end

SLASH_DADUNMUTE1 = "/dadunmute"
SLASH_DADUNMUTE2 = "/dollyunmute"
SLASH_DADUNMUTE3 = "/unmute"
SlashCmdList.DADUNMUTE = function(command, editBox)
	if command == "meerah" then
		for _, id in pairs (DollyAndDotIDs) do
			local index = SimpleFindArrayIndex(DollyAndDotCustomSounds, id)
			if index > 0 then
				table.remove(DollyAndDotCustomSounds, index)
				UnmuteSoundFile(id)
			end
		end
		PrintToFrame("removed Dolly and Dot sounds from mute list")
		return
	elseif command == "train" then
		for _, id in pairs (TrainIDs) do
			local index = SimpleFindArrayIndex(DollyAndDotCustomSounds, id)
			if index > 0 then
				table.remove(DollyAndDotCustomSounds, index)
				UnmuteSoundFile(id)
			end
		end
		PrintToFrame("removed Train sounds from mute list")
		return
	end
	
	local fileDataId = tonumber(command)
	if tonumber(fileDataId) == nil then
		PrintToFrame("file data id must be a number", true)
		return
	end
	
	if DollyAndDotCustomSounds == nil then
		DollyAndDotCustomSounds = {}
		PrintToFrame("file data id "..fileDataId.." was not muted!")
		return
	end
	
	local index = SimpleFindArrayIndex(DollyAndDotCustomSounds, tonumber(fileDataId))
	
	if index > 0 then
		table.remove(DollyAndDotCustomSounds, index)
		UnmuteSoundFile(fileDataId)
		PrintToFrame("unmuted file data id "..fileDataId)
	else
		PrintToFrame("file data id "..fileDataId.." was not muted!")
	end			
end

SLASH_DADMUTELIST1 = "/mutelist"
SlashCmdList.DADMUTELIST = function(editBox)
	if DollyAndDotCustomSounds == nil then
		DollyAndDotCustomSounds = {}
	end
	
	local defaultCount = 0
	local customCount = 0
	for _, id in pairs(DollyAndDotCustomSounds) do
		if SimpleFindArrayIndex(DollyAndDotIDs, id) > 0 then
			defaultCount = defaultCount + 1
		elseif SimpleFindArrayIndex(TrainIDs, id) > 0 then
			defaultCount = defaultCount + 1
		else
			customCount = customCount + 1
		end
	end
	PrintToFrame(defaultCount.." default sounds and "..customCount.." additional sounds muted")
end

local DADFrame = CreateFrame("Frame", "DollyAndDotAreNotMyFriends")
DADFrame:RegisterEvent("PLAYER_LOGIN")

DADFrame:SetScript("OnEvent",
	function(self, event, ...)
		if event == "PLAYER_LOGIN" then
			if DollyAndDotCustomSounds == nil or DollyAndDotAreNotMyFriends == {} then
				RestoreDefaultSoundList()
			end
			local customCount = table.getn(DollyAndDotCustomSounds)
			if customCount > 0 then
				PrintToFrame(myVersion.." preferences loaded ... "..customCount.." sounds blacklisted.")
			end
			local count = MuteAllSounds()
			PrintToFrame(myVersion.." muted "..count.." total sounds. Enjoy! :)")
		end
	end
)
