--[[
AdiBags_Outfutter - Adds Outfitter set filters to AdiBags.
Copyright 2010 Adirelle (adirelle@tagada-team.net)
All rights reserved.
--]]

local _, ns = ...

local addon = LibStub('AceAddon-3.0'):GetAddon('AdiBags')
local L = setmetatable({}, {__index = addon.L})

do -- Localization
	L["uiName"] = "Mythic+ filter"
	L["UiDesc"] = "Putting items that are from Mythic+ dungeons in a specific section."
	local locale = GetLocale()
end

-----------------------------------------------------------
-- Filter Setup
-----------------------------------------------------------

-- Register our filter with AdiBags
local filter = addon:RegisterFilter("MythicPlus", 92, 'AceEvent-3.0')
filter.uiName = L['uiName']
filter.uiDesc = L['UiDesc']

function filter:OnInitialize()
	self.db = addon.db:RegisterNamespace('MythicPlus', {
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
	local tip = CreateFrame("GameTooltip","Tooltip",nil,"GameTooltipTemplate")
	tip:SetOwner(UIParent, "ANCHOR_NONE")
	tip:SetHyperlink(slotData.link);
	tip:Show()
	for i = 2,2 do--tip:NumLines() do
		local text = _G["TooltipTextLeft"..i]:GetText()
	   if(string.find(text, "Mythic %d") or string.find(text, "Mythic Level")) then
		  return "Mythic+"
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
