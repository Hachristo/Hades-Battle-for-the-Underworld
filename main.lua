io.stdout:setvbuf("no")

require "card"
require "grabber"
require "pile"
require "drawPile"
require "deck"

seed = os.time()

function love.load()
  loadGame(seed)
end

function love.update()
  grabber:update()
  drawPile:update()
  
  checkForMouseMoving()  
  
  for _, card in ipairs(cardTable) do
    card:update()
  end
  local completePiles = 0
  for _, pile in ipairs(pileTable) do
    pile:update()
    if pile.complete then
      completePiles = completePiles + 1
    end
  end
  if completePiles == 4 then
    won = true
  end
  if love.keyboard.isDown("r") then
    resetGame()
  end
  if love.keyboard.isDown("y") then
    restartGame()
  end
end

function love.draw()
  drawPile:draw()
  for _, card in ipairs(cardTable) do
    card:draw() --card.draw(card)
  end
  for _, pile in ipairs(pileTable) do
    pile:draw()
  end
  love.graphics.setColor(1, 1, 1, 1)
  if won then
    love.graphics.print("You Win!", 450, 200)
  end
  love.graphics.print("Press R to reset (same seed)",0,0)
  love.graphics.print("Press Y to restart (new seed)",0,15)
  love.graphics.print("Hades: Battle for the Underworld", 750, 10, 0, 2, 2)
  
end

function checkForMouseMoving()
  if grabber.currentMousePos == nil then
    return
  end
  
  for _, card in ipairs(cardTable) do
    card:checkForMouseOver(grabber)
  end
end

function gameSetup()
  local cardNum = 1
  for i = 1, 3 do
    local faceUp = true
    table.insert(cardTable, CardClass:new(0, 0, deck:removeTopCard(), faceUp, faceUp))
    pileTable[5]:addCard(cardTable[cardNum])
    cardNum = cardNum + 1
  end
end

function resetGame()
  loadGame(seed)
end

function restartGame()
  seed = os.time()
  loadGame(seed)
end

function winSetup()
  pileTable[8]:addCard(CardClass:new(0, 0, "card_spades_13.png"))
  pileTable[9]:addCard(CardClass:new(0, 0, "card_clubs_13.png"))
  pileTable[10]:addCard(CardClass:new(0, 0, "card_hearts_13.png"))
  pileTable[11]:addCard(CardClass:new(0, 0, "card_diamonds_13.png"))
end

function loadGame(seed)
  love.window.setMode(1920, 1080)
  love.graphics.setBackgroundColor(0, 0.37, 0.58, 1)
  
  grabber = GrabberClass:new()
  cardTable = {}
  pileTable = {}
  won = false
  
  table.insert(pileTable, PileClass:new(225, 550, 250, 70, 1))
  table.insert(pileTable, PileClass:new(825, 550, 250, 70, 1))
  table.insert(pileTable, PileClass:new(1425, 550, 250, 70, 1))
  
  table.insert(pileTable, PileClass:new(225, 900, 50, 70, 3))
  
  table.insert(pileTable, PileClass:new(430, 850, 1000, 70, 2))
  
--  table.insert(pileTable, PileClass:new(400, 300, 1))
--  table.insert(pileTable, PileClass:new(500, 300, 1))
--  table.insert(pileTable, PileClass:new(600, 300, 1))
--  table.insert(pileTable, PileClass:new(700, 300, 1))
  
--  table.insert(pileTable, PileClass:new(400, 100, 0))
--  table.insert(pileTable, PileClass:new(500, 100, 0))
--  table.insert(pileTable, PileClass:new(600, 100, 0))
--  table.insert(pileTable, PileClass:new(700, 100, 0))
  
  
  deck = DeckClass:new(pileTable[4], seed)
  deck:fillDeck()
  
  drawPile = DrawPileClass:new(1600, 900, cardTable, deck, pileTable[5], pileTable[4])
  
  gameSetup()
  --winSetup()
end