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
local filter = addon:RegisterFilter("Ascension", 70, 'AceEvent-3.0')
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
	-- local AscensionItemList = {32912, 33016}
	--777910, 121421, 1903512, 1903513, 1903515, 121422, 110000, 777999, 640542, 1777028, 121421, 121422, 777999, 110000, 1903512, 1903513, 777910, 1903515, 640542, 977028, 1777028
	-- for k,v in pairs(AscensionItemList) do
	-- 	if v == slotData.itemId then
	-- 		return ASCENSION
	-- 	end
	-- end
	if VANITY_ITEMS[slotData.id] then
		return "Ascension"
	end

	if slotData.quality and slotData.quality >= 6 and slotData.name and not string.find(slotData.name, " of the ") then
		return "Ascension"
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
