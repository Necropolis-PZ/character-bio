
local ISWriteBio = ISPanel:derive("ISWriteBio")

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
local FONT_SCALE = FONT_HGT_SMALL / 14


function ISWriteBio:setVisible(visible)
  self.javaObject:setVisible(visible)
end

function ISWriteBio:render()
  local z = 15 * FONT_SCALE
  
  self:drawTextCentre(self.targetPlayerName .. "'s Bio", self.width/2, z, 1,1,1,1, UIFont.Medium)
end

local function OnServerCommand(module, command, args)
  if module == "CharacterBio" and command == "load" then
    Events.OnServerCommand.Remove(OnServerCommand)
    ISWriteBio.instance.entry:setText(args and args.description or "No Bio Set.")
  end
end

function ISWriteBio:createChildren()
  local btnWid = 150 * FONT_SCALE
  local btnHgt = FONT_HGT_SMALL + 5 * 2 * FONT_SCALE
  local padBottom = 10 * FONT_SCALE
  
  local height = 35 * FONT_HGT_SMALL + 4
  self.entry = ISTextEntryBox:new("Loading...", padBottom, 30 * FONT_SCALE + FONT_HGT_MEDIUM, self.width - 20 * FONT_SCALE, height)
  self.entry:initialise()
  self.entry:instantiate()
  self.entry:setMultipleLine(true)
  self.entry.javaObject:setMaxLines(35)
  self:addChild(self.entry)
  Events.OnServerCommand.Add(OnServerCommand)
  sendClientCommand("CharacterBio", "load", {self.targetPlayerUsername})
  
  if self.canEdit then
    self.save = ISButton:new(padBottom, self.height - padBottom - btnHgt, btnWid, btnHgt, "SAVE", self, ISWriteBio.onSave)
    self.save:initialise()
    self.save.borderColor = self.buttonBorderColor
    self:addChild(self.save)
  else
    self.entry:setEditable(false)
  end
  
  self.cancel = ISButton:new(self.width - btnWid - padBottom, self.height - padBottom - btnHgt, btnWid, btnHgt, getText("UI_btn_close"), self, ISWriteBio.close)
  self.cancel:initialise()
  self.cancel.borderColor = self.buttonBorderColor
  self:addChild(self.cancel)
end

function ISWriteBio:onSave(button, x, y)
  sendClientCommand("CharacterBio", "save", {description = self.entry:getText()})
  self:close()
end

function ISWriteBio:close()
  self:setVisible(false)
  self:removeFromUIManager()
  ISWriteBio.instance = nil
end

function ISWriteBio:new(x, y, width, height, targetPlayer, canEdit)
  local o = ISPanel:new(x, y, width, height)
  setmetatable(o, self)
  self.__index = self
  o.variableColor = {r=0.9, g=0.55, b=0.1, a=1}
  o.borderColor = {r=0.4, g=0.4, b=0.4, a=1}
  o.backgroundColor = {r=0, g=0, b=0, a=0.8}
  o.buttonBorderColor = {r=0.7, g=0.7, b=0.7, a=0.5}
  o.moveWithMouse = true
  o.targetPlayerName = targetPlayer:getDescriptor():getForename()
  o.targetPlayerUsername = targetPlayer:getUsername()
  o.canEdit = canEdit
  ISWriteBio.instance = o
  return o
end

return ISWriteBio
