
if not isServer() then return end

local Json = require("json")

local CharacterBioStorage


----------------------------------- loading -----------------------------------
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

Events.OnInitGlobalModData.Add(function()
	Load()

  local newStorage = ModData.getOrCreate("CharacterBioStorage")

  if CharacterBioStorage then
    for k, v in pairs(CharacterBioStorage) do
      newStorage[k] = {description = v}
    end
  end

  CharacterBioStorage = newStorage
end)
-------------------------------------------------------------------------------

Events.OnClientCommand.Add(function(module, command, player, args)
	if module == "CharacterBio" then
    if command == "save" then
      CharacterBioStorage[args[1]].description = args[2]
    elseif command == "load" then
      sendServerCommand(player, module, command, CharacterBioStorage[args[1]])
    end

  end
end)
