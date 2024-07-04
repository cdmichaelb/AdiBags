--[[
AdiBags_Outfutter - Adds Outfitter set filters to AdiBags.
Copyright 2010 Adirelle (adirelle@tagada-team.net)
All rights reserved.
--]]

local _, ns = ...

local addon = LibStub('AceAddon-3.0'):GetAddon('AdiBags')
local L = setmetatable({}, {__index = addon.L})

do -- Localization
	L["uiName"] = "Transmog filter"
	L["UiDesc"] = "Putting items that can unlock new Transmogs in a specific section."
	local locale = GetLocale()
end

-----------------------------------------------------------
-- Filter Setup
-----------------------------------------------------------

-- Register our filter with AdiBags
local filter = addon:RegisterFilter("Transmog", 65, 'AceEvent-3.0')
filter.uiName = L['uiName']
filter.uiDesc = L['UiDesc']

function filter:OnInitialize()
	self.db = addon.db:RegisterNamespace('Transmog', {
		profile = { oneSectionPerSet = true },
		char = { mergedSets = { ['*'] = false } },
	})
end

function filter:OnEnable()
	addon:UpdateFilters()
end

function filter:OnDisable()
	addon:UpdateFilters()
end

function filter:Filter(slotData)
	-- if C_Appearance then
		-- local appearanceID = C_Appearance.GetItemAppearanceID(slotData.itemId) -- new API not in use yet
	if APPEARANCE_ITEM_INFO then
		if APPEARANCE_ITEM_INFO and APPEARANCE_ITEM_INFO[slotData.itemId] and slotData.subclass ~= "Thrown" and (slotData.class == "Weapon" or slotData.class == "Armor") then
			local appearanceID = APPEARANCE_ITEM_INFO[slotData.itemId]:GetCollectedID()
			if not appearanceID then
				-- local isCollected = C_AppearanceCollection.IsAppearanceCollected(appearanceID)
				-- if isCollected then -- unlocked
					-- Owned = 2
				-- else    -- unknown
				Owned = 3
				return "Transmog"
				-- end
			end
		end
	else
		if C_Appearance and slotData.subclass ~= "Thrown" and (slotData.class == "Weapon" or slotData.class == "Armor") then
			local appearanceID = C_Appearance.GetItemAppearanceID(slotData.itemId)
			if not appearanceID then
				-- local isCollected = C_AppearanceCollection.IsAppearanceCollected(appearanceID)
				-- if isCollected then -- unlocked
					-- Owned = 2
				-- else    -- unknown
				Owned = 3
				return "Transmog"
				-- end
			end
		end
	end
end

function filter:GetFilterOptions()
	return {
		-- oneSectionPerSet = {
		-- 	name = L['One section per set'],
		-- 	desc = L['Check this to display one individual section per set. If this is disabled, there will be one big "Sets" section.'],
		-- 	type = 'toggle',
		-- 	order = 10,
		-- }
	}, addon:GetOptionHandler(self, true)
end
