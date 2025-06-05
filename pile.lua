io.stdout:setvbuf("no")
require "vector"

PileClass = {}

function PileClass:new(xPos, yPos, xSize, ySize, tableau)
  local pile = {}
  local metadata = {__index = PileClass}
  setmetatable(pile, metadata)
  
  pile.position = Vector(xPos, yPos)
  pile.size = Vector(xSize, ySize)
  pile.cards = {}
  
  pile.mana = 0
  
  pile.type = tableau
  pile.complete = false
  
  return pile
end

function PileClass:update()
  if self.type == 3 then
    self:discardUpdate()
  else
    self:tableauUpdate()
  end
end

function PileClass:draw()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)
  for _, card in ipairs(self.cards) do
    card:draw()
  end
end

function PileClass:tableauUpdate()
  local pileMana = 0
  for i, iCard in ipairs(self.cards) do
    iCard.side = true
    iCard.draggable = true
    pileMana = pileMana + iCard.cost
  end
  self.mana = pileMana
end

function PileClass:discardUpdate()
  for i, iCard in ipairs(self.cards) do
    iCard.side = false
    iCard.draggable = false
    iCard.state = 0
  end
end

function PileClass:checkForMouseOver(grabber)
  if grabber.grabPos == nil then
    return
  end
    
  local mousePos = grabber.currentMousePos
  local isMouseOver= false
  if self.type == 1 then
    isMouseOver = 
      mousePos.x > self.position.x and
      mousePos.x < self.position.x + self.size.x and
      mousePos.y > self.position.y and
      mousePos.y < (self.position.y + self.size.y)
  else
    isMouseOver = 
      mousePos.x > self.position.x and
      mousePos.x < self.position.x + self.size.x and
      mousePos.y > self.position.y and
      mousePos.y < self.position.y + self.size.y
  end
  
  return isMouseOver
end

function PileClass:addCard(card)
  local spacing = 0
  -- only tableaus and hand have spacing
  if self.type == 1 or self.type == 2 then
    spacing = 1
  end
  if self.type == 0 then
    if tonumber(card.number) == 13 then
      self.complete = true
      print("complete")
    end
  end
  table.insert(self.cards, card)
  for i, iCard in ipairs(self.cards) do
    iCard.position.x = self.position.x + ((i-1) * 150 * spacing)
    iCard.position.y = self.position.y
  end
end

function PileClass:removeCard(card)
  if card == nil then
    return
  end
  local index = -1;
  for i, iCard in ipairs(self.cards) do
    if card == iCard then
      index = i
    end
  end
  if index == -1 then
    return
  end
  table.remove(self.cards, index)
end

function PileClass:refreshPile()
  local spacing = 0
  -- only tableaus and hand have spacing
  if self.type == 1 or self.type == 2 then
    spacing = 1
  end
  for i, iCard in ipairs(self.cards) do
    iCard.position.x = self.position.x + ((i-1) * 150 * spacing)
    iCard.position.y = self.position.y
  end
end

function PileClass:getPileCards()
  return self.cards
end