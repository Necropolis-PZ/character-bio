
local bioMenu

local function onBioMenu(player, canEdit)
  bioMenu = ISWriteBio:new(100, 100, 400, 600, player, canEdit)
  bioMenu:initialise()
  bioMenu:addToUIManager()
end

local function OnFillWorldObjectContextMenu(player, context, worldObjects, test)
  if test then return true end
  local playerObj = getSpecificPlayer(player)

  local clickedPlayer
  print("Number of Objects: " .. #worldObjects)
  for i, v in ipairs(worldObjects) do
    local movingObjects = v:getSquare():getMovingObjects()
    for i = 0, movingObjects:size() - 1 do
      local o = movingObjects:get(i)
      if instanceof(o, "IsoPlayer") then
        clickedPlayer = o
        break
      end
    end
  end

  if clickedPlayer then
    if clickedPlayer ~= playerObj then
      local option = context:addOption("View Bio", clickedPlayer, onBioMenu, false)
    else
      local option = context:addOption("Edit Bio", clickedPlayer, onBioMenu, true)
    end
  end

end

local function OnServerCommand(module, command, args)
  if module == "CharacterBio" and command == "load" then
    print(args)
    if args then
      bioMenu:setEntryText(args[1])
    else
      bioMenu:setEntryText("No Bio Set.")
    end
  end
end

Events.OnServerCommand.Add(OnServerCommand)
Events.OnFillWorldObjectContextMenu.Add(OnFillWorldObjectContextMenu)
