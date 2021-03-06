
local myname, Cork = ...
local ldb, ae = LibStub:GetLibrary("LibDataBroker-1.1"), LibStub("AceEvent-3.0")

local IconLine = Cork.IconLine("Interface\\Icons\\inv_misc_book_09", "Unlearned spells")
Cork.defaultspc["Training-enabled"] = true

local dataobj = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("Cork Training", {type = "cork", tiptext = "Warn when you have abilities or spells to learn from a trainer."})

local blacklist = {
	[34091] = true, -- artisan riding (epic flying)
	[40120] = true, -- druid swift flight
	[90265] = true, -- master riding (super-epic flying)
}
local function NeedToTrain()
	for i=1,MAX_SPELLS do
		local spelltype, spellid = GetSpellBookItemInfo(i, "spell")
		if not spelltype then return end
		if spelltype == "FUTURESPELL" and not blacklist[spellid] and (GetSpellAvailableLevel(i, "spell") or math.huge) <= UnitLevel("player") then return true end
	end
end
local function Test() return Cork.dbpc["Training-enabled"] and NeedToTrain() and IconLine end

function dataobj:Scan() dataobj.player = Test() end

ae.RegisterEvent("Cork Training", "SPELLS_CHANGED", dataobj.Scan)
ae.RegisterEvent("Cork Training", "LEARNED_SPELL_IN_TAB", dataobj.Scan)
