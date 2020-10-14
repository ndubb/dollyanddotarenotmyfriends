-- Dolly and Dot are Not My Friends (v1.2 - Updated 2020-06-29)

local myName = "DaDaNMF"
local myVersion = "v1.2.1"

DaDSoundGroup = { category = "Unknown", name = "Unknown", ids = {} }

-- Create a new DaDSoundGroup object with the specified category, group name, and ids
function DaDSoundGroup:new(category, name, ids)
	local self = {}
	self.__index = self
	self.category = category or "Unknown"
	self.name = name or "Unknown"
	self.ids = ids or {}
	return self
end

-- Add a single sound ID to the group
function DaDSoundGroup:add(id)
	if FindIndex(self.ids, id) == nil then
		table.insert(self.ids, id)
	end
end

-- Add a range of sound IDs to the group
function DaDSoundGroup:addRange(ids)
	for _, id in pairs(ids) do
		self:add(id)
	end
end

-- Find the index of a value in the table, returns nil if not found
-- PARAMETERS
-- tbl: table to search
-- value: value to look for in table
local function FindIndex(tbl, value) 
	for index, v in pairs(tbl) do
		if (v == value) then
			return index
		end
	end
	return nil
end

function GetTableSize(tbl)
	if tbl == nil then
		return nil
	end
    local count = 0
    for _, __ in pairs(tbl) do
        count = count + 1
    end
    return count
end

-- Colorize the given text using a hex color code, for printing to a chat frame
-- PARAMETERS
-- text: text to colorize
-- hexColor: hex color code
local function ColorText(text, hexColor)
	return "\124c"..hexColor..text.."\124r"
end

-- Print a message to the specified chat frame
-- PARAMETERS
-- text: message to print
-- isError: true to print using error text color, otherwise use default text color
-- prefix: true to prefix each message with addon name, otherwise no prefix
-- frame: output chat frame (DEFAULT_CHAT_FRAME if none specified)
local function PrintToFrame(text, isError, prefix, frame)
	if frame == nil then
		frame = DEFAULT_CHAT_FRAME
	end
	if isError then
		if prefix then
			frame:AddMessage("["..ColorText(myName, "ffebe834").."] "..tostring(text), 1, 0.2, 0.2)
		else
			frame:AddMessage(tostring(text), 1, 0.2, 0.2)
		end
	else
		if prefix then
			frame:AddMessage("["..ColorText(myName, "ffebe834").."] "..tostring(text))
		else
			frame:AddMessage(tostring(text))
		end
	end
end

local DollyAndDotGroup = DaDSoundGroup:new("toys", "meerah", {1998845, 3169894})

local TrainGroup = DaDSoundGroup:new("toys", "train", {
	539203, 539219, 1313588, 1306531, 1902030, 1902543,
	539516, 539730, 539802, 539881, 540271, 540275,
	542017, 541769, 1730534, 1730908, 540734, 540535,
	2491898, 2531204, 1731656, 1731282, 1951457, 1951458, 
	3107182, 3107651, 540947, 540870, 1316209, 1304872,
	1732405, 1732030, 541157, 541239, 636621, 630296, 
	630298, 542896, 542818, 543085, 543093, 542600, 542526,
	1732785, 1733163, 3106252, 3106717, 542206, 542035, 
	541463, 541601, 1903049, 1903522
})

local RhoninGroup = DaDSoundGroup:new("npcs", "rhonin", {})

local GroupDictionary = {}
GroupDictionary["meerah"] = DollyAndDotGroup
GroupDictionary["train"] = TrainGroup
--GroupDictionary["rhonin"] = RhoninGroup

local DefaultGroupNames = {"meerah", "train"}

local function MuteAllSounds()
   count = 0
   if DollyAndDotCustomSounds ~= nil then
      for _, fileDataId in pairs(DollyAndDotCustomSounds) do
         MuteSoundFile(fileDataId)
         count = count + 1
      end
   end
   return count
end

local function SetDefaultSoundList()
	for _, group in pairs(DefaultGroupNames) do
		for _, id in pairs(GroupDictionary[group].ids) do
			if FindIndex(DollyAndDotCustomSounds, id) == nil then
				table.insert(DollyAndDotCustomSounds, id)
			end
		end
	end
end

SLASH_DADMUTE1 = "/mute"
SLASH_DADMUTE2 = "/dadmute"
SlashCmdList.DADMUTE = function(command, editBox)
	if command == "default" then
		if DollyAndDotCustomSounds ~= nil then
			PrintToFrame("resetting to default mute list", false, true)
			for _, id in pairs(DollyAndDotCustomSounds) do
				UnmuteSoundFile(id)
			end
		end
		DollyAndDotCustomSounds = {}
		SetDefaultSoundList()
		for _, group in pairs(DefaultGroupNames) do
			PrintToFrame("added "..ColorText(group, "ffb8cff5").." to mute list", false, true)
		end
		local count = MuteAllSounds()
		PrintToFrame("muted "..ColorText(count, "ffb8cff5").." total sounds :)", false, true)
		return
	elseif GroupDictionary[command] ~= nil then
		for _, id in pairs(GroupDictionary[command].ids) do
			if FindIndex(DollyAndDotCustomSounds, id) == nil then
				table.insert(DollyAndDotCustomSounds, id)
				MuteSoundFile(id)
			end
		end
		PrintToFrame("added "..ColorText(command, "ffb8cff5").." sound group to mute list", false, true)
		return
	end
	
	local fileDataId = tonumber(command)
	if fileDataId == nil then
		PrintToFrame("file data id must be a number", true, true)
		return
	end
	
	local index = FindIndex(DollyAndDotCustomSounds, tonumber(fileDataId))
	if index ~= nil then
		PrintToFrame("file data id "..ColorText(fileDataId, "ffb8cff5").." is already muted!", false, true)
	else
		table.insert(DollyAndDotCustomSounds, tonumber(fileDataId))
		MuteSoundFile(fileDataId)
		PrintToFrame("muted file data id "..ColorText(fileDataId, "ffb8cff5"), false, true)
	end
end

SLASH_DADUNMUTE1 = "/unmute"
SLASH_DADUNMUTE2 = "/dadunmute"
SlashCmdList.DADUNMUTE = function(command, editBox)
	if GroupDictionary[command] ~= nil then
		for _, id in pairs(GroupDictionary[command].ids) do
			local index = FindIndex(DollyAndDotCustomSounds, id)
			if index ~= nil then
				table.remove(DollyAndDotCustomSounds, index)
				UnmuteSoundFile(id)
			end
		end
		PrintToFrame("removed "..ColorText(command, "ffb8cff5").." sound group from mute list", false, true)
		return
	end
	
	local fileDataId = tonumber(command)
	if tonumber(fileDataId) == nil then
		PrintToFrame("must enter a recognized sound group or a numeric sound id", true, true)
		return
	end
		
	local index = FindIndex(DollyAndDotCustomSounds, tonumber(fileDataId))
	if index ~= nil then
		table.remove(DollyAndDotCustomSounds, index)
		UnmuteSoundFile(fileDataId)
		PrintToFrame("unmuted id "..ColorText(fileDataId, "ffb8cff5"), false, true)
	else
		PrintToFrame("id "..ColorText(fileDataId, "ffb8cff5").." was not muted!", false, true)
	end			
end

SLASH_DADMUTELIST1 = "/mutelist"
SlashCmdList.DADMUTELIST = function(editBox)	
	local defaultCount = 0
	local customCount = 0
	for _, id in pairs(DollyAndDotCustomSounds) do
		local isDefault = false
		for _, group in pairs(DefaultGroupNames) do
			if FindIndex(GroupDictionary[group].ids, id) ~= nil and not isDefault then
				defaultCount = defaultCount + 1
				isDefault = true
			end
		end
		if not isDefault then
			customCount = customCount + 1
		end
	end
	PrintToFrame(ColorText(defaultCount, "ffb8cff5").." default sounds and "..ColorText(customCount, "ffb8cff5").." additional sounds muted", false, true)
end

SLASH_DADMUTEHELP1 = "/mutehelp"
SlashCmdList.DADMUTEHELP = function(command, editBox)
	if command == nil or command == "" then
		PrintToFrame("help topics: mute, unmute, groups. Type "..ColorText("/mutehelp <topic>", "ffebe834").." for more info (e.g., /mutehelp mute)", false, true)
	elseif command == "mute" then
		PrintToFrame("Mutes a group of sounds by name, or one sound file id", false)
		PrintToFrame("Usage: "..ColorText("/mute default", "ffebe834")..", "..ColorText("/mute <group name>", "ffebe834")..", or "..ColorText("/mute <sound id>", "ffebe834"), false)
	elseif command == "unmute" then
		PrintToFrame("Unmutes a group of sounds by name, or one sound file id", false)
		PrintToFrame("Usage: "..ColorText("/unmute <group name>", "ffebe834").." or "..ColorText("/unmute <sound id>", "ffebe834"), false)
	elseif command == "groups" then
		local groupNames = ""
		for key, group in pairs(GroupDictionary) do
			if groupNames == "" then
				groupNames = key
			else
				groupNames = groupNames..", "..key
			end
		end
		PrintToFrame("Group names recognized by mute and unmute commands: "..groupNames, false)
	else
		PrintToFrame(command.." is not a recognized command. Try "..ColorText("/mutehelp mute", "ffebe834")..", "..ColorText("/mutehelp unmute", "ffebe834")..", or "..ColorText("/mutehelp groups", "ffebe834"))
	end
end

local DADFrame = CreateFrame("Frame", "DollyAndDotAreNotMyFriends")
DADFrame:RegisterEvent("PLAYER_LOGIN")
DADFrame:RegisterEvent("ADDON_LOADED")

DADFrame:SetScript("OnEvent",
	function(self, event, arg1)
		if event == "ADDON_LOADED" and arg1 == "DollyAndDotAreNotMyFriends" then			
			if not DollyAndDotCustomSounds or not DollyAndDotSet then
				if not DollyAndDotCustomSounds then
					DollyAndDotCustomSounds = {}
				end
				DollyAndDotSet = true
				SetDefaultSoundList()
			end
		elseif event == "PLAYER_LOGIN" then
			local count = MuteAllSounds()
			PrintToFrame(myVersion.." loaded ... "..ColorText(count, "ffb8cff5").." sounds blacklisted. Type "..ColorText("/mutehelp", "ffebe834").." for more info!", false, true)
		end
	end
)
