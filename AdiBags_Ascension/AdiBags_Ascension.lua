--[[
AdiBags_Outfutter - Adds Outfitter set filters to AdiBags.
Copyright 2010 Adirelle (adirelle@tagada-team.net)
All rights reserved.
--]]

local _, ns = ...

local addon = LibStub('AceAddon-3.0'):GetAddon('AdiBags')
local L = setmetatable({}, {__index = addon.L})

do -- Localization
	L["uiName"] = "Ascension filter"
	L["UiDesc"] = "Putting items that are from Ascension in a specific section."
	local locale = GetLocale()
end

-----------------------------------------------------------
-- Filter Setup
-----------------------------------------------------------

-- Register our filter with AdiBags
local filter = addon:RegisterFilter("Ascension", 95, 'AceEvent-3.0')
filter.uiName = L['uiName']
filter.uiDesc = L['UiDesc']

function filter:OnInitialize()
	self.db = addon.db:RegisterNamespace('Ascension', {
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
	-- Vanity items
	if VANITY_ITEMS[slotData.id] then
		return "Ascension"
	-- Transmog items
	elseif (slotData.class == "Weapon" or slotData.class == "Armor") then
		local item = GetItemInfoInstant(slotData.itemId) -- _, description, inventoryType =
		if item.description and (string.find(item.description, "@Mythic %d") or string.find(item.description, "@Mythic Level")) then
			return "Mythic+"
		end
		if APPEARANCE_ITEM_INFO[slotData.itemId] and slotData.subclass ~= "Thrown" then
			local appearanceID = APPEARANCE_ITEM_INFO[slotData.itemId]:GetCollectedID()
			if not appearanceID then
				Owned = 3
				return "Transmog"
			end
		elseif C_Appearance and slotData.subclass ~= "Thrown" then
			local appearanceID = C_Appearance.GetItemAppearanceID(slotData.itemId)
			if appearanceID then
				local isCollected = C_AppearanceCollection.IsAppearanceCollected(appearanceID)
				if not isCollected then
					Owned = 3
					return "Transmog"
				end
			end
		end
	-- Mythic+ items
	else
		local item = GetItemInfoInstant(slotData.itemId) --_, description, inventoryType 
		if item.description and (string.find(item.description, "@Mythic %d") or string.find(item.description, "@Mythic Level")) then
			return "Mythic+"
		elseif item.description and item.inventoryType == 0 and string.find(item.description, "This token") then
			return "Tier Token"
		elseif item.description and string.find(item.description, "@re") then
			return "Mystic Enchants"
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
