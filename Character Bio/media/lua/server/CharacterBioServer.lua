
if isClient() then return end

local Json = require("json")

local CharacterBioStorage = {}


------------------------------ encoding/decoding ------------------------------
local function Save()
    local fileWriterObj = getFileWriter("CharacterBioStorage.json", true, false)
    local json = Json.Encode(CharacterBioStorage)
    fileWriterObj:write(json)
    fileWriterObj:close()
end

local function Load()
    local fileReaderObj = getFileReader("CharacterBioStorage.json", true)
    local json = ""
    local line = fileReaderObj:readLine()
    while line ~= nil do
        json = json .. line
        line = fileReaderObj:readLine()
    end
    fileReaderObj:close()

    if json and json ~= "" then
        CharacterBioStorage = Json.Decode(json)
    end
end
-------------------------------------------------------------------------------


local function OnClientCommand(module, command, player, args)
	if module == "CharacterBio" then

    if command == "save" then
      CharacterBioStorage[args[1]] = args[2]
    elseif command == "load" then
      sendServerCommand(player, module, command, {CharacterBioStorage[args[1]]})
    end

  end
end

local function OnInitGlobalModData(isNewGame)
	Load()
  print(CharacterBioStorage)
end

local function EveryHours()
	Save()
end

Events.OnClientCommand.Add(OnClientCommand)
Events.OnInitGlobalModData.Add(OnInitGlobalModData)
Events.EveryHours.Add(EveryHours)
