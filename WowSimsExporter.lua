local addonName, Env = ...

local LibParse = LibStub("LibParse")

local WowSimsExporter = LibStub("AceAddon-3.0"):NewAddon("WowSimsExporter", "AceConsole-3.0", "AceEvent-3.0")

local defaults = {
    profile = {},
}

local options = {
    name = addonName,
    handler = WowSimsExporter,
    type = "group",
    args = {
        openExporterButton = {
            type = "execute",
            name = "Open Exporter Window",
            desc = "Opens the exporter window",
            func = function() WowSimsExporter:OpenWindow() end
        },
    },
}

function WowSimsExporter:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("WSEDB", defaults, true)

    LibStub("AceConfig-3.0"):RegisterOptionsTable("WowSimsExporter", options)
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("WowSimsExporter", "WowSimsExporter")

    local profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
    LibStub("AceConfig-3.0"):RegisterOptionsTable("WowSimsExporter_Profiles", profiles)
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("WowSimsExporter_Profiles", "Profiles", "WowSimsExporter")

    self:RegisterChatCommand("wse", "OpenWindow")
    self:RegisterChatCommand("wowsimsexporter", "OpenWindow")
    self:RegisterChatCommand("wsexporter", "OpenWindow")
    Env.UI:CreateCharacterPanelButton(options.args.openExporterButton.func)

    self:Print(addonName .. " " .. Env.VERSION .. " Initialized. use /wse For Window.")
end

function WowSimsExporter:OpenWindow(input)
    if not input or input:trim() == "" then
        self:CreateWindow()
    elseif (input == "export") then
        self:CreateWindow(true)
    elseif (input == "options") then
        InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
        InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
    end
end

local function GenerateOutput(character, exportBags)
    character:FillForExport()
    return LibParse:JSONEncode(character)
end

local function GenerateOutputBags()
    local equipmentSpecBags = Env.CreateEquipmentSpec()
    equipmentSpecBags:FillFromBagItems()
    DEFAULT_CHAT_FRAME:AddMessage(("[|cffFFFF00WowSimsExporter|r] Exported %d items from bags."):format(#
        equipmentSpecBags.items))
    return LibParse:JSONEncode(equipmentSpecBags)
end

function WowSimsExporter:CreateWindow(generate)
    local character = Env.CreateCharacter()
    character:SetUnit("player")
    local classIsSupported = table.contains(Env.supportedClasses, character.class)
    local linkToSim = Env.prelink .. select(2, Env.GetSpec("player"))

    Env.UI:CreateMainWindow(classIsSupported, linkToSim)
    if not classIsSupported then return end
    if generate then Env.UI:SetOutput(GenerateOutput(character)) end
end

Env.UI:SetOutputGenerator(function()
    local character = Env.CreateCharacter()
    character:SetUnit("player")
    local output = GenerateOutput(character)
    return output
end)

Env.UI:SetOutputGeneratorBags(function()
    local character = Env.CreateCharacter()
    character:SetUnit("player")
    local output = GenerateOutputBags()
    return output
end)
