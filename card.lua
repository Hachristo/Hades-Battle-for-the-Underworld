
require "vector"

CardClass = {}

CARD_STATE = {
  IDLE = 0,
  MOUSE_OVER = 1,
  GRABBED = 2
}

SPRITE_SIZE = 8
SPRITE_SCALE = 0.6

Cost = {
  ["Aphrodite.png"] = 4,
  ["Apollo.png"] = 3,
  ["Ares.png"] = 5,
  ["Artemis.png"] = 3,
  ["Demeter.png"] = 3,
  ["Dionysus.png"] = 3,
  ["Hades.png"] = 6,
  ["Hermes.png"] = 2,
  ["Minotaur.png"] = 5,
  ["Pegasus.png"] = 3,
  ["Poseidon.png"] = 5,
  ["Titan.png"] = 6,
  ["Wooden Cow.png"] = 1,
  ["Zeus.png"] = 5
}

Power = {
  ["Aphrodite.png"] = 3,
  ["Apollo.png"] = 5,
  ["Ares.png"] = 10,
  ["Artemis.png"] = 7,
  ["Demeter.png"] = 8,
  ["Dionysus.png"] = 4,
  ["Hades.png"] = 8,
  ["Hermes.png"] = 5,
  ["Minotaur.png"] = 9,
  ["Pegasus.png"] = 5,
  ["Poseidon.png"] = 9,
  ["Titan.png"] = 12,
  ["Wooden Cow.png"] = 1,
  ["Zeus.png"] = 9
}

function CardClass:new(xPos, yPos, sprite, draggable, faceUp, player)
  local card = {}
  local metadata = {__index = CardClass}
  setmetatable(card, metadata)
  
  card.position = Vector(xPos, yPos)
  card.size = Vector(142, 200)
  card.scale = SPRITE_SCALE
  card.state = CARD_STATE.IDLE
  card.side = faceUp
  card.bottomCard = faceUp
  
  card.name = sprite
  card.cost = Cost[sprite]
  card.power = Power[sprite]
  card.player = player
  
  card.image = love.graphics.newImage("NewSprites/" .. sprite)
  card.back = love.graphics.newImage("Sprites/card_back.png")
  
  card.draggable = draggable
  
  return card
end

function CardClass:update()
  
end

function CardClass:draw()
  if self.side then
    love.graphics.draw(self.image, self.position.x, self.position.y, 0, self.scale, self.scale)
    love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print(self.cost, self.position.x + 16, self.position.y + 179)
    if self.power > 9 then
      love.graphics.print(self.power, self.position.x + 115, self.position.y + 179)
    else
      love.graphics.print(self.power, self.position.x + 120, self.position.y + 179)
    end
    
    love.graphics.setColor(1, 1, 1, 1)

  else
    love.graphics.draw(self.back, self.position.x, self.position.y, 0, 3.45, 3.45)
  end
  
end

function CardClass:checkForMouseOver(grabber)
  if self.state == CARD_STATE.GRABBED or not self.draggable then
    return
  end
    
  local mousePos = grabber.currentMousePos
  local isMouseOver = false
  if self.bottomCard then
    isMouseOver = mousePos.x > self.position.x and
      mousePos.x < self.position.x + self.size.x and
      mousePos.y > self.position.y and
      mousePos.y < self.position.y + self.size.y
  else
    isMouseOver = 
      mousePos.x > self.position.x and
      mousePos.x < self.position.x + self.size.x and
      mousePos.y > self.position.y and
      mousePos.y < self.position.y + (self.size.y / 5)
  end
  
  self.state = isMouseOver and CARD_STATE.MOUSE_OVER or CARD_STATE.IDLE
end

function CardClass:onReveal()
  stringFunction[self.name]()
end
-- Card Subclasses
-- Wooden Cow
WoodenCowPrototype = CardClass:new(0, 0, "Wooden Cow.png", false, false, 0)
function WoodenCowPrototype:new()
  local card = CardClass:new(0, 0, "Wooden Cow.png", false, false, 0)
  local metadata = {__index = WoodenCowPrototype}
  setmetatable(card, metadata)
  return card
end
function WoodenCowPrototype:onReveal(cardLocation)
  
end
-- Pegasus
PegasusPrototype = CardClass:new(0, 0, "Pegasus.png", false, false, 0)
function PegasusPrototype:new()
  local card = CardClass:new(0, 0, "Minotaur.png", false, false, 0)
  local metadata = {__index = PegasusPrototype}
  setmetatable(card, metadata)
  return card
end
function PegasusPrototype:onReveal(cardLocation)
  
end
-- Minotaur
MinotaurPrototype = CardClass:new(0, 0, "Minotaur.png", false, false, 0)
function MinotaurPrototype:new()
  local card = CardClass:new(0, 0, "Minotaur.png", false, false, 0)
  local metadata = {__index = MinotaurPrototype}
  setmetatable(card, metadata)
  return card
end
function MinotaurPrototype:onReveal(cardLocation)
  
end
-- Titan
TitanPrototype = CardClass:new(0, 0, "Titan.png", false, false, 0)
function TitanPrototype:new()
  local card = CardClass:new(0, 0, "Titan.png", false, false, 0)
  local metadata = {__index = TitanPrototype}
  setmetatable(card, metadata)
  return card
end
function TitanPrototype:onReveal(cardLocation)
  
end
-- Zeus
ZeusPrototype = CardClass:new(0, 0, "Zeus.png", false, false, 0)
function ZeusPrototype:newCard()
  local card = CardClass:new(0, 0, "Zeus.png", false, false, 0)
  local metadata = {__index = ZeusPrototype}
  setmetatable(card, metadata)
  return card
end
function ZeusPrototype:onReveal(cardLocation)
  print("revealed")
  local enemyHand = pileTable[10]
  if self.player == AI then
    enemyHand = pileTable[5]
  end
  for _, card in ipairs(enemyHand.cards) do
    card.power = card.power - 1
  end
end
-- Ares
AresPrototype = CardClass:new(0, 0, "Ares.png", false, false, 0)
function AresPrototype:new()
  local card = CardClass:new(0, 0, "Ares.png", false, false, 0)
  local metadata = {__index = AresPrototype}
  setmetatable(card, metadata)
  return card
end
function AresPrototype:onReveal(cardLocation)
  if cardLocation == 1 then
    local enemyLocation = pileTable[6]
    if self.player == AI then
      enemyLocation = pileTable[1]
    end
    self.power = self.power + #enemyLocation.cards * 2
  elseif cardLocation == 2 then
    local enemyLocation = pileTable[7]
    if self.player == AI then
      enemyLocation = pileTable[2]
    end
    self.power = self.power + #enemyLocation.cards * 2
  else
    local enemyLocation = pileTable[8]
    if self.player == AI then
      enemyLocation = pileTable[3]
    end
    self.power = self.power + #enemyLocation.cards * 2
  end
end
-- Poseidon
PoseidonPrototype = CardClass:new(0, 0, "Poseidon.png", false, false, 0)
function PoseidonPrototype:new()
  local card = CardClass:new(0, 0, "Poseidon.png", false, false, 0)
  local metadata = {__index = PoseidonPrototype}
  setmetatable(card, metadata)
  return card
end
function PoseidonPrototype:onReveal(cardLocation)
  
end
-- Artemis
ArtemisPrototype = CardClass:new(0, 0, "Artemis.png", false, false, 0)
function ArtemisPrototype:new()
  local card = CardClass:new(0, 0, "Artemis.png", false, false, 0)
  local metadata = {__index = ArtemisPrototype}
  setmetatable(card, metadata)
  return card
end
function ArtemisPrototype:onReveal(cardLocation)
  
end
-- Demeter
DemeterPrototype = CardClass:new(0, 0, "Demeter.png", false, false, 0)
function DemeterPrototype:new()
  local card = CardClass:new(0, 0, "Demeter.png", false, false, 0)
  local metadata = {__index = DemeterPrototype}
  setmetatable(card, metadata)
  return card
end
function DemeterPrototype:onReveal(cardLocation)
  
end
-- Hades
HadesPrototype = CardClass:new(0, 0, "Hades.png", false, false, 0)
function HadesPrototype:new()
  local card = CardClass:new(0, 0, "Demeter.png", false, false, 0)
  local metadata = {__index = HadesPrototype}
  setmetatable(card, metadata)
  return card
end
function HadesPrototype:onReveal(cardLocation)
  
end
-- Dionysus
DionysusPrototype = CardClass:new(0, 0, "Dionysus.png", false, false, 0)
function DionysusPrototype:new()
  local card = CardClass:new(0, 0, "Dionysus.png", false, false, 0)
  local metadata = {__index = DionysusPrototype}
  setmetatable(card, metadata)
  return card
end
function DionysusPrototype:onReveal(cardLocation)
  
end
-- Hermes
HermesPrototype = CardClass:new(0, 0, "Hermes.png", false, false, 0)
function HermesPrototype:new()
  local card = CardClass:new(0, 0, "Hermes.png", false, false, 0)
  local metadata = {__index = HermesPrototype}
  setmetatable(card, metadata)
  return card
end
function HermesPrototype:onReveal(cardLocation)
  
end
-- Aphrodite
AphroditePrototype = CardClass:new(0, 0, "Aphrodite.png", false, false, 0)
function AphroditePrototype:new()
  local card = CardClass:new(0, 0, "Aphrodite.png", false, false, 0)
  local metadata = {__index = AphroditePrototype}
  setmetatable(card, metadata)
  return card
end
function AphroditePrototype:onReveal(cardLocation)
  
end
-- Apollo
ApolloPrototype = CardClass:new(0, 0, "Apollo.png", false, false, 0)
function ApolloPrototype:new()
  local card = CardClass:new(0, 0, "Apollo.png", false, false, 0)
  local metadata = {__index = ApolloPrototype}
  setmetatable(card, metadata)
  return card
end
function ApolloPrototype:onReveal(cardLocation)
  
end
