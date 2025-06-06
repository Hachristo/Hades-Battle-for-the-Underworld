
require "vector"
require "card"

DrawPileClass = {}

function DrawPileClass:new(xPos, yPos, cards, deck, hand, discard)
  local drawPile = {}
  local metadata = {__index = DrawPileClass}
  setmetatable(drawPile, metadata)
  
  drawPile.position = Vector(xPos, yPos)
  drawPile.size = Vector(142, 200)
  drawPile.cards = cards
  drawPile.deck = deck
  drawPile.hand = hand
  drawPile.discard = discard
  drawPile.refill = false
  
  drawPile.sprite = love.graphics.newImage("Sprites/card_back.png")
  
  drawPile.buffer = true
  
  return drawPile
end

function DrawPileClass:draw()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(self.sprite, self.position.x, self.position.y, 0, 3.45, 3.45)
end

function DrawPileClass:update()
  if love.mouse.isDown(1) and self:checkForMouseOver() and self.buffer then
    self:drawCards()
    self.buffer = false
  end
  if not love.mouse.isDown(1) then
    self.buffer = true
  end
  
end

function DrawPileClass:checkForMouseOver()
  local mousePos = Vector(
    love.mouse.getX(),
    love.mouse.getY()
  )
  local isMouseOver = 
    mousePos.x > self.position.x and
    mousePos.x < self.position.x + self.size.x and
    mousePos.y > self.position.y and
    mousePos.y < self.position.y + self.size.y
  
  return isMouseOver
end

function DrawPileClass:drawCards()
  local card = nil
  if self.discard == pileTable[4] then
    if #pileTable[4] <= 7 then
      local cardString = self.deck:removeTopCard()
      card = stringFunction[cardString](self, 1)
    end
  else
    if #pileTable[9] <= 7 then
      local cardString = self.deck:removeTopCard()
      card = stringFunction[cardString](self, 2)
    end
  end
  if card == nil then
    return
  end
  table.insert(self.cards, card)
  self.hand:addCard(card)
end