--[[
AdiBags_Outfutter - Adds Outfitter set filters to AdiBags.
Copyright 2010 Adirelle (adirelle@tagada-team.net)
All rights reserved.
--]]

local _, ns = ...

local addon = LibStub('AceAddon-3.0'):GetAddon('AdiBags')
local L = setmetatable({}, {__index = addon.L})

local tooltip = CreateFrame('GameTooltip', 'AdiBagsAscensionTooltip', nil, 'GameTooltipTemplate')

local tooltipLines = {}
local function GetTooltipLines(link)
        wipe(tooltipLines)

        if not link then
                return tooltipLines
        end

        tooltip:SetOwner(UIParent or WorldFrame, 'ANCHOR_NONE')
        tooltip:ClearLines()
        tooltip:SetHyperlink(link)

        for i = 2, tooltip:NumLines() do
                local leftLine = _G['AdiBagsAscensionTooltipTextLeft' .. i]
                local text = leftLine and leftLine:GetText()
                if text and text ~= '' then
                        tooltipLines[#tooltipLines + 1] = text
                end
        end

        tooltip:Hide()

        return tooltipLines
end

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
        local equipSlot = slotData.equipSlot
        if not equipSlot then
                local _, _, _, _, _, _, _, _, fetchedSlot = GetItemInfo(slotData.itemId)
                equipSlot = fetchedSlot or ''
        end

        local tooltipText = GetTooltipLines(slotData.link)

        local function tooltipContains(pattern)
                for i = 1, #tooltipText do
                        if string.find(tooltipText[i], pattern) then
                                return true
                        end
                end
                return false
        end

        local function tooltipContainsAny(patterns)
                for i = 1, #patterns do
                        if tooltipContains(patterns[i]) then
                                return true
                        end
                end
                return false
        end

        -- Transmog items
        if (slotData.class == "Weapon" or slotData.class == "Armor") then
                if tooltipContainsAny({"@Mythic %d", "@Mythic Level"}) then
                        return "Mythic+", 'Equipment'
                end
                if C_Appearance and C_AppearanceCollection and slotData.subclass ~= "Thrown" and slotData.itemId ~= 5956 then
                        local appearanceID = C_Appearance.GetItemAppearanceID(slotData.itemId)
                        if appearanceID then
                                local isCollected = C_AppearanceCollection.IsAppearanceCollected(appearanceID)
                                if not isCollected then
                                        return "Transmog", 'Equipment'
                                end
                        end
                end
        -- Mythic+ items
        else
                if tooltipContainsAny({"@Mythic %d", "@Mythic Level"}) then
                        return "Mythic+", 'Equipment'
                elseif (equipSlot == '' or equipSlot == nil) and tooltipContainsAny({"This Token", "This token"}) then
                        return "Tier Token", 'Equipment'
                elseif tooltipContains("@re") then
                        return "Mystic Enchants"
                end
        end
	-- Trade Goods equipment
	if slotData.itemId == 5956 or slotData.itemId == 6219 or slotData.itemId == 20824 or slotData.itemId == 20815 or slotData.itemId == 10498 or
		slotData.itemId == 22463 or slotData.itemId == 22462 or slotData.itemId == 22461 or slotData.itemId == 16207 or slotData.itemId == 11145 or
		slotData.itemId == 11130 or slotData.itemId == 6339 or slotData.itemId == 6218 or slotData.itemId == 23821 or slotData.itemId == 6954 or 
		slotData.itemId == 9149 or slotData.itemId == 2901 or slotData.itemId == 7005 then
		return "Tools", 'Trade Goods'
	end
	-- Vanity items
        if slotData.quality == 6 then
                if VANITY_ITEMS and VANITY_ITEMS[slotData.itemId] and VANITY_ITEMS[slotData.itemId].itemid > 0 then
                        return "Ascension"
                else
                        return "Vanity"
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
