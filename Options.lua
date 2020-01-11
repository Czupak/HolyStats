local addonName = 'HolyStats'
local optionsFrame = CreateFrame("FRAME")
optionsFrame.name = addonName
optionsFrame:Hide()
optionsFrame:SetScript("OnShow", function(optionsFrame)
    local function newCheckbox(label, description, onClick)
		local check = CreateFrame("CheckButton", "CCDCheck" .. label, optionsFrame, "InterfaceOptionsCheckButtonTemplate")
		check:SetScript("OnClick", function(self)
			local tick = self:GetChecked()
			onClick(self, tick and true or false)
		end)
		check.label = _G[check:GetName() .. "Text"]
		check.label:SetText(label)
		check.tooltipText = label
		check.tooltipRequirement = description
		return check
	end

    local function newEditbox(label, description, onClick)
		local eb = CreateFrame("EditBox", "HSEB" .. label, optionsFrame, "InputBoxTemplate")
        -- check:SetScript("OnEnterPressed", function(self, value)
        --     print("ENTER")
        --     print(value)
		-- 	-- local tick = self:GetChecked()
		-- 	-- onClick(self, tick and true or false)
		-- end)
		-- check.label = _G[check:GetName() .. "Text"]
		-- check.label:SetText(label)
		-- check.tooltipText = label
        -- check.tooltipRequirement = description
        eb:SetWidth(200)
        eb:SetHeight(5)
		return eb
	end

    local function newSlider(label, configKey, onClick)
        local sl = CreateFrame("Slider", "HSSlider" .. label, optionsFrame, "HorizontalSliderTemplate")
        sl:SetMinMaxValues(1, 20)
        sl:SetValueStep(1)
        sl:SetOrientation("HORIZONTAL")
        -- sl:Enable()
        sl:SetWidth(250)
        sl:SetHeight(4)
        sl:SetValue(config[configKey])
        sl:SetScript("OnValueChanged", function(self)
			local val = self:GetValue()
            onClick(self, val)
        end)
		return sl
	end
    
	local title = optionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText(addonName)

    local fontLabel = optionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	fontLabel:SetPoint("TOPLEFT", title, "BOTTOMLEFT", -2, -16)
	fontLabel:SetText("Main Window Font Size")
	local fontSlider = newSlider(
		"fontSlider",
		'fontSize',
        function(self, value)
            if value ~= nil and value > 0
            then
                config['fontSize'] = math.floor(value + 0.50)
                self:SetValue(config['fontSize'])
            end
        end)
	fontSlider:SetPoint("TOPLEFT", fontLabel, "BOTTOMLEFT", 0, -10)

    if config['fontSizeSpell'] == nil
    then
        config['fontSizeSpell'] = 10
    end
    local spellFontLabel = optionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	spellFontLabel:SetPoint("TOPLEFT", fontLabel, "BOTTOMLEFT", 0, -30)
	spellFontLabel:SetText("Spells Font Size")
	local spellsFontSlider = newSlider(
		"fontSpellsSlider",
		"fontSizeSpell",
        function(self, value)
            if value ~= nil and value > 0
            then
                config['fontSizeSpell'] = math.floor(value + 0.50)
                self:SetValue(config['fontSizeSpell'])
            end
        end)
    spellsFontSlider:SetPoint("TOPLEFT", spellFontLabel, "BOTTOMLEFT", 0, -10)

    local resetButton = CreateFrame("Button", "ResetButtonFrame", optionsFrame, "UIPanelButtonTemplate")
	resetButton:SetPoint("TOPLEFT", spellsFontSlider, "BOTTOMLEFT", 0, -8)
	resetButton:SetScript("OnClick", function()
		resetPosition()
	end)
	resetButton:SetText('Reset window size and position')
	resetButton:SetWidth(170)

    fontLabel = optionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	fontLabel:SetPoint("TOPLEFT", resetButton, "BOTTOMLEFT", -2, -16)
    fontLabel:SetText("Simulate talents")
    
    local dropdown = CreateFrame("Frame", "Simulate", optionsFrame, "UIDropDownMenuTemplate")
	dropdown:SetPoint("TOPLEFT", fontLabel, "BOTTOMLEFT", 0, -8)
	dropdown.initialize = function()
		local dd = {}
			dd.text = 'Improved Renew'
			dd.value = 'Improved Renew'
			dd.func = function(self)
				toggleTalentSim(self.value)
				self.checked = isTalentSim(self.value)
				-- CCDIgnoredString:SetText(getIgnoredString())
			end
            dd.checked = isTalentSim(dd.text)
            UIDropDownMenu_AddButton(dd)
		-- for _, entry in pairs(sortHash(cache['crafts']))
		-- do
		-- 	dd.text = entry['name']
		-- 	dd.value = entry['name']
		-- 	dd.func = function(self)
		-- 		toggleIgnoreCooldown(self.value)
		-- 		self.checked = isCooldownIgnored(self.value)
		-- 		CCDIgnoredString:SetText(getIgnoredString())
		-- 	end
		-- end
	end



    optionsFrame:SetScript("OnShow", nil)
end)

InterfaceOptions_AddCategory(optionsFrame)

SLASH_HOLYSTATS1 = '/holystats'
function SlashCmdList.HOLYSTATS(msg)
	InterfaceOptionsFrame_OpenToCategory(addonName)
	InterfaceOptionsFrame_OpenToCategory(addonName)
end

function resetPosition()
    HolyStatsFrame:SetSize(150,180)
    HolyStatsFrame:SetPoint("TOPLEFT",UIParent,"CENTER",-50,50)
    SpellsFrame:SetPoint("TOPLEFT",UIParent,"CENTER",-50,50)
    SpellsFrameConfig:SetPoint("TOPLEFT",UIParent,"CENTER",-50,50)
end