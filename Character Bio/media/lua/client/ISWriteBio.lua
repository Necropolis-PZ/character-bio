
ISWriteBio = ISPanel:derive("ISWriteBio")

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
local FONT_HGT_LARGE = getTextManager():getFontHeight(UIFont.Large)


function ISWriteBio:initialise()
    ISPanel.initialise(self)
    self:create()
end


function ISWriteBio:setVisible(visible)
    self.javaObject:setVisible(visible)
end

function ISWriteBio:render()
    local z = 15

    self:drawText(self.targetPlayerName .. "'s Bio", self.width/2 - (getTextManager():MeasureStringX(UIFont.Medium, getText("UI_mainscreen_userpanel")) / 2), z, 1,1,1,1, UIFont.Medium)

end

function ISWriteBio:create()
    local btnWid = 150
    local btnHgt = math.max(25, FONT_HGT_SMALL + 3 * 2)
    local padBottom = 10

    local inset = 2
    local height = inset + 35 * FONT_HGT_SMALL + inset
    sendClientCommand("CharacterBio", "load", {self.targetPlayerUsername})
    self.entry = ISTextEntryBox:new("Loading...", self:getWidth() / 2 - ((self:getWidth() - 20) / 2), 45, self:getWidth() - 20, height)
    self.entry:initialise()
    self.entry:instantiate()
    self.entry:setMultipleLine(true)
    self.entry.javaObject:setMaxLines(35)
	--self.entry.javaObject:setMaxTextLength(20)
    self:addChild(self.entry)
    if not self.canEdit then
        self.entry:setEditable(false)
    end

    if self.canEdit then
      self.save = ISButton:new(10, self:getHeight() - padBottom - btnHgt, btnWid, btnHgt, "SAVE", self, ISWriteBio.onOptionMouseDown)
      self.save.internal = "SAVE"
      self.save:initialise()
      self.save:instantiate()
      self.save.borderColor = self.buttonBorderColor
      self:addChild(self.save)
    end

    self.cancel = ISButton:new(self:getWidth() - btnWid - 10, self:getHeight() - padBottom - btnHgt, btnWid, btnHgt, getText("UI_btn_close"), self, ISWriteBio.onOptionMouseDown)
    self.cancel.internal = "CANCEL"
    self.cancel:initialise()
    self.cancel:instantiate()
    self.cancel.borderColor = self.buttonBorderColor
    self:addChild(self.cancel)
end

function ISWriteBio:onOptionMouseDown(button, x, y)
  if button.internal == "CANCEL" then
    self:close()
  elseif button.internal == "SAVE" then
    sendClientCommand("CharacterBio", "save", {self.targetPlayerUsername, self.entry:getText()})
    self:close()
  end
end

function ISWriteBio:close()
    self:setVisible(false)
    self:removeFromUIManager()
    ISUserPanelUI.instance = nil
end

function ISWriteBio:setEntryText(text)
    self.entry:setText(text)
end

function ISWriteBio:new(x, y, width, height, targetPlayer, canEdit)
    local o = {}
    o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.variableColor={r=0.9, g=0.55, b=0.1, a=1}
    o.borderColor = {r=0.4, g=0.4, b=0.4, a=1}
    o.backgroundColor = {r=0, g=0, b=0, a=0.8}
    o.buttonBorderColor = {r=0.7, g=0.7, b=0.7, a=0.5}
    o.zOffsetSmallFont = 25
    o.moveWithMouse = true
    o.targetPlayerName = targetPlayer:getDescriptor():getForename()
	o.targetPlayerUsername = targetPlayer:getUsername()
    o.canEdit = canEdit
    ISWriteBio.instance = o
    return o
end
