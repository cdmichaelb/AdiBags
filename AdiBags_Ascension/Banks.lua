local addon = LibStub('AceAddon-3.0'):GetAddon('AdiBags')

local CloseGuildBankFrame = _G.CloseGuildBankFrame
local PERSONAL_BANK_WINDOW = "ASCENSION_PERSONALBANKFRAME"
local REALM_BANK_WINDOW = "ASCENSION_REALMBANKFRAME"

if addon.RegisterBankWindow then
       addon:RegisterBankWindow(PERSONAL_BANK_WINDOW, { close = CloseGuildBankFrame })
       addon:RegisterBankWindow(REALM_BANK_WINDOW, { close = CloseGuildBankFrame })
end

do
       local baseResolve = addon.ResolveInteractingWindow or function(_, _, window) return window end
       function addon:ResolveInteractingWindow(event, window, ...)
               window = baseResolve(self, event, window, ...)
               if window == "GUILDBANKFRAME" then
                       local frame = _G.GuildBankFrame
                       if frame then
                               if frame.IsPersonalBank == true then
                                       return PERSONAL_BANK_WINDOW
                               elseif frame.IsRealmBank == true then
                                       return REALM_BANK_WINDOW
                               end
                       end
               end
               return window
       end
end

