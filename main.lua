io.stdout:setvbuf("no")

require "card"
require "grabber"
require "pile"
require "drawPile"
require "deck"

seed = os.time()
seedAI = seed + 1

playerMana = 0

function love.load()
  loadGame(seed, seedAI)
end

function love.update()
  grabber:update()
  drawPilePlayer:update()
  drawPileAI:update()
  
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
  playerMana = 1 - (pileTable[1].mana + pileTable[2].mana + pileTable[3].mana)
end

function love.draw()
  drawPilePlayer:draw()
  drawPileAI:draw()
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
  love.graphics.print("Mana: " .. playerMana, 10, 500)
  
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
    table.insert(cardTable, CardClass:new(0, 0, deckPlayer:removeTopCard(), faceUp, faceUp))
    pileTable[5]:addCard(cardTable[cardNum])
    cardNum = cardNum + 1
    faceUp = false
    table.insert(cardTable, CardClass:new(0, 0, deckAI:removeTopCard(), faceUp, faceUp))
    pileTable[10]:addCard(cardTable[cardNum])
    cardNum = cardNum + 1
  end
end

function resetGame()
  loadGame(seed, seedAI)
end

function restartGame()
  seed = os.time()
  seedAI = seed + 1
  loadGame(seed, seedAI)
end

function winSetup()
  pileTable[8]:addCard(CardClass:new(0, 0, "card_spades_13.png"))
  pileTable[9]:addCard(CardClass:new(0, 0, "card_clubs_13.png"))
  pileTable[10]:addCard(CardClass:new(0, 0, "card_hearts_13.png"))
  pileTable[11]:addCard(CardClass:new(0, 0, "card_diamonds_13.png"))
end

function loadGame(seed, seedAI)
  love.window.setMode(1920, 1080)
  love.graphics.setBackgroundColor(0, 0.37, 0.58, 1)
  
  grabber = GrabberClass:new()
  cardTable = {}
  pileTable = {}
  won = false
  
  table.insert(pileTable, PileClass:new(125, 550, 450, 70, 1))
  table.insert(pileTable, PileClass:new(725, 550, 450, 70, 1))
  table.insert(pileTable, PileClass:new(1325, 550, 450, 70, 1))
  
  table.insert(pileTable, PileClass:new(125, 850, 150, 70, 3))
  
  table.insert(pileTable, PileClass:new(430, 850, 1000, 70, 2))
  
  deckPlayer = DeckClass:new(pileTable[4], seed)
  deckPlayer:fillDeck()
  
  drawPilePlayer = DrawPileClass:new(1600, 850, cardTable, deckPlayer, pileTable[5], pileTable[4])
  
  table.insert(pileTable, PileClass:new(125, 350, 450, 70, 1))
  table.insert(pileTable, PileClass:new(725, 350, 450, 70, 1))
  table.insert(pileTable, PileClass:new(1325, 350, 450, 70, 1))
  
  table.insert(pileTable, PileClass:new(125, 50, 150, 70, 3))
  
  table.insert(pileTable, PileClass:new(430, 50, 1000, 70, 2))
  
  
  deckAI = DeckClass:new(pileTable[9], seedAI)
  deckAI:fillDeck()
  
  drawPileAI = DrawPileClass:new(1600, 50, cardTable, deckAI, pileTable[10], pileTable[9])
  
  gameSetup()
  --winSetup()
end