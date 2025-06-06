io.stdout:setvbuf("no")

require "card"
require "grabber"
require "pile"
require "drawPile"
require "deck"

seed = os.time()
seedAI = seed + 1

playerMana = 0
playerPoints = 0

AIMana = 0
AIPoints = 0

turn = 1

submitBuffer = true

ENTITIES = {
  PLAYER = 1,
  AI = 2
}

cardConstructors = {
  cardWoodenCow = WoodenCowPrototype.new,
  cardPegasus = PegasusPrototype.new,
  cardMinotaur = MinotaurPrototype.new,
  cardTitan = TitanPrototype.new,
  cardZeus = ZeusPrototype.newCard,
  cardAres = AresPrototype.new,
  cardPoseidon = PoseidonPrototype.new,
  cardArtemis = ArtemisPrototype.new,
  cardDemeter = DemeterPrototype.new,
  cardHades = HadesPrototype.new,
  cardDionysus = DionysusPrototype.new,
  cardHermes = HermesPrototype.new,
  cardAphrodite = AphroditePrototype.new,
  cardApollo = ApolloPrototype.new
}

stringFunction = {
  ["Wooden Cow.png"] = cardConstructors.cardWoodenCow,
  ["Pegasus.png"] = cardConstructors.cardPegasus,
  ["Minotaur.png"] = cardConstructors.cardMinotaur,
  ["Titan.png"] = cardConstructors.cardTitan,
  ["Zeus.png"] = cardConstructors.cardZeus,
  ["Ares.png"] = cardConstructors.cardAres,
  ["Poseidon.png"] = cardConstructors.cardPoseidon,
  ["Artemis.png"] = cardConstructors.cardArtemis,
  ["Demeter.png"] = cardConstructors.cardDemeter,
  ["Hades.png"] = cardConstructors.cardHades,
  ["Dionysus.png"] = cardConstructors.cardDionysus,
  ["Hermes.png"] = cardConstructors.cardHermes,
  ["Aphrodite.png"] = cardConstructors.cardAphrodite,
  ["Apollo.png"] = cardConstructors.cardApollo
}

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
  if love.keyboard.isDown("s") and submitBuffer then
    submitBuffer = false
    submitMove()
  end
  if not love.keyboard.isDown("s") then
    submitBuffer = true
  end
  playerMana = turn - (pileTable[1].mana + pileTable[2].mana + pileTable[3].mana)
  AIMana = turn - (pileTable[6].mana + pileTable[7].mana + pileTable[8].mana)
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
  love.graphics.print("Press S to submit turn",0,30)
  love.graphics.print("Hades: Battle for the Underworld", 750, 10, 0, 2, 2)
  -- Player
  love.graphics.print("Mana: " .. playerMana, 1750, 850)
  love.graphics.print("Points: " .. playerPoints, 1750, 865)
  -- AI
  love.graphics.print("Mana: " .. AIMana, 1750, 50)
  love.graphics.print("Points: " .. AIPoints, 1750, 65)
  
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
    local cardString = deckPlayer:removeTopCard()
    table.insert(cardTable, stringFunction[cardString](self, 0, 0, cardString, faceUp, faceUp, PLAYER))
    pileTable[5]:addCard(cardTable[cardNum])
    cardNum = cardNum + 1
    faceUp = false
    cardString = deckPlayer:removeTopCard()
    table.insert(cardTable, stringFunction[cardString](self, 0, 0, cardString, faceUp, faceUp, AI))
    pileTable[10]:addCard(cardTable[cardNum])
    cardNum = cardNum + 1
  end
  pileTable[5]:refreshPile()
  pileTable[10]:refreshPile()
--  for i, _ in ipairs(cardTable) do
--    print(cardTable[i])
--  end
end

function resetGame()
  loadGame(seed, seedAI)
end

function restartGame()
  seed = os.time()
  seedAI = seed + 1
  loadGame(seed, seedAI)
end

--function winSetup()
--  pileTable[8]:addCard(CardClass:new(0, 0, "card_spades_13.png"))
--  pileTable[9]:addCard(CardClass:new(0, 0, "card_clubs_13.png"))
--  pileTable[10]:addCard(CardClass:new(0, 0, "card_hearts_13.png"))
--  pileTable[11]:addCard(CardClass:new(0, 0, "card_diamonds_13.png"))
--end

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
function submitMove()
  comparePiles(pileTable[1], pileTable[6], 1)
  comparePiles(pileTable[2], pileTable[7], 2)
  comparePiles(pileTable[3], pileTable[8], 3)
  turn = turn + 1
end

function comparePiles(pilePlayer, pileAI, location)
  if pilePlayer.power >= pileAI.power then
    for _, card in ipairs(pilePlayer.cards) do
      card:onReveal(location)
    end
    playerPoints = playerPoints + (pilePlayer.power - pileAI.power)
  else
    AIPoints = AIPoints + (pileAI.power - pilePlayer.power)
  end
end